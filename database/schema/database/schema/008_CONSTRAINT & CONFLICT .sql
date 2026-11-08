-- CONSTRAINTS & CONFLICTS DOMAIN

-- 1. CONSTRAINT TYPES

CREATE TABLE constraint_types (
    constraint_type_id BIGSERIAL PRIMARY KEY,

    type_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,

    CONSTRAINT chk_constraint_type_name
        CHECK (length(trim(type_name)) > 0),

    CONSTRAINT chk_constraint_type_description
        CHECK (
            description IS NULL
            OR length(trim(description)) > 0
        )
);

-- 2. CONSTRAINTS

CREATE TABLE constraints (
    constraint_id BIGSERIAL PRIMARY KEY,

    constraint_type_id BIGINT NOT NULL,

    constraint_code VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,

    hard_or_soft VARCHAR(10) NOT NULL,
    severity VARCHAR(30) NOT NULL,

    penalty_weight NUMERIC(12,4) NOT NULL DEFAULT 0,

    active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_constraint_code
        CHECK (length(trim(constraint_code)) > 0),

    CONSTRAINT chk_hard_or_soft
        CHECK (
            hard_or_soft IN (
                'HARD',
                'SOFT'
            )
        ),

    CONSTRAINT chk_constraint_severity
        CHECK (
            severity IN (
                'LOW',
                'MEDIUM',
                'HIGH',
                'CRITICAL'
            )
        ),

    CONSTRAINT chk_penalty_weight
        CHECK (
            penalty_weight >= 0
        ),

    CONSTRAINT chk_hard_constraint_penalty
        CHECK (
            hard_or_soft = 'SOFT'
            OR penalty_weight = 0
        ),

    CONSTRAINT chk_constraint_type_id
        CHECK (
            constraint_type_id > 0
        )
);


-- 3. CONSTRAINT RULES

CREATE TABLE constraint_rules (
    rule_id BIGSERIAL PRIMARY KEY,

    constraint_id BIGINT NOT NULL,

    rule_expression TEXT NOT NULL,
    severity_level VARCHAR(30) NOT NULL,

    CONSTRAINT chk_rule_expression
        CHECK (
            length(trim(rule_expression)) > 0
        ),

    CONSTRAINT chk_rule_severity
        CHECK (
            severity_level IN (
                'LOW',
                'MEDIUM',
                'HIGH',
                'CRITICAL'
            )
        ),

    CONSTRAINT chk_rule_constraint_id
        CHECK (
            constraint_id > 0
        ),

    CONSTRAINT uq_constraint_rule
        UNIQUE (
            constraint_id,
            rule_expression
        )
);

-- 4. SEVERITY LEVELS

CREATE TABLE severity_levels (
    severity_id BIGSERIAL PRIMARY KEY,

    level_name VARCHAR(50) NOT NULL UNIQUE,
    rank INTEGER NOT NULL,
    color_code VARCHAR(20),
    description TEXT,

    CONSTRAINT chk_severity_rank
        CHECK (
            rank > 0
        ),

    CONSTRAINT chk_severity_color
        CHECK (
            color_code IS NULL
            OR length(trim(color_code)) > 0
        ),

    CONSTRAINT chk_severity_description
        CHECK (
            description IS NULL
            OR length(trim(description)) > 0
        ),

    CONSTRAINT uq_severity_rank
        UNIQUE (rank)
);

-- 5. CRITICALITY LEVELS

CREATE TABLE criticality_levels (
    criticality_id BIGSERIAL PRIMARY KEY,

    level_name VARCHAR(50) NOT NULL UNIQUE,
    rank INTEGER NOT NULL,
    color_code VARCHAR(20),
    description TEXT,

    CONSTRAINT chk_criticality_rank
        CHECK (
            rank > 0
        ),

    CONSTRAINT chk_criticality_color
        CHECK (
            color_code IS NULL
            OR length(trim(color_code)) > 0
        ),

    CONSTRAINT chk_criticality_description
        CHECK (
            description IS NULL
            OR length(trim(description)) > 0
        ),

    CONSTRAINT uq_criticality_rank
        UNIQUE (rank)
);

-- 6. CONFLICTS

