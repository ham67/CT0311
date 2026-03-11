package com.example.sso.service;

import com.example.sso.dto.TenantRegistrationRequest;
import com.example.sso.dto.TenantRegistrationResponse;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class TenantRegistrationService {

    private final Map<String, TenantRegistrationResponse> tenantStore = new ConcurrentHashMap<>();

    public TenantRegistrationResponse register(TenantRegistrationRequest request) {
        validate(request);

        String tenantCode = request.tenantCode().trim().toLowerCase();
        if (tenantStore.containsKey(tenantCode)) {
            throw new IllegalArgumentException("租户编码已存在: " + tenantCode);
        }

        TenantRegistrationResponse response = new TenantRegistrationResponse(
                tenantCode,
                request.tenantName().trim(),
                request.adminUsername().trim(),
                "PENDING_REVIEW",
                LocalDateTime.now()
        );

        tenantStore.put(tenantCode, response);
        return response;
    }

    public TenantRegistrationResponse getByCode(String tenantCode) {
        TenantRegistrationResponse response = tenantStore.get(tenantCode.toLowerCase());
        if (response == null) {
            throw new IllegalArgumentException("租户不存在: " + tenantCode);
        }
        return response;
    }

    private void validate(TenantRegistrationRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("请求体不能为空");
        }
        if (!StringUtils.hasText(request.tenantCode())) {
            throw new IllegalArgumentException("tenantCode 不能为空");
        }
        if (!StringUtils.hasText(request.tenantName())) {
            throw new IllegalArgumentException("tenantName 不能为空");
        }
        if (!StringUtils.hasText(request.adminUsername())) {
            throw new IllegalArgumentException("adminUsername 不能为空");
        }
        if (!StringUtils.hasText(request.adminEmail())) {
            throw new IllegalArgumentException("adminEmail 不能为空");
        }
    }
}
