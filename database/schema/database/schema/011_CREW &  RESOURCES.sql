--  CREW & RESOURCES


-- 1. CREW MEMBERS

CREATE TABLE crew_members (
    crew_id BIGSERIAL PRIMARY KEY,
    department_id BIGINT NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role VARCHAR(100) NOT NULL,
    contact_number VARCHAR(30),
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT chk_crew_department
        CHECK (department_id > 0),

    CONSTRAINT chk_crew_name
        CHECK (length(trim(full_name)) > 0),

    CONSTRAINT chk_crew_role
        CHECK (length(trim(role)) > 0),

    CONSTRAINT chk_crew_status
        CHECK (status IN (
            'ACTIVE',
            'INACTIVE',
            'SUSPENDED',
            'ON_LEAVE'
        ))
);


-- ============================================================
-- 2. CREW SHIFTS
-- ============================================================

CREATE TABLE crew_shifts (
    shift_id BIGSERIAL PRIMARY KEY,
    crew_id BIGINT NOT NULL,
    shift_start TIMESTAMPTZ NOT NULL,
    shift_end TIMESTAMPTZ NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'SCHEDULED',

    CONSTRAINT chk_crew_shifts_crew
        CHECK (crew_id > 0),

    CONSTRAINT chk_crew_shifts_time
        CHECK (shift_end > shift_start),

    CONSTRAINT chk_crew_shifts_status
        CHECK (status IN (
            'SCHEDULED',
            'ACTIVE',
            'COMPLETED',
            'CANCELLED'
        )),

    CONSTRAINT uq_crew_shift
        UNIQUE (
            crew_id,
            shift_start,
            shift_end
        )
);


-- ============================================================
-- 3. RESOURCES
-- ============================================================

CREATE TABLE resources (
    resource_id BIGSERIAL PRIMARY KEY,
    resource_name VARCHAR(150) NOT NULL,
    resource_type VARCHAR(100) NOT NULL,
    total_quantity NUMERIC(12,2) NOT NULL,
    unit VARCHAR(50) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE',

    CONSTRAINT chk_resources_quantity
        CHECK (total_quantity >= 0),

    CONSTRAINT chk_resources_name
        CHECK (length(trim(resource_name)) > 0),

    CONSTRAINT chk_resources_type
        CHECK (length(trim(resource_type)) > 0),

    CONSTRAINT chk_resources_unit
        CHECK (length(trim(unit)) > 0),

    CONSTRAINT chk_resources_status
        CHECK (status IN (
            'AVAILABLE',
            'PARTIALLY_AVAILABLE',
            'UNAVAILABLE',
            'MAINTENANCE',
            'RETIRED'
        )),

    CONSTRAINT uq_resource_name_type
        UNIQUE (
            resource_name,
            resource_type
        )
);


-- ============================================================
-- 4. BLOCK CREW ASSIGNMENTS
-- ============================================================

CREATE TABLE block_crew_assignments (
    id BIGSERIAL PRIMARY KEY,
    block_id BIGINT NOT NULL,
    crew_id BIGINT NOT NULL,
    role_in_block VARCHAR(100) NOT NULL,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_block_crew_block
        CHECK (block_id > 0),

    CONSTRAINT chk_block_crew_crew
        CHECK (crew_id > 0),

    CONSTRAINT chk_block_crew_role
        CHECK (length(trim(role_in_block)) > 0),

    CONSTRAINT chk_block_crew_assigned_at
        CHECK (assigned_at <= CURRENT_TIMESTAMP),

    CONSTRAINT uq_block_crew_assignment
        UNIQUE (
            block_id,
            crew_id
        )
);


-- ============================================================
-- 5. BLOCK RESOURCE ASSIGNMENTS
-- ============================================================

CREATE TABLE block_resource_assignments (
    id BIGSERIAL PRIMARY KEY,
    block_id BIGINT NOT NULL,
    resource_id BIGINT NOT NULL,
    quantity_allocated NUMERIC(12,2) NOT NULL,

    CONSTRAINT chk_block_resource_block
        CHECK (block_id > 0),

    CONSTRAINT chk_block_resource_resource
        CHECK (resource_id > 0),

    CONSTRAINT chk_block_resource_quantity
        CHECK (quantity_allocated > 0),

    CONSTRAINT uq_block_resource_assignment
        UNIQUE (
            block_id,
            resource_id
        )
);


