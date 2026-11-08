-- WHAT-IF SIMULATOR


-- 1. SIMULATION SCENARIO TYPES

CREATE TABLE simulation_scenario_types (
    scenario_type_id BIGSERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    description TEXT,

    CONSTRAINT uq_simulation_scenario_type_name
        UNIQUE (type_name),

    CONSTRAINT chk_simulation_scenario_type_name
        CHECK (length(trim(type_name)) > 0)
);


-- ============================================================
-- 2. SIMULATION RUNS
-- ============================================================

CREATE TABLE simulation_runs (
    simulation_id BIGSERIAL PRIMARY KEY,
    based_on_request_id BIGINT,
    scenario_type_id BIGINT NOT NULL,
    run_by BIGINT NOT NULL,
    scenario_name VARCHAR(200) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'CREATED',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_simulation_based_request
        CHECK (
            based_on_request_id IS NULL
            OR based_on_request_id > 0
        ),

    CONSTRAINT chk_simulation_scenario_type
        CHECK (scenario_type_id > 0),

    CONSTRAINT chk_simulation_run_by
        CHECK (run_by > 0),

    CONSTRAINT chk_simulation_name
        CHECK (length(trim(scenario_name)) > 0),

    CONSTRAINT chk_simulation_status
        CHECK (status IN (
            'CREATED',
            'QUEUED',
            'RUNNING',
            'COMPLETED',
            'FAILED',
            'CANCELLED'
        )),

    CONSTRAINT chk_simulation_created_at
        CHECK (created_at <= CURRENT_TIMESTAMP)
);


-- ============================================================
-- 3. SIMULATION PARAMETERS
-- ============================================================

CREATE TABLE simulation_parameters (
    parameter_id BIGSERIAL PRIMARY KEY,
    simulation_id BIGINT NOT NULL,
    param_name VARCHAR(150) NOT NULL,
    param_value JSONB,

    CONSTRAINT chk_simulation_parameter_simulation
        CHECK (simulation_id > 0),

    CONSTRAINT chk_simulation_parameter_name
        CHECK (length(trim(param_name)) > 0),

    CONSTRAINT uq_simulation_parameter
        UNIQUE (
            simulation_id,
            param_name
        )
);


-- ============================================================
-- 4. SIMULATION RESULTS
-- ============================================================

