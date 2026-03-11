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

COMMENT ON TABLE tenant_application IS '租户入驻申请表';
COMMENT ON COLUMN tenant_application.id IS '主键ID';
COMMENT ON COLUMN tenant_application.tenant_code IS '租户编码（唯一）';
COMMENT ON COLUMN tenant_application.tenant_name IS '租户名称';
COMMENT ON COLUMN tenant_application.admin_username IS '管理员用户名';
COMMENT ON COLUMN tenant_application.admin_email IS '管理员邮箱';
COMMENT ON COLUMN tenant_application.company_name IS '企业名称';
COMMENT ON COLUMN tenant_application.unified_social_credit_code IS '统一社会信用代码';
COMMENT ON COLUMN tenant_application.contact_phone IS '联系电话';
COMMENT ON COLUMN tenant_application.business_license_no IS '营业执照编号';
COMMENT ON COLUMN tenant_application.status IS '申请状态（SUBMITTED/UNDER_REVIEW/APPROVED/REJECTED）';
COMMENT ON COLUMN tenant_application.review_comment IS '审批意见';
COMMENT ON COLUMN tenant_application.reviewed_by IS '审批人';
COMMENT ON COLUMN tenant_application.created_at IS '创建时间';
COMMENT ON COLUMN tenant_application.updated_at IS '更新时间';

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

COMMENT ON TABLE audit_log IS '审计日志表';
COMMENT ON COLUMN audit_log.id IS '主键ID';
COMMENT ON COLUMN audit_log.method IS '请求方法';
COMMENT ON COLUMN audit_log.uri IS '请求路径';
COMMENT ON COLUMN audit_log.ip IS '请求IP';
COMMENT ON COLUMN audit_log.status IS '响应状态码';
COMMENT ON COLUMN audit_log.username IS '操作用户';
COMMENT ON COLUMN audit_log.user_agent IS '客户端标识';
COMMENT ON COLUMN audit_log.created_at IS '日志时间';
