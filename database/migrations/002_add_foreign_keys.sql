
-- This migration adds the actual FK constraints only.




ALTER TABLE users
    ADD CONSTRAINT fk_users_department_id
    FOREIGN KEY (department_id)
    REFERENCES departments (department_id)
    ON DELETE RESTRICT;

ALTER TABLE user_roles
    ADD CONSTRAINT fk_user_roles_user_id
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON DELETE CASCADE;

ALTER TABLE user_roles
    ADD CONSTRAINT fk_user_roles_role_id
    FOREIGN KEY (role_id)
    REFERENCES roles (role_id)
    ON DELETE CASCADE;

ALTER TABLE role_permissions
    ADD CONSTRAINT fk_role_permissions_role_id
    FOREIGN KEY (role_id)
    REFERENCES roles (role_id)
    ON DELETE CASCADE;

ALTER TABLE role_permissions
    ADD CONSTRAINT fk_role_permissions_permission_id
    FOREIGN KEY (permission_id)
    REFERENCES permissions (permission_id)
    ON DELETE CASCADE;

ALTER TABLE railway_divisions
    ADD CONSTRAINT fk_railway_divisions_zone_id
    FOREIGN KEY (zone_id)
    REFERENCES railway_zones (zone_id)
    ON DELETE RESTRICT;

ALTER TABLE stations
    ADD CONSTRAINT fk_stations_division_id
    FOREIGN KEY (division_id)
    REFERENCES railway_divisions (division_id)
    ON DELETE RESTRICT;

ALTER TABLE station_platforms
    ADD CONSTRAINT fk_station_platforms_station_id
    FOREIGN KEY (station_id)
    REFERENCES stations (station_id)
    ON DELETE CASCADE;

ALTER TABLE sections
    ADD CONSTRAINT fk_sections_start_station_id
    FOREIGN KEY (start_station_id)
    REFERENCES stations (station_id)
    ON DELETE RESTRICT;

ALTER TABLE sections
    ADD CONSTRAINT fk_sections_end_station_id
    FOREIGN KEY (end_station_id)
    REFERENCES stations (station_id)
    ON DELETE RESTRICT;

ALTER TABLE section_stations
    ADD CONSTRAINT fk_section_stations_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE section_stations
    ADD CONSTRAINT fk_section_stations_station_id
    FOREIGN KEY (station_id)
    REFERENCES stations (station_id)
    ON DELETE RESTRICT;

ALTER TABLE tracks
    ADD CONSTRAINT fk_tracks_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE track_segments
    ADD CONSTRAINT fk_track_segments_track_id
    FOREIGN KEY (track_id)
    REFERENCES tracks (track_id)
    ON DELETE CASCADE;

ALTER TABLE block_sections
    ADD CONSTRAINT fk_block_sections_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE route_sections
    ADD CONSTRAINT fk_route_sections_route_id
    FOREIGN KEY (route_id)
    REFERENCES routes (route_id)
    ON DELETE CASCADE;

ALTER TABLE route_sections
    ADD CONSTRAINT fk_route_sections_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE RESTRICT;

ALTER TABLE junctions
    ADD CONSTRAINT fk_junctions_station_id
    FOREIGN KEY (station_id)
    REFERENCES stations (station_id)
    ON DELETE CASCADE;

ALTER TABLE signals
    ADD CONSTRAINT fk_signals_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE points_crossings
    ADD CONSTRAINT fk_points_crossings_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE level_crossings
    ADD CONSTRAINT fk_level_crossings_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE bridges
    ADD CONSTRAINT fk_bridges_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE tunnels
    ADD CONSTRAINT fk_tunnels_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE electrification_assets
    ADD CONSTRAINT fk_electrification_assets_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE signalling_assets
    ADD CONSTRAINT fk_signalling_assets_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE telecom_assets
    ADD CONSTRAINT fk_telecom_assets_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE section_corridors
    ADD CONSTRAINT fk_section_corridors_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE section_corridors
    ADD CONSTRAINT fk_section_corridors_corridor_id
    FOREIGN KEY (corridor_id)
    REFERENCES corridors (corridor_id)
    ON DELETE CASCADE;

ALTER TABLE assets
    ADD CONSTRAINT fk_assets_asset_type_id
    FOREIGN KEY (asset_type_id)
    REFERENCES asset_types (asset_type_id)
    ON DELETE RESTRICT;

ALTER TABLE assets
    ADD CONSTRAINT fk_assets_department_id
    FOREIGN KEY (department_id)
    REFERENCES departments (department_id)
    ON DELETE SET NULL;

ALTER TABLE asset_locations
    ADD CONSTRAINT fk_asset_locations_asset_id
    FOREIGN KEY (asset_id)
    REFERENCES assets (asset_id)
    ON DELETE CASCADE;

ALTER TABLE asset_locations
    ADD CONSTRAINT fk_asset_locations_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE RESTRICT;

ALTER TABLE asset_health
    ADD CONSTRAINT fk_asset_health_asset_id
    FOREIGN KEY (asset_id)
    REFERENCES assets (asset_id)
    ON DELETE CASCADE;

ALTER TABLE asset_inspections
    ADD CONSTRAINT fk_asset_inspections_asset_id
    FOREIGN KEY (asset_id)
    REFERENCES assets (asset_id)
    ON DELETE RESTRICT;

