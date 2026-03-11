package com.example.sso.service;

import com.example.sso.dto.TenantRegistrationRequest;
import com.example.sso.dto.TenantRegistrationResponse;
import com.example.sso.entity.TenantApplication;
import com.example.sso.enums.TenantApplicationStatus;
import com.example.sso.repository.TenantApplicationRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Locale;
import java.util.regex.Pattern;

@Service
public class TenantRegistrationService {

    private static final Pattern CREDIT_CODE_PATTERN = Pattern.compile("^[0-9A-Z]{18}$");

    private final TenantApplicationRepository tenantApplicationRepository;

    public TenantRegistrationService(TenantApplicationRepository tenantApplicationRepository) {
        this.tenantApplicationRepository = tenantApplicationRepository;
    }

    @Transactional
    public TenantRegistrationResponse submit(TenantRegistrationRequest request) {
        validate(request);

        String tenantCode = request.tenantCode().trim().toLowerCase(Locale.ROOT);
        String creditCode = request.unifiedSocialCreditCode().trim().toUpperCase(Locale.ROOT);

        if (tenantApplicationRepository.existsByTenantCode(tenantCode)) {
            throw new IllegalArgumentException("租户编码已存在: " + tenantCode);
        }
        if (tenantApplicationRepository.existsByUnifiedSocialCreditCode(creditCode)) {
            throw new IllegalArgumentException("统一社会信用代码已存在: " + creditCode);
        }

        TenantApplication entity = new TenantApplication();
        entity.setTenantCode(tenantCode);
        entity.setTenantName(request.tenantName().trim());
        entity.setAdminUsername(request.adminUsername().trim());
        entity.setAdminEmail(request.adminEmail().trim());
        entity.setCompanyName(request.companyName().trim());
        entity.setUnifiedSocialCreditCode(creditCode);
        entity.setContactPhone(request.contactPhone());
        entity.setBusinessLicenseNo(request.businessLicenseNo());
        entity.setStatus(TenantApplicationStatus.SUBMITTED);
        entity.setCreatedAt(LocalDateTime.now());
        entity.setUpdatedAt(LocalDateTime.now());

        TenantApplication saved = tenantApplicationRepository.save(entity);
        return toResponse(saved);
    }

    public TenantRegistrationResponse getByTenantCode(String tenantCode) {
        TenantApplication entity = tenantApplicationRepository.findByTenantCode(tenantCode.toLowerCase(Locale.ROOT))
                .orElseThrow(() -> new IllegalArgumentException("租户申请不存在: " + tenantCode));
        return toResponse(entity);
    }

    @Transactional
    public TenantRegistrationResponse review(Long id, String action, String comment, String reviewer) {
        TenantApplication entity = tenantApplicationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("租户申请不存在: " + id));

        String normalized = action.toUpperCase(Locale.ROOT);
        switch (normalized) {
            case "APPROVE" -> entity.setStatus(TenantApplicationStatus.APPROVED);
            case "REJECT" -> entity.setStatus(TenantApplicationStatus.REJECTED);
            default -> throw new IllegalArgumentException("action 仅支持 APPROVE / REJECT");
        }

        entity.setReviewComment(comment);
        entity.setReviewedBy(reviewer);
        entity.setUpdatedAt(LocalDateTime.now());
        return toResponse(tenantApplicationRepository.save(entity));
    }

    private void validate(TenantRegistrationRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("请求体不能为空");
        }
        if (!StringUtils.hasText(request.unifiedSocialCreditCode())
                || !CREDIT_CODE_PATTERN.matcher(request.unifiedSocialCreditCode().trim().toUpperCase(Locale.ROOT)).matches()) {
            throw new IllegalArgumentException("统一社会信用代码格式不正确，必须为18位大写字母/数字");
        }
    }

    private TenantRegistrationResponse toResponse(TenantApplication entity) {
        return new TenantRegistrationResponse(
                entity.getId(),
                entity.getTenantCode(),
                entity.getTenantName(),
                entity.getAdminUsername(),
                entity.getCompanyName(),
                entity.getStatus().name(),
                entity.getReviewComment(),
                entity.getCreatedAt()
        );
    }
}
