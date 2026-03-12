CREATE TABLE IF NOT EXISTS users (
    username VARCHAR(50) PRIMARY KEY COMMENT '用户名',
    password VARCHAR(500) NOT NULL COMMENT '加密后的密码',
    enabled TINYINT(1) NOT NULL COMMENT '是否启用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';

CREATE TABLE IF NOT EXISTS authorities (
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    authority VARCHAR(50) NOT NULL COMMENT '权限标识（如ROLE_ADMIN）',
    CONSTRAINT fk_authorities_users FOREIGN KEY(username) REFERENCES users(username),
    CONSTRAINT ix_auth_username UNIQUE (username, authority)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户权限表';

CREATE TABLE IF NOT EXISTS oauth2_registered_client (
    id VARCHAR(100) PRIMARY KEY COMMENT '客户端主键ID',
    client_id VARCHAR(100) NOT NULL COMMENT '客户端ID',
    client_id_issued_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '客户端ID签发时间',
    client_secret VARCHAR(200) DEFAULT NULL COMMENT '客户端密钥',
    client_secret_expires_at TIMESTAMP NULL DEFAULT NULL COMMENT '客户端密钥过期时间',
    client_name VARCHAR(200) NOT NULL COMMENT '客户端名称',
    client_authentication_methods VARCHAR(1000) NOT NULL COMMENT '客户端认证方式',
    authorization_grant_types VARCHAR(1000) NOT NULL COMMENT '授权类型',
    redirect_uris VARCHAR(1000) DEFAULT NULL COMMENT '重定向地址列表',
    post_logout_redirect_uris VARCHAR(1000) DEFAULT NULL COMMENT '登出后重定向地址列表',
    scopes VARCHAR(1000) NOT NULL COMMENT '授权范围',
    client_settings VARCHAR(2000) NOT NULL COMMENT '客户端配置JSON',
    token_settings VARCHAR(2000) NOT NULL COMMENT '令牌配置JSON'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OAuth2注册客户端表';

CREATE TABLE IF NOT EXISTS oauth2_authorization_consent (
    registered_client_id VARCHAR(100) NOT NULL COMMENT '客户端ID',
    principal_name VARCHAR(200) NOT NULL COMMENT '主体用户名',
    authorities VARCHAR(1000) NOT NULL COMMENT '同意的权限范围',
    PRIMARY KEY (registered_client_id, principal_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OAuth2授权同意表';

CREATE TABLE IF NOT EXISTS oauth2_authorization (
    id VARCHAR(100) PRIMARY KEY COMMENT '授权记录ID',
    registered_client_id VARCHAR(100) NOT NULL COMMENT '客户端ID',
    principal_name VARCHAR(200) NOT NULL COMMENT '主体用户名',
    authorization_grant_type VARCHAR(100) NOT NULL COMMENT '授权模式',
    authorized_scopes VARCHAR(1000) DEFAULT NULL COMMENT '已授权范围',
    attributes TEXT DEFAULT NULL COMMENT '扩展属性JSON',
    state VARCHAR(500) DEFAULT NULL COMMENT 'OAuth2状态参数',
    authorization_code_value TEXT DEFAULT NULL COMMENT '授权码值',
    authorization_code_issued_at TIMESTAMP NULL DEFAULT NULL COMMENT '授权码签发时间',
    authorization_code_expires_at TIMESTAMP NULL DEFAULT NULL COMMENT '授权码过期时间',
    authorization_code_metadata TEXT DEFAULT NULL COMMENT '授权码元数据',
    access_token_value TEXT DEFAULT NULL COMMENT '访问令牌值',
    access_token_issued_at TIMESTAMP NULL DEFAULT NULL COMMENT '访问令牌签发时间',
    access_token_expires_at TIMESTAMP NULL DEFAULT NULL COMMENT '访问令牌过期时间',
    access_token_metadata TEXT DEFAULT NULL COMMENT '访问令牌元数据',
    access_token_type VARCHAR(100) DEFAULT NULL COMMENT '访问令牌类型',
    access_token_scopes VARCHAR(1000) DEFAULT NULL COMMENT '访问令牌范围',
    oidc_id_token_value TEXT DEFAULT NULL COMMENT 'OIDC ID令牌值',
    oidc_id_token_issued_at TIMESTAMP NULL DEFAULT NULL COMMENT 'OIDC ID令牌签发时间',
    oidc_id_token_expires_at TIMESTAMP NULL DEFAULT NULL COMMENT 'OIDC ID令牌过期时间',
    oidc_id_token_metadata TEXT DEFAULT NULL COMMENT 'OIDC ID令牌元数据',
    refresh_token_value TEXT DEFAULT NULL COMMENT '刷新令牌值',
    refresh_token_issued_at TIMESTAMP NULL DEFAULT NULL COMMENT '刷新令牌签发时间',
    refresh_token_expires_at TIMESTAMP NULL DEFAULT NULL COMMENT '刷新令牌过期时间',
    refresh_token_metadata TEXT DEFAULT NULL COMMENT '刷新令牌元数据',
    user_code_value TEXT DEFAULT NULL COMMENT '设备授权用户码值',
    user_code_issued_at TIMESTAMP NULL DEFAULT NULL COMMENT '设备授权用户码签发时间',
    user_code_expires_at TIMESTAMP NULL DEFAULT NULL COMMENT '设备授权用户码过期时间',
    user_code_metadata TEXT DEFAULT NULL COMMENT '设备授权用户码元数据',
    device_code_value TEXT DEFAULT NULL COMMENT '设备码值',
    device_code_issued_at TIMESTAMP NULL DEFAULT NULL COMMENT '设备码签发时间',
    device_code_expires_at TIMESTAMP NULL DEFAULT NULL COMMENT '设备码过期时间',
    device_code_metadata TEXT DEFAULT NULL COMMENT '设备码元数据'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OAuth2授权信息表';
