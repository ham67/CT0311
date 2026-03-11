package com.example.sso.dto;

import java.time.LocalDateTime;

public record TenantRegistrationResponse(
        Long id,
        String tenantCode,
        String tenantName,
        String adminUsername,
        String companyName,
        String status,
        String reviewComment,
        LocalDateTime createdAt
) {
}
