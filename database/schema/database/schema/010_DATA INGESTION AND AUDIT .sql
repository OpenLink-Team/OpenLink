--  DATA INGESTION & AUDIT

-- 1. DATA SOURCES

CREATE TABLE data_sources (
    source_id BIGSERIAL PRIMARY KEY,
    source_name VARCHAR(150) NOT NULL,
    source_type VARCHAR(50) NOT NULL,
    last_sync TIMESTAMPTZ,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT uq_data_sources_name
        UNIQUE (source_name),

    CONSTRAINT chk_data_sources_source_type
        CHECK (source_type IN (
            'EXCEL',
            'CSV',
            'API',
            'SENSOR',
            'DATABASE',
            'OTHER'
        )),

    CONSTRAINT chk_data_sources_status
        CHECK (status IN (
            'ACTIVE',
            'INACTIVE',
            'ERROR',
            'SUSPENDED'
        )),

    CONSTRAINT chk_data_sources_last_sync
        CHECK (last_sync IS NULL OR last_sync <= CURRENT_TIMESTAMP)
);

-- 2. DATA UPLOADS

CREATE TABLE data_uploads (
    upload_id BIGSERIAL PRIMARY KEY,
    uploaded_by BIGINT NOT NULL,
    source_id BIGINT,
    file_name VARCHAR(255) NOT NULL,
    file_type VARCHAR(30) NOT NULL,
    storage_path TEXT,
    uploaded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_data_uploads_uploaded_by
        CHECK (uploaded_by > 0),

    CONSTRAINT chk_data_uploads_source_id
        CHECK (source_id IS NULL OR source_id > 0),

    CONSTRAINT chk_data_uploads_file_type
        CHECK (file_type IN (
            'XLS',
            'XLSX',
            'CSV',
            'JSON',
            'XML',
            'API',
            'OTHER'
        )),

    CONSTRAINT chk_data_uploads_file_name
        CHECK (length(trim(file_name)) > 0),

    CONSTRAINT chk_data_uploads_uploaded_at
        CHECK (uploaded_at <= CURRENT_TIMESTAMP)
);

-- 3. COLUMN MAPPINGS

CREATE TABLE column_mappings (
    mapping_id BIGSERIAL PRIMARY KEY,
    source_id BIGINT NOT NULL,
    source_column VARCHAR(150) NOT NULL,
    target_table VARCHAR(150) NOT NULL,
    target_column VARCHAR(150) NOT NULL,
    transformation_rule TEXT,

    CONSTRAINT chk_column_mappings_source_id
        CHECK (source_id > 0),

    CONSTRAINT chk_column_mappings_source_column
        CHECK (length(trim(source_column)) > 0),

    CONSTRAINT chk_column_mappings_target_table
        CHECK (length(trim(target_table)) > 0),

    CONSTRAINT chk_column_mappings_target_column
        CHECK (length(trim(target_column)) > 0),

    CONSTRAINT uq_column_mappings_source_target
        UNIQUE (
            source_id,
            source_column,
            target_table,
            target_column
        )
);

-- 4. VALIDATION RULES

CREATE TABLE validation_rules (
    validation_id BIGSERIAL PRIMARY KEY,
    table_name VARCHAR(150) NOT NULL,
    column_name VARCHAR(150) NOT NULL,
    rule_expression TEXT NOT NULL,
    severity VARCHAR(30) NOT NULL DEFAULT 'ERROR',

    CONSTRAINT chk_validation_rules_table_name
        CHECK (length(trim(table_name)) > 0),

    CONSTRAINT chk_validation_rules_column_name
        CHECK (length(trim(column_name)) > 0),

    CONSTRAINT chk_validation_rules_severity
        CHECK (severity IN (
            'INFO',
            'WARNING',
            'ERROR',
            'CRITICAL'
        )),

    CONSTRAINT uq_validation_rules_definition
        UNIQUE (
            table_name,
            column_name,
            rule_expression
        )
);

- 5. IMPORT BATCHES

CREATE TABLE import_batches (
    batch_id BIGSERIAL PRIMARY KEY,
    upload_id BIGINT NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,

    CONSTRAINT chk_import_batches_upload_id
        CHECK (upload_id > 0),

    CONSTRAINT chk_import_batches_status
        CHECK (status IN (
            'PENDING',
            'PROCESSING',
            'COMPLETED',
            'FAILED',
            'PARTIAL'
        )),

    CONSTRAINT chk_import_batches_dates
        CHECK (
            completed_at IS NULL
            OR started_at IS NULL
            OR completed_at >= started_at
        ),

    CONSTRAINT chk_import_batches_completed_status
        CHECK (
            status NOT IN ('COMPLETED', 'FAILED', 'PARTIAL')
            OR completed_at IS NOT NULL
        )
);