CREATE TABLE conflicts (
    conflict_id BIGSERIAL PRIMARY KEY,

    block_id BIGINT NOT NULL,

    conflict_type VARCHAR(50) NOT NULL,

    severity_id BIGINT NOT NULL,

    detected_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    status VARCHAR(30) NOT NULL DEFAULT 'OPEN',

    CONSTRAINT chk_conflict_type
        CHECK (
            length(trim(conflict_type)) > 0
        ),

    CONSTRAINT chk_conflict_status
        CHECK (
            status IN (
                'OPEN',
                'UNDER_REVIEW',
                'RESOLVED',
                'IGNORED',
                'ESCALATED'
            )
        ),

    CONSTRAINT chk_conflict_block_id
        CHECK (
            block_id > 0
        ),

    CONSTRAINT chk_conflict_severity_id
        CHECK (
            severity_id > 0
        )
);

-- 7. CONFLICT TRAINS

CREATE TABLE conflict_trains (
    id BIGSERIAL PRIMARY KEY,

    conflict_id BIGINT NOT NULL,
    train_id BIGINT NOT NULL,

    priority_score NUMERIC(10,4) NOT NULL DEFAULT 0,

    CONSTRAINT chk_conflict_train_conflict
        CHECK (
            conflict_id > 0
        ),

    CONSTRAINT chk_conflict_train_train
        CHECK (
            train_id > 0
        ),

    CONSTRAINT chk_conflict_train_priority
        CHECK (
            priority_score >= 0
        ),

    CONSTRAINT uq_conflict_train
        UNIQUE (
            conflict_id,
            train_id
        ),

    CONSTRAINT chk_conflict_train_ids
        CHECK (
            conflict_id <> train_id
        )
);


-- 8. CONFLICT SECTIONS

CREATE TABLE conflict_sections (
    id BIGSERIAL PRIMARY KEY,

    conflict_id BIGINT NOT NULL,
    section_id BIGINT NOT NULL,

    priority_score NUMERIC(10,4) NOT NULL DEFAULT 0,

    CONSTRAINT chk_conflict_section_conflict
        CHECK (
            conflict_id > 0
        ),

    CONSTRAINT chk_conflict_section_section
        CHECK (
            section_id > 0
        ),

    CONSTRAINT chk_conflict_section_priority
        CHECK (
            priority_score >= 0
        ),

    CONSTRAINT uq_conflict_section
        UNIQUE (
            conflict_id,
            section_id
        ),

    CONSTRAINT chk_conflict_section_ids
        CHECK (
            conflict_id <> section_id
        )
);

-- 9. CONFLICT TRACKS

CREATE TABLE conflict_tracks (
    id BIGSERIAL PRIMARY KEY,

    conflict_id BIGINT NOT NULL,
    track_id BIGINT NOT NULL,

    priority_score NUMERIC(10,4) NOT NULL DEFAULT 0,

    CONSTRAINT chk_conflict_track_conflict
        CHECK (
            conflict_id > 0
        ),

    CONSTRAINT chk_conflict_track_track
        CHECK (
            track_id > 0
        ),

    CONSTRAINT chk_conflict_track_priority
        CHECK (
            priority_score >= 0
        ),

    CONSTRAINT uq_conflict_track
        UNIQUE (
            conflict_id,
            track_id
        ),

    CONSTRAINT chk_conflict_track_ids
        CHECK (
            conflict_id <> track_id
        )
);

-- 10. CONFLICT ASSETS

CREATE TABLE conflict_assets (
    id BIGSERIAL PRIMARY KEY,

    conflict_id BIGINT NOT NULL,
    asset_id BIGINT NOT NULL,

    priority_score NUMERIC(10,4) NOT NULL DEFAULT 0,

    CONSTRAINT chk_conflict_asset_conflict
        CHECK (
            conflict_id > 0
        ),

    CONSTRAINT chk_conflict_asset_asset
        CHECK (
            asset_id > 0
        ),

    CONSTRAINT chk_conflict_asset_priority
        CHECK (
            priority_score >= 0
        ),

    CONSTRAINT uq_conflict_asset
        UNIQUE (
            conflict_id,
            asset_id
        ),

    CONSTRAINT chk_conflict_asset_ids
        CHECK (
            conflict_id <> asset_id
        )
);

-- 11. CONFLICT BLOCKS

CREATE TABLE conflict_blocks (
    id BIGSERIAL PRIMARY KEY,

    conflict_id BIGINT NOT NULL,
    block_id BIGINT NOT NULL,

    priority_score NUMERIC(10,4) NOT NULL DEFAULT 0,

    CONSTRAINT chk_conflict_block_conflict
        CHECK (
            conflict_id > 0
        ),

    CONSTRAINT chk_conflict_block_block
        CHECK (
            block_id > 0
        ),

    CONSTRAINT chk_conflict_block_priority
        CHECK (
            priority_score >= 0
        ),

    CONSTRAINT uq_conflict_block
        UNIQUE (
            conflict_id,
            block_id
        ),

    CONSTRAINT chk_conflict_block_ids
        CHECK (
            conflict_id <> block_id
        )
);