ALTER TABLE asset_failures
    ADD CONSTRAINT fk_asset_failures_asset_id
    FOREIGN KEY (asset_id)
    REFERENCES assets (asset_id)
    ON DELETE RESTRICT;

ALTER TABLE asset_failures
    ADD CONSTRAINT fk_asset_failures_severity_id
    FOREIGN KEY (severity_id)
    REFERENCES severity_levels (severity_id)
    ON DELETE RESTRICT;

ALTER TABLE asset_availability
    ADD CONSTRAINT fk_asset_availability_asset_id
    FOREIGN KEY (asset_id)
    REFERENCES assets (asset_id)
    ON DELETE CASCADE;

ALTER TABLE asset_condition_history
    ADD CONSTRAINT fk_asset_condition_history_asset_id
    FOREIGN KEY (asset_id)
    REFERENCES assets (asset_id)
    ON DELETE CASCADE;

ALTER TABLE asset_condition_history
    ADD CONSTRAINT fk_asset_condition_history_source_id
    FOREIGN KEY (source_id)
    REFERENCES data_sources (source_id)
    ON DELETE SET NULL;

ALTER TABLE asset_degradation_predictions
    ADD CONSTRAINT fk_asset_degradation_predictions_asset_id
    FOREIGN KEY (asset_id)
    REFERENCES assets (asset_id)
    ON DELETE CASCADE;

ALTER TABLE trains
    ADD CONSTRAINT fk_trains_train_type_id
    FOREIGN KEY (train_type_id)
    REFERENCES train_types (train_type_id)
    ON DELETE RESTRICT;

ALTER TABLE train_schedules
    ADD CONSTRAINT fk_train_schedules_train_id
    FOREIGN KEY (train_id)
    REFERENCES trains (train_id)
    ON DELETE CASCADE;

ALTER TABLE train_schedule_stops
    ADD CONSTRAINT fk_train_schedule_stops_schedule_id
    FOREIGN KEY (schedule_id)
    REFERENCES train_schedules (schedule_id)
    ON DELETE CASCADE;

ALTER TABLE train_schedule_stops
    ADD CONSTRAINT fk_train_schedule_stops_station_id
    FOREIGN KEY (station_id)
    REFERENCES stations (station_id)
    ON DELETE RESTRICT;

ALTER TABLE train_routes
    ADD CONSTRAINT fk_train_routes_train_id
    FOREIGN KEY (train_id)
    REFERENCES trains (train_id)
    ON DELETE CASCADE;

ALTER TABLE train_routes
    ADD CONSTRAINT fk_train_routes_route_id
    FOREIGN KEY (route_id)
    REFERENCES routes (route_id)
    ON DELETE RESTRICT;

ALTER TABLE train_running_days
    ADD CONSTRAINT fk_train_running_days_schedule_id
    FOREIGN KEY (schedule_id)
    REFERENCES train_schedules (schedule_id)
    ON DELETE CASCADE;

ALTER TABLE train_priorities
    ADD CONSTRAINT fk_train_priorities_train_id
    FOREIGN KEY (train_id)
    REFERENCES trains (train_id)
    ON DELETE CASCADE;

ALTER TABLE train_movements
    ADD CONSTRAINT fk_train_movements_train_id
    FOREIGN KEY (train_id)
    REFERENCES trains (train_id)
    ON DELETE RESTRICT;

ALTER TABLE train_movements
    ADD CONSTRAINT fk_train_movements_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE RESTRICT;

ALTER TABLE train_delays
    ADD CONSTRAINT fk_train_delays_movement_id
    FOREIGN KEY (movement_id)
    REFERENCES train_movements (movement_id)
    ON DELETE CASCADE;

ALTER TABLE traffic_density
    ADD CONSTRAINT fk_traffic_density_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE alternative_routes
    ADD CONSTRAINT fk_alternative_routes_train_id
    FOREIGN KEY (train_id)
    REFERENCES trains (train_id)
    ON DELETE CASCADE;

ALTER TABLE alternative_routes
    ADD CONSTRAINT fk_alternative_routes_original_route_id
    FOREIGN KEY (original_route_id)
    REFERENCES routes (route_id)
    ON DELETE RESTRICT;

ALTER TABLE alternative_routes
    ADD CONSTRAINT fk_alternative_routes_proposed_route_id
    FOREIGN KEY (proposed_route_id)
    REFERENCES routes (route_id)
    ON DELETE RESTRICT;

ALTER TABLE train_block_impacts
    ADD CONSTRAINT fk_train_block_impacts_train_id
    FOREIGN KEY (train_id)
    REFERENCES trains (train_id)
    ON DELETE CASCADE;

ALTER TABLE train_block_impacts
    ADD CONSTRAINT fk_train_block_impacts_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE train_block_impacts
    ADD CONSTRAINT fk_train_block_impacts_affected_section_id
    FOREIGN KEY (affected_section_id)
    REFERENCES sections (section_id)
    ON DELETE SET NULL;

ALTER TABLE train_block_impacts
    ADD CONSTRAINT fk_train_block_impacts_original_route_id
    FOREIGN KEY (original_route_id)
    REFERENCES routes (route_id)
    ON DELETE SET NULL;

