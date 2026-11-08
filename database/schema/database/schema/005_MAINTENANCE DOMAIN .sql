-- MAINTENANCE DOMAIN


-- 1. MAINTENANCE JOB TYPES

CREATE TABLE maintenance_job_types (
    job_type_id BIGSERIAL PRIMARY KEY,

    type_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,

    CONSTRAINT chk_maintenance_job_type_name
        CHECK (length(trim(type_name)) > 0),

    CONSTRAINT chk_maintenance_job_type_description
        CHECK (
            description IS NULL
            OR length(trim(description)) > 0
        )
);

-- 2. MAINTENANCE JOBS
CREATE TABLE maintenance_jobs (
    job_id BIGSERIAL PRIMARY KEY,

    job_type_id BIGINT NOT NULL,
    department_id BIGINT NOT NULL,

    job_code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,

    priority_id BIGINT,
    urgency_id BIGINT,

    due_date TIMESTAMP NOT NULL,

    required_duration INTEGER NOT NULL,
    min_duration INTEGER NOT NULL,
    max_duration INTEGER NOT NULL,

    earliest_start TIMESTAMP,
    latest_finish TIMESTAMP,

    required_possession BOOLEAN NOT NULL DEFAULT FALSE,
    splittable BOOLEAN NOT NULL DEFAULT FALSE,
    preemptible BOOLEAN NOT NULL DEFAULT FALSE,

    setup_time INTEGER NOT NULL DEFAULT 0,
    cleanup_time INTEGER NOT NULL DEFAULT 0,

    risk_severity_id BIGINT,

    condition_triggered BOOLEAN NOT NULL DEFAULT FALSE,
    condition_score NUMERIC(5,2),

    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',


-- CONSTRAINTS

    CONSTRAINT chk_maintenance_job_code
        CHECK (length(trim(job_code)) > 0),

    CONSTRAINT chk_required_duration
        CHECK (required_duration > 0),

    CONSTRAINT chk_min_duration
        CHECK (min_duration > 0),

    CONSTRAINT chk_max_duration
        CHECK (max_duration >= min_duration),

    CONSTRAINT chk_required_duration_range
        CHECK (
            required_duration >= min_duration
            AND required_duration <= max_duration
        ),

    CONSTRAINT chk_maintenance_window
        CHECK (
            latest_finish IS NULL
            OR earliest_start IS NULL
            OR latest_finish >= earliest_start
        ),

    CONSTRAINT chk_setup_time
        CHECK (setup_time >= 0),

    CONSTRAINT chk_cleanup_time
        CHECK (cleanup_time >= 0),

    CONSTRAINT chk_condition_score
        CHECK (
            condition_score IS NULL
            OR condition_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_condition_trigger
        CHECK (
            condition_triggered = FALSE
            OR condition_score IS NOT NULL
        ),

    CONSTRAINT chk_maintenance_status
        CHECK (
            status IN (
                'PENDING',
                'SCHEDULED',
                'IN_PROGRESS',
                'COMPLETED',
                'CANCELLED',
                'ON_HOLD'
            )
        ),

    CONSTRAINT chk_latest_finish_due_date
        CHECK (
            latest_finish IS NULL
            OR latest_finish <= due_date
        ),

    CONSTRAINT chk_due_date
        CHECK (
            due_date IS NOT NULL
        ),

    CONSTRAINT chk_job_duration_consistency
        CHECK (
            max_duration >= required_duration
        ),

    CONSTRAINT chk_maintenance_window_duration
        CHECK (
            earliest_start IS NULL
            OR latest_finish IS NULL
            OR EXTRACT(
                EPOCH FROM (latest_finish - earliest_start)
            ) / 60 >= min_duration
        ),

    CONSTRAINT chk_job_type_valid
        CHECK (job_type_id > 0),

    CONSTRAINT chk_department_valid
        CHECK (department_id > 0),

    CONSTRAINT chk_priority_valid
        CHECK (
            priority_id IS NULL
            OR priority_id > 0
        ),

    CONSTRAINT chk_urgency_valid
        CHECK (
            urgency_id IS NULL
            OR urgency_id > 0
        ),

    CONSTRAINT chk_risk_severity_valid
        CHECK (
            risk_severity_id IS NULL
            OR risk_severity_id > 0
        )
);


-- 3. MAINTENANCE JOB ASSETS

CREATE TABLE maintenance_job_assets (
    id BIGSERIAL PRIMARY KEY,

    job_id BIGINT NOT NULL,
    asset_id BIGINT NOT NULL,

    CONSTRAINT chk_job_asset_job_id
        CHECK (job_id > 0),

    CONSTRAINT chk_job_asset_asset_id
        CHECK (asset_id > 0),

    CONSTRAINT uq_maintenance_job_asset
        UNIQUE (
            job_id,
            asset_id
        ),

    CONSTRAINT chk_job_asset_relationship
        CHECK (
            job_id <> asset_id
        )
);


-- 4. MAINTENANCE JOB SECTIONS

CREATE TABLE maintenance_job_sections (
    id BIGSERIAL PRIMARY KEY,

    job_id BIGINT NOT NULL,
    section_id BIGINT NOT NULL,

    CONSTRAINT chk_job_section_job_id
        CHECK (job_id > 0),

    CONSTRAINT chk_job_section_section_id
        CHECK (section_id > 0),

    CONSTRAINT uq_maintenance_job_section
        UNIQUE (
            job_id,
            section_id
        ),

    CONSTRAINT chk_job_section_relationship
        CHECK (
            job_id <> section_id
        )
);


-- 5. MAINTENANCE REQUIREMENTS

CREATE TABLE maintenance_requirements (
    requirement_id BIGSERIAL PRIMARY KEY,

    job_id BIGINT NOT NULL,
    resource_type VARCHAR(100) NOT NULL,
    quantity_required NUMERIC(12,2) NOT NULL,

    CONSTRAINT chk_requirement_job_id
        CHECK (job_id > 0),

    CONSTRAINT chk_resource_type
        CHECK (
            length(trim(resource_type)) > 0
        ),

    CONSTRAINT chk_quantity_required
        CHECK (
            quantity_required > 0
        ),

    CONSTRAINT uq_job_resource_type
        UNIQUE (
            job_id,
            resource_type
        )
);


-- 6. MAINTENANCE PRIORITIES

CREATE TABLE maintenance_priorities (
    priority_id BIGSERIAL PRIMARY KEY,

    job_id BIGINT NOT NULL,
    priority_level INTEGER NOT NULL,
    effective_from TIMESTAMP NOT NULL,

    CONSTRAINT chk_maintenance_priority_job
        CHECK (job_id > 0),

    CONSTRAINT chk_priority_level
        CHECK (priority_level > 0),

    CONSTRAINT uq_job_priority_effective
        UNIQUE (
            job_id,
            effective_from
        )
);

-- 7. MAINTENANCE DEPENDENCIES

CREATE TABLE maintenance_dependencies (
    dependency_id BIGSERIAL PRIMARY KEY,

    job_id BIGINT NOT NULL,
    depends_on_job_id BIGINT NOT NULL,

    dependency_type VARCHAR(50) NOT NULL,

    CONSTRAINT chk_dependency_job
        CHECK (job_id > 0),

    CONSTRAINT chk_dependency_parent_job
        CHECK (depends_on_job_id > 0),

    CONSTRAINT chk_no_self_dependency
        CHECK (
            job_id <> depends_on_job_id
        ),

    CONSTRAINT chk_dependency_type
        CHECK (
            dependency_type IN (
                'FINISH_TO_START',
                'START_TO_START',
                'FINISH_TO_FINISH',
                'START_TO_FINISH'
            )
        ),

    CONSTRAINT uq_maintenance_dependency
        UNIQUE (
            job_id,
            depends_on_job_id,
            dependency_type
        ),

    CONSTRAINT chk_dependency_pair
        CHECK (
            job_id <> depends_on_job_id
        )
);

-- 8. MAINTENANCE HISTORY

CREATE TABLE maintenance_history (
    history_id BIGSERIAL PRIMARY KEY,

    job_id BIGINT NOT NULL,
    status VARCHAR(30) NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    remarks TEXT,

    CONSTRAINT chk_history_job
        CHECK (job_id > 0),

    CONSTRAINT chk_history_status
        CHECK (
            status IN (
                'PENDING',
                'SCHEDULED',
                'IN_PROGRESS',
                'COMPLETED',
                'CANCELLED',
                'ON_HOLD'
            )
        ),

    CONSTRAINT chk_history_remarks
        CHECK (
            remarks IS NULL
            OR length(trim(remarks)) > 0
        ),

    CONSTRAINT uq_job_history_change
        UNIQUE (
            job_id,
            changed_at
        )
);

-- 9. MAINTENANCE TRANSITION COSTS

CREATE TABLE maintenance_transition_costs (
    transition_id BIGSERIAL PRIMARY KEY,

    from_job_type_id BIGINT NOT NULL,
    to_job_type_id BIGINT NOT NULL,

    from_location_id BIGINT NOT NULL,
    to_location_id BIGINT NOT NULL,

    travel_time INTEGER NOT NULL DEFAULT 0,
    setup_time INTEGER NOT NULL DEFAULT 0,
    equipment_change_time INTEGER NOT NULL DEFAULT 0,
    crew_change_time INTEGER NOT NULL DEFAULT 0,

    cost NUMERIC(12,2) NOT NULL DEFAULT 0,


-- CONSTRAINTS
    
    CONSTRAINT chk_from_job_type
        CHECK (from_job_type_id > 0),

    CONSTRAINT chk_to_job_type
        CHECK (to_job_type_id > 0),

    CONSTRAINT chk_from_location
        CHECK (from_location_id > 0),

    CONSTRAINT chk_to_location
        CHECK (to_location_id > 0),

    CONSTRAINT chk_travel_time
        CHECK (travel_time >= 0),

    CONSTRAINT chk_setup_time_transition
        CHECK (setup_time >= 0),

    CONSTRAINT chk_equipment_change_time
        CHECK (equipment_change_time >= 0),

    CONSTRAINT chk_crew_change_time
        CHECK (crew_change_time >= 0),

    CONSTRAINT chk_transition_cost
        CHECK (cost >= 0),

    CONSTRAINT uq_maintenance_transition
        UNIQUE (
            from_job_type_id,
            to_job_type_id,
            from_location_id,
            to_location_id
        ),

    CONSTRAINT chk_transition_job_types
        CHECK (
            from_job_type_id <> to_job_type_id
            OR from_location_id <> to_location_id
        )
);


-- INDEXES

CREATE INDEX idx_maintenance_jobs_job_type
    ON maintenance_jobs(job_type_id);

CREATE INDEX idx_maintenance_jobs_department
    ON maintenance_jobs(department_id);

CREATE INDEX idx_maintenance_jobs_priority
    ON maintenance_jobs(priority_id);

CREATE INDEX idx_maintenance_jobs_urgency
    ON maintenance_jobs(urgency_id);

CREATE INDEX idx_maintenance_jobs_due_date
    ON maintenance_jobs(due_date);

CREATE INDEX idx_maintenance_jobs_status
    ON maintenance_jobs(status);

CREATE INDEX idx_maintenance_jobs_risk
    ON maintenance_jobs(risk_severity_id);

CREATE INDEX idx_maintenance_job_assets_job
    ON maintenance_job_assets(job_id);

CREATE INDEX idx_maintenance_job_assets_asset
    ON maintenance_job_assets(asset_id);

CREATE INDEX idx_maintenance_job_sections_job
    ON maintenance_job_sections(job_id);

CREATE INDEX idx_maintenance_job_sections_section
    ON maintenance_job_sections(section_id);

CREATE INDEX idx_maintenance_requirements_job
    ON maintenance_requirements(job_id);

CREATE INDEX idx_maintenance_priorities_job
    ON maintenance_priorities(job_id);

CREATE INDEX idx_maintenance_dependencies_job
    ON maintenance_dependencies(job_id);

CREATE INDEX idx_maintenance_dependencies_depends_on
    ON maintenance_dependencies(depends_on_job_id);

CREATE INDEX idx_maintenance_history_job
    ON maintenance_history(job_id);

CREATE INDEX idx_maintenance_history_changed_at
    ON maintenance_history(changed_at);

CREATE INDEX idx_maintenance_transition_from_type
    ON maintenance_transition_costs(from_job_type_id);

CREATE INDEX idx_maintenance_transition_to_type
    ON maintenance_transition_costs(to_job_type_id);

CREATE INDEX idx_maintenance_transition_from_location
    ON maintenance_transition_costs(from_location_id);

CREATE INDEX idx_maintenance_transition_to_location
    ON maintenance_transition_costs(to_location_id);