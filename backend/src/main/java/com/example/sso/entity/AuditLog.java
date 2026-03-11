package com.example.sso.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "audit_log")
public class AuditLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 16)
    private String method;

    @Column(nullable = false, length = 256)
    private String uri;

    @Column(nullable = false, length = 64)
    private String ip;

    @Column(nullable = false)
    private Integer status;

    @Column(length = 64)
    private String username;

    @Column(length = 512)
    private String userAgent;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    public void setMethod(String method) { this.method = method; }
    public void setUri(String uri) { this.uri = uri; }
    public void setIp(String ip) { this.ip = ip; }
    public void setStatus(Integer status) { this.status = status; }
    public void setUsername(String username) { this.username = username; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
