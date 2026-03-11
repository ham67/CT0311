package com.example.sso.risk;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class RiskControlFilter extends OncePerRequestFilter {

    private final RiskControlProperties properties;

    public RiskControlFilter(RiskControlProperties properties) {
        this.properties = properties;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String ip = request.getRemoteAddr();
        String userAgent = request.getHeader("User-Agent");

        if (properties.getBlacklistIps().contains(ip)) {
            reject(response, "IP 位于黑名单");
            return;
        }

        if (!properties.getWhitelistIps().isEmpty() && !properties.getWhitelistIps().contains(ip)) {
            reject(response, "IP 不在白名单");
            return;
        }

        if (userAgent == null || userAgent.isBlank()) {
            reject(response, "缺少 User-Agent，触发风控规则");
            return;
        }

        filterChain.doFilter(request, response);
    }

    private void reject(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.getWriter().write("{\"code\":403,\"message\":\"" + message + "\"}");
    }
}
