package com.example.sso.risk;

import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.ArrayList;
import java.util.List;

@ConfigurationProperties(prefix = "risk-control")
public class RiskControlProperties {

    private List<String> whitelistIps = new ArrayList<>();
    private List<String> blacklistIps = new ArrayList<>();

    public List<String> getWhitelistIps() { return whitelistIps; }
    public void setWhitelistIps(List<String> whitelistIps) { this.whitelistIps = whitelistIps; }
    public List<String> getBlacklistIps() { return blacklistIps; }
    public void setBlacklistIps(List<String> blacklistIps) { this.blacklistIps = blacklistIps; }
}
