package com.example.sso.controller;

import com.example.sso.dto.TenantRegistrationRequest;
import com.example.sso.dto.TenantRegistrationResponse;
import com.example.sso.dto.TenantReviewRequest;
import com.example.sso.service.TenantRegistrationService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/tenant-applications")
public class TenantController {

    private final TenantRegistrationService tenantRegistrationService;

    public TenantController(TenantRegistrationService tenantRegistrationService) {
        this.tenantRegistrationService = tenantRegistrationService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public TenantRegistrationResponse submit(@RequestBody @Valid TenantRegistrationRequest request) {
        return tenantRegistrationService.submit(request);
    }

    @GetMapping("/{tenantCode}")
    public TenantRegistrationResponse detail(@PathVariable String tenantCode) {
        return tenantRegistrationService.getByTenantCode(tenantCode);
    }

    @PostMapping("/{id}/review")
    public TenantRegistrationResponse review(@PathVariable Long id,
                                             @RequestBody @Valid TenantReviewRequest request,
                                             Authentication authentication) {
        return tenantRegistrationService.review(id, request.action(), request.comment(), authentication.getName());
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Map<String, Object> handleIllegalArg(IllegalArgumentException ex) {
        return Map.of("code", 400, "message", ex.getMessage());
    }
}