-- ============================================================
-- 6. RESOURCE AVAILABILITY
-- ============================================================

CREATE TABLE resource_availability (
    availability_id BIGSERIAL PRIMARY KEY,
    resource_id BIGINT NOT NULL,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    available_quantity NUMERIC(12,2) NOT NULL,
    row_version BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT chk_resource_availability_resource
        CHECK (resource_id > 0),

    CONSTRAINT chk_resource_availability_time
        CHECK (end_time > start_time),

    CONSTRAINT chk_resource_available_quantity
        CHECK (available_quantity >= 0),

    CONSTRAINT chk_resource_row_version
        CHECK (row_version > 0),

    CONSTRAINT uq_resource_availability_window
        UNIQUE (
            resource_id,
            start_time,
            end_time
        )
);


-- ============================================================
-- 7. EQUIPMENT TYPES
-- ============================================================

CREATE TABLE equipment_types (
    equipment_type_id BIGSERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    description TEXT,

    CONSTRAINT chk_equipment_type_name
        CHECK (length(trim(type_name)) > 0),

    CONSTRAINT uq_equipment_type_name
        UNIQUE (type_name)
);


-- ============================================================
-- 8. MAINTENANCE EQUIPMENT
-- ============================================================

CREATE TABLE maintenance_equipment (
    equipment_id BIGSERIAL PRIMARY KEY,
    equipment_type_id BIGINT NOT NULL,
    equipment_code VARCHAR(100) NOT NULL,
    home_location_id BIGINT,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    availability_status VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE',

    CONSTRAINT chk_maintenance_equipment_type
        CHECK (equipment_type_id > 0),

    CONSTRAINT chk_maintenance_equipment_location
        CHECK (
            home_location_id IS NULL
            OR home_location_id > 0
        ),

    CONSTRAINT chk_maintenance_equipment_code
        CHECK (length(trim(equipment_code)) > 0),

    CONSTRAINT chk_maintenance_equipment_status
        CHECK (status IN (
            'ACTIVE',
            'INACTIVE',
            'RETIRED',
            'MAINTENANCE'
        )),

    CONSTRAINT chk_maintenance_equipment_availability
        CHECK (availability_status IN (
            'AVAILABLE',
            'ALLOCATED',
            'UNAVAILABLE',
            'MAINTENANCE'
        )),

    CONSTRAINT uq_equipment_code
        UNIQUE (equipment_code)
);


-- ============================================================
-- 9. EQUIPMENT AVAILABILITY
-- ============================================================

CREATE TABLE equipment_availability (
    availability_id BIGSERIAL PRIMARY KEY,
    equipment_id BIGINT NOT NULL,
    available_from TIMESTAMPTZ NOT NULL,
    available_to TIMESTAMPTZ NOT NULL,
    location_id BIGINT,
    status VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE',
    row_version BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT chk_equipment_availability_equipment
        CHECK (equipment_id > 0),

    CONSTRAINT chk_equipment_availability_time
        CHECK (available_to > available_from),

    CONSTRAINT chk_equipment_availability_location
        CHECK (
            location_id IS NULL
            OR location_id > 0
        ),

    CONSTRAINT chk_equipment_availability_status
        CHECK (status IN (
            'AVAILABLE',
            'ALLOCATED',
            'UNAVAILABLE',
            'MAINTENANCE'
        )),

    CONSTRAINT chk_equipment_availability_version
        CHECK (row_version > 0),

    CONSTRAINT uq_equipment_availability_window
        UNIQUE (
            equipment_id,
            available_from,
            available_to
        )
);


-- ============================================================
-- 10. MAINTENANCE JOB REQUIRED EQUIPMENT
-- ============================================================

CREATE TABLE maintenance_job_required_equipment (
    id BIGSERIAL PRIMARY KEY,
    job_id BIGINT NOT NULL,
    equipment_type_id BIGINT NOT NULL,
    quantity_required NUMERIC(12,2) NOT NULL,
    required_duration INTERVAL NOT NULL,

    CONSTRAINT chk_job_required_equipment_job
        CHECK (job_id > 0),

    CONSTRAINT chk_job_required_equipment_type
        CHECK (equipment_type_id > 0),

    CONSTRAINT chk_job_required_equipment_quantity
        CHECK (quantity_required > 0),

    CONSTRAINT chk_job_required_equipment_duration
        CHECK (required_duration > INTERVAL '0'),

    CONSTRAINT uq_job_required_equipment
        UNIQUE (
            job_id,
            equipment_type_id
        )
);


