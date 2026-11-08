-- AI ENGINE — OPTIMIZATION, ASSISTANT & ANALYTICS


-- 1. AI RUNS

CREATE TABLE ai_runs (
    run_id BIGSERIAL PRIMARY KEY,

    run_type VARCHAR(50) NOT NULL,
    engine_name VARCHAR(100) NOT NULL,

    requested_by BIGINT,
    request_id BIGINT,
    block_id BIGINT,

    input_text TEXT,
    input_hash VARCHAR(128),

    determinism_mode VARCHAR(30) NOT NULL DEFAULT 'DETERMINISTIC',
    random_seed BIGINT,

    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',

    started_at TIMESTAMP,
    completed_at TIMESTAMP,

    CONSTRAINT chk_ai_run_type
        CHECK (
            length(trim(run_type)) > 0
        ),

    CONSTRAINT chk_ai_engine_name
        CHECK (
            length(trim(engine_name)) > 0
        ),

    CONSTRAINT chk_ai_input_hash
        CHECK (
            input_hash IS NULL
            OR length(trim(input_hash)) > 0
        ),

    CONSTRAINT chk_ai_determinism_mode
        CHECK (
            determinism_mode IN (
                'DETERMINISTIC',
                'SEEDED',
                'RANDOM'
            )
        ),

    CONSTRAINT chk_ai_random_seed
        CHECK (
            determinism_mode <> 'SEEDED'
            OR random_seed IS NOT NULL
        ),

    CONSTRAINT chk_ai_run_status
        CHECK (
            status IN (
                'PENDING',
                'RUNNING',
                'COMPLETED',
                'FAILED',
                'CANCELLED'
            )
        ),

    CONSTRAINT chk_ai_run_times
        CHECK (
            completed_at IS NULL
            OR started_at IS NULL
            OR completed_at >= started_at
        ),

    CONSTRAINT chk_ai_request_id
        CHECK (
            request_id IS NULL
            OR request_id > 0
        ),

    CONSTRAINT chk_ai_requested_by
        CHECK (
            requested_by IS NULL
            OR requested_by > 0
        ),

    CONSTRAINT chk_ai_block_id
        CHECK (
            block_id IS NULL
            OR block_id > 0
        ),

    CONSTRAINT chk_ai_started_at
        CHECK (
            started_at IS NULL
            OR started_at <= CURRENT_TIMESTAMP
        ),

    CONSTRAINT chk_ai_completed_at
        CHECK (
            completed_at IS NULL
            OR completed_at <= CURRENT_TIMESTAMP
        ),

    CONSTRAINT uq_ai_run_input_hash
        UNIQUE (
            run_type,
            input_hash
        )
);

-- 2. AI RUN PARAMETERS

CREATE TABLE ai_run_parameters (
    parameter_id BIGSERIAL PRIMARY KEY,

    run_id BIGINT NOT NULL,

    param_name VARCHAR(100) NOT NULL,
    param_value TEXT NOT NULL,

    CONSTRAINT chk_ai_parameter_name
        CHECK (
            length(trim(param_name)) > 0
        ),

    CONSTRAINT chk_ai_parameter_value
        CHECK (
            length(trim(param_value)) > 0
        ),

    CONSTRAINT chk_ai_parameter_run_id
        CHECK (
            run_id > 0
        ),

    CONSTRAINT uq_ai_run_parameter
        UNIQUE (
            run_id,
            param_name
        )
);


-- 3. AI OUTPUTS

