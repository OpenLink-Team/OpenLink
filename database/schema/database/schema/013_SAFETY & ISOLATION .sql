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


SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE'
  AND table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY table_schema, table_name;