-- 6. IMPORT ROWS

CREATE TABLE import_rows (
    row_id BIGSERIAL PRIMARY KEY,
    batch_id BIGINT NOT NULL,
    row_number BIGINT NOT NULL,
    raw_data JSONB NOT NULL,

    CONSTRAINT chk_import_rows_batch_id
        CHECK (batch_id > 0),

    CONSTRAINT chk_import_rows_row_number
        CHECK (row_number > 0),

    CONSTRAINT uq_import_rows_batch_row
        UNIQUE (
            batch_id,
            row_number
        )
);

-- 7. INVALID ROWS

CREATE TABLE invalid_rows (
    id BIGSERIAL PRIMARY KEY,
    batch_id BIGINT NOT NULL,
    row_number BIGINT NOT NULL,
    error_reason TEXT NOT NULL,

    CONSTRAINT chk_invalid_rows_batch_id
        CHECK (batch_id > 0),

    CONSTRAINT chk_invalid_rows_row_number
        CHECK (row_number > 0),

    CONSTRAINT chk_invalid_rows_error_reason
        CHECK (length(trim(error_reason)) > 0),

    CONSTRAINT uq_invalid_rows_batch_row
        UNIQUE (
            batch_id,
            row_number
        )
);


-- 8. AUDIT LOGS

CREATE TABLE audit_logs (
    log_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    entity_type VARCHAR(100) NOT NULL,
    entity_id BIGINT,
    action VARCHAR(100) NOT NULL,
    old_value JSONB,
    new_value JSONB,
    logged_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_audit_logs_entity_id
        CHECK (entity_id IS NULL OR entity_id > 0),

    CONSTRAINT chk_audit_logs_entity_type
        CHECK (length(trim(entity_type)) > 0),

    CONSTRAINT chk_audit_logs_action
        CHECK (length(trim(action)) > 0),

    CONSTRAINT chk_audit_logs_logged_at
        CHECK (logged_at <= CURRENT_TIMESTAMP),

    CONSTRAINT chk_audit_logs_values
        CHECK (
            old_value IS NOT NULL
            OR new_value IS NOT NULL
        )
);

-- 9. WORKING HISTORY

CREATE TABLE working_history (
    history_id BIGSERIAL PRIMARY KEY,
    actor_type VARCHAR(30) NOT NULL,
    actor_user_id BIGINT,
    mode VARCHAR(30) NOT NULL,
    action_type VARCHAR(100) NOT NULL,
    entity_type_id BIGINT NOT NULL,
    entity_id BIGINT NOT NULL,
    action_detail JSONB,
    performed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actor_label VARCHAR(150),

    CONSTRAINT chk_working_history_actor_type
        CHECK (actor_type IN (
            'USER',
            'AI',
            'SYSTEM',
            'AUTOMATION',
            'CREW'
        )),

    CONSTRAINT chk_working_history_actor_user
        CHECK (
            actor_type <> 'USER'
            OR actor_user_id IS NOT NULL
        ),

    CONSTRAINT chk_working_history_mode
        CHECK (mode IN (
            'MANUAL',
            'AUTOMATIC',
            'AI_ASSISTED',
            'SYSTEM'
        )),

    CONSTRAINT chk_working_history_entity_id
        CHECK (entity_id > 0),

    CONSTRAINT chk_working_history_entity_type_id
        CHECK (entity_type_id > 0),

    CONSTRAINT chk_working_history_action
        CHECK (length(trim(action_type)) > 0),

    CONSTRAINT chk_working_history_performed_at
        CHECK (performed_at <= CURRENT_TIMESTAMP),

    CONSTRAINT chk_working_history_actor_label
        CHECK (
            actor_label IS NULL
            OR length(trim(actor_label)) > 0
        )
);

-- 10. EXTERNAL SYSTEM LINKS

