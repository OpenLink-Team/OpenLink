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




-- RAILWAY NETWORK & INFRASTRUCTURE



-- 1. RAILWAY ZONES
CREATE TABLE railway_zones (
    zone_id BIGSERIAL PRIMARY KEY,
    zone_code VARCHAR(20) NOT NULL,
    zone_name VARCHAR(100) NOT NULL,
    headquarters VARCHAR(150)
);



-- 2. DEPARTMENTS
CREATE TABLE departments (
    department_id BIGSERIAL PRIMARY KEY,
    department_code VARCHAR(20) NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    department_type VARCHAR(50)
);



-- 3. RAILWAY DIVISIONS
CREATE TABLE railway_divisions (
    division_id BIGSERIAL PRIMARY KEY,
    zone_id BIGINT NOT NULL,
    division_code VARCHAR(20) NOT NULL,
    division_name VARCHAR(100) NOT NULL,
    headquarters VARCHAR(150)

);



-- 4. STATIONS
CREATE TABLE stations (
    station_id BIGSERIAL PRIMARY KEY,
    division_id BIGINT NOT NULL,
    station_code VARCHAR(20) NOT NULL,
    station_name VARCHAR(150) NOT NULL,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    station_type VARCHAR(50)

);



-- 5. STATION PLATFORMS
CREATE TABLE station_platforms (
    platform_id BIGSERIAL PRIMARY KEY,
    station_id BIGINT NOT NULL,
    platform_number VARCHAR(20) NOT NULL,
    length_m DECIMAL(10,2),
    platform_type VARCHAR(50)

);



-- 6. SECTIONS
CREATE TABLE sections (
    section_id BIGSERIAL PRIMARY KEY,
    start_station_id BIGINT NOT NULL,
    end_station_id BIGINT NOT NULL,
    section_code VARCHAR(30) NOT NULL,
    length_km DECIMAL(10,3),
    track_type VARCHAR(50),
    status VARCHAR(30)

);



-- 7. SECTION STATIONS
CREATE TABLE section_stations (
    section_station_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    station_id BIGINT NOT NULL,
    sequence_no INTEGER NOT NULL

);


-- 8. TRACKS
CREATE TABLE tracks (
    track_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    track_number VARCHAR(20) NOT NULL,
    gauge VARCHAR(30),
    electrified BOOLEAN,
    status VARCHAR(30)
   
);


-- 9. TRACK SEGMENTS
CREATE TABLE track_segments (
    segment_id BIGSERIAL PRIMARY KEY,
    track_id BIGINT NOT NULL,
    segment_number INTEGER NOT NULL,
    start_km DECIMAL(10,3),
    end_km DECIMAL(10,3),
    speed_limit DECIMAL(10,2)
   
);



-- 10. BLOCK SECTIONS
CREATE TABLE block_sections (
    block_section_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    block_section_code VARCHAR(30) NOT NULL,
    length_km DECIMAL(10,3),
    signalling_type VARCHAR(50)

);


-- 11. ROUTES
CREATE TABLE routes (
    route_id BIGSERIAL PRIMARY KEY,
    route_code VARCHAR(30) NOT NULL,
    route_name VARCHAR(150) NOT NULL,
    description TEXT
);



-- 12. ROUTE SECTIONS
CREATE TABLE route_sections (
    route_section_id BIGSERIAL PRIMARY KEY,
    route_id BIGINT NOT NULL,
    section_id BIGINT NOT NULL,
    sequence_no INTEGER NOT NULL

);



-- 13. JUNCTIONS
CREATE TABLE junctions (
    junction_id BIGSERIAL PRIMARY KEY,
    station_id BIGINT NOT NULL,
    junction_code VARCHAR(30) NOT NULL,
    junction_type VARCHAR(50)
  
);



-- 14. SIGNALS
CREATE TABLE signals (
    signal_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    signal_code VARCHAR(30) NOT NULL,
    signal_type VARCHAR(50),
    aspect_count INTEGER,
    status VARCHAR(30)  
);



