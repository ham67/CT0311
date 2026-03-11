# 统一登录平台（Spring Authorization Server + Vue + 达梦 + 网关限流）

## 目标能力
- 统一认证：Spring Authorization Server（OIDC）
- 前端：Vue 3
- 数据库：达梦 DM8（Druid 连接池）
- 网关限流：Spring Cloud Gateway + Redis
- 签名密钥：通过 KMS HTTP 接口拉取，避免代码硬编码
- 持久化：用户、客户端、授权信息 JDBC/JPA 落库达梦
- 租户注册：工作流审批 + 企业资质（统一社会信用代码）校验
- 安全增强：审计日志、登录风控、黑白名单
- SSO 单点登录：新增 OAuth2 Client 示例业务系统（`sso-client`）

## 项目结构
```text
.
├── backend/      # 认证中心（Authorization Server）
├── gateway/      # 统一网关（Redis 限流）
├── frontend/     # Vue 前端
└── sso-client/   # SSO 客户端业务系统示例
```

## 后端（backend）关键实现
1. **达梦 + Druid**
   - `spring.datasource.type=com.alibaba.druid.pool.DruidDataSource`
2. **Authorization Server 持久化**
   - `JdbcRegisteredClientRepository`
   - `JdbcOAuth2AuthorizationService`
   - `JdbcOAuth2AuthorizationConsentService`
   - `JdbcUserDetailsManager`
3. **KMS 签名密钥接入**
   - `HttpKmsKeyService` 通过 `kms.endpoint + token` 拉取 PEM 公私钥
4. **租户工作流审批**
   - 提交申请：`POST /api/tenant-applications`
   - 查询申请：`GET /api/tenant-applications/{tenantCode}`
   - 审批申请：`POST /api/tenant-applications/{id}/review`（ADMIN）
5. **资质校验**
   - 统一社会信用代码正则校验（18位大写字母/数字）
6. **风控与黑白名单**
   - `RiskControlFilter`：黑名单拦截、白名单放行、异常 UA 拦截
7. **审计日志**
   - `AuditLogFilter` 持久化请求方法、URI、IP、状态码、用户等信息
8. **新增 SSO 客户端注册**
   - 认证中心自动注册 `sso-client-app`（授权码 + 刷新令牌）

## 网关（gateway）限流
- 基于 Spring Cloud Gateway + Redis 的全局限流
- 默认按源 IP 进行限流（`KeyResolver`）
- 默认 30 req/s，突发容量 60

## SSO 单点登录（sso-client）
- 示例业务系统端口：`9101`
- 客户端类型：OAuth2 Client（`spring-boot-starter-oauth2-client`）
- 关键路径：
  - 访问受保护资源：`http://localhost:9101/user`
  - 触发登录：自动跳转认证中心
  - 单点登出：`http://localhost:9101/logout`（OIDC RP-Initiated Logout）
- 客户端使用认证中心 `issuer-uri: http://localhost:8080`

## SQL 初始化
- `backend/src/main/resources/sql/schema-security.sql`
- `backend/src/main/resources/sql/schema-business.sql`

## 启动（示例）
```bash
# 1) 启动 backend（认证中心）
cd backend && mvn spring-boot:run

# 2) 启动 gateway
cd ../gateway && mvn spring-boot:run

# 3) 启动 sso-client（示例业务系统）
cd ../sso-client && mvn spring-boot:run

# 4) 启动 frontend（可选）
cd ../frontend && npm install && npm run dev
```

> 建议认证相关请求统一走网关 `http://localhost:8080`。
