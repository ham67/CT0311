package com.example.sso.controller;

import com.example.sso.dto.TenantRegistrationRequest;
import com.example.sso.dto.TenantRegistrationResponse;
import com.example.sso.service.TenantRegistrationService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/tenants")
public class TenantController {

    private final TenantRegistrationService tenantRegistrationService;

    public TenantController(TenantRegistrationService tenantRegistrationService) {
        this.tenantRegistrationService = tenantRegistrationService;
    }

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    public TenantRegistrationResponse register(@RequestBody TenantRegistrationRequest request) {
        return tenantRegistrationService.register(request);
    }

    @GetMapping("/{tenantCode}")
    public TenantRegistrationResponse getByCode(@PathVariable String tenantCode) {
        return tenantRegistrationService.getByCode(tenantCode);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Map<String, Object> handleIllegalArg(IllegalArgumentException ex) {
        return Map.of("code", 400, "message", ex.getMessage());
    }
}