-- 15. POINTS / CROSSINGS
CREATE TABLE points_crossings (
    point_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    point_code VARCHAR(30) NOT NULL,
    point_type VARCHAR(50),
    status VARCHAR(30)   
);



-- 16. LEVEL CROSSINGS
CREATE TABLE level_crossings (
    crossing_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    crossing_code VARCHAR(30) NOT NULL,
    gate_type VARCHAR(50),
    manned BOOLEAN 
);



-- 17. BRIDGES
CREATE TABLE bridges (
    bridge_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    bridge_code VARCHAR(30) NOT NULL,
    bridge_type VARCHAR(50),
    span_length_m DECIMAL(10,2),
    condition_status VARCHAR(50) 
);



-- 18. TUNNELS
CREATE TABLE tunnels (
    tunnel_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    tunnel_code VARCHAR(30) NOT NULL,
    length_m DECIMAL(10,2),
    condition_status VARCHAR(50)
);



-- 19. ELECTRIFICATION ASSETS
CREATE TABLE electrification_assets (
    asset_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    asset_code VARCHAR(30) NOT NULL,
    voltage_kv DECIMAL(10,2),
    ohe_type VARCHAR(50),
    status VARCHAR(30)
  
);



-- 20. SIGNALLING ASSETS
CREATE TABLE signalling_assets (
    asset_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    asset_code VARCHAR(30) NOT NULL,
    system_type VARCHAR(50),
    status VARCHAR(30)
    
);



-- 21. TELECOM ASSETS
CREATE TABLE telecom_assets (
    asset_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    asset_code VARCHAR(30) NOT NULL,
    system_type VARCHAR(50),
    status VARCHAR(30)

);



-- 22. CORRIDORS
CREATE TABLE corridors (
    corridor_id BIGSERIAL PRIMARY KEY,
    corridor_code VARCHAR(30) NOT NULL,
    corridor_name VARCHAR(150) NOT NULL,
    description TEXT
);



-- 23. SECTION CORRIDORS
CREATE TABLE section_corridors (
    id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    corridor_id BIGINT NOT NULL
   
);




-- ASSET REGISTRY



-- 1. ASSET TYPES
CREATE TABLE asset_types (
    asset_type_id BIGSERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    department VARCHAR(100)
);



-- 2. ASSETS
CREATE TABLE assets (
    asset_id BIGSERIAL PRIMARY KEY,
    asset_type_id BIGINT NOT NULL,
    department_id BIGINT NOT NULL,
    asset_code VARCHAR(50) NOT NULL,
    asset_name VARCHAR(150) NOT NULL,
    manufacturer VARCHAR(100),
    installation_date DATE,
    status VARCHAR(30)
  
);



-- 3. ASSET LOCATIONS
CREATE TABLE asset_locations (
    location_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL,
    section_id BIGINT NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP
 
);



-- 4. ASSET HEALTH
CREATE TABLE asset_health (
    health_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL,
    health_score DECIMAL(5,2),
    condition_status VARCHAR(50),
    recorded_at TIMESTAMP NOT NULL
  
);



-- 5. ASSET INSPECTIONS
CREATE TABLE asset_inspections (
    inspection_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL,
    inspection_date DATE NOT NULL,
    inspector_name VARCHAR(150),
    findings TEXT,
    result VARCHAR(50)
   
);



-- 6. ASSET FAILURES
CREATE TABLE asset_failures (
    failure_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL,
    failure_date TIMESTAMP NOT NULL,
    failure_type VARCHAR(100),
    severity_id BIGINT NOT NULL,
    resolved BOOLEAN DEFAULT FALSE
   
);

-- 7. ASSET AVAILABILITY
CREATE TABLE asset_availability (
    availability_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    available BOOLEAN NOT NULL
 
);

