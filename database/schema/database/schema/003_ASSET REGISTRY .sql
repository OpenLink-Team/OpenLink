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



