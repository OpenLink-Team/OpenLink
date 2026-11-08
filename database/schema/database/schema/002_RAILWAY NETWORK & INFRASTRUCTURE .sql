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