ALTER TABLE train_block_impacts
    ADD CONSTRAINT fk_train_block_impacts_alternative_route_id
    FOREIGN KEY (alternative_route_id)
    REFERENCES routes (route_id)
    ON DELETE SET NULL;

ALTER TABLE train_block_impacts
    ADD CONSTRAINT fk_train_block_impacts_severity_id
    FOREIGN KEY (severity_id)
    REFERENCES severity_levels (severity_id)
    ON DELETE RESTRICT;

ALTER TABLE maintenance_jobs
    ADD CONSTRAINT fk_maintenance_jobs_job_type_id
    FOREIGN KEY (job_type_id)
    REFERENCES maintenance_job_types (job_type_id)
    ON DELETE RESTRICT;

ALTER TABLE maintenance_jobs
    ADD CONSTRAINT fk_maintenance_jobs_department_id
    FOREIGN KEY (department_id)
    REFERENCES departments (department_id)
    ON DELETE SET NULL;

ALTER TABLE maintenance_jobs
    ADD CONSTRAINT fk_maintenance_jobs_risk_severity_id
    FOREIGN KEY (risk_severity_id)
    REFERENCES severity_levels (severity_id)
    ON DELETE RESTRICT;

ALTER TABLE maintenance_jobs
    ADD CONSTRAINT fk_maintenance_jobs_priority_id
    FOREIGN KEY (priority_id)
    REFERENCES criticality_levels (criticality_id)
    ON DELETE RESTRICT;

ALTER TABLE maintenance_jobs
    ADD CONSTRAINT fk_maintenance_jobs_urgency_id
    FOREIGN KEY (urgency_id)
    REFERENCES criticality_levels (criticality_id)
    ON DELETE RESTRICT;

