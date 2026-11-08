-- ============================================================
-- TRAINS & OPERATIONS
-- 12 TABLES
-- PostgreSQL
-- NO FOREIGN KEY CONSTRAINTS
-- ============================================================


-- ============================================================
-- 1. TRAIN TYPES
-- ============================================================

CREATE TABLE train_types (
    train_type_id BIGSERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,

    CONSTRAINT chk_train_type_name
        CHECK (length(trim(type_name)) > 0),

    CONSTRAINT chk_train_type_description
        CHECK (
            description IS NULL
            OR length(trim(description)) > 0
        )
);


-- ============================================================
-- 2. TRAINS
-- ============================================================

CREATE TABLE trains (
    train_id BIGSERIAL PRIMARY KEY,
    train_type_id BIGINT NOT NULL,
    train_number VARCHAR(20) NOT NULL UNIQUE,
    train_name VARCHAR(150) NOT NULL,
    capacity INTEGER NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT chk_train_number
        CHECK (length(trim(train_number)) > 0),

    CONSTRAINT chk_train_name
        CHECK (length(trim(train_name)) > 0),

    CONSTRAINT chk_train_capacity
        CHECK (capacity > 0),

    CONSTRAINT chk_train_status
        CHECK (
            status IN (
                'ACTIVE',
                'INACTIVE',
                'MAINTENANCE',
                'CANCELLED'
            )
        )
);


-- ============================================================
-- 3. TRAIN SCHEDULES
-- ============================================================

CREATE TABLE train_schedules (
    schedule_id BIGSERIAL PRIMARY KEY,
    train_id BIGINT NOT NULL,
    effective_from DATE NOT NULL,
    effective_to DATE,
    frequency VARCHAR(50) NOT NULL,

    CONSTRAINT chk_schedule_dates
        CHECK (
            effective_to IS NULL
            OR effective_to >= effective_from
        ),

    CONSTRAINT chk_schedule_frequency
        CHECK (length(trim(frequency)) > 0),

    CONSTRAINT uq_train_schedule_period
        UNIQUE (
            train_id,
            effective_from
        )
);


-- ============================================================
-- 4. TRAIN SCHEDULE STOPS
-- ============================================================

CREATE TABLE train_schedule_stops (
    stop_id BIGSERIAL PRIMARY KEY,
    schedule_id BIGINT NOT NULL,
    station_id BIGINT NOT NULL,
    sequence_no INTEGER NOT NULL,
    scheduled_arrival TIME,
    scheduled_departure TIME,

    CONSTRAINT chk_stop_sequence
        CHECK (sequence_no > 0),

    CONSTRAINT chk_arrival_departure
        CHECK (
            scheduled_arrival IS NULL
            OR scheduled_departure IS NULL
            OR scheduled_departure >= scheduled_arrival
        ),

    CONSTRAINT uq_schedule_stop_sequence
        UNIQUE (
            schedule_id,
            sequence_no
        ),

    CONSTRAINT uq_schedule_station
        UNIQUE (
            schedule_id,
            station_id
        )
);


-- ============================================================
-- 5. TRAIN ROUTES
-- ============================================================

CREATE TABLE train_routes (
    train_route_id BIGSERIAL PRIMARY KEY,
    train_id BIGINT NOT NULL,
    route_id BIGINT NOT NULL,
    effective_from DATE NOT NULL,

    CONSTRAINT uq_train_route_effective
        UNIQUE (
            train_id,
            route_id,
            effective_from
        )
);


-- ============================================================
-- 6. TRAIN RUNNING DAYS
-- ============================================================

CREATE TABLE train_running_days (
    running_day_id BIGSERIAL PRIMARY KEY,
    schedule_id BIGINT NOT NULL,
    day_of_week SMALLINT NOT NULL,

    CONSTRAINT chk_day_of_week
        CHECK (
            day_of_week BETWEEN 1 AND 7
        ),

    CONSTRAINT uq_schedule_running_day
        UNIQUE (
            schedule_id,
            day_of_week
        )
);