-- 8. ASSET CONDITION HISTORY
CREATE TABLE asset_condition_history (
    condition_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL,
    inspection_date TIMESTAMP NOT NULL,
    condition_score DECIMAL(5,2),
    severity VARCHAR(50),
    measurement_type VARCHAR(100),
    measurement_value DECIMAL(12,3),
    alert_limit DECIMAL(12,3),
    critical_limit DECIMAL(12,3),
    source_id BIGINT,
    confidence_score DECIMAL(5,2)
  
);


-- 9. ASSET DEGRADATION PREDICTIONS
CREATE TABLE asset_degradation_predictions (
    prediction_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL,
    prediction_time TIMESTAMP NOT NULL,
    predicted_condition VARCHAR(100),
    failure_probability DECIMAL(5,4),
    prediction_horizon VARCHAR(50),
    model_name VARCHAR(100),
    model_version VARCHAR(50),
    confidence_score DECIMAL(5,2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  
);




--Block Request 



-- block types 
CREATE TABLE block_types (
    block_type_id BIGSERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);



--block_request 
CREATE TABLE block_requests (
    request_id BIGSERIAL PRIMARY KEY,

    department_id BIGINT NOT NULL,
    requested_by BIGINT NOT NULL,

    request_code VARCHAR(50) NOT NULL UNIQUE,
    purpose TEXT NOT NULL,

    priority_id BIGINT NOT NULL,

    requested_start TIMESTAMP NOT NULL,
    requested_end TIMESTAMP NOT NULL,

    min_duration INTERVAL NOT NULL,
    max_duration INTERVAL NOT NULL,

    status VARCHAR(30) NOT NULL DEFAULT 'REQUESTED',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    is_emergency BOOLEAN NOT NULL DEFAULT FALSE,

    row_version BIGINT NOT NULL DEFAULT 1,

    

    CONSTRAINT chk_block_request_time
        CHECK (requested_end > requested_start),

    CONSTRAINT chk_block_request_duration
        CHECK (
            min_duration > INTERVAL '0 minutes'
            AND max_duration >= min_duration
        ),

    CONSTRAINT chk_block_request_version
        CHECK (row_version >= 1)
);



-- block_request_jobs
CREATE TABLE block_request_jobs (
    id BIGSERIAL PRIMARY KEY,

    request_id BIGINT NOT NULL,
    job_id BIGINT NOT NULL,

    CONSTRAINT uq_block_request_job
        UNIQUE (request_id, job_id)
);




--block_request_sections
CREATE TABLE block_request_sections (
    id BIGSERIAL PRIMARY KEY,

    request_id BIGINT NOT NULL,
    section_id BIGINT NOT NULL,

    CONSTRAINT uq_block_request_section
        UNIQUE (request_id, section_id)
);



--block_request_tracks
CREATE TABLE block_request_tracks (
    id BIGSERIAL PRIMARY KEY,

    request_id BIGINT NOT NULL,
    track_id BIGINT NOT NULL,

    CONSTRAINT uq_block_request_track
        UNIQUE (request_id, track_id)
);




-- BLOCK PLANNING MODULE



--BLOCK WINDOWS
CREATE TABLE block_windows (
    window_id BIGSERIAL PRIMARY KEY,

    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,

    window_type VARCHAR(50) NOT NULL,
    availability_status VARCHAR(30) NOT NULL,

    capacity_minutes INTEGER NOT NULL,

    row_version BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT chk_block_window_time
        CHECK (end_time > start_time),

    CONSTRAINT chk_block_window_capacity
        CHECK (capacity_minutes > 0),

    CONSTRAINT chk_block_window_version
        CHECK (row_version >= 1)
);



-- BLOCK WINDOW SECTIONS
CREATE TABLE block_window_sections (
    id BIGSERIAL PRIMARY KEY,

    window_id BIGINT NOT NULL,
    section_id BIGINT NOT NULL,

    CONSTRAINT uq_block_window_section
        UNIQUE (window_id, section_id)
);



-- BLOCK WINDOW TRACKS
CREATE TABLE block_window_tracks (
    id BIGSERIAL PRIMARY KEY,

    window_id BIGINT NOT NULL,
    track_id BIGINT NOT NULL,

    CONSTRAINT uq_block_window_track
        UNIQUE (window_id, track_id)
);



-- PLANNED BLOCKS
CREATE TABLE planned_blocks (
    block_id BIGSERIAL PRIMARY KEY,

    block_type_id BIGINT NOT NULL,
    window_id BIGINT NOT NULL,
    request_id BIGINT NOT NULL,

    planned_start TIMESTAMP NOT NULL,
    planned_end TIMESTAMP NOT NULL,

    status VARCHAR(30) NOT NULL,

    row_version BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT chk_planned_block_time
        CHECK (planned_end > planned_start),

    CONSTRAINT chk_planned_block_version
        CHECK (row_version >= 1)
);



-- PLANNED BLOCK JOBS
CREATE TABLE planned_block_jobs (
    id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,
    job_id BIGINT NOT NULL,

    sequence_no INTEGER NOT NULL,

    CONSTRAINT chk_planned_block_job_sequence
        CHECK (sequence_no > 0),

    CONSTRAINT uq_planned_block_job_sequence
        UNIQUE (block_id, sequence_no)
);



-- PLANNED BLOCK SECTIONS
CREATE TABLE planned_block_sections (
    id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,
    section_id BIGINT NOT NULL,

    CONSTRAINT uq_planned_block_section
        UNIQUE (block_id, section_id)
);



-- PLANNED BLOCK TRAINS
CREATE TABLE planned_block_trains (
    id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,
    train_id BIGINT NOT NULL,

    expected_delay INTERVAL,

    CONSTRAINT uq_planned_block_train
        UNIQUE (block_id, train_id),

    CONSTRAINT chk_expected_delay
        CHECK (
            expected_delay IS NULL
            OR expected_delay >= INTERVAL '0 minutes'
        )
);



-- BLOCK STATUS HISTORY
CREATE TABLE block_status_history (
    history_id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,

    status VARCHAR(30) NOT NULL,

    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    remarks TEXT

   
);



-- BLOCK APPROVALS
CREATE TABLE block_approvals (
    approval_id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,

    decision VARCHAR(30) NOT NULL,

    decided_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    comments TEXT

);



-- BLOCK EXECUTION
CREATE TABLE block_execution (
    execution_id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,

    execution_status VARCHAR(30) NOT NULL,

    actual_start TIMESTAMP,
    actual_end TIMESTAMP,

    actual_duration INTERVAL,
    actual_delay INTERVAL,

    completion_percentage DECIMAL(5,2),

    outcome TEXT,

    CONSTRAINT chk_execution_completion
        CHECK (
            completion_percentage IS NULL
            OR completion_percentage BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_execution_time
        CHECK (
            actual_end IS NULL
            OR actual_start IS NULL
            OR actual_end >= actual_start
        ),

    CONSTRAINT chk_execution_delay
        CHECK (
            actual_delay IS NULL
            OR actual_delay >= INTERVAL '0 minutes'
        )
);



-- BLOCK CANCELLATIONS
CREATE TABLE block_cancellations (
    cancellation_id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,

    reason TEXT NOT NULL,

    cancelled_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
   
);



-- BLOCK RESCHEDULING
CREATE TABLE block_rescheduling (
    reschedule_id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,
    new_window_id BIGINT NOT NULL,

    reason TEXT,

    rescheduled_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  
);



-- BLOCK TASKS
CREATE TABLE block_tasks (
    task_id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,
    job_id BIGINT NOT NULL,
    corridor_id BIGINT NOT NULL,

    task_name VARCHAR(200) NOT NULL,

    duration_minutes INTEGER NOT NULL,

    due_at TIMESTAMP,

    urgency_id BIGINT NOT NULL,

    status VARCHAR(30) NOT NULL,

    CONSTRAINT chk_block_task_duration
        CHECK (duration_minutes > 0)
);



--  BLOCK POSSESSIONS
CREATE TABLE block_possessions (
    possession_id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,

    possession_type VARCHAR(50) NOT NULL,

    planned_start TIMESTAMP NOT NULL,
    planned_end TIMESTAMP NOT NULL,

    actual_start TIMESTAMP,
    actual_end TIMESTAMP,

    status VARCHAR(30) NOT NULL,

    safety_status VARCHAR(30) NOT NULL,

    CONSTRAINT chk_possession_planned_time
        CHECK (planned_end > planned_start),

    CONSTRAINT chk_possession_actual_time
        CHECK (
            actual_end IS NULL
            OR actual_start IS NULL
            OR actual_end >= actual_start
        )
);



-- PLAN VERSIONS
CREATE TABLE plan_versions (
    version_id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,

    version_number INTEGER NOT NULL,

    generated_by BIGINT NOT NULL,

    generated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    reason TEXT,

    is_current BOOLEAN NOT NULL DEFAULT FALSE,

    change_type VARCHAR(50),

    rolled_back_from_version_id BIGINT,

    CONSTRAINT chk_plan_version_number
        CHECK (version_number > 0),

    CONSTRAINT uq_plan_version_number
        UNIQUE (block_id, version_number)
);



-- PLAN CHANGES
CREATE TABLE plan_changes (
    change_id BIGSERIAL PRIMARY KEY,

    version_id BIGINT NOT NULL,

    changed_field VARCHAR(150) NOT NULL,

    old_value TEXT,
    new_value TEXT,

    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
 
);



-- PLAN EXECUTION EVENTS
CREATE TABLE plan_execution_events (
    event_id BIGSERIAL PRIMARY KEY,

    execution_id BIGINT NOT NULL,

    event_type VARCHAR(50) NOT NULL,

    event_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    description TEXT,

    severity VARCHAR(30)
 
);



--PLANNED BLOCK TRACKS
CREATE TABLE planned_block_tracks (
    id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,
    track_id BIGINT NOT NULL,

    CONSTRAINT uq_planned_block_track
        UNIQUE (block_id, track_id)
);



-- EMERGENCY OVERRIDES
CREATE TABLE emergency_overrides (
    override_id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,

    bypassed_step VARCHAR(150) NOT NULL,

    authorized_by BIGINT NOT NULL,

    justification TEXT NOT NULL,

    reviewed_at TIMESTAMP,

    reviewed_by BIGINT

);



--PLAN VERSION COMPARISONS
CREATE TABLE plan_version_comparisons (
    comparison_id BIGSERIAL PRIMARY KEY,

    version_id BIGINT NOT NULL,

    compared_to_version_id BIGINT NOT NULL,

    delta_summary TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_version_comparison_different
        CHECK (version_id <> compared_to_version_id)
);




--Safety and Isolation


--safety_requirements
CREATE TABLE safety_requirements (
    safety_requirement_id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,
    section_id BIGINT NOT NULL,
    track_id BIGINT NOT NULL,

    protection_type VARCHAR(100) NOT NULL,

    isolation_required BOOLEAN NOT NULL DEFAULT FALSE,
    traction_isolation_required BOOLEAN NOT NULL DEFAULT FALSE,
    signal_protection_required BOOLEAN NOT NULL DEFAULT FALSE,
    speed_restriction_required BOOLEAN NOT NULL DEFAULT FALSE,

    protection_status VARCHAR(30) NOT NULL,

    verified_by BIGINT,
    verified_at TIMESTAMP
 
);



--safety_isolations
CREATE TABLE safety_isolations (
    isolation_id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,
    asset_id BIGINT NOT NULL,

    isolation_type VARCHAR(100) NOT NULL,

    requested_at TIMESTAMP NOT NULL,
    confirmed_at TIMESTAMP,

    status VARCHAR(30) NOT NULL,

    verified_by BIGINT,
  
    CONSTRAINT chk_safety_isolation_time
        CHECK (
            confirmed_at IS NULL
            OR confirmed_at >= requested_at
        )
);