CREATE TABLE ai_outputs (
    output_id BIGSERIAL PRIMARY KEY,

    run_id BIGINT NOT NULL,
    block_id BIGINT,

    output_text TEXT,

    feasibility_score NUMERIC(7,4),
    safety_score NUMERIC(7,4),
    confidence_score NUMERIC(7,4),

    asset_availability_gain NUMERIC(12,4),
    train_delay_minutes INTEGER,

    maintenance_completion_score NUMERIC(7,4),
    resource_utilization_score NUMERIC(7,4),

    conflict_penalty NUMERIC(12,4) NOT NULL DEFAULT 0,
    safety_penalty NUMERIC(12,4) NOT NULL DEFAULT 0,

    overall_score NUMERIC(12,4),

    rank_position INTEGER,

    is_selected BOOLEAN NOT NULL DEFAULT FALSE,
    is_cached BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_ai_output_run
        CHECK (
            run_id > 0
        ),

    CONSTRAINT chk_ai_output_block
        CHECK (
            block_id IS NULL
            OR block_id > 0
        ),

    CONSTRAINT chk_feasibility_score
        CHECK (
            feasibility_score IS NULL
            OR feasibility_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_safety_score
        CHECK (
            safety_score IS NULL
            OR safety_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_confidence_score
        CHECK (
            confidence_score IS NULL
            OR confidence_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_asset_availability_gain
        CHECK (
            asset_availability_gain IS NULL
            OR asset_availability_gain >= 0
        ),

    CONSTRAINT chk_train_delay
        CHECK (
            train_delay_minutes IS NULL
            OR train_delay_minutes >= 0
        ),

    CONSTRAINT chk_maintenance_score
        CHECK (
            maintenance_completion_score IS NULL
            OR maintenance_completion_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_resource_utilization
        CHECK (
            resource_utilization_score IS NULL
            OR resource_utilization_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_conflict_penalty
        CHECK (
            conflict_penalty >= 0
        ),

    CONSTRAINT chk_safety_penalty
        CHECK (
            safety_penalty >= 0
        ),

    CONSTRAINT chk_rank_position
        CHECK (
            rank_position IS NULL
            OR rank_position > 0
        ),

    CONSTRAINT chk_overall_score
        CHECK (
            overall_score IS NULL
            OR overall_score >= 0
        ),

    CONSTRAINT chk_output_text
        CHECK (
            output_text IS NOT NULL
            OR overall_score IS NOT NULL
        ),

    CONSTRAINT chk_created_at
        CHECK (
            created_at <= CURRENT_TIMESTAMP
        ),

    CONSTRAINT uq_run_rank
        UNIQUE (
            run_id,
            rank_position
        )
);

-- 4. AI OUTPUT REASONS

CREATE TABLE ai_output_reasons (
    reason_id BIGSERIAL PRIMARY KEY,

    output_id BIGINT NOT NULL,

    reason_summary TEXT NOT NULL,
    contributing_factors TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    violation_id BIGINT,

    CONSTRAINT chk_reason_output
        CHECK (
            output_id > 0
        ),

    CONSTRAINT chk_reason_summary
        CHECK (
            length(trim(reason_summary)) > 0
        ),

    CONSTRAINT chk_reason_factors
        CHECK (
            contributing_factors IS NULL
            OR length(trim(contributing_factors)) > 0
        ),

    CONSTRAINT chk_reason_violation
        CHECK (
            violation_id IS NULL
            OR violation_id > 0
        ),

    CONSTRAINT chk_reason_created_at
        CHECK (
            created_at <= CURRENT_TIMESTAMP
        ),

    CONSTRAINT uq_output_reason
        UNIQUE (
            output_id,
            reason_summary
        )
);

-- 5. AI ANSWER CACHE

CREATE TABLE ai_answer_cache (
    cache_id BIGSERIAL PRIMARY KEY,

    input_hash VARCHAR(128) NOT NULL,
    run_type VARCHAR(50) NOT NULL,

    cached_output_id BIGINT NOT NULL,

    hit_count INTEGER NOT NULL DEFAULT 0,

    valid_until TIMESTAMP,

    last_used_at TIMESTAMP,

    CONSTRAINT chk_cache_input_hash
        CHECK (
            length(trim(input_hash)) > 0
        ),

    CONSTRAINT chk_cache_run_type
        CHECK (
            length(trim(run_type)) > 0
        ),

    CONSTRAINT chk_cache_output
        CHECK (
            cached_output_id > 0
        ),

    CONSTRAINT chk_cache_hit_count
        CHECK (
            hit_count >= 0
        ),

    CONSTRAINT chk_cache_valid_until
        CHECK (
            valid_until IS NULL
            OR valid_until > CURRENT_TIMESTAMP
        ),

    CONSTRAINT chk_cache_last_used
        CHECK (
            last_used_at IS NULL
            OR last_used_at <= CURRENT_TIMESTAMP
        ),

    CONSTRAINT uq_ai_answer_cache
        UNIQUE (
            input_hash,
            run_type
        )
);

-- 6. AI ENGINE SCORES

CREATE TABLE ai_engine_scores (
    score_id BIGSERIAL PRIMARY KEY,

    output_id BIGINT NOT NULL,

    engine_name VARCHAR(100) NOT NULL,
    score_type VARCHAR(100) NOT NULL,

    score_value NUMERIC(12,6) NOT NULL,

    computed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_engine_score_output
        CHECK (
            output_id > 0
        ),

    CONSTRAINT chk_engine_score_engine
        CHECK (
            length(trim(engine_name)) > 0
        ),

    CONSTRAINT chk_engine_score_type
        CHECK (
            length(trim(score_type)) > 0
        ),

    CONSTRAINT chk_engine_score_value
        CHECK (
            score_value >= 0
        ),

    CONSTRAINT chk_engine_score_time
        CHECK (
            computed_at <= CURRENT_TIMESTAMP
        ),

    CONSTRAINT uq_engine_output_score
        UNIQUE (
            output_id,
            engine_name,
            score_type
        )
);

-- 7. OPTIMIZATION OBJECTIVES

CREATE TABLE optimization_objectives (
    objective_id BIGSERIAL PRIMARY KEY,

    run_id BIGINT NOT NULL,

    objective_type VARCHAR(100) NOT NULL,

    weight NUMERIC(12,6) NOT NULL,

    direction VARCHAR(10) NOT NULL,

    target_value NUMERIC(14,6),
    actual_value NUMERIC(14,6),

    priority INTEGER NOT NULL,

    CONSTRAINT chk_objective_run
        CHECK (
            run_id > 0
        ),

    CONSTRAINT chk_objective_type
        CHECK (
            length(trim(objective_type)) > 0
        ),

    CONSTRAINT chk_objective_weight
        CHECK (
            weight >= 0
        ),

    CONSTRAINT chk_objective_direction
        CHECK (
            direction IN (
                'MAXIMIZE',
                'MINIMIZE'
            )
        ),

    CONSTRAINT chk_objective_priority
        CHECK (
            priority > 0
        ),

    CONSTRAINT chk_objective_target
        CHECK (
            target_value IS NULL
            OR target_value >= 0
        ),

    CONSTRAINT chk_objective_actual
        CHECK (
            actual_value IS NULL
            OR actual_value >= 0
        ),

    CONSTRAINT uq_run_objective
        UNIQUE (
            run_id,
            objective_type,
            priority
        )
);

-- 8. ANALYTICS METRICS

CREATE TABLE analytics_metrics (
    metric_id BIGSERIAL PRIMARY KEY,

    metric_name VARCHAR(100) NOT NULL,
    metric_value NUMERIC(18,6) NOT NULL,

    scope_type VARCHAR(50) NOT NULL,
    scope_id BIGINT,

    measured_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_metric_name
        CHECK (
            length(trim(metric_name)) > 0
        ),

    CONSTRAINT chk_metric_scope_type
        CHECK (
            length(trim(scope_type)) > 0
        ),

    CONSTRAINT chk_metric_scope_id
        CHECK (
            scope_id IS NULL
            OR scope_id > 0
        ),

    CONSTRAINT chk_metric_time
        CHECK (
            measured_at <= CURRENT_TIMESTAMP
        ),

    CONSTRAINT uq_metric_measurement
        UNIQUE (
            metric_name,
            scope_type,
            scope_id,
            measured_at
        ),

    CONSTRAINT chk_metric_value
        CHECK (
            metric_value >= 0
        )
);

-- 9. AI DECISION STEPS

CREATE TABLE ai_decision_steps (
    step_id BIGSERIAL PRIMARY KEY,

    run_id BIGINT NOT NULL,

    step_number INTEGER NOT NULL,
    step_type VARCHAR(100) NOT NULL,

    detail TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_decision_step_run
        CHECK (
            run_id > 0
        ),

    CONSTRAINT chk_step_number
        CHECK (
            step_number > 0
        ),

    CONSTRAINT chk_step_type
        CHECK (
            length(trim(step_type)) > 0
        ),

    CONSTRAINT chk_step_detail
        CHECK (
            detail IS NULL
            OR length(trim(detail)) > 0
        ),

    CONSTRAINT chk_step_created_at
        CHECK (
            created_at <= CURRENT_TIMESTAMP
        ),

    CONSTRAINT uq_run_step_number
        UNIQUE (
            run_id,
            step_number
        ),

    CONSTRAINT uq_run_step_type
        UNIQUE (
            run_id,
            step_number,
            step_type
        ),

    CONSTRAINT chk_step_detail_or_type
        CHECK (
            detail IS NOT NULL
            OR step_type IS NOT NULL
        )
);
-- 10. BASELINE PLANS

CREATE TABLE baseline_plans (
    baseline_id BIGSERIAL PRIMARY KEY,

    request_id BIGINT NOT NULL,
    created_by BIGINT NOT NULL,
    window_id BIGINT NOT NULL,

    planned_start TIMESTAMP NOT NULL,
    planned_end TIMESTAMP NOT NULL,

    source VARCHAR(50) NOT NULL,

    CONSTRAINT chk_baseline_request
        CHECK (
            request_id > 0
        ),

    CONSTRAINT chk_baseline_created_by
        CHECK (
            created_by > 0
        ),

    CONSTRAINT chk_baseline_window
        CHECK (
            window_id > 0
        ),

    CONSTRAINT chk_baseline_times
        CHECK (
            planned_end >= planned_start
        ),

    CONSTRAINT chk_baseline_source
        CHECK (
            source IN (
                'HUMAN',
                'HISTORICAL',
                'POLICY',
                'MANUAL',
                'OTHER'
            )
        ),

    CONSTRAINT uq_baseline_request_window
        UNIQUE (
            request_id,
            window_id
        )
);

-- 11. BASELINE VS AI COMPARISON

CREATE TABLE baseline_vs_ai_comparison (
    comparison_id BIGSERIAL PRIMARY KEY,

    baseline_id BIGINT NOT NULL,
    output_id BIGINT NOT NULL,

    delta_delay_minutes INTEGER NOT NULL,
    delta_feasibility_score NUMERIC(10,4),
    delta_safety_score NUMERIC(10,4),

    recommendation VARCHAR(50) NOT NULL,

    CONSTRAINT chk_comparison_baseline
        CHECK (
            baseline_id > 0
        ),

    CONSTRAINT chk_comparison_output
        CHECK (
            output_id > 0
        ),

    CONSTRAINT chk_delta_feasibility
        CHECK (
            delta_feasibility_score IS NULL
            OR delta_feasibility_score BETWEEN -100 AND 100
        ),

    CONSTRAINT chk_delta_safety
        CHECK (
            delta_safety_score IS NULL
            OR delta_safety_score BETWEEN -100 AND 100
        ),

    CONSTRAINT chk_recommendation
        CHECK (
            recommendation IN (
                'AI_BETTER',
                'BASELINE_BETTER',
                'EQUIVALENT',
                'INCONCLUSIVE'
            )
        ),

    CONSTRAINT uq_baseline_output
        UNIQUE (
            baseline_id,
            output_id
        )
);

-- INDEXES

CREATE INDEX idx_ai_runs_requested_by
    ON ai_runs(requested_by);

CREATE INDEX idx_ai_runs_request
    ON ai_runs(request_id);

CREATE INDEX idx_ai_runs_block
    ON ai_runs(block_id);

CREATE INDEX idx_ai_runs_status
    ON ai_runs(status);

CREATE INDEX idx_ai_runs_type
    ON ai_runs(run_type);

CREATE INDEX idx_ai_runs_started_at
    ON ai_runs(started_at);


CREATE INDEX idx_ai_run_parameters_run
    ON ai_run_parameters(run_id);


CREATE INDEX idx_ai_outputs_run
    ON ai_outputs(run_id);

CREATE INDEX idx_ai_outputs_block
    ON ai_outputs(block_id);

CREATE INDEX idx_ai_outputs_selected
    ON ai_outputs(is_selected);

CREATE INDEX idx_ai_outputs_created_at
    ON ai_outputs(created_at);


CREATE INDEX idx_ai_output_reasons_output
    ON ai_output_reasons(output_id);

CREATE INDEX idx_ai_output_reasons_violation
    ON ai_output_reasons(violation_id);


CREATE INDEX idx_ai_answer_cache_hash
    ON ai_answer_cache(input_hash);

CREATE INDEX idx_ai_answer_cache_valid_until
    ON ai_answer_cache(valid_until);


CREATE INDEX idx_ai_engine_scores_output
    ON ai_engine_scores(output_id);

CREATE INDEX idx_ai_engine_scores_engine
    ON ai_engine_scores(engine_name);


CREATE INDEX idx_optimization_objectives_run
    ON optimization_objectives(run_id);

CREATE INDEX idx_optimization_objectives_priority
    ON optimization_objectives(priority);


CREATE INDEX idx_analytics_metrics_name
    ON analytics_metrics(metric_name);

CREATE INDEX idx_analytics_metrics_scope
    ON analytics_metrics(scope_type, scope_id);

CREATE INDEX idx_analytics_metrics_measured_at
    ON analytics_metrics(measured_at);


CREATE INDEX idx_ai_decision_steps_run
    ON ai_decision_steps(run_id);

CREATE INDEX idx_ai_decision_steps_type
    ON ai_decision_steps(step_type);


CREATE INDEX idx_baseline_plans_request
    ON baseline_plans(request_id);

CREATE INDEX idx_baseline_plans_created_by
    ON baseline_plans(created_by);

CREATE INDEX idx_baseline_plans_window
    ON baseline_plans(window_id);


CREATE INDEX idx_baseline_comparison_baseline
    ON baseline_vs_ai_comparison(baseline_id);

CREATE INDEX idx_baseline_comparison_output
    ON baseline_vs_ai_comparison(output_id);