CREATE TABLE IF NOT EXISTS users (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(500) NOT NULL,
    enabled BOOLEAN NOT NULL
);

COMMENT ON TABLE users IS '系统用户表';
COMMENT ON COLUMN users.username IS '用户名';
COMMENT ON COLUMN users.password IS '加密后的密码';
COMMENT ON COLUMN users.enabled IS '是否启用';

CREATE TABLE IF NOT EXISTS authorities (
    username VARCHAR(50) NOT NULL,
    authority VARCHAR(50) NOT NULL,
    CONSTRAINT fk_authorities_users FOREIGN KEY(username) REFERENCES users(username),
    CONSTRAINT ix_auth_username UNIQUE (username, authority)
);

COMMENT ON TABLE authorities IS '用户权限表';
COMMENT ON COLUMN authorities.username IS '用户名';
COMMENT ON COLUMN authorities.authority IS '权限标识（如ROLE_ADMIN）';

CREATE TABLE IF NOT EXISTS oauth2_registered_client (
    id VARCHAR(100) PRIMARY KEY,
    client_id VARCHAR(100) NOT NULL,
    client_id_issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    client_secret VARCHAR(200) DEFAULT NULL,
    client_secret_expires_at TIMESTAMP DEFAULT NULL,
    client_name VARCHAR(200) NOT NULL,
    client_authentication_methods VARCHAR(1000) NOT NULL,
    authorization_grant_types VARCHAR(1000) NOT NULL,
    redirect_uris VARCHAR(1000) DEFAULT NULL,
    post_logout_redirect_uris VARCHAR(1000) DEFAULT NULL,
    scopes VARCHAR(1000) NOT NULL,
    client_settings VARCHAR(2000) NOT NULL,
    token_settings VARCHAR(2000) NOT NULL
);

COMMENT ON TABLE oauth2_registered_client IS 'OAuth2注册客户端表';
COMMENT ON COLUMN oauth2_registered_client.id IS '客户端主键ID';
COMMENT ON COLUMN oauth2_registered_client.client_id IS '客户端ID';
COMMENT ON COLUMN oauth2_registered_client.client_id_issued_at IS '客户端ID签发时间';
COMMENT ON COLUMN oauth2_registered_client.client_secret IS '客户端密钥';
COMMENT ON COLUMN oauth2_registered_client.client_secret_expires_at IS '客户端密钥过期时间';
COMMENT ON COLUMN oauth2_registered_client.client_name IS '客户端名称';
COMMENT ON COLUMN oauth2_registered_client.client_authentication_methods IS '客户端认证方式';
COMMENT ON COLUMN oauth2_registered_client.authorization_grant_types IS '授权类型';
COMMENT ON COLUMN oauth2_registered_client.redirect_uris IS '重定向地址列表';
COMMENT ON COLUMN oauth2_registered_client.post_logout_redirect_uris IS '登出后重定向地址列表';
COMMENT ON COLUMN oauth2_registered_client.scopes IS '授权范围';
COMMENT ON COLUMN oauth2_registered_client.client_settings IS '客户端配置JSON';
COMMENT ON COLUMN oauth2_registered_client.token_settings IS '令牌配置JSON';

CREATE TABLE IF NOT EXISTS oauth2_authorization_consent (
    registered_client_id VARCHAR(100) NOT NULL,
    principal_name VARCHAR(200) NOT NULL,
    authorities VARCHAR(1000) NOT NULL,
    PRIMARY KEY (registered_client_id, principal_name)
);

COMMENT ON TABLE oauth2_authorization_consent IS 'OAuth2授权同意表';
COMMENT ON COLUMN oauth2_authorization_consent.registered_client_id IS '客户端ID';
COMMENT ON COLUMN oauth2_authorization_consent.principal_name IS '主体用户名';
COMMENT ON COLUMN oauth2_authorization_consent.authorities IS '同意的权限范围';