CREATE TABLE external_system_links (
    link_id BIGSERIAL PRIMARY KEY,
    abps_entity_type_id BIGINT NOT NULL,
    abps_entity_id BIGINT NOT NULL,
    source_system VARCHAR(100) NOT NULL,
    source_record_id VARCHAR(150) NOT NULL,
    sync_status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    synced_at TIMESTAMPTZ,

    CONSTRAINT chk_external_links_entity_type
        CHECK (abps_entity_type_id > 0),

    CONSTRAINT chk_external_links_entity_id
        CHECK (abps_entity_id > 0),

    CONSTRAINT chk_external_links_source_system
        CHECK (length(trim(source_system)) > 0),

    CONSTRAINT chk_external_links_source_record
        CHECK (length(trim(source_record_id)) > 0),

    CONSTRAINT chk_external_links_sync_status
        CHECK (sync_status IN (
            'PENDING',
            'SYNCED',
            'FAILED',
            'CONFLICT',
            'DISCONNECTED'
        )),

    CONSTRAINT chk_external_links_synced_at
        CHECK (
            sync_status <> 'SYNCED'
            OR synced_at IS NOT NULL
        ),

    CONSTRAINT uq_external_system_record
        UNIQUE (
            source_system,
            source_record_id
        )
);

-- 11. NOTIFICATIONS & ALERTS

CREATE TABLE notifications_alerts (
    notification_id BIGSERIAL PRIMARY KEY,
    recipient_type VARCHAR(30) NOT NULL,
    recipient_user_id BIGINT,
    entity_type_id BIGINT,
    entity_id BIGINT,
    message TEXT NOT NULL,
    severity VARCHAR(30) NOT NULL,
    channel VARCHAR(30) NOT NULL,
    sent_at TIMESTAMPTZ,
    read_at TIMESTAMPTZ,
    recipient_crew_id BIGINT,

    CONSTRAINT chk_notifications_recipient_type
        CHECK (recipient_type IN (
            'USER',
            'CREW'
        )),

    CONSTRAINT chk_notifications_recipient
        CHECK (
            (recipient_type = 'USER' AND recipient_user_id IS NOT NULL)
            OR
            (recipient_type = 'CREW' AND recipient_crew_id IS NOT NULL)
        ),

    CONSTRAINT chk_notifications_entity_id
        CHECK (
            entity_id IS NULL
            OR entity_id > 0
        ),

    CONSTRAINT chk_notifications_entity_type
        CHECK (
            entity_type_id IS NULL
            OR entity_type_id > 0
        ),

    CONSTRAINT chk_notifications_message
        CHECK (length(trim(message)) > 0),

    CONSTRAINT chk_notifications_severity
        CHECK (severity IN (
            'INFO',
            'LOW',
            'MEDIUM',
            'HIGH',
            'CRITICAL'
        )),

    CONSTRAINT chk_notifications_channel
        CHECK (channel IN (
            'IN_APP',
            'EMAIL',
            'SMS',
            'PUSH',
            'SYSTEM'
        )),

    CONSTRAINT chk_notifications_dates
        CHECK (
            read_at IS NULL
            OR sent_at IS NULL
            OR read_at >= sent_at
        ),

    CONSTRAINT chk_notifications_sent_at
        CHECK (
            sent_at IS NULL
            OR sent_at <= CURRENT_TIMESTAMP
        ),

    CONSTRAINT chk_notifications_read_at
        CHECK (
            read_at IS NULL
            OR read_at <= CURRENT_TIMESTAMP
        )
);


-- ============================================================
-- 12. ENTITY TYPES
-- ============================================================

CREATE TABLE entity_types (
    entity_type_id BIGSERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    table_name VARCHAR(150) NOT NULL,
    pk_column VARCHAR(150) NOT NULL,

    CONSTRAINT uq_entity_types_type_name
        UNIQUE (type_name),

    CONSTRAINT uq_entity_types_table_pk
        UNIQUE (
            table_name,
            pk_column
        ),

    CONSTRAINT chk_entity_types_type_name
        CHECK (length(trim(type_name)) > 0),

    CONSTRAINT chk_entity_types_table_name
        CHECK (length(trim(table_name)) > 0),

    CONSTRAINT chk_entity_types_pk_column
        CHECK (length(trim(pk_column)) > 0),

    CONSTRAINT chk_entity_types_lowercase
        CHECK (
            type_name = lower(type_name)
        )
);


-- 13. DATA QUALITY SCORES

