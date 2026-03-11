package com.example.sso.dto;

import java.time.LocalDateTime;

public record TenantRegistrationResponse(
        String tenantCode,
        String tenantName,
        String adminUsername,
        String status,
        LocalDateTime createdAt
) {
}
