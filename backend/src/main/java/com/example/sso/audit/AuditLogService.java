package com.example.sso.audit;

import com.example.sso.entity.AuditLog;
import com.example.sso.repository.AuditLogRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class AuditLogService {

    private final AuditLogRepository auditLogRepository;

    public AuditLogService(AuditLogRepository auditLogRepository) {
        this.auditLogRepository = auditLogRepository;
    }

    public void write(String method, String uri, String ip, Integer status, String username, String userAgent) {
        AuditLog log = new AuditLog();
        log.setMethod(method);
        log.setUri(uri);
        log.setIp(ip);
        log.setStatus(status);
        log.setUsername(username);
        log.setUserAgent(userAgent);
        log.setCreatedAt(LocalDateTime.now());
        auditLogRepository.save(log);
    }
}