CREATE TABLE IF NOT EXISTS oauth2_authorization (
    id VARCHAR(100) PRIMARY KEY,
    registered_client_id VARCHAR(100) NOT NULL,
    principal_name VARCHAR(200) NOT NULL,
    authorization_grant_type VARCHAR(100) NOT NULL,
    authorized_scopes VARCHAR(1000) DEFAULT NULL,
    attributes VARCHAR(4000) DEFAULT NULL,
    state VARCHAR(500) DEFAULT NULL,
    authorization_code_value VARCHAR(4000) DEFAULT NULL,
    authorization_code_issued_at TIMESTAMP DEFAULT NULL,
    authorization_code_expires_at TIMESTAMP DEFAULT NULL,
    authorization_code_metadata VARCHAR(4000) DEFAULT NULL,
    access_token_value VARCHAR(4000) DEFAULT NULL,
    access_token_issued_at TIMESTAMP DEFAULT NULL,
    access_token_expires_at TIMESTAMP DEFAULT NULL,
    access_token_metadata VARCHAR(4000) DEFAULT NULL,
    access_token_type VARCHAR(100) DEFAULT NULL,
    access_token_scopes VARCHAR(1000) DEFAULT NULL,
    oidc_id_token_value VARCHAR(4000) DEFAULT NULL,
    oidc_id_token_issued_at TIMESTAMP DEFAULT NULL,
    oidc_id_token_expires_at TIMESTAMP DEFAULT NULL,
    oidc_id_token_metadata VARCHAR(4000) DEFAULT NULL,
    refresh_token_value VARCHAR(4000) DEFAULT NULL,
    refresh_token_issued_at TIMESTAMP DEFAULT NULL,
    refresh_token_expires_at TIMESTAMP DEFAULT NULL,
    refresh_token_metadata VARCHAR(4000) DEFAULT NULL,
    user_code_value VARCHAR(4000) DEFAULT NULL,
    user_code_issued_at TIMESTAMP DEFAULT NULL,
    user_code_expires_at TIMESTAMP DEFAULT NULL,
    user_code_metadata VARCHAR(4000) DEFAULT NULL,
    device_code_value VARCHAR(4000) DEFAULT NULL,
    device_code_issued_at TIMESTAMP DEFAULT NULL,
    device_code_expires_at TIMESTAMP DEFAULT NULL,
    device_code_metadata VARCHAR(4000) DEFAULT NULL
);

COMMENT ON TABLE oauth2_authorization IS 'OAuth2授权信息表';
COMMENT ON COLUMN oauth2_authorization.id IS '授权记录ID';
COMMENT ON COLUMN oauth2_authorization.registered_client_id IS '客户端ID';
COMMENT ON COLUMN oauth2_authorization.principal_name IS '主体用户名';
COMMENT ON COLUMN oauth2_authorization.authorization_grant_type IS '授权模式';
COMMENT ON COLUMN oauth2_authorization.authorized_scopes IS '已授权范围';
COMMENT ON COLUMN oauth2_authorization.attributes IS '扩展属性JSON';
COMMENT ON COLUMN oauth2_authorization.state IS 'OAuth2状态参数';
COMMENT ON COLUMN oauth2_authorization.authorization_code_value IS '授权码值';
COMMENT ON COLUMN oauth2_authorization.authorization_code_issued_at IS '授权码签发时间';
COMMENT ON COLUMN oauth2_authorization.authorization_code_expires_at IS '授权码过期时间';
COMMENT ON COLUMN oauth2_authorization.authorization_code_metadata IS '授权码元数据';
COMMENT ON COLUMN oauth2_authorization.access_token_value IS '访问令牌值';
COMMENT ON COLUMN oauth2_authorization.access_token_issued_at IS '访问令牌签发时间';
COMMENT ON COLUMN oauth2_authorization.access_token_expires_at IS '访问令牌过期时间';
COMMENT ON COLUMN oauth2_authorization.access_token_metadata IS '访问令牌元数据';
COMMENT ON COLUMN oauth2_authorization.access_token_type IS '访问令牌类型';
COMMENT ON COLUMN oauth2_authorization.access_token_scopes IS '访问令牌范围';
COMMENT ON COLUMN oauth2_authorization.oidc_id_token_value IS 'OIDC ID令牌值';
COMMENT ON COLUMN oauth2_authorization.oidc_id_token_issued_at IS 'OIDC ID令牌签发时间';
COMMENT ON COLUMN oauth2_authorization.oidc_id_token_expires_at IS 'OIDC ID令牌过期时间';
COMMENT ON COLUMN oauth2_authorization.oidc_id_token_metadata IS 'OIDC ID令牌元数据';
COMMENT ON COLUMN oauth2_authorization.refresh_token_value IS '刷新令牌值';
COMMENT ON COLUMN oauth2_authorization.refresh_token_issued_at IS '刷新令牌签发时间';
COMMENT ON COLUMN oauth2_authorization.refresh_token_expires_at IS '刷新令牌过期时间';
COMMENT ON COLUMN oauth2_authorization.refresh_token_metadata IS '刷新令牌元数据';
COMMENT ON COLUMN oauth2_authorization.user_code_value IS '设备授权用户码值';
COMMENT ON COLUMN oauth2_authorization.user_code_issued_at IS '设备授权用户码签发时间';
COMMENT ON COLUMN oauth2_authorization.user_code_expires_at IS '设备授权用户码过期时间';
COMMENT ON COLUMN oauth2_authorization.user_code_metadata IS '设备授权用户码元数据';
COMMENT ON COLUMN oauth2_authorization.device_code_value IS '设备码值';
COMMENT ON COLUMN oauth2_authorization.device_code_issued_at IS '设备码签发时间';
COMMENT ON COLUMN oauth2_authorization.device_code_expires_at IS '设备码过期时间';
COMMENT ON COLUMN oauth2_authorization.device_code_metadata IS '设备码元数据';
