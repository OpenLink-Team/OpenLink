-- USER AND ACCESS 



-- 1. USERS
CREATE TABLE users (
    user_id BIGSERIAL PRIMARY KEY,

    department_id BIGINT NOT NULL,
    employee_code VARCHAR(50) NOT NULL UNIQUE,

    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),

    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED')),

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
   
);



-- 2. ROLES
CREATE TABLE roles (
    role_id BIGSERIAL PRIMARY KEY,

    role_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);



-- 3.PERMISSIONS
CREATE TABLE permissions (
    permission_id BIGSERIAL PRIMARY KEY,

    module VARCHAR(100) NOT NULL,
    action VARCHAR(100) NOT NULL,

    -- Same module + action should not be duplicated
    CONSTRAINT uq_permission_module_action
        UNIQUE (module, action)
);



-- 4. USER_ROLES
CREATE TABLE user_roles (
    user_role_id BIGSERIAL PRIMARY KEY,

    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,

    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Prevent assigning the same role twice
    CONSTRAINT uq_user_role
        UNIQUE (user_id, role_id)
);



-- 5. ROLE_PERMISSIONS
CREATE TABLE role_permissions (
    role_permission_id BIGSERIAL PRIMARY KEY,

    role_id BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,

    -- Prevent assigning the same permission twice to a role
    CONSTRAINT uq_role_permission
        UNIQUE (role_id, permission_id)
);

