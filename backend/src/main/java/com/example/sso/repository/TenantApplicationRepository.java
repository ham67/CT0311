package com.example.sso.repository;

import com.example.sso.entity.TenantApplication;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface TenantApplicationRepository extends JpaRepository<TenantApplication, Long> {
    boolean existsByTenantCode(String tenantCode);
    boolean existsByUnifiedSocialCreditCode(String unifiedSocialCreditCode);
    Optional<TenantApplication> findByTenantCode(String tenantCode);
}
