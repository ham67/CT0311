package com.example.sso.dto;

import jakarta.validation.constraints.NotBlank;

public record TenantRegistrationRequest(
        @NotBlank String tenantCode,
        @NotBlank String tenantName,
        @NotBlank String adminUsername,
        @NotBlank String adminEmail,
        @NotBlank String companyName,
        @NotBlank String unifiedSocialCreditCode,
        String contactPhone,
        String businessLicenseNo
) {
}