CREATE TABLE simulation_results (
    result_id BIGSERIAL PRIMARY KEY,
    simulation_id BIGINT NOT NULL,
    predicted_conflicts INTEGER NOT NULL DEFAULT 0,
    predicted_delay_minutes NUMERIC(12,2) NOT NULL DEFAULT 0,
    feasibility_score NUMERIC(5,2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_simulation_result_simulation
        CHECK (simulation_id > 0),

    CONSTRAINT chk_simulation_predicted_conflicts
        CHECK (predicted_conflicts >= 0),

    CONSTRAINT chk_simulation_predicted_delay
        CHECK (predicted_delay_minutes >= 0),

    CONSTRAINT chk_simulation_feasibility
        CHECK (
            feasibility_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_simulation_result_created_at
        CHECK (created_at <= CURRENT_TIMESTAMP),

    CONSTRAINT uq_simulation_result
        UNIQUE (
            simulation_id,
            created_at
        )
);


-- ============================================================
-- 5. SIMULATION CANDIDATE BLOCKS
-- ============================================================

CREATE TABLE simulation_candidate_blocks (
    id BIGSERIAL PRIMARY KEY,
    simulation_id BIGINT NOT NULL,
    block_id BIGINT NOT NULL,
    candidate_rank INTEGER NOT NULL,
    feasibility_score NUMERIC(5,2) NOT NULL,
    safety_score NUMERIC(5,2) NOT NULL,
    predicted_delay_minutes NUMERIC(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT chk_sim_candidate_simulation
        CHECK (simulation_id > 0),

    CONSTRAINT chk_sim_candidate_block
        CHECK (block_id > 0),

    CONSTRAINT chk_sim_candidate_rank
        CHECK (candidate_rank > 0),

    CONSTRAINT chk_sim_candidate_feasibility
        CHECK (
            feasibility_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_sim_candidate_safety
        CHECK (
            safety_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_sim_candidate_delay
        CHECK (predicted_delay_minutes >= 0),

    CONSTRAINT uq_sim_candidate_rank
        UNIQUE (
            simulation_id,
            candidate_rank
        ),

    CONSTRAINT uq_sim_candidate_block
        UNIQUE (
            simulation_id,
            block_id
        )
);


-- ============================================================
-- 6. SIMULATION TRAIN IMPACTS
-- ============================================================

CREATE TABLE simulation_train_impacts (
    id BIGSERIAL PRIMARY KEY,
    simulation_id BIGINT NOT NULL,
    train_id BIGINT NOT NULL,
    delay_minutes NUMERIC(12,2) NOT NULL DEFAULT 0,
    impact_type VARCHAR(50) NOT NULL,

    CONSTRAINT chk_sim_train_impact_simulation
        CHECK (simulation_id > 0),

    CONSTRAINT chk_sim_train_impact_train
        CHECK (train_id > 0),

    CONSTRAINT chk_sim_train_impact_delay
        CHECK (delay_minutes >= 0),

    CONSTRAINT chk_sim_train_impact_type
        CHECK (length(trim(impact_type)) > 0),

    CONSTRAINT uq_simulation_train_impact
        UNIQUE (
            simulation_id,
            train_id,
            impact_type
        )
);


-- ============================================================
-- 7. SIMULATION RESOURCE IMPACTS
-- ============================================================

CREATE TABLE simulation_resource_impacts (
    id BIGSERIAL PRIMARY KEY,
    simulation_id BIGINT NOT NULL,
    resource_id BIGINT NOT NULL,
    required_quantity NUMERIC(12,2) NOT NULL,
    available_quantity NUMERIC(12,2) NOT NULL,
    shortfall NUMERIC(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT chk_sim_resource_simulation
        CHECK (simulation_id > 0),

    CONSTRAINT chk_sim_resource_resource
        CHECK (resource_id > 0),

    CONSTRAINT chk_sim_resource_required
        CHECK (required_quantity >= 0),

    CONSTRAINT chk_sim_resource_available
        CHECK (available_quantity >= 0),

    CONSTRAINT chk_sim_resource_shortfall
        CHECK (shortfall >= 0),

    CONSTRAINT chk_sim_resource_shortfall_logic
        CHECK (
            shortfall = GREATEST(
                required_quantity - available_quantity,
                0
            )
        ),

    CONSTRAINT uq_simulation_resource
        UNIQUE (
            simulation_id,
            resource_id
        )
);


-- ============================================================
-- 8. SIMULATION COMPARISON
-- ============================================================

CREATE TABLE simulation_comparison (
    comparison_id BIGSERIAL PRIMARY KEY,
    simulation_id BIGINT NOT NULL,
    compared_to_simulation_id BIGINT,
    delta_delay_minutes NUMERIC(12,2) NOT NULL,
    delta_feasibility_score NUMERIC(6,2) NOT NULL,
    recommendation VARCHAR(50) NOT NULL,

    CONSTRAINT chk_sim_comparison_simulation
        CHECK (simulation_id > 0),

    CONSTRAINT chk_sim_comparison_target
        CHECK (
            compared_to_simulation_id IS NULL
            OR compared_to_simulation_id > 0
        ),

    CONSTRAINT chk_sim_comparison_not_self
        CHECK (
            compared_to_simulation_id IS NULL
            OR simulation_id <> compared_to_simulation_id
        ),

    CONSTRAINT chk_sim_comparison_recommendation
        CHECK (length(trim(recommendation)) > 0),

    CONSTRAINT uq_simulation_comparison
        UNIQUE (
            simulation_id,
            compared_to_simulation_id
        )
);


-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_simulation_runs_request
    ON simulation_runs(based_on_request_id);

CREATE INDEX idx_simulation_runs_scenario_type
    ON simulation_runs(scenario_type_id);

CREATE INDEX idx_simulation_runs_run_by
    ON simulation_runs(run_by);

CREATE INDEX idx_simulation_runs_status
    ON simulation_runs(status);

CREATE INDEX idx_simulation_runs_created_at
    ON simulation_runs(created_at);

CREATE INDEX idx_simulation_parameters_simulation
    ON simulation_parameters(simulation_id);

CREATE INDEX idx_simulation_results_simulation
    ON simulation_results(simulation_id);

CREATE INDEX idx_simulation_candidate_blocks_simulation
    ON simulation_candidate_blocks(simulation_id);

CREATE INDEX idx_simulation_candidate_blocks_block
    ON simulation_candidate_blocks(block_id);

CREATE INDEX idx_simulation_train_impacts_simulation
    ON simulation_train_impacts(simulation_id);

CREATE INDEX idx_simulation_train_impacts_train
    ON simulation_train_impacts(train_id);

CREATE INDEX idx_simulation_resource_impacts_simulation
    ON simulation_resource_impacts(simulation_id);

CREATE INDEX idx_simulation_resource_impacts_resource
    ON simulation_resource_impacts(resource_id);

CREATE INDEX idx_simulation_comparison_simulation
    ON simulation_comparison(simulation_id);

CREATE INDEX idx_simulation_comparison_target
    ON simulation_comparison(compared_to_simulation_id);