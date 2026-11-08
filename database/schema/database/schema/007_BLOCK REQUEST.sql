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

