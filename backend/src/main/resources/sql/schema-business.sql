CREATE TABLE IF NOT EXISTS tenant_application (
    id BIGINT IDENTITY PRIMARY KEY,
    tenant_code VARCHAR(64) NOT NULL UNIQUE,
    tenant_name VARCHAR(128) NOT NULL,
    admin_username VARCHAR(128) NOT NULL,
    admin_email VARCHAR(128) NOT NULL,
    company_name VARCHAR(256) NOT NULL,
    unified_social_credit_code VARCHAR(64) NOT NULL UNIQUE,
    contact_phone VARCHAR(64),
    business_license_no VARCHAR(64),
    status VARCHAR(32) NOT NULL,
    review_comment VARCHAR(512),
    reviewed_by VARCHAR(64),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS audit_log (
    id BIGINT IDENTITY PRIMARY KEY,
    method VARCHAR(16) NOT NULL,
    uri VARCHAR(256) NOT NULL,
    ip VARCHAR(64) NOT NULL,
    status INT NOT NULL,
    username VARCHAR(64),
    user_agent VARCHAR(512),
    created_at TIMESTAMP NOT NULL
);
