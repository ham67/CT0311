CREATE TABLE IF NOT EXISTS tenant_application (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    tenant_code VARCHAR(64) NOT NULL UNIQUE COMMENT '租户编码（唯一）',
    tenant_name VARCHAR(128) NOT NULL COMMENT '租户名称',
    admin_username VARCHAR(128) NOT NULL COMMENT '管理员用户名',
    admin_email VARCHAR(128) NOT NULL COMMENT '管理员邮箱',
    company_name VARCHAR(256) NOT NULL COMMENT '企业名称',
    unified_social_credit_code VARCHAR(64) NOT NULL UNIQUE COMMENT '统一社会信用代码',
    contact_phone VARCHAR(64) DEFAULT NULL COMMENT '联系电话',
    business_license_no VARCHAR(64) DEFAULT NULL COMMENT '营业执照编号',
    status VARCHAR(32) NOT NULL COMMENT '申请状态（SUBMITTED/UNDER_REVIEW/APPROVED/REJECTED）',
    review_comment VARCHAR(512) DEFAULT NULL COMMENT '审批意见',
    reviewed_by VARCHAR(64) DEFAULT NULL COMMENT '审批人',
    created_at TIMESTAMP NOT NULL COMMENT '创建时间',
    updated_at TIMESTAMP NOT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='租户入驻申请表';

CREATE TABLE IF NOT EXISTS audit_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    method VARCHAR(16) NOT NULL COMMENT '请求方法',
    uri VARCHAR(256) NOT NULL COMMENT '请求路径',
    ip VARCHAR(64) NOT NULL COMMENT '请求IP',
    status INT NOT NULL COMMENT '响应状态码',
    username VARCHAR(64) DEFAULT NULL COMMENT '操作用户',
    user_agent VARCHAR(512) DEFAULT NULL COMMENT '客户端标识',
    created_at TIMESTAMP NOT NULL COMMENT '日志时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审计日志表';
