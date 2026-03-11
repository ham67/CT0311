package com.example.sso.dto;

public record TenantRegistrationRequest(
        String tenantCode,
        String tenantName,
        String adminUsername,
        String adminEmail,
        String contactPhone
) {
}