-- ============================================================
-- 7. TRAIN PRIORITIES
-- ============================================================

CREATE TABLE train_priorities (
    priority_id BIGSERIAL PRIMARY KEY,
    train_id BIGINT NOT NULL,
    priority_level INTEGER NOT NULL,
    effective_from DATE NOT NULL,

    CONSTRAINT chk_priority_level
        CHECK (priority_level > 0),

    CONSTRAINT uq_train_priority_effective
        UNIQUE (
            train_id,
            effective_from
        )
);


-- ============================================================
-- 8. TRAIN MOVEMENTS
-- ============================================================

CREATE TABLE train_movements (
    movement_id BIGSERIAL PRIMARY KEY,
    train_id BIGINT NOT NULL,
    section_id BIGINT NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP,
    speed NUMERIC(6,2),
    status VARCHAR(30) NOT NULL DEFAULT 'PLANNED',

    CONSTRAINT chk_movement_times
        CHECK (
            arrival_time IS NULL
            OR arrival_time >= departure_time
        ),

    CONSTRAINT chk_movement_speed
        CHECK (
            speed IS NULL
            OR speed >= 0
        ),

    CONSTRAINT chk_movement_status
        CHECK (
            status IN (
                'PLANNED',
                'RUNNING',
                'COMPLETED',
                'CANCELLED',
                'HELD',
                'REROUTED'
            )
        )
);


-- ============================================================
-- 9. TRAIN DELAYS
-- ============================================================

CREATE TABLE train_delays (
    delay_id BIGSERIAL PRIMARY KEY,
    movement_id BIGINT NOT NULL,
    delay_minutes INTEGER NOT NULL,
    delay_reason VARCHAR(255),

    CONSTRAINT chk_delay_minutes
        CHECK (delay_minutes > 0),

    CONSTRAINT chk_delay_reason
        CHECK (
            delay_reason IS NULL
            OR length(trim(delay_reason)) > 0
        ),

    CONSTRAINT uq_movement_delay
        UNIQUE (movement_id)
);


-- ============================================================
-- 10. TRAFFIC DENSITY
-- ============================================================

CREATE TABLE traffic_density (
    density_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    measured_at TIMESTAMP NOT NULL,
    train_count INTEGER NOT NULL,
    density_level VARCHAR(30) NOT NULL,

    CONSTRAINT chk_train_count
        CHECK (train_count >= 0),

    CONSTRAINT chk_density_level
        CHECK (
            density_level IN (
                'LOW',
                'MEDIUM',
                'HIGH',
                'CRITICAL'
            )
        ),

    CONSTRAINT uq_section_density_time
        UNIQUE (
            section_id,
            measured_at
        )
);


-- ============================================================
-- 11. ALTERNATIVE ROUTES
-- ============================================================

CREATE TABLE alternative_routes (
    alt_route_id BIGSERIAL PRIMARY KEY,
    train_id BIGINT NOT NULL,
    original_route_id BIGINT NOT NULL,
    proposed_route_id BIGINT NOT NULL,
    estimated_delay INTEGER NOT NULL DEFAULT 0,
    extra_distance_km NUMERIC(10,2) NOT NULL DEFAULT 0,
    feasibility_score NUMERIC(5,2) NOT NULL,

    CONSTRAINT chk_alt_routes_different
        CHECK (
            original_route_id <> proposed_route_id
        ),

    CONSTRAINT chk_estimated_delay
        CHECK (
            estimated_delay >= 0
        ),

    CONSTRAINT chk_extra_distance
        CHECK (
            extra_distance_km >= 0
        ),

    CONSTRAINT chk_feasibility_score
        CHECK (
            feasibility_score BETWEEN 0 AND 100
        ),

    CONSTRAINT uq_train_route_alternative
        UNIQUE (
            train_id,
            original_route_id,
            proposed_route_id
        )
);