-- ============================================================
-- 11. CREW SKILLS
-- ============================================================

CREATE TABLE crew_skills (
    skill_id BIGSERIAL PRIMARY KEY,
    skill_name VARCHAR(150) NOT NULL,

    CONSTRAINT chk_crew_skill_name
        CHECK (length(trim(skill_name)) > 0),

    CONSTRAINT uq_crew_skill_name
        UNIQUE (skill_name)
);


-- ============================================================
-- 12. CREW MEMBER SKILLS
-- ============================================================

CREATE TABLE crew_member_skills (
    id BIGSERIAL PRIMARY KEY,
    crew_id BIGINT NOT NULL,
    skill_id BIGINT NOT NULL,
    certification_level INTEGER NOT NULL,
    valid_until DATE,

    CONSTRAINT chk_crew_member_skill_crew
        CHECK (crew_id > 0),

    CONSTRAINT chk_crew_member_skill_skill
        CHECK (skill_id > 0),

    CONSTRAINT chk_crew_member_skill_level
        CHECK (certification_level >= 1),

    CONSTRAINT chk_crew_member_skill_validity
        CHECK (
            valid_until IS NULL
            OR valid_until >= CURRENT_DATE
        ),

    CONSTRAINT uq_crew_member_skill
        UNIQUE (
            crew_id,
            skill_id
        )
);


-- ============================================================
-- 13. MAINTENANCE JOB REQUIRED SKILLS
-- ============================================================

CREATE TABLE maintenance_job_required_skills (
    id BIGSERIAL PRIMARY KEY,
    job_id BIGINT NOT NULL,
    skill_id BIGINT NOT NULL,
    minimum_level INTEGER NOT NULL,

    CONSTRAINT chk_job_required_skill_job
        CHECK (job_id > 0),

    CONSTRAINT chk_job_required_skill_skill
        CHECK (skill_id > 0),

    CONSTRAINT chk_job_required_skill_level
        CHECK (minimum_level >= 1),

    CONSTRAINT uq_job_required_skill
        UNIQUE (
            job_id,
            skill_id
        )
);


-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_crew_members_department
    ON crew_members(department_id);

CREATE INDEX idx_crew_members_status
    ON crew_members(status);

CREATE INDEX idx_crew_shifts_crew
    ON crew_shifts(crew_id);

CREATE INDEX idx_crew_shifts_time
    ON crew_shifts(shift_start, shift_end);

CREATE INDEX idx_resources_type
    ON resources(resource_type);

CREATE INDEX idx_resources_status
    ON resources(status);

CREATE INDEX idx_block_crew_block
    ON block_crew_assignments(block_id);

CREATE INDEX idx_block_crew_crew
    ON block_crew_assignments(crew_id);

CREATE INDEX idx_block_resource_block
    ON block_resource_assignments(block_id);

CREATE INDEX idx_block_resource_resource
    ON block_resource_assignments(resource_id);

CREATE INDEX idx_resource_availability_resource
    ON resource_availability(resource_id);

CREATE INDEX idx_resource_availability_time
    ON resource_availability(start_time, end_time);

CREATE INDEX idx_maintenance_equipment_type
    ON maintenance_equipment(equipment_type_id);

CREATE INDEX idx_maintenance_equipment_location
    ON maintenance_equipment(home_location_id);

CREATE INDEX idx_maintenance_equipment_status
    ON maintenance_equipment(status);

CREATE INDEX idx_equipment_availability_equipment
    ON equipment_availability(equipment_id);

CREATE INDEX idx_equipment_availability_time
    ON equipment_availability(
        available_from,
        available_to
    );

CREATE INDEX idx_equipment_availability_location
    ON equipment_availability(location_id);

CREATE INDEX idx_job_required_equipment_job
    ON maintenance_job_required_equipment(job_id);

CREATE INDEX idx_job_required_equipment_type
    ON maintenance_job_required_equipment(equipment_type_id);

CREATE INDEX idx_crew_member_skills_crew
    ON crew_member_skills(crew_id);

CREATE INDEX idx_crew_member_skills_skill
    ON crew_member_skills(skill_id);

CREATE INDEX idx_job_required_skills_job
    ON maintenance_job_required_skills(job_id);

CREATE INDEX idx_job_required_skills_skill
    ON maintenance_job_required_skills(skill_id);