CREATE TABLE data_quality_scores (
    score_id BIGSERIAL PRIMARY KEY,
    batch_id BIGINT NOT NULL,
    completeness_score NUMERIC(5,2) NOT NULL,
    accuracy_score NUMERIC(5,2) NOT NULL,
    consistency_score NUMERIC(5,2) NOT NULL,
    timeliness_score NUMERIC(5,2) NOT NULL,
    overall_score NUMERIC(5,2) NOT NULL,
    scored_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_quality_scores_batch_id
        CHECK (batch_id > 0),

    CONSTRAINT chk_quality_completeness
        CHECK (
            completeness_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_quality_accuracy
        CHECK (
            accuracy_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_quality_consistency
        CHECK (
            consistency_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_quality_timeliness
        CHECK (
            timeliness_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_quality_overall
        CHECK (
            overall_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_quality_scored_at
        CHECK (scored_at <= CURRENT_TIMESTAMP),

    CONSTRAINT uq_quality_batch_time
        UNIQUE (
            batch_id,
            scored_at
        )
);

-- 14. FIELD PROVENANCE

CREATE TABLE field_provenance (
    provenance_id BIGSERIAL PRIMARY KEY,
    table_name VARCHAR(150) NOT NULL,
    column_name VARCHAR(150) NOT NULL,
    entity_id BIGINT NOT NULL,
    source_id BIGINT NOT NULL,
    upload_id BIGINT,
    import_row_id BIGINT,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_provenance_table_name
        CHECK (length(trim(table_name)) > 0),

    CONSTRAINT chk_provenance_column_name
        CHECK (length(trim(column_name)) > 0),

    CONSTRAINT chk_provenance_entity_id
        CHECK (entity_id > 0),

    CONSTRAINT chk_provenance_source_id
        CHECK (source_id > 0),

    CONSTRAINT chk_provenance_upload_id
        CHECK (
            upload_id IS NULL
            OR upload_id > 0
        ),

    CONSTRAINT chk_provenance_import_row_id
        CHECK (
            import_row_id IS NULL
            OR import_row_id > 0
        ),

    CONSTRAINT chk_provenance_recorded_at
        CHECK (recorded_at <= CURRENT_TIMESTAMP),

    CONSTRAINT uq_field_provenance
        UNIQUE (
            table_name,
            column_name,
            entity_id,
            recorded_at
        )
);

-- INDEXES

CREATE INDEX idx_data_uploads_source
    ON data_uploads(source_id);

CREATE INDEX idx_data_uploads_uploaded_by
    ON data_uploads(uploaded_by);

CREATE INDEX idx_column_mappings_source
    ON column_mappings(source_id);

CREATE INDEX idx_validation_rules_table_column
    ON validation_rules(table_name, column_name);

CREATE INDEX idx_import_batches_upload
    ON import_batches(upload_id);

CREATE INDEX idx_import_batches_status
    ON import_batches(status);

CREATE INDEX idx_import_rows_batch
    ON import_rows(batch_id);

CREATE INDEX idx_invalid_rows_batch
    ON invalid_rows(batch_id);

CREATE INDEX idx_audit_logs_user
    ON audit_logs(user_id);

CREATE INDEX idx_audit_logs_entity
    ON audit_logs(entity_type, entity_id);

CREATE INDEX idx_audit_logs_logged_at
    ON audit_logs(logged_at);

CREATE INDEX idx_working_history_actor
    ON working_history(actor_type, actor_user_id);

CREATE INDEX idx_working_history_entity
    ON working_history(entity_type_id, entity_id);

CREATE INDEX idx_working_history_performed_at
    ON working_history(performed_at);

CREATE INDEX idx_external_links_entity
    ON external_system_links(
        abps_entity_type_id,
        abps_entity_id
    );

CREATE INDEX idx_external_links_source
    ON external_system_links(
        source_system,
        source_record_id
    );

CREATE INDEX idx_notifications_user
    ON notifications_alerts(recipient_user_id);

CREATE INDEX idx_notifications_crew
    ON notifications_alerts(recipient_crew_id);

CREATE INDEX idx_notifications_entity
    ON notifications_alerts(entity_type_id, entity_id);

CREATE INDEX idx_notifications_unread
    ON notifications_alerts(read_at)
    WHERE read_at IS NULL;

CREATE INDEX idx_data_quality_batch
    ON data_quality_scores(batch_id);

CREATE INDEX idx_field_provenance_entity
    ON field_provenance(
        table_name,
        column_name,
        entity_id
    );

CREATE INDEX idx_field_provenance_source
    ON field_provenance(source_id);

CREATE INDEX idx_field_provenance_upload
    ON field_provenance(upload_id);

CREATE INDEX idx_field_provenance_import_row
    ON field_provenance(import_row_id);