-- ============================================================
-- 12. TRAIN BLOCK IMPACTS
-- ============================================================

CREATE TABLE train_block_impacts (
    impact_id BIGSERIAL PRIMARY KEY,

    train_id BIGINT NOT NULL,
    block_id BIGINT NOT NULL,

    impact_type VARCHAR(30) NOT NULL,
    delay_minutes INTEGER NOT NULL DEFAULT 0,
    cancelled BOOLEAN NOT NULL DEFAULT FALSE,
    rerouted BOOLEAN NOT NULL DEFAULT FALSE,
    platform_change BOOLEAN NOT NULL DEFAULT FALSE,
    speed_restriction BOOLEAN NOT NULL DEFAULT FALSE,

    affected_section_id BIGINT,
    original_route_id BIGINT,
    alternative_route_id BIGINT,

    impact_cost NUMERIC(12,2) NOT NULL DEFAULT 0,
    severity_id BIGINT NOT NULL,

    CONSTRAINT chk_impact_type
        CHECK (
            impact_type IN (
                'HOLD',
                'DELAY',
                'REROUTE',
                'CANCEL',
                'SPEED_RESTRICTION',
                'PLATFORM_CHANGE'
            )
        ),

    CONSTRAINT chk_impact_delay
        CHECK (
            delay_minutes >= 0
        ),

    CONSTRAINT chk_impact_cost
        CHECK (
            impact_cost >= 0
        ),

    CONSTRAINT chk_reroute_route
        CHECK (
            rerouted = FALSE
            OR alternative_route_id IS NOT NULL
        ),

    CONSTRAINT chk_original_route
        CHECK (
            alternative_route_id IS NULL
            OR original_route_id IS NOT NULL
        ),

    CONSTRAINT chk_cancelled_impact
        CHECK (
            cancelled = FALSE
            OR impact_type = 'CANCEL'
        ),

    CONSTRAINT chk_speed_restriction_impact
        CHECK (
            speed_restriction = FALSE
            OR impact_type = 'SPEED_RESTRICTION'
        ),

    CONSTRAINT chk_platform_change_impact
        CHECK (
            platform_change = FALSE
            OR impact_type = 'PLATFORM_CHANGE'
        ),

    CONSTRAINT uq_train_block_impact
        UNIQUE (
            train_id,
            block_id
        )
);


-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_trains_train_type
    ON trains(train_type_id);

CREATE INDEX idx_train_schedules_train
    ON train_schedules(train_id);

CREATE INDEX idx_schedule_stops_schedule
    ON train_schedule_stops(schedule_id);

CREATE INDEX idx_schedule_stops_station
    ON train_schedule_stops(station_id);

CREATE INDEX idx_train_routes_train
    ON train_routes(train_id);

CREATE INDEX idx_train_routes_route
    ON train_routes(route_id);

CREATE INDEX idx_running_days_schedule
    ON train_running_days(schedule_id);

CREATE INDEX idx_train_priorities_train
    ON train_priorities(train_id);

CREATE INDEX idx_train_movements_train
    ON train_movements(train_id);

CREATE INDEX idx_train_movements_section
    ON train_movements(section_id);

CREATE INDEX idx_train_movements_departure
    ON train_movements(departure_time);

CREATE INDEX idx_train_delays_movement
    ON train_delays(movement_id);

CREATE INDEX idx_traffic_density_section_time
    ON traffic_density(section_id, measured_at);

CREATE INDEX idx_alternative_routes_train
    ON alternative_routes(train_id);

CREATE INDEX idx_block_impacts_train
    ON train_block_impacts(train_id);

CREATE INDEX idx_block_impacts_block
    ON train_block_impacts(block_id);

CREATE INDEX idx_block_impacts_section
    ON train_block_impacts(affected_section_id);

CREATE INDEX idx_block_impacts_severity
    ON train_block_impacts(severity_id);