-- 12. CONFLICT RESOLUTIONS

CREATE TABLE conflict_resolutions (
    resolution_id BIGSERIAL PRIMARY KEY,

    conflict_id BIGINT NOT NULL,

    resolution_type VARCHAR(50) NOT NULL,

    resolved_by BIGINT,

    resolved_at TIMESTAMP,

    CONSTRAINT chk_resolution_conflict
        CHECK (
            conflict_id > 0
        ),

    CONSTRAINT chk_resolution_type
        CHECK (
            length(trim(resolution_type)) > 0
        ),

    CONSTRAINT chk_resolved_by
        CHECK (
            resolved_by IS NULL
            OR resolved_by > 0
        ),

    CONSTRAINT chk_resolution_time
        CHECK (
            resolved_at IS NULL
            OR resolved_at <= CURRENT_TIMESTAMP
        ),

    CONSTRAINT chk_resolution_completion
        CHECK (
            resolved_at IS NULL
            OR resolved_by IS NOT NULL
        )
);

-- 13. CONSTRAINT VIOLATIONS

CREATE TABLE constraint_violations (
    violation_id BIGSERIAL PRIMARY KEY,

    output_id BIGINT NOT NULL,
    constraint_id BIGINT NOT NULL,

    is_hard BOOLEAN NOT NULL,

    penalty_applied NUMERIC(12,4) NOT NULL DEFAULT 0,

    detected_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_violation_output
        CHECK (
            output_id > 0
        ),

    CONSTRAINT chk_violation_constraint
        CHECK (
            constraint_id > 0
        ),

    CONSTRAINT chk_violation_penalty
        CHECK (
            penalty_applied >= 0
        ),

    CONSTRAINT chk_hard_violation_penalty
        CHECK (
            is_hard = TRUE
            OR penalty_applied >= 0
        ),

    CONSTRAINT chk_violation_timestamp
        CHECK (
            detected_at <= CURRENT_TIMESTAMP
        ),

    CONSTRAINT uq_output_constraint_violation
        UNIQUE (
            output_id,
            constraint_id
        ),

    CONSTRAINT chk_violation_ids
        CHECK (
            output_id <> constraint_id
        ),

    CONSTRAINT chk_violation_hard_logic
        CHECK (
            is_hard = TRUE
            OR penalty_applied >= 0
        )
);

-- INDEXES

CREATE INDEX idx_constraints_type
    ON constraints(constraint_type_id);

CREATE INDEX idx_constraints_active
    ON constraints(active);

CREATE INDEX idx_constraint_rules_constraint
    ON constraint_rules(constraint_id);

CREATE INDEX idx_conflicts_block
    ON conflicts(block_id);

CREATE INDEX idx_conflicts_severity
    ON conflicts(severity_id);

CREATE INDEX idx_conflicts_status
    ON conflicts(status);

CREATE INDEX idx_conflicts_detected_at
    ON conflicts(detected_at);

CREATE INDEX idx_conflict_trains_conflict
    ON conflict_trains(conflict_id);

CREATE INDEX idx_conflict_trains_train
    ON conflict_trains(train_id);

CREATE INDEX idx_conflict_sections_conflict
    ON conflict_sections(conflict_id);

CREATE INDEX idx_conflict_sections_section
    ON conflict_sections(section_id);

CREATE INDEX idx_conflict_tracks_conflict
    ON conflict_tracks(conflict_id);

CREATE INDEX idx_conflict_tracks_track
    ON conflict_tracks(track_id);

CREATE INDEX idx_conflict_assets_conflict
    ON conflict_assets(conflict_id);

CREATE INDEX idx_conflict_assets_asset
    ON conflict_assets(asset_id);

CREATE INDEX idx_conflict_blocks_conflict
    ON conflict_blocks(conflict_id);

CREATE INDEX idx_conflict_blocks_block
    ON conflict_blocks(block_id);

CREATE INDEX idx_conflict_resolutions_conflict
    ON conflict_resolutions(conflict_id);

CREATE INDEX idx_constraint_violations_output
    ON constraint_violations(output_id);

CREATE INDEX idx_constraint_violations_constraint
    ON constraint_violations(constraint_id);

CREATE INDEX idx_constraint_violations_detected
    ON constraint_violations(detected_at);