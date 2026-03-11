# 统一登录平台（Spring Authorization Server + Vue + 达梦 + 接口限流）

这是一个可扩展的统一登录平台基础骨架，包含：

- 后端：Java 17 + Spring Boot 3 + Spring Authorization Server
- 前端：Vue 3 + Vue Router + Axios
- 数据库：达梦（DM8）
- 限流：Bucket4j（基于 IP + URI 的令牌桶）
- 租户注册：提供租户入驻接口与前端注册页面

## 1. 目录结构

```text
.
├── backend/                    # Spring Authorization Server 后端
│   ├── pom.xml
│   └── src/main
│       ├── java/com/example/sso
│       │   ├── SsoApplication.java
│       │   ├── config/SecurityConfig.java
│       │   ├── controller/UserController.java
│       │   ├── controller/TenantController.java
│       │   ├── dto/TenantRegistrationRequest.java
│       │   ├── dto/TenantRegistrationResponse.java
│       │   ├── service/TenantRegistrationService.java
│       │   └── ratelimit/RateLimitFilter.java
│       └── resources/application.yml
└── frontend/                   # Vue 前端
    ├── package.json
    ├── vite.config.js
    ├── index.html
    └── src
        ├── main.js
        ├── App.vue
        ├── router/index.js
        ├── api/http.js
        └── views
            ├── LoginView.vue
            └── TenantRegisterView.vue
```

## 2. 后端关键点

### 2.1 认证中心（Authorization Server）

- 使用 `spring-security-oauth2-authorization-server`
- 提供 OIDC 支持（`/oauth2/authorize`、`/oauth2/token`、`/userinfo` 等）
- 内置一个示例客户端（`vue-client`）用于前端联调

### 2.2 达梦数据库接入

在 `application.yml` 中配置了达梦连接示例：

- Driver: `dm.jdbc.driver.DmDriver`
- URL: `jdbc:dm://127.0.0.1:5236/SYSDBA`

> 生产上建议把账号密码放到环境变量或配置中心。

### 2.3 接口限流

实现 `RateLimitFilter`：

- 维度：`IP + URI`
- 规则：默认每分钟 60 次
- 超限返回：HTTP 429 + JSON 错误体

### 2.4 租户注册能力

- 开放接口：`POST /api/tenants/register`（无需登录）
- 查询接口：`GET /api/tenants/{tenantCode}`
- 当前实现为内存存储，方便本地联调；生产可替换为达梦持久化。

示例请求：

```json
{
  "tenantCode": "acme",
  "tenantName": "Acme Corp",
  "adminUsername": "acme-admin",
  "adminEmail": "admin@acme.com",
  "contactPhone": "13800000000"
}
```

## 3. 前端关键点

- Vue 3 + Vite
- 登录页提供：
  - 跳转授权登录（Authorization Code）
  - 调用受保护接口 `/api/users/me`
  - 跳转租户注册页面
- 租户注册页提供：
  - 提交租户注册请求
  - 按租户编码查询注册结果

## 4. 启动步骤（示例）

### 4.1 启动后端

```bash
cd backend
mvn spring-boot:run
```

### 4.2 启动前端

```bash
cd frontend
npm install
npm run dev
```

## 5. 生产建议

1. 统一网关层限流（如 Spring Cloud Gateway + Redis）。
2. 令牌签名密钥接入 KMS，不要在代码中硬编码。
3. 用户、客户端、授权信息改为 JDBC/JPA 持久化到达梦。
4. 租户注册改为工作流审批并结合企业资质校验。
5. 增加审计日志、登录风控、黑白名单策略。
6. 增加双因子认证（短信/OTP）与单点登出（RP-Initiated Logout）。