ALTER TABLE maintenance_job_assets
    ADD CONSTRAINT fk_maintenance_job_assets_job_id
    FOREIGN KEY (job_id)
    REFERENCES maintenance_jobs (job_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_job_assets
    ADD CONSTRAINT fk_maintenance_job_assets_asset_id
    FOREIGN KEY (asset_id)
    REFERENCES assets (asset_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_job_sections
    ADD CONSTRAINT fk_maintenance_job_sections_job_id
    FOREIGN KEY (job_id)
    REFERENCES maintenance_jobs (job_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_job_sections
    ADD CONSTRAINT fk_maintenance_job_sections_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_requirements
    ADD CONSTRAINT fk_maintenance_requirements_job_id
    FOREIGN KEY (job_id)
    REFERENCES maintenance_jobs (job_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_priorities
    ADD CONSTRAINT fk_maintenance_priorities_job_id
    FOREIGN KEY (job_id)
    REFERENCES maintenance_jobs (job_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_dependencies
    ADD CONSTRAINT fk_maintenance_dependencies_job_id
    FOREIGN KEY (job_id)
    REFERENCES maintenance_jobs (job_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_dependencies
    ADD CONSTRAINT fk_maintenance_dependencies_depends_on_job_id
    FOREIGN KEY (depends_on_job_id)
    REFERENCES maintenance_jobs (job_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_history
    ADD CONSTRAINT fk_maintenance_history_job_id
    FOREIGN KEY (job_id)
    REFERENCES maintenance_jobs (job_id)
    ON DELETE RESTRICT;

ALTER TABLE maintenance_transition_costs
    ADD CONSTRAINT fk_maintenance_transition_costs_from_job_type_id
    FOREIGN KEY (from_job_type_id)
    REFERENCES maintenance_job_types (job_type_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_transition_costs
    ADD CONSTRAINT fk_maintenance_transition_costs_to_job_type_id
    FOREIGN KEY (to_job_type_id)
    REFERENCES maintenance_job_types (job_type_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_transition_costs
    ADD CONSTRAINT fk_maintenance_transition_costs_from_location_id
    FOREIGN KEY (from_location_id)
    REFERENCES stations (station_id)
    ON DELETE SET NULL;

ALTER TABLE maintenance_transition_costs
    ADD CONSTRAINT fk_maintenance_transition_costs_to_location_id
    FOREIGN KEY (to_location_id)
    REFERENCES stations (station_id)
    ON DELETE SET NULL;

ALTER TABLE block_requests
    ADD CONSTRAINT fk_block_requests_department_id
    FOREIGN KEY (department_id)
    REFERENCES departments (department_id)
    ON DELETE SET NULL;

ALTER TABLE block_requests
    ADD CONSTRAINT fk_block_requests_requested_by
    FOREIGN KEY (requested_by)
    REFERENCES users (user_id)
    ON DELETE RESTRICT;

ALTER TABLE block_requests
    ADD CONSTRAINT fk_block_requests_priority_id
    FOREIGN KEY (priority_id)
    REFERENCES criticality_levels (criticality_id)
    ON DELETE RESTRICT;

ALTER TABLE block_request_jobs
    ADD CONSTRAINT fk_block_request_jobs_request_id
    FOREIGN KEY (request_id)
    REFERENCES block_requests (request_id)
    ON DELETE CASCADE;

ALTER TABLE block_request_jobs
    ADD CONSTRAINT fk_block_request_jobs_job_id
    FOREIGN KEY (job_id)
    REFERENCES maintenance_jobs (job_id)
    ON DELETE CASCADE;

ALTER TABLE block_request_sections
    ADD CONSTRAINT fk_block_request_sections_request_id
    FOREIGN KEY (request_id)
    REFERENCES block_requests (request_id)
    ON DELETE CASCADE;

ALTER TABLE block_request_sections
    ADD CONSTRAINT fk_block_request_sections_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE block_request_tracks
    ADD CONSTRAINT fk_block_request_tracks_request_id
    FOREIGN KEY (request_id)
    REFERENCES block_requests (request_id)
    ON DELETE CASCADE;

ALTER TABLE block_request_tracks
    ADD CONSTRAINT fk_block_request_tracks_track_id
    FOREIGN KEY (track_id)
    REFERENCES tracks (track_id)
    ON DELETE CASCADE;

ALTER TABLE block_window_sections
    ADD CONSTRAINT fk_block_window_sections_window_id
    FOREIGN KEY (window_id)
    REFERENCES block_windows (window_id)
    ON DELETE CASCADE;

ALTER TABLE block_window_sections
    ADD CONSTRAINT fk_block_window_sections_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE block_window_tracks
    ADD CONSTRAINT fk_block_window_tracks_window_id
    FOREIGN KEY (window_id)
    REFERENCES block_windows (window_id)
    ON DELETE CASCADE;

ALTER TABLE block_window_tracks
    ADD CONSTRAINT fk_block_window_tracks_track_id
    FOREIGN KEY (track_id)
    REFERENCES tracks (track_id)
    ON DELETE CASCADE;

ALTER TABLE planned_blocks
    ADD CONSTRAINT fk_planned_blocks_block_type_id
    FOREIGN KEY (block_type_id)
    REFERENCES block_types (block_type_id)
    ON DELETE RESTRICT;

ALTER TABLE planned_blocks
    ADD CONSTRAINT fk_planned_blocks_window_id
    FOREIGN KEY (window_id)
    REFERENCES block_windows (window_id)
    ON DELETE RESTRICT;

ALTER TABLE planned_blocks
    ADD CONSTRAINT fk_planned_blocks_request_id
    FOREIGN KEY (request_id)
    REFERENCES block_requests (request_id)
    ON DELETE RESTRICT;

ALTER TABLE planned_block_jobs
    ADD CONSTRAINT fk_planned_block_jobs_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE planned_block_jobs
    ADD CONSTRAINT fk_planned_block_jobs_job_id
    FOREIGN KEY (job_id)
    REFERENCES maintenance_jobs (job_id)
    ON DELETE CASCADE;

ALTER TABLE planned_block_sections
    ADD CONSTRAINT fk_planned_block_sections_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE planned_block_sections
    ADD CONSTRAINT fk_planned_block_sections_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE planned_block_trains
    ADD CONSTRAINT fk_planned_block_trains_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE planned_block_trains
    ADD CONSTRAINT fk_planned_block_trains_train_id
    FOREIGN KEY (train_id)
    REFERENCES trains (train_id)
    ON DELETE CASCADE;

ALTER TABLE block_status_history
    ADD CONSTRAINT fk_block_status_history_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE RESTRICT;

ALTER TABLE block_approvals
    ADD CONSTRAINT fk_block_approvals_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE block_approvals
    ADD CONSTRAINT fk_block_approvals_user_id
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON DELETE RESTRICT;

ALTER TABLE block_execution
    ADD CONSTRAINT fk_block_execution_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE block_cancellations
    ADD CONSTRAINT fk_block_cancellations_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE block_rescheduling
    ADD CONSTRAINT fk_block_rescheduling_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE block_rescheduling
    ADD CONSTRAINT fk_block_rescheduling_new_window_id
    FOREIGN KEY (new_window_id)
    REFERENCES block_windows (window_id)
    ON DELETE RESTRICT;

ALTER TABLE block_tasks
    ADD CONSTRAINT fk_block_tasks_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE block_tasks
    ADD CONSTRAINT fk_block_tasks_job_id
    FOREIGN KEY (job_id)
    REFERENCES maintenance_jobs (job_id)
    ON DELETE SET NULL;

ALTER TABLE block_tasks
    ADD CONSTRAINT fk_block_tasks_corridor_id
    FOREIGN KEY (corridor_id)
    REFERENCES corridors (corridor_id)
    ON DELETE SET NULL;

ALTER TABLE block_tasks
    ADD CONSTRAINT fk_block_tasks_urgency_id
    FOREIGN KEY (urgency_id)
    REFERENCES criticality_levels (criticality_id)
    ON DELETE RESTRICT;

ALTER TABLE block_possessions
    ADD CONSTRAINT fk_block_possessions_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE plan_versions
    ADD CONSTRAINT fk_plan_versions_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE plan_versions
    ADD CONSTRAINT fk_plan_versions_rolled_back_from_version_id
    FOREIGN KEY (rolled_back_from_version_id)
    REFERENCES plan_versions (version_id)
    ON DELETE SET NULL;

ALTER TABLE plan_changes
    ADD CONSTRAINT fk_plan_changes_version_id
    FOREIGN KEY (version_id)
    REFERENCES plan_versions (version_id)
    ON DELETE CASCADE;

ALTER TABLE plan_execution_events
    ADD CONSTRAINT fk_plan_execution_events_execution_id
    FOREIGN KEY (execution_id)
    REFERENCES block_execution (execution_id)
    ON DELETE CASCADE;

ALTER TABLE planned_block_tracks
    ADD CONSTRAINT fk_planned_block_tracks_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE planned_block_tracks
    ADD CONSTRAINT fk_planned_block_tracks_track_id
    FOREIGN KEY (track_id)
    REFERENCES tracks (track_id)
    ON DELETE CASCADE;

ALTER TABLE emergency_overrides
    ADD CONSTRAINT fk_emergency_overrides_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE emergency_overrides
    ADD CONSTRAINT fk_emergency_overrides_authorized_by
    FOREIGN KEY (authorized_by)
    REFERENCES users (user_id)
    ON DELETE RESTRICT;

ALTER TABLE emergency_overrides
    ADD CONSTRAINT fk_emergency_overrides_reviewed_by
    FOREIGN KEY (reviewed_by)
    REFERENCES users (user_id)
    ON DELETE SET NULL;

ALTER TABLE plan_version_comparisons
    ADD CONSTRAINT fk_plan_version_comparisons_version_id
    FOREIGN KEY (version_id)
    REFERENCES plan_versions (version_id)
    ON DELETE CASCADE;

ALTER TABLE plan_version_comparisons
    ADD CONSTRAINT fk_plan_version_comparisons_compared_to_version_id
    FOREIGN KEY (compared_to_version_id)
    REFERENCES plan_versions (version_id)
    ON DELETE CASCADE;

ALTER TABLE constraints
    ADD CONSTRAINT fk_constraints_constraint_type_id
    FOREIGN KEY (constraint_type_id)
    REFERENCES constraint_types (constraint_type_id)
    ON DELETE RESTRICT;

ALTER TABLE constraint_rules
    ADD CONSTRAINT fk_constraint_rules_constraint_id
    FOREIGN KEY (constraint_id)
    REFERENCES constraints (constraint_id)
    ON DELETE CASCADE;

ALTER TABLE conflicts
    ADD CONSTRAINT fk_conflicts_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE conflicts
    ADD CONSTRAINT fk_conflicts_severity_id
    FOREIGN KEY (severity_id)
    REFERENCES severity_levels (severity_id)
    ON DELETE RESTRICT;

ALTER TABLE conflict_trains
    ADD CONSTRAINT fk_conflict_trains_conflict_id
    FOREIGN KEY (conflict_id)
    REFERENCES conflicts (conflict_id)
    ON DELETE CASCADE;

ALTER TABLE conflict_trains
    ADD CONSTRAINT fk_conflict_trains_train_id
    FOREIGN KEY (train_id)
    REFERENCES trains (train_id)
    ON DELETE CASCADE;

ALTER TABLE conflict_sections
    ADD CONSTRAINT fk_conflict_sections_conflict_id
    FOREIGN KEY (conflict_id)
    REFERENCES conflicts (conflict_id)
    ON DELETE CASCADE;

ALTER TABLE conflict_sections
    ADD CONSTRAINT fk_conflict_sections_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE CASCADE;

ALTER TABLE conflict_tracks
    ADD CONSTRAINT fk_conflict_tracks_conflict_id
    FOREIGN KEY (conflict_id)
    REFERENCES conflicts (conflict_id)
    ON DELETE CASCADE;

ALTER TABLE conflict_tracks
    ADD CONSTRAINT fk_conflict_tracks_track_id
    FOREIGN KEY (track_id)
    REFERENCES tracks (track_id)
    ON DELETE CASCADE;

ALTER TABLE conflict_assets
    ADD CONSTRAINT fk_conflict_assets_conflict_id
    FOREIGN KEY (conflict_id)
    REFERENCES conflicts (conflict_id)
    ON DELETE CASCADE;

ALTER TABLE conflict_assets
    ADD CONSTRAINT fk_conflict_assets_asset_id
    FOREIGN KEY (asset_id)
    REFERENCES assets (asset_id)
    ON DELETE CASCADE;

ALTER TABLE conflict_blocks
    ADD CONSTRAINT fk_conflict_blocks_conflict_id
    FOREIGN KEY (conflict_id)
    REFERENCES conflicts (conflict_id)
    ON DELETE CASCADE;

ALTER TABLE conflict_blocks
    ADD CONSTRAINT fk_conflict_blocks_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE conflict_resolutions
    ADD CONSTRAINT fk_conflict_resolutions_conflict_id
    FOREIGN KEY (conflict_id)
    REFERENCES conflicts (conflict_id)
    ON DELETE CASCADE;

ALTER TABLE conflict_resolutions
    ADD CONSTRAINT fk_conflict_resolutions_resolved_by
    FOREIGN KEY (resolved_by)
    REFERENCES users (user_id)
    ON DELETE SET NULL;

ALTER TABLE constraint_violations
    ADD CONSTRAINT fk_constraint_violations_output_id
    FOREIGN KEY (output_id)
    REFERENCES ai_outputs (output_id)
    ON DELETE CASCADE;

ALTER TABLE constraint_violations
    ADD CONSTRAINT fk_constraint_violations_constraint_id
    FOREIGN KEY (constraint_id)
    REFERENCES constraints (constraint_id)
    ON DELETE RESTRICT;

ALTER TABLE ai_runs
    ADD CONSTRAINT fk_ai_runs_requested_by
    FOREIGN KEY (requested_by)
    REFERENCES users (user_id)
    ON DELETE RESTRICT;

ALTER TABLE ai_runs
    ADD CONSTRAINT fk_ai_runs_request_id
    FOREIGN KEY (request_id)
    REFERENCES block_requests (request_id)
    ON DELETE SET NULL;

ALTER TABLE ai_runs
    ADD CONSTRAINT fk_ai_runs_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE SET NULL;

ALTER TABLE ai_run_parameters
    ADD CONSTRAINT fk_ai_run_parameters_run_id
    FOREIGN KEY (run_id)
    REFERENCES ai_runs (run_id)
    ON DELETE CASCADE;

ALTER TABLE ai_outputs
    ADD CONSTRAINT fk_ai_outputs_run_id
    FOREIGN KEY (run_id)
    REFERENCES ai_runs (run_id)
    ON DELETE CASCADE;

ALTER TABLE ai_outputs
    ADD CONSTRAINT fk_ai_outputs_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE ai_output_reasons
    ADD CONSTRAINT fk_ai_output_reasons_output_id
    FOREIGN KEY (output_id)
    REFERENCES ai_outputs (output_id)
    ON DELETE CASCADE;

ALTER TABLE ai_output_reasons
    ADD CONSTRAINT fk_ai_output_reasons_violation_id
    FOREIGN KEY (violation_id)
    REFERENCES constraint_violations (violation_id)
    ON DELETE SET NULL;

ALTER TABLE ai_answer_cache
    ADD CONSTRAINT fk_ai_answer_cache_cached_output_id
    FOREIGN KEY (cached_output_id)
    REFERENCES ai_outputs (output_id)
    ON DELETE CASCADE;

ALTER TABLE ai_engine_scores
    ADD CONSTRAINT fk_ai_engine_scores_output_id
    FOREIGN KEY (output_id)
    REFERENCES ai_outputs (output_id)
    ON DELETE CASCADE;

ALTER TABLE optimization_objectives
    ADD CONSTRAINT fk_optimization_objectives_run_id
    FOREIGN KEY (run_id)
    REFERENCES ai_runs (run_id)
    ON DELETE CASCADE;

ALTER TABLE ai_decision_steps
    ADD CONSTRAINT fk_ai_decision_steps_run_id
    FOREIGN KEY (run_id)
    REFERENCES ai_runs (run_id)
    ON DELETE CASCADE;

ALTER TABLE baseline_plans
    ADD CONSTRAINT fk_baseline_plans_request_id
    FOREIGN KEY (request_id)
    REFERENCES block_requests (request_id)
    ON DELETE CASCADE;

ALTER TABLE baseline_plans
    ADD CONSTRAINT fk_baseline_plans_created_by
    FOREIGN KEY (created_by)
    REFERENCES users (user_id)
    ON DELETE SET NULL;

ALTER TABLE baseline_plans
    ADD CONSTRAINT fk_baseline_plans_window_id
    FOREIGN KEY (window_id)
    REFERENCES block_windows (window_id)
    ON DELETE SET NULL;

ALTER TABLE baseline_vs_ai_comparison
    ADD CONSTRAINT fk_baseline_vs_ai_comparison_baseline_id
    FOREIGN KEY (baseline_id)
    REFERENCES baseline_plans (baseline_id)
    ON DELETE CASCADE;

ALTER TABLE baseline_vs_ai_comparison
    ADD CONSTRAINT fk_baseline_vs_ai_comparison_output_id
    FOREIGN KEY (output_id)
    REFERENCES ai_outputs (output_id)
    ON DELETE CASCADE;

ALTER TABLE data_uploads
    ADD CONSTRAINT fk_data_uploads_uploaded_by
    FOREIGN KEY (uploaded_by)
    REFERENCES users (user_id)
    ON DELETE RESTRICT;

ALTER TABLE data_uploads
    ADD CONSTRAINT fk_data_uploads_source_id
    FOREIGN KEY (source_id)
    REFERENCES data_sources (source_id)
    ON DELETE SET NULL;

ALTER TABLE column_mappings
    ADD CONSTRAINT fk_column_mappings_source_id
    FOREIGN KEY (source_id)
    REFERENCES data_sources (source_id)
    ON DELETE CASCADE;

ALTER TABLE import_batches
    ADD CONSTRAINT fk_import_batches_upload_id
    FOREIGN KEY (upload_id)
    REFERENCES data_uploads (upload_id)
    ON DELETE CASCADE;

ALTER TABLE import_rows
    ADD CONSTRAINT fk_import_rows_batch_id
    FOREIGN KEY (batch_id)
    REFERENCES import_batches (batch_id)
    ON DELETE CASCADE;

ALTER TABLE invalid_rows
    ADD CONSTRAINT fk_invalid_rows_batch_id
    FOREIGN KEY (batch_id)
    REFERENCES import_batches (batch_id)
    ON DELETE CASCADE;

ALTER TABLE audit_logs
    ADD CONSTRAINT fk_audit_logs_user_id
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON DELETE SET NULL;

ALTER TABLE working_history
    ADD CONSTRAINT fk_working_history_actor_user_id
    FOREIGN KEY (actor_user_id)
    REFERENCES users (user_id)
    ON DELETE SET NULL;

ALTER TABLE working_history
    ADD CONSTRAINT fk_working_history_entity_type_id
    FOREIGN KEY (entity_type_id)
    REFERENCES entity_types (entity_type_id)
    ON DELETE RESTRICT;

ALTER TABLE notifications_alerts
    ADD CONSTRAINT fk_notifications_alerts_recipient_user_id
    FOREIGN KEY (recipient_user_id)
    REFERENCES users (user_id)
    ON DELETE CASCADE;

ALTER TABLE notifications_alerts
    ADD CONSTRAINT fk_notifications_alerts_recipient_crew_id
    FOREIGN KEY (recipient_crew_id)
    REFERENCES crew_members (crew_id)
    ON DELETE CASCADE;

ALTER TABLE notifications_alerts
    ADD CONSTRAINT fk_notifications_alerts_entity_type_id
    FOREIGN KEY (entity_type_id)
    REFERENCES entity_types (entity_type_id)
    ON DELETE RESTRICT;

ALTER TABLE data_quality_scores
    ADD CONSTRAINT fk_data_quality_scores_batch_id
    FOREIGN KEY (batch_id)
    REFERENCES import_batches (batch_id)
    ON DELETE CASCADE;

ALTER TABLE field_provenance
    ADD CONSTRAINT fk_field_provenance_source_id
    FOREIGN KEY (source_id)
    REFERENCES data_sources (source_id)
    ON DELETE SET NULL;

ALTER TABLE field_provenance
    ADD CONSTRAINT fk_field_provenance_upload_id
    FOREIGN KEY (upload_id)
    REFERENCES data_uploads (upload_id)
    ON DELETE SET NULL;

ALTER TABLE field_provenance
    ADD CONSTRAINT fk_field_provenance_import_row_id
    FOREIGN KEY (import_row_id)
    REFERENCES import_rows (row_id)
    ON DELETE SET NULL;

ALTER TABLE crew_members
    ADD CONSTRAINT fk_crew_members_department_id
    FOREIGN KEY (department_id)
    REFERENCES departments (department_id)
    ON DELETE SET NULL;

ALTER TABLE crew_shifts
    ADD CONSTRAINT fk_crew_shifts_crew_id
    FOREIGN KEY (crew_id)
    REFERENCES crew_members (crew_id)
    ON DELETE CASCADE;

ALTER TABLE block_crew_assignments
    ADD CONSTRAINT fk_block_crew_assignments_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE block_crew_assignments
    ADD CONSTRAINT fk_block_crew_assignments_crew_id
    FOREIGN KEY (crew_id)
    REFERENCES crew_members (crew_id)
    ON DELETE CASCADE;

ALTER TABLE block_resource_assignments
    ADD CONSTRAINT fk_block_resource_assignments_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE block_resource_assignments
    ADD CONSTRAINT fk_block_resource_assignments_resource_id
    FOREIGN KEY (resource_id)
    REFERENCES resources (resource_id)
    ON DELETE RESTRICT;

ALTER TABLE resource_availability
    ADD CONSTRAINT fk_resource_availability_resource_id
    FOREIGN KEY (resource_id)
    REFERENCES resources (resource_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_equipment
    ADD CONSTRAINT fk_maintenance_equipment_equipment_type_id
    FOREIGN KEY (equipment_type_id)
    REFERENCES equipment_types (equipment_type_id)
    ON DELETE RESTRICT;

ALTER TABLE maintenance_equipment
    ADD CONSTRAINT fk_maintenance_equipment_home_location_id
    FOREIGN KEY (home_location_id)
    REFERENCES stations (station_id)
    ON DELETE SET NULL;

ALTER TABLE equipment_availability
    ADD CONSTRAINT fk_equipment_availability_equipment_id
    FOREIGN KEY (equipment_id)
    REFERENCES maintenance_equipment (equipment_id)
    ON DELETE CASCADE;

ALTER TABLE equipment_availability
    ADD CONSTRAINT fk_equipment_availability_location_id
    FOREIGN KEY (location_id)
    REFERENCES stations (station_id)
    ON DELETE SET NULL;

ALTER TABLE maintenance_job_required_equipment
    ADD CONSTRAINT fk_maintenance_job_required_equipment_job_id
    FOREIGN KEY (job_id)
    REFERENCES maintenance_jobs (job_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_job_required_equipment
    ADD CONSTRAINT fk_maintenance_job_required_equipment_equipment_type_id
    FOREIGN KEY (equipment_type_id)
    REFERENCES equipment_types (equipment_type_id)
    ON DELETE RESTRICT;

ALTER TABLE crew_member_skills
    ADD CONSTRAINT fk_crew_member_skills_crew_id
    FOREIGN KEY (crew_id)
    REFERENCES crew_members (crew_id)
    ON DELETE CASCADE;

ALTER TABLE crew_member_skills
    ADD CONSTRAINT fk_crew_member_skills_skill_id
    FOREIGN KEY (skill_id)
    REFERENCES crew_skills (skill_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_job_required_skills
    ADD CONSTRAINT fk_maintenance_job_required_skills_job_id
    FOREIGN KEY (job_id)
    REFERENCES maintenance_jobs (job_id)
    ON DELETE CASCADE;

ALTER TABLE maintenance_job_required_skills
    ADD CONSTRAINT fk_maintenance_job_required_skills_skill_id
    FOREIGN KEY (skill_id)
    REFERENCES crew_skills (skill_id)
    ON DELETE CASCADE;

ALTER TABLE simulation_runs
    ADD CONSTRAINT fk_simulation_runs_based_on_request_id
    FOREIGN KEY (based_on_request_id)
    REFERENCES block_requests (request_id)
    ON DELETE SET NULL;

ALTER TABLE simulation_runs
    ADD CONSTRAINT fk_simulation_runs_scenario_type_id
    FOREIGN KEY (scenario_type_id)
    REFERENCES simulation_scenario_types (scenario_type_id)
    ON DELETE SET NULL;

ALTER TABLE simulation_runs
    ADD CONSTRAINT fk_simulation_runs_run_by
    FOREIGN KEY (run_by)
    REFERENCES users (user_id)
    ON DELETE RESTRICT;

ALTER TABLE simulation_parameters
    ADD CONSTRAINT fk_simulation_parameters_simulation_id
    FOREIGN KEY (simulation_id)
    REFERENCES simulation_runs (simulation_id)
    ON DELETE CASCADE;

ALTER TABLE simulation_results
    ADD CONSTRAINT fk_simulation_results_simulation_id
    FOREIGN KEY (simulation_id)
    REFERENCES simulation_runs (simulation_id)
    ON DELETE CASCADE;

ALTER TABLE simulation_candidate_blocks
    ADD CONSTRAINT fk_simulation_candidate_blocks_simulation_id
    FOREIGN KEY (simulation_id)
    REFERENCES simulation_runs (simulation_id)
    ON DELETE CASCADE;

ALTER TABLE simulation_candidate_blocks
    ADD CONSTRAINT fk_simulation_candidate_blocks_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE SET NULL;

ALTER TABLE simulation_train_impacts
    ADD CONSTRAINT fk_simulation_train_impacts_simulation_id
    FOREIGN KEY (simulation_id)
    REFERENCES simulation_runs (simulation_id)
    ON DELETE CASCADE;

ALTER TABLE simulation_train_impacts
    ADD CONSTRAINT fk_simulation_train_impacts_train_id
    FOREIGN KEY (train_id)
    REFERENCES trains (train_id)
    ON DELETE CASCADE;

ALTER TABLE simulation_resource_impacts
    ADD CONSTRAINT fk_simulation_resource_impacts_simulation_id
    FOREIGN KEY (simulation_id)
    REFERENCES simulation_runs (simulation_id)
    ON DELETE CASCADE;

ALTER TABLE simulation_resource_impacts
    ADD CONSTRAINT fk_simulation_resource_impacts_resource_id
    FOREIGN KEY (resource_id)
    REFERENCES resources (resource_id)
    ON DELETE CASCADE;

ALTER TABLE simulation_comparison
    ADD CONSTRAINT fk_simulation_comparison_simulation_id
    FOREIGN KEY (simulation_id)
    REFERENCES simulation_runs (simulation_id)
    ON DELETE CASCADE;

ALTER TABLE simulation_comparison
    ADD CONSTRAINT fk_simulation_comparison_compared_to_simulation_id
    FOREIGN KEY (compared_to_simulation_id)
    REFERENCES simulation_runs (simulation_id)
    ON DELETE SET NULL;

ALTER TABLE safety_requirements
    ADD CONSTRAINT fk_safety_requirements_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE safety_requirements
    ADD CONSTRAINT fk_safety_requirements_section_id
    FOREIGN KEY (section_id)
    REFERENCES sections (section_id)
    ON DELETE SET NULL;

ALTER TABLE safety_requirements
    ADD CONSTRAINT fk_safety_requirements_track_id
    FOREIGN KEY (track_id)
    REFERENCES tracks (track_id)
    ON DELETE SET NULL;

ALTER TABLE safety_requirements
    ADD CONSTRAINT fk_safety_requirements_verified_by
    FOREIGN KEY (verified_by)
    REFERENCES users (user_id)
    ON DELETE SET NULL;

ALTER TABLE safety_isolations
    ADD CONSTRAINT fk_safety_isolations_block_id
    FOREIGN KEY (block_id)
    REFERENCES planned_blocks (block_id)
    ON DELETE CASCADE;

ALTER TABLE safety_isolations
    ADD CONSTRAINT fk_safety_isolations_asset_id
    FOREIGN KEY (asset_id)
    REFERENCES assets (asset_id)
    ON DELETE CASCADE;

ALTER TABLE safety_isolations
    ADD CONSTRAINT fk_safety_isolations_verified_by
    FOREIGN KEY (verified_by)
    REFERENCES users (user_id)
    ON DELETE SET NULL;


-- Verification: number of FK constraints added by this migration

SELECT COUNT(*) AS abps_fk_constraint_count
FROM pg_constraint c
WHERE c.contype = 'f'
  AND c.conname LIKE 'fk_%';


