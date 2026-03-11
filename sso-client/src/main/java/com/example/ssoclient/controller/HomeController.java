package com.example.ssoclient.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.Map;

@RestController
public class HomeController {

    @GetMapping("/")
    public Map<String, Object> index() {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("message", "sso client app is running");
        result.put("login", "http://localhost:9101/user");
        return result;
    }

    @GetMapping("/user")
    public Map<String, Object> user(@AuthenticationPrincipal OidcUser oidcUser) {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("name", oidcUser.getName());
        result.put("email", oidcUser.getEmail());
        result.put("claims", oidcUser.getClaims());
        result.put("logout", "http://localhost:9101/logout");
        return result;
    }

    @GetMapping("/public")
    public Map<String, String> publicEndpoint() {
        return Map.of("status", "ok");
    }
}
