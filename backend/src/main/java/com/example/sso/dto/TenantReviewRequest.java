package com.example.sso.dto;

import jakarta.validation.constraints.NotBlank;

public record TenantReviewRequest(
        @NotBlank String action,
        String comment
) {
}
