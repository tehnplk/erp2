--
-- PostgreSQL database dump
--

\restrict UKUSySYV0gZXiBl7YMlmeqllmYyrcgchbxA1TAPeCFgJnta0CWGlqsBdsbGDfeY

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP EVENT TRIGGER IF EXISTS pgrst_drop_watch;
DROP EVENT TRIGGER IF EXISTS pgrst_ddl_watch;
DROP EVENT TRIGGER IF EXISTS issue_pg_net_access;
DROP EVENT TRIGGER IF EXISTS issue_pg_graphql_access;
DROP EVENT TRIGGER IF EXISTS issue_pg_cron_access;
DROP EVENT TRIGGER IF EXISTS issue_graphql_placeholder;
DROP PUBLICATION IF EXISTS supabase_realtime;
ALTER TABLE IF EXISTS ONLY storage.vector_indexes DROP CONSTRAINT IF EXISTS vector_indexes_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_upload_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS "objects_bucketId_fkey";
ALTER TABLE IF EXISTS ONLY storage.iceberg_tables DROP CONSTRAINT IF EXISTS iceberg_tables_namespace_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.iceberg_tables DROP CONSTRAINT IF EXISTS iceberg_tables_catalog_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.iceberg_namespaces DROP CONSTRAINT IF EXISTS iceberg_namespaces_catalog_id_fkey;
ALTER TABLE IF EXISTS ONLY public.purchase_approval DROP CONSTRAINT IF EXISTS purchase_approval_status_fkey;
ALTER TABLE IF EXISTS ONLY public.purchase_approval_inventory_link DROP CONSTRAINT IF EXISTS purchase_approval_inventory_link_purchase_approval_detail_id_fk;
ALTER TABLE IF EXISTS ONLY public.purchase_approval_inventory_link DROP CONSTRAINT IF EXISTS purchase_approval_inventory_link_last_receipt_id_fkey;
ALTER TABLE IF EXISTS ONLY public.purchase_approval_detail DROP CONSTRAINT IF EXISTS purchase_approval_detail_purchase_approval_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_requisition_item DROP CONSTRAINT IF EXISTS "InventoryRequisitionItem_requisitionId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_requisition_item DROP CONSTRAINT IF EXISTS "InventoryRequisitionItem_inventoryItemId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_receipt_item DROP CONSTRAINT IF EXISTS "InventoryReceiptItem_receiptId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_receipt_item DROP CONSTRAINT IF EXISTS "InventoryReceiptItem_inventoryItemId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_period_balance DROP CONSTRAINT IF EXISTS "InventoryPeriodBalance_periodId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_period_balance DROP CONSTRAINT IF EXISTS "InventoryPeriodBalance_inventoryItemId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_movement DROP CONSTRAINT IF EXISTS "InventoryMovement_inventoryItemId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_location DROP CONSTRAINT IF EXISTS "InventoryLocation_warehouseId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_item DROP CONSTRAINT IF EXISTS "InventoryItem_warehouseId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_item DROP CONSTRAINT IF EXISTS "InventoryItem_locationId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_issue DROP CONSTRAINT IF EXISTS "InventoryIssue_requisitionId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_issue_item DROP CONSTRAINT IF EXISTS "InventoryIssueItem_requisitionItemId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_issue_item DROP CONSTRAINT IF EXISTS "InventoryIssueItem_issueId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_issue_item DROP CONSTRAINT IF EXISTS "InventoryIssueItem_inventoryItemId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_balance DROP CONSTRAINT IF EXISTS "InventoryBalance_inventoryItemId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_adjustment_item DROP CONSTRAINT IF EXISTS "InventoryAdjustmentItem_inventoryItemId_fkey";
ALTER TABLE IF EXISTS ONLY public.inventory_adjustment_item DROP CONSTRAINT IF EXISTS "InventoryAdjustmentItem_adjustmentId_fkey";
ALTER TABLE IF EXISTS ONLY auth.sso_domains DROP CONSTRAINT IF EXISTS sso_domains_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_oauth_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_flow_state_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_session_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.one_time_tokens DROP CONSTRAINT IF EXISTS one_time_tokens_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_challenges DROP CONSTRAINT IF EXISTS mfa_challenges_auth_factor_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS mfa_amr_claims_session_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_user_id_fkey;
ALTER TABLE IF EXISTS ONLY _realtime.extensions DROP CONSTRAINT IF EXISTS extensions_tenant_external_id_fkey;
DROP TRIGGER IF EXISTS update_objects_updated_at ON storage.objects;
DROP TRIGGER IF EXISTS protect_objects_delete ON storage.objects;
DROP TRIGGER IF EXISTS protect_buckets_delete ON storage.buckets;
DROP TRIGGER IF EXISTS enforce_bucket_name_length_trigger ON storage.buckets;
DROP TRIGGER IF EXISTS tr_check_filters ON realtime.subscription;
DROP TRIGGER IF EXISTS trg_purchase_approval_budget_year ON public.purchase_approval;
DROP TRIGGER IF EXISTS purchase_approval_updated_at ON public.purchase_approval;
DROP TRIGGER IF EXISTS purchase_approval_detail_updated_at ON public.purchase_approval_detail;
DROP INDEX IF EXISTS supabase_functions.supabase_functions_hooks_request_id_idx;
DROP INDEX IF EXISTS supabase_functions.supabase_functions_hooks_h_table_id_h_name_idx;
DROP INDEX IF EXISTS storage.vector_indexes_name_bucket_id_idx;
DROP INDEX IF EXISTS storage.name_prefix_search;
DROP INDEX IF EXISTS storage.idx_objects_bucket_id_name_lower;
DROP INDEX IF EXISTS storage.idx_objects_bucket_id_name;
DROP INDEX IF EXISTS storage.idx_multipart_uploads_list;
DROP INDEX IF EXISTS storage.idx_iceberg_tables_namespace_id;
DROP INDEX IF EXISTS storage.idx_iceberg_tables_location;
DROP INDEX IF EXISTS storage.idx_iceberg_namespaces_bucket_id;
DROP INDEX IF EXISTS storage.buckets_analytics_unique_name_idx;
DROP INDEX IF EXISTS storage.bucketid_objname;
DROP INDEX IF EXISTS storage.bname;
DROP INDEX IF EXISTS realtime.subscription_subscription_id_entity_filters_action_filter_key;
DROP INDEX IF EXISTS realtime.messages_inserted_at_topic_index;
DROP INDEX IF EXISTS realtime.ix_realtime_subscription_entity;
DROP INDEX IF EXISTS public.inventory_movement_item_date_idx;
DROP INDEX IF EXISTS public.inventory_item_unique_product_wh_location_lot;
DROP INDEX IF EXISTS public.idx_purchase_approval_status;
DROP INDEX IF EXISTS public.idx_purchase_approval_seller_id;
DROP INDEX IF EXISTS public.idx_purchase_approval_is_inspection;
DROP INDEX IF EXISTS public.idx_purchase_approval_inventory_link_detail_unique;
DROP INDEX IF EXISTS public.idx_purchase_approval_inventory_link_detail_id;
DROP INDEX IF EXISTS public.idx_purchase_approval_doc_no;
DROP INDEX IF EXISTS public.idx_purchase_approval_doc_date;
DROP INDEX IF EXISTS public.idx_purchase_approval_detail_status;
DROP INDEX IF EXISTS public.idx_purchase_approval_detail_purchase_plan_id;
DROP INDEX IF EXISTS public.idx_purchase_approval_detail_purchase_approval_id;
DROP INDEX IF EXISTS public.idx_purchase_approval_detail_proposed_quantity;
DROP INDEX IF EXISTS public.idx_purchase_approval_detail_proposed_amount;
DROP INDEX IF EXISTS public.idx_purchase_approval_budget_year;
DROP INDEX IF EXISTS public.idx_purchase_approval_approve_code;
DROP INDEX IF EXISTS public.idx_product_purchase_department_id;
DROP INDEX IF EXISTS public.idx_approval_doc_status_status;
DROP INDEX IF EXISTS public.idx_approval_doc_status_code;
DROP INDEX IF EXISTS public."Seller_code_key";
DROP INDEX IF EXISTS public."Product_code_key";
DROP INDEX IF EXISTS auth.users_is_anonymous_idx;
DROP INDEX IF EXISTS auth.users_instance_id_idx;
DROP INDEX IF EXISTS auth.users_instance_id_email_idx;
DROP INDEX IF EXISTS auth.users_email_partial_key;
DROP INDEX IF EXISTS auth.user_id_created_at_idx;
DROP INDEX IF EXISTS auth.unique_phone_factor_per_user;
DROP INDEX IF EXISTS auth.sso_providers_resource_id_pattern_idx;
DROP INDEX IF EXISTS auth.sso_providers_resource_id_idx;
DROP INDEX IF EXISTS auth.sso_domains_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.sso_domains_domain_idx;
DROP INDEX IF EXISTS auth.sessions_user_id_idx;
DROP INDEX IF EXISTS auth.sessions_oauth_client_id_idx;
DROP INDEX IF EXISTS auth.sessions_not_after_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_for_email_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_created_at_idx;
DROP INDEX IF EXISTS auth.saml_providers_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_updated_at_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_session_id_revoked_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_parent_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_instance_id_user_id_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_instance_id_idx;
DROP INDEX IF EXISTS auth.recovery_token_idx;
DROP INDEX IF EXISTS auth.reauthentication_token_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_user_id_token_type_key;
DROP INDEX IF EXISTS auth.one_time_tokens_token_hash_hash_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_relates_to_hash_idx;
DROP INDEX IF EXISTS auth.oauth_consents_user_order_idx;
DROP INDEX IF EXISTS auth.oauth_consents_active_user_client_idx;
DROP INDEX IF EXISTS auth.oauth_consents_active_client_idx;
DROP INDEX IF EXISTS auth.oauth_clients_deleted_at_idx;
DROP INDEX IF EXISTS auth.oauth_auth_pending_exp_idx;
DROP INDEX IF EXISTS auth.mfa_factors_user_id_idx;
DROP INDEX IF EXISTS auth.mfa_factors_user_friendly_name_unique;
DROP INDEX IF EXISTS auth.mfa_challenge_created_at_idx;
DROP INDEX IF EXISTS auth.idx_user_id_auth_method;
DROP INDEX IF EXISTS auth.idx_oauth_client_states_created_at;
DROP INDEX IF EXISTS auth.idx_auth_code;
DROP INDEX IF EXISTS auth.identities_user_id_idx;
DROP INDEX IF EXISTS auth.identities_email_idx;
DROP INDEX IF EXISTS auth.flow_state_created_at_idx;
DROP INDEX IF EXISTS auth.factor_id_created_at_idx;
DROP INDEX IF EXISTS auth.email_change_token_new_idx;
DROP INDEX IF EXISTS auth.email_change_token_current_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_provider_type_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_identifier_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_enabled_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_created_at_idx;
DROP INDEX IF EXISTS auth.confirmation_token_idx;
DROP INDEX IF EXISTS auth.audit_logs_instance_id_idx;
DROP INDEX IF EXISTS _realtime.tenants_external_id_index;
DROP INDEX IF EXISTS _realtime.extensions_tenant_external_id_type_index;
DROP INDEX IF EXISTS _realtime.extensions_tenant_external_id_index;
ALTER TABLE IF EXISTS ONLY supabase_functions.migrations DROP CONSTRAINT IF EXISTS migrations_pkey;
ALTER TABLE IF EXISTS ONLY supabase_functions.hooks DROP CONSTRAINT IF EXISTS hooks_pkey;
ALTER TABLE IF EXISTS ONLY storage.vector_indexes DROP CONSTRAINT IF EXISTS vector_indexes_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_pkey;
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS objects_pkey;
ALTER TABLE IF EXISTS ONLY storage.migrations DROP CONSTRAINT IF EXISTS migrations_pkey;
ALTER TABLE IF EXISTS ONLY storage.migrations DROP CONSTRAINT IF EXISTS migrations_name_key;
ALTER TABLE IF EXISTS ONLY storage.iceberg_tables DROP CONSTRAINT IF EXISTS iceberg_tables_pkey;
ALTER TABLE IF EXISTS ONLY storage.iceberg_namespaces DROP CONSTRAINT IF EXISTS iceberg_namespaces_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets_vectors DROP CONSTRAINT IF EXISTS buckets_vectors_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets DROP CONSTRAINT IF EXISTS buckets_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets_analytics DROP CONSTRAINT IF EXISTS buckets_analytics_pkey;
ALTER TABLE IF EXISTS ONLY realtime.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY realtime.subscription DROP CONSTRAINT IF EXISTS pk_subscription;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_03_30 DROP CONSTRAINT IF EXISTS messages_2026_03_30_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_03_29 DROP CONSTRAINT IF EXISTS messages_2026_03_29_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_03_28 DROP CONSTRAINT IF EXISTS messages_2026_03_28_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_03_27 DROP CONSTRAINT IF EXISTS messages_2026_03_27_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_03_26 DROP CONSTRAINT IF EXISTS messages_2026_03_26_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_03_25 DROP CONSTRAINT IF EXISTS messages_2026_03_25_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_03_24 DROP CONSTRAINT IF EXISTS messages_2026_03_24_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages DROP CONSTRAINT IF EXISTS messages_pkey;
ALTER TABLE IF EXISTS ONLY public.test_data DROP CONSTRAINT IF EXISTS test_data_pkey;
ALTER TABLE IF EXISTS ONLY public.purchase_plan DROP CONSTRAINT IF EXISTS purchase_plan_pkey;
ALTER TABLE IF EXISTS ONLY public.purchase_approval DROP CONSTRAINT IF EXISTS purchase_approval_pkey;
ALTER TABLE IF EXISTS ONLY public.purchase_approval_detail DROP CONSTRAINT IF EXISTS purchase_approval_detail_unique_plan_per_approval;
ALTER TABLE IF EXISTS ONLY public.purchase_approval_detail DROP CONSTRAINT IF EXISTS purchase_approval_detail_pkey;
ALTER TABLE IF EXISTS ONLY public.purchase_approval DROP CONSTRAINT IF EXISTS purchase_approval_approve_code_key;
ALTER TABLE IF EXISTS ONLY public.inventory_period DROP CONSTRAINT IF EXISTS inventory_period_unique_period;
ALTER TABLE IF EXISTS ONLY public.inventory_period_balance DROP CONSTRAINT IF EXISTS inventory_period_balance_unique_item_per_period;
ALTER TABLE IF EXISTS ONLY public.inventory_location DROP CONSTRAINT IF EXISTS inventory_location_warehouse_id_location_code_key;
ALTER TABLE IF EXISTS ONLY public.department DROP CONSTRAINT IF EXISTS department_department_code_key;
ALTER TABLE IF EXISTS ONLY public.approval_doc_status DROP CONSTRAINT IF EXISTS approval_doc_status_status_key;
ALTER TABLE IF EXISTS ONLY public.approval_doc_status DROP CONSTRAINT IF EXISTS approval_doc_status_pkey;
ALTER TABLE IF EXISTS ONLY public.approval_doc_status DROP CONSTRAINT IF EXISTS approval_doc_status_code_key;
ALTER TABLE IF EXISTS ONLY public.usage_plan DROP CONSTRAINT IF EXISTS "Survey_pkey";
ALTER TABLE IF EXISTS ONLY public.seller DROP CONSTRAINT IF EXISTS "Seller_pkey";
ALTER TABLE IF EXISTS ONLY public.purchase_approval_inventory_link DROP CONSTRAINT IF EXISTS "PurchaseApprovalInventoryLink_pkey";
ALTER TABLE IF EXISTS ONLY public.product DROP CONSTRAINT IF EXISTS "Product_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_warehouse DROP CONSTRAINT IF EXISTS "InventoryWarehouse_warehouseCode_key";
ALTER TABLE IF EXISTS ONLY public.inventory_warehouse DROP CONSTRAINT IF EXISTS "InventoryWarehouse_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_requisition DROP CONSTRAINT IF EXISTS "InventoryRequisition_requisitionNo_key";
ALTER TABLE IF EXISTS ONLY public.inventory_requisition DROP CONSTRAINT IF EXISTS "InventoryRequisition_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_requisition_item DROP CONSTRAINT IF EXISTS "InventoryRequisitionItem_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_receipt DROP CONSTRAINT IF EXISTS "InventoryReceipt_receiptNo_key";
ALTER TABLE IF EXISTS ONLY public.inventory_receipt DROP CONSTRAINT IF EXISTS "InventoryReceipt_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_receipt_item DROP CONSTRAINT IF EXISTS "InventoryReceiptItem_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_period DROP CONSTRAINT IF EXISTS "InventoryPeriod_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_period_balance DROP CONSTRAINT IF EXISTS "InventoryPeriodBalance_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_movement DROP CONSTRAINT IF EXISTS "InventoryMovement_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_location DROP CONSTRAINT IF EXISTS "InventoryLocation_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_item DROP CONSTRAINT IF EXISTS "InventoryItem_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_issue DROP CONSTRAINT IF EXISTS "InventoryIssue_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_issue DROP CONSTRAINT IF EXISTS "InventoryIssue_issueNo_key";
ALTER TABLE IF EXISTS ONLY public.inventory_issue_item DROP CONSTRAINT IF EXISTS "InventoryIssueItem_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_balance DROP CONSTRAINT IF EXISTS "InventoryBalance_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_balance DROP CONSTRAINT IF EXISTS "InventoryBalance_inventoryItemId_key";
ALTER TABLE IF EXISTS ONLY public.inventory_adjustment DROP CONSTRAINT IF EXISTS "InventoryAdjustment_pkey";
ALTER TABLE IF EXISTS ONLY public.inventory_adjustment DROP CONSTRAINT IF EXISTS "InventoryAdjustment_adjustmentNo_key";
ALTER TABLE IF EXISTS ONLY public.inventory_adjustment_item DROP CONSTRAINT IF EXISTS "InventoryAdjustmentItem_pkey";
ALTER TABLE IF EXISTS ONLY public.department DROP CONSTRAINT IF EXISTS "Department_pkey";
ALTER TABLE IF EXISTS ONLY public.category DROP CONSTRAINT IF EXISTS "Category_pkey";
ALTER TABLE IF EXISTS ONLY auth.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY auth.users DROP CONSTRAINT IF EXISTS users_phone_key;
ALTER TABLE IF EXISTS ONLY auth.sso_providers DROP CONSTRAINT IF EXISTS sso_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.sso_domains DROP CONSTRAINT IF EXISTS sso_domains_pkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE IF EXISTS ONLY auth.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_entity_id_key;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_token_unique;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.one_time_tokens DROP CONSTRAINT IF EXISTS one_time_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_user_client_unique;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_clients DROP CONSTRAINT IF EXISTS oauth_clients_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_client_states DROP CONSTRAINT IF EXISTS oauth_client_states_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_authorization_id_key;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_authorization_code_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_last_challenged_at_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_challenges DROP CONSTRAINT IF EXISTS mfa_challenges_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS mfa_amr_claims_session_id_authentication_method_pkey;
ALTER TABLE IF EXISTS ONLY auth.instances DROP CONSTRAINT IF EXISTS instances_pkey;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_provider_id_provider_unique;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_pkey;
ALTER TABLE IF EXISTS ONLY auth.flow_state DROP CONSTRAINT IF EXISTS flow_state_pkey;
ALTER TABLE IF EXISTS ONLY auth.custom_oauth_providers DROP CONSTRAINT IF EXISTS custom_oauth_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.custom_oauth_providers DROP CONSTRAINT IF EXISTS custom_oauth_providers_identifier_key;
ALTER TABLE IF EXISTS ONLY auth.audit_log_entries DROP CONSTRAINT IF EXISTS audit_log_entries_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS amr_id_pk;
ALTER TABLE IF EXISTS ONLY _realtime.tenants DROP CONSTRAINT IF EXISTS tenants_pkey;
ALTER TABLE IF EXISTS ONLY _realtime.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY _realtime.extensions DROP CONSTRAINT IF EXISTS extensions_pkey;
ALTER TABLE IF EXISTS supabase_functions.hooks ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.usage_plan ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.test_data ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.seller ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.purchase_plan ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.purchase_approval_inventory_link ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.purchase_approval_detail ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.purchase_approval ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.product ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_warehouse ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_requisition_item ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_requisition ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_receipt_item ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_receipt ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_period_balance ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_period ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_movement ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_location ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_item ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_issue_item ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_issue ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_balance ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_adjustment_item ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_adjustment ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.department ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.category ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.approval_doc_status ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS auth.refresh_tokens ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS supabase_functions.migrations;
DROP SEQUENCE IF EXISTS supabase_functions.hooks_id_seq;
DROP TABLE IF EXISTS supabase_functions.hooks;
DROP TABLE IF EXISTS storage.vector_indexes;
DROP TABLE IF EXISTS storage.s3_multipart_uploads_parts;
DROP TABLE IF EXISTS storage.s3_multipart_uploads;
DROP TABLE IF EXISTS storage.objects;
DROP TABLE IF EXISTS storage.migrations;
DROP TABLE IF EXISTS storage.iceberg_tables;
DROP TABLE IF EXISTS storage.iceberg_namespaces;
DROP TABLE IF EXISTS storage.buckets_vectors;
DROP TABLE IF EXISTS storage.buckets_analytics;
DROP TABLE IF EXISTS storage.buckets;
DROP TABLE IF EXISTS realtime.subscription;
DROP TABLE IF EXISTS realtime.schema_migrations;
DROP TABLE IF EXISTS realtime.messages_2026_03_30;
DROP TABLE IF EXISTS realtime.messages_2026_03_29;
DROP TABLE IF EXISTS realtime.messages_2026_03_28;
DROP TABLE IF EXISTS realtime.messages_2026_03_27;
DROP TABLE IF EXISTS realtime.messages_2026_03_26;
DROP TABLE IF EXISTS realtime.messages_2026_03_25;
DROP TABLE IF EXISTS realtime.messages_2026_03_24;
DROP TABLE IF EXISTS realtime.messages;
DROP SEQUENCE IF EXISTS public.test_data_id_seq;
DROP TABLE IF EXISTS public.test_data;
DROP SEQUENCE IF EXISTS public.purchase_plan_id_seq;
DROP TABLE IF EXISTS public.purchase_plan;
DROP TABLE IF EXISTS public.purchase_approval_inventory_link_backup;
DROP SEQUENCE IF EXISTS public.purchase_approval_id_seq;
DROP SEQUENCE IF EXISTS public.purchase_approval_detail_id_seq;
DROP TABLE IF EXISTS public.purchase_approval_detail;
DROP TABLE IF EXISTS public.purchase_approval_backup;
DROP SEQUENCE IF EXISTS public.purchase_approval_approval_id_seq;
DROP TABLE IF EXISTS public.purchase_approval;
DROP SEQUENCE IF EXISTS public.inventory_warehouse_id_seq;
DROP TABLE IF EXISTS public.inventory_warehouse;
DROP SEQUENCE IF EXISTS public.inventory_requisition_item_id_seq;
DROP TABLE IF EXISTS public.inventory_requisition_item;
DROP SEQUENCE IF EXISTS public.inventory_requisition_id_seq;
DROP TABLE IF EXISTS public.inventory_requisition;
DROP SEQUENCE IF EXISTS public.inventory_receipt_item_id_seq;
DROP TABLE IF EXISTS public.inventory_receipt_item;
DROP SEQUENCE IF EXISTS public.inventory_receipt_id_seq;
DROP TABLE IF EXISTS public.inventory_receipt;
DROP SEQUENCE IF EXISTS public.inventory_period_id_seq;
DROP SEQUENCE IF EXISTS public.inventory_period_balance_id_seq;
DROP TABLE IF EXISTS public.inventory_period_balance;
DROP TABLE IF EXISTS public.inventory_period;
DROP SEQUENCE IF EXISTS public.inventory_movement_id_seq;
DROP TABLE IF EXISTS public.inventory_movement;
DROP SEQUENCE IF EXISTS public.inventory_location_id_seq;
DROP TABLE IF EXISTS public.inventory_location;
DROP SEQUENCE IF EXISTS public.inventory_item_id_seq;
DROP TABLE IF EXISTS public.inventory_item;
DROP SEQUENCE IF EXISTS public.inventory_issue_item_id_seq;
DROP TABLE IF EXISTS public.inventory_issue_item;
DROP SEQUENCE IF EXISTS public.inventory_issue_id_seq;
DROP TABLE IF EXISTS public.inventory_issue;
DROP SEQUENCE IF EXISTS public.inventory_balance_id_seq;
DROP TABLE IF EXISTS public.inventory_balance;
DROP SEQUENCE IF EXISTS public.inventory_adjustment_item_id_seq;
DROP TABLE IF EXISTS public.inventory_adjustment_item;
DROP SEQUENCE IF EXISTS public.inventory_adjustment_id_seq;
DROP TABLE IF EXISTS public.inventory_adjustment;
DROP SEQUENCE IF EXISTS public.approval_doc_status_id_seq;
DROP TABLE IF EXISTS public.approval_doc_status;
DROP SEQUENCE IF EXISTS public."Survey_id_seq";
DROP TABLE IF EXISTS public.usage_plan;
DROP SEQUENCE IF EXISTS public."Seller_id_seq";
DROP TABLE IF EXISTS public.seller;
DROP SEQUENCE IF EXISTS public."PurchaseApprovalInventoryLink_id_seq";
DROP TABLE IF EXISTS public.purchase_approval_inventory_link;
DROP SEQUENCE IF EXISTS public."Product_id_seq";
DROP TABLE IF EXISTS public.product;
DROP SEQUENCE IF EXISTS public."Department_id_seq";
DROP TABLE IF EXISTS public.department;
DROP SEQUENCE IF EXISTS public."Category_id_seq";
DROP TABLE IF EXISTS public.category;
DROP TABLE IF EXISTS auth.users;
DROP TABLE IF EXISTS auth.sso_providers;
DROP TABLE IF EXISTS auth.sso_domains;
DROP TABLE IF EXISTS auth.sessions;
DROP TABLE IF EXISTS auth.schema_migrations;
DROP TABLE IF EXISTS auth.saml_relay_states;
DROP TABLE IF EXISTS auth.saml_providers;
DROP SEQUENCE IF EXISTS auth.refresh_tokens_id_seq;
DROP TABLE IF EXISTS auth.refresh_tokens;
DROP TABLE IF EXISTS auth.one_time_tokens;
DROP TABLE IF EXISTS auth.oauth_consents;
DROP TABLE IF EXISTS auth.oauth_clients;
DROP TABLE IF EXISTS auth.oauth_client_states;
DROP TABLE IF EXISTS auth.oauth_authorizations;
DROP TABLE IF EXISTS auth.mfa_factors;
DROP TABLE IF EXISTS auth.mfa_challenges;
DROP TABLE IF EXISTS auth.mfa_amr_claims;
DROP TABLE IF EXISTS auth.instances;
DROP TABLE IF EXISTS auth.identities;
DROP TABLE IF EXISTS auth.flow_state;
DROP TABLE IF EXISTS auth.custom_oauth_providers;
DROP TABLE IF EXISTS auth.audit_log_entries;
DROP TABLE IF EXISTS _realtime.tenants;
DROP TABLE IF EXISTS _realtime.schema_migrations;
DROP TABLE IF EXISTS _realtime.extensions;
DROP FUNCTION IF EXISTS supabase_functions.http_request();
DROP FUNCTION IF EXISTS storage.update_updated_at_column();
DROP FUNCTION IF EXISTS storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text);
DROP FUNCTION IF EXISTS storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text);
DROP FUNCTION IF EXISTS storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text);
DROP FUNCTION IF EXISTS storage.protect_delete();
DROP FUNCTION IF EXISTS storage.operation();
DROP FUNCTION IF EXISTS storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text);
DROP FUNCTION IF EXISTS storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text);
DROP FUNCTION IF EXISTS storage.get_size_by_bucket();
DROP FUNCTION IF EXISTS storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text);
DROP FUNCTION IF EXISTS storage.foldername(name text);
DROP FUNCTION IF EXISTS storage.filename(name text);
DROP FUNCTION IF EXISTS storage.extension(name text);
DROP FUNCTION IF EXISTS storage.enforce_bucket_name_length();
DROP FUNCTION IF EXISTS storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb);
DROP FUNCTION IF EXISTS realtime.topic();
DROP FUNCTION IF EXISTS realtime.to_regrole(role_name text);
DROP FUNCTION IF EXISTS realtime.subscription_check_filters();
DROP FUNCTION IF EXISTS realtime.send(payload jsonb, event text, topic text, private boolean);
DROP FUNCTION IF EXISTS realtime.quote_wal2json(entity regclass);
DROP FUNCTION IF EXISTS realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer);
DROP FUNCTION IF EXISTS realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]);
DROP FUNCTION IF EXISTS realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text);
DROP FUNCTION IF EXISTS realtime."cast"(val text, type_ regtype);
DROP FUNCTION IF EXISTS realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]);
DROP FUNCTION IF EXISTS realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text);
DROP FUNCTION IF EXISTS realtime.apply_rls(wal jsonb, max_record_bytes integer);
DROP FUNCTION IF EXISTS public.update_updated_at_column();
DROP FUNCTION IF EXISTS public.update_purchase_approval_updated_at();
DROP FUNCTION IF EXISTS public.update_purchase_approval_detail_updated_at();
DROP FUNCTION IF EXISTS public.set_purchase_approval_budget_year();
DROP FUNCTION IF EXISTS pgbouncer.get_auth(p_usename text);
DROP FUNCTION IF EXISTS extensions.set_graphql_placeholder();
DROP FUNCTION IF EXISTS extensions.pgrst_drop_watch();
DROP FUNCTION IF EXISTS extensions.pgrst_ddl_watch();
DROP FUNCTION IF EXISTS extensions.grant_pg_net_access();
DROP FUNCTION IF EXISTS extensions.grant_pg_graphql_access();
DROP FUNCTION IF EXISTS extensions.grant_pg_cron_access();
DROP FUNCTION IF EXISTS auth.uid();
DROP FUNCTION IF EXISTS auth.role();
DROP FUNCTION IF EXISTS auth.jwt();
DROP FUNCTION IF EXISTS auth.email();
DROP TYPE IF EXISTS storage.buckettype;
DROP TYPE IF EXISTS realtime.wal_rls;
DROP TYPE IF EXISTS realtime.wal_column;
DROP TYPE IF EXISTS realtime.user_defined_filter;
DROP TYPE IF EXISTS realtime.equality_op;
DROP TYPE IF EXISTS realtime.action;
DROP TYPE IF EXISTS auth.one_time_token_type;
DROP TYPE IF EXISTS auth.oauth_response_type;
DROP TYPE IF EXISTS auth.oauth_registration_type;
DROP TYPE IF EXISTS auth.oauth_client_type;
DROP TYPE IF EXISTS auth.oauth_authorization_status;
DROP TYPE IF EXISTS auth.factor_type;
DROP TYPE IF EXISTS auth.factor_status;
DROP TYPE IF EXISTS auth.code_challenge_method;
DROP TYPE IF EXISTS auth.aal_level;
DROP EXTENSION IF EXISTS "uuid-ossp";
DROP EXTENSION IF EXISTS supabase_vault;
DROP EXTENSION IF EXISTS pgcrypto;
DROP EXTENSION IF EXISTS pg_stat_statements;
DROP EXTENSION IF EXISTS pg_graphql;
DROP SCHEMA IF EXISTS vault;
DROP SCHEMA IF EXISTS supabase_functions;
DROP SCHEMA IF EXISTS storage;
DROP SCHEMA IF EXISTS realtime;
DROP SCHEMA IF EXISTS pgbouncer;
DROP EXTENSION IF EXISTS pg_net;
DROP SCHEMA IF EXISTS graphql_public;
DROP SCHEMA IF EXISTS graphql;
DROP SCHEMA IF EXISTS extensions;
DROP SCHEMA IF EXISTS auth;
DROP SCHEMA IF EXISTS _realtime;
--
-- Name: _realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA _realtime;


--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA supabase_functions;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


--
-- Name: set_purchase_approval_budget_year(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_purchase_approval_budget_year() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.doc_date IS NULL THEN
    NEW.budget_year := NULL;
  ELSIF EXTRACT(MONTH FROM NEW.doc_date) >= 10 THEN
    NEW.budget_year := EXTRACT(YEAR FROM NEW.doc_date)::int + 544;
  ELSE
    NEW.budget_year := EXTRACT(YEAR FROM NEW.doc_date)::int + 543;
  END IF;

  RETURN NEW;
END;
$$;


--
-- Name: update_purchase_approval_detail_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_purchase_approval_detail_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  NEW.version = OLD.version + 1;
  RETURN NEW;
END;
$$;


--
-- Name: update_purchase_approval_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_purchase_approval_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  NEW.version = OLD.version + 1;
  RETURN NEW;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: -
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
  DECLARE
    request_id bigint;
    payload jsonb;
    url text := TG_ARGV[0]::text;
    method text := TG_ARGV[1]::text;
    headers jsonb DEFAULT '{}'::jsonb;
    params jsonb DEFAULT '{}'::jsonb;
    timeout_ms integer DEFAULT 1000;
  BEGIN
    IF url IS NULL OR url = 'null' THEN
      RAISE EXCEPTION 'url argument is missing';
    END IF;

    IF method IS NULL OR method = 'null' THEN
      RAISE EXCEPTION 'method argument is missing';
    END IF;

    IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
      headers = '{"Content-Type": "application/json"}'::jsonb;
    ELSE
      headers = TG_ARGV[2]::jsonb;
    END IF;

    IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
      params = '{}'::jsonb;
    ELSE
      params = TG_ARGV[3]::jsonb;
    END IF;

    IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
      timeout_ms = 1000;
    ELSE
      timeout_ms = TG_ARGV[4]::integer;
    END IF;

    CASE
      WHEN method = 'GET' THEN
        SELECT http_get INTO request_id FROM net.http_get(
          url,
          params,
          headers,
          timeout_ms
        );
      WHEN method = 'POST' THEN
        payload = jsonb_build_object(
          'old_record', OLD,
          'record', NEW,
          'type', TG_OP,
          'table', TG_TABLE_NAME,
          'schema', TG_TABLE_SCHEMA
        );

        SELECT http_post INTO request_id FROM net.http_post(
          url,
          payload,
          params,
          headers,
          timeout_ms
        );
      ELSE
        RAISE EXCEPTION 'method argument % is invalid', method;
    END CASE;

    INSERT INTO supabase_functions.hooks
      (hook_table_id, hook_name, request_id)
    VALUES
      (TG_RELID, TG_NAME, request_id);

    RETURN NEW;
  END
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: extensions; Type: TABLE; Schema: _realtime; Owner: -
--

CREATE TABLE _realtime.extensions (
    id uuid NOT NULL,
    type text,
    settings jsonb,
    tenant_external_id text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: _realtime; Owner: -
--

CREATE TABLE _realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: tenants; Type: TABLE; Schema: _realtime; Owner: -
--

CREATE TABLE _realtime.tenants (
    id uuid NOT NULL,
    name text,
    external_id text,
    jwt_secret text,
    max_concurrent_users integer DEFAULT 200 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    max_events_per_second integer DEFAULT 100 NOT NULL,
    postgres_cdc_default text DEFAULT 'postgres_cdc_rls'::text,
    max_bytes_per_second integer DEFAULT 100000 NOT NULL,
    max_channels_per_client integer DEFAULT 100 NOT NULL,
    max_joins_per_second integer DEFAULT 500 NOT NULL,
    suspend boolean DEFAULT false,
    jwt_jwks jsonb,
    notify_private_alpha boolean DEFAULT false,
    private_only boolean DEFAULT false NOT NULL,
    migrations_ran integer DEFAULT 0,
    broadcast_adapter character varying(255) DEFAULT 'gen_rpc'::character varying,
    max_presence_events_per_second integer DEFAULT 1000,
    max_payload_size_in_kb integer DEFAULT 3000,
    max_client_presence_events_per_window integer,
    client_presence_window_ms integer,
    presence_enabled boolean DEFAULT false NOT NULL,
    CONSTRAINT jwt_secret_or_jwt_jwks_required CHECK (((jwt_secret IS NOT NULL) OR (jwt_jwks IS NOT NULL)))
);


--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category (
    id integer NOT NULL,
    category text NOT NULL,
    type text NOT NULL,
    subtype text,
    category_code text,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: Category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Category_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Category_id_seq" OWNED BY public.category.id;


--
-- Name: department; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.department (
    id integer NOT NULL,
    name text NOT NULL,
    department_code character varying(4),
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: Department_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Department_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Department_id_seq" OWNED BY public.department.id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product (
    id integer NOT NULL,
    code text NOT NULL,
    category text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    subtype text NOT NULL,
    unit text NOT NULL,
    cost_price numeric(10,2),
    sell_price numeric(10,2),
    stock_balance integer,
    stock_value numeric(10,2),
    seller_code text,
    image text,
    flag_activate boolean DEFAULT true NOT NULL,
    admin_note text,
    is_active boolean DEFAULT true NOT NULL,
    purchase_department_id integer
);


--
-- Name: Product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Product_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Product_id_seq" OWNED BY public.product.id;


--
-- Name: purchase_approval_inventory_link; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_approval_inventory_link (
    id integer NOT NULL,
    purchase_approval_id integer NOT NULL,
    inventory_receipt_status text DEFAULT 'PENDING'::text NOT NULL,
    received_qty integer DEFAULT 0 NOT NULL,
    last_receipt_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    purchase_approval_detail_id integer NOT NULL,
    CONSTRAINT "PurchaseApprovalInventoryLink_receivedQty_non_negative" CHECK ((received_qty >= 0))
);


--
-- Name: TABLE purchase_approval_inventory_link; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.purchase_approval_inventory_link IS 'Link table between purchase approval details and inventory receipts';


--
-- Name: COLUMN purchase_approval_inventory_link.purchase_approval_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.purchase_approval_inventory_link.purchase_approval_id IS 'Purchase approval header ID (legacy, kept for compatibility)';


--
-- Name: COLUMN purchase_approval_inventory_link.purchase_approval_detail_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.purchase_approval_inventory_link.purchase_approval_detail_id IS 'Purchase approval detail ID (primary reference)';


--
-- Name: PurchaseApprovalInventoryLink_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."PurchaseApprovalInventoryLink_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: PurchaseApprovalInventoryLink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."PurchaseApprovalInventoryLink_id_seq" OWNED BY public.purchase_approval_inventory_link.id;


--
-- Name: seller; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seller (
    id integer NOT NULL,
    code text NOT NULL,
    prefix text,
    name text NOT NULL,
    business text,
    address text,
    phone text,
    fax text,
    mobile text,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: Seller_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Seller_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Seller_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Seller_id_seq" OWNED BY public.seller.id;


--
-- Name: usage_plan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usage_plan (
    id integer NOT NULL,
    product_code text,
    requested_amount integer,
    approved_quota integer,
    budget_year integer DEFAULT 2569,
    sequence_no integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    requesting_dept_code character varying(4),
    purchase_plan_id integer,
    plan_flag character varying(20) DEFAULT 'ในแผน'::character varying NOT NULL,
    CONSTRAINT "Survey_sequence_no_check" CHECK ((sequence_no = ANY (ARRAY[1, 2])))
);


--
-- Name: Survey_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Survey_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Survey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Survey_id_seq" OWNED BY public.usage_plan.id;


--
-- Name: approval_doc_status; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approval_doc_status (
    id integer NOT NULL,
    code character varying(3) NOT NULL,
    status text NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: approval_doc_status_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_doc_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_doc_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_doc_status_id_seq OWNED BY public.approval_doc_status.id;


--
-- Name: inventory_adjustment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_adjustment (
    id integer NOT NULL,
    adjustment_no text NOT NULL,
    adjustment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    reason text NOT NULL,
    status text DEFAULT 'DRAFT'::text NOT NULL,
    created_by text,
    approved_by text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: inventory_adjustment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_adjustment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_adjustment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_adjustment_id_seq OWNED BY public.inventory_adjustment.id;


--
-- Name: inventory_adjustment_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_adjustment_item (
    id integer NOT NULL,
    adjustment_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    qty_diff integer NOT NULL,
    unit_cost numeric(18,2) DEFAULT 0 NOT NULL,
    note text
);


--
-- Name: inventory_adjustment_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_adjustment_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_adjustment_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_adjustment_item_id_seq OWNED BY public.inventory_adjustment_item.id;


--
-- Name: inventory_balance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_balance (
    id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    on_hand_qty integer DEFAULT 0 NOT NULL,
    reserved_qty integer DEFAULT 0 NOT NULL,
    available_qty integer DEFAULT 0 NOT NULL,
    avg_cost numeric(18,2) DEFAULT 0 NOT NULL,
    last_movement_at timestamp without time zone,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT inventory_balance_non_negative CHECK (((on_hand_qty >= 0) AND (reserved_qty >= 0) AND (available_qty >= 0)))
);


--
-- Name: inventory_balance_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_balance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_balance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_balance_id_seq OWNED BY public.inventory_balance.id;


--
-- Name: inventory_issue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_issue (
    id integer NOT NULL,
    issue_no text NOT NULL,
    issue_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    requisition_id integer NOT NULL,
    requesting_department text NOT NULL,
    status text DEFAULT 'POSTED'::text NOT NULL,
    issued_by text,
    approved_by text,
    note text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    requesting_department_code character varying(4)
);


--
-- Name: inventory_issue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_issue_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_issue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_issue_id_seq OWNED BY public.inventory_issue.id;


--
-- Name: inventory_issue_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_issue_item (
    id integer NOT NULL,
    issue_id integer NOT NULL,
    requisition_item_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    issued_qty integer NOT NULL,
    unit_cost numeric(18,2) DEFAULT 0 NOT NULL,
    total_cost numeric(18,2) DEFAULT 0 NOT NULL,
    CONSTRAINT inventory_issue_item_issued_qty_positive CHECK ((issued_qty > 0))
);


--
-- Name: inventory_issue_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_issue_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_issue_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_issue_item_id_seq OWNED BY public.inventory_issue_item.id;


--
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_item (
    id integer NOT NULL,
    product_code text NOT NULL,
    product_name text NOT NULL,
    category text,
    product_type text,
    product_subtype text,
    unit text,
    warehouse_id integer NOT NULL,
    location_id integer,
    lot_no text,
    expiry_date date,
    standard_cost numeric(18,2) DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: inventory_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_item_id_seq OWNED BY public.inventory_item.id;


--
-- Name: inventory_location; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_location (
    id integer NOT NULL,
    warehouse_id integer NOT NULL,
    location_code text NOT NULL,
    location_name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: inventory_location_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_location_id_seq OWNED BY public.inventory_location.id;


--
-- Name: inventory_movement; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_movement (
    id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    movement_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    movement_type text NOT NULL,
    qty_in integer DEFAULT 0 NOT NULL,
    qty_out integer DEFAULT 0 NOT NULL,
    unit_cost numeric(18,2) DEFAULT 0 NOT NULL,
    total_cost numeric(18,2) DEFAULT 0 NOT NULL,
    balance_qty_after integer DEFAULT 0 NOT NULL,
    balance_value_after numeric(18,2) DEFAULT 0 NOT NULL,
    reference_type text,
    reference_id integer,
    reference_no text,
    source_department text,
    target_department text,
    note text,
    created_by text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT inventory_movement_qty_valid CHECK (((qty_in >= 0) AND (qty_out >= 0)))
);


--
-- Name: inventory_movement_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_movement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_movement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_movement_id_seq OWNED BY public.inventory_movement.id;


--
-- Name: inventory_period; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_period (
    id integer NOT NULL,
    period_year integer NOT NULL,
    period_month integer NOT NULL,
    status text DEFAULT 'OPEN'::text NOT NULL,
    closed_at timestamp without time zone,
    closed_by text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT inventory_period_month_valid CHECK (((period_month >= 1) AND (period_month <= 12)))
);


--
-- Name: inventory_period_balance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_period_balance (
    id integer NOT NULL,
    period_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    opening_qty integer DEFAULT 0 NOT NULL,
    opening_value numeric(18,2) DEFAULT 0 NOT NULL,
    closing_qty integer DEFAULT 0 NOT NULL,
    closing_value numeric(18,2) DEFAULT 0 NOT NULL
);


--
-- Name: inventory_period_balance_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_period_balance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_period_balance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_period_balance_id_seq OWNED BY public.inventory_period_balance.id;


--
-- Name: inventory_period_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_period_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_period_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_period_id_seq OWNED BY public.inventory_period.id;


--
-- Name: inventory_receipt; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_receipt (
    id integer NOT NULL,
    receipt_no text NOT NULL,
    receipt_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    receipt_type text NOT NULL,
    status text DEFAULT 'POSTED'::text NOT NULL,
    vendor_name text,
    source_reference_type text,
    source_reference_id integer,
    source_reference_no text,
    note text,
    created_by text,
    approved_by text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: inventory_receipt_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_receipt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_receipt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_receipt_id_seq OWNED BY public.inventory_receipt.id;


--
-- Name: inventory_receipt_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_receipt_item (
    id integer NOT NULL,
    receipt_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    purchase_approval_id integer,
    qty integer NOT NULL,
    unit_cost numeric(18,2) DEFAULT 0 NOT NULL,
    total_cost numeric(18,2) DEFAULT 0 NOT NULL,
    lot_no text,
    expiry_date date,
    CONSTRAINT inventory_receipt_item_qty_positive CHECK ((qty > 0))
);


--
-- Name: inventory_receipt_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_receipt_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_receipt_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_receipt_item_id_seq OWNED BY public.inventory_receipt_item.id;


--
-- Name: inventory_requisition; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_requisition (
    id integer NOT NULL,
    requisition_no text NOT NULL,
    request_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    requesting_department text NOT NULL,
    status text DEFAULT 'DRAFT'::text NOT NULL,
    requested_by text,
    approved_by text,
    approved_at timestamp without time zone,
    issued_by text,
    issued_at timestamp without time zone,
    note text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    requesting_department_code character varying(4)
);


--
-- Name: inventory_requisition_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_requisition_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_requisition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_requisition_id_seq OWNED BY public.inventory_requisition.id;


--
-- Name: inventory_requisition_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_requisition_item (
    id integer NOT NULL,
    requisition_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    requested_qty integer NOT NULL,
    approved_qty integer DEFAULT 0 NOT NULL,
    issued_qty integer DEFAULT 0 NOT NULL,
    unit_cost_at_issue numeric(18,2) DEFAULT 0 NOT NULL,
    line_status text DEFAULT 'DRAFT'::text NOT NULL,
    note text,
    CONSTRAINT inventory_requisition_item_qty_valid CHECK (((requested_qty > 0) AND (approved_qty >= 0) AND (issued_qty >= 0)))
);


--
-- Name: inventory_requisition_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_requisition_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_requisition_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_requisition_item_id_seq OWNED BY public.inventory_requisition_item.id;


--
-- Name: inventory_warehouse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_warehouse (
    id integer NOT NULL,
    warehouse_code text NOT NULL,
    warehouse_name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: inventory_warehouse_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_warehouse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_warehouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_warehouse_id_seq OWNED BY public.inventory_warehouse.id;


--
-- Name: purchase_approval; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_approval (
    id integer NOT NULL,
    approve_code text NOT NULL,
    doc_no text DEFAULT 'พล. ๐๗๓๓.๓๐๑/พิเศษ'::text NOT NULL,
    doc_date date DEFAULT CURRENT_DATE NOT NULL,
    status character varying(3) DEFAULT '001'::character varying NOT NULL,
    total_amount numeric(15,2) DEFAULT 0,
    total_items integer DEFAULT 0,
    prepared_by text,
    approved_by text,
    approved_at timestamp without time zone,
    notes text,
    created_by text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    doc_seq integer,
    pending_note text,
    budget_year integer,
    seller_id integer,
    is_inspection boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE purchase_approval; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.purchase_approval IS 'Purchase approval header table with enhanced logging and status tracking';


--
-- Name: purchase_approval_approval_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.purchase_approval_approval_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: purchase_approval_backup; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_approval_backup (
    id integer,
    approval_id text,
    department text,
    record_number text,
    request_date text,
    product_name text,
    product_code text,
    category text,
    product_type text,
    product_subtype text,
    requested_quantity integer,
    unit text,
    price_per_unit numeric(10,2),
    total_value numeric(10,2),
    over_plan_case text,
    requester text,
    approver text,
    budget_year integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    department_code character varying(4)
);


--
-- Name: purchase_approval_detail; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_approval_detail (
    id integer NOT NULL,
    purchase_approval_id integer NOT NULL,
    purchase_plan_id integer NOT NULL,
    line_number integer NOT NULL,
    status text DEFAULT 'PENDING'::text NOT NULL,
    approved_quantity integer DEFAULT 0,
    approved_amount numeric(15,2) DEFAULT 0,
    remarks text,
    created_by text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    proposed_quantity integer,
    proposed_amount numeric(15,2),
    CONSTRAINT purchase_approval_detail_status_check CHECK ((status = ANY (ARRAY['PENDING'::text, 'APPROVED'::text, 'REJECTED'::text, 'MODIFIED'::text])))
);


--
-- Name: TABLE purchase_approval_detail; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.purchase_approval_detail IS 'Purchase approval detail table with 1:1 relationship to purchase_plan and enhanced logging';


--
-- Name: purchase_approval_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.purchase_approval_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: purchase_approval_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.purchase_approval_detail_id_seq OWNED BY public.purchase_approval_detail.id;


--
-- Name: purchase_approval_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.purchase_approval_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: purchase_approval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.purchase_approval_id_seq OWNED BY public.purchase_approval.id;


--
-- Name: purchase_approval_inventory_link_backup; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_approval_inventory_link_backup (
    id integer,
    purchase_approval_id integer,
    inventory_receipt_status text,
    received_qty integer,
    last_receipt_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: purchase_plan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_plan (
    id integer NOT NULL,
    inventory_qty integer DEFAULT 0,
    qouta_qty integer,
    purchase_qty integer DEFAULT 0
);


--
-- Name: purchase_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.purchase_plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: purchase_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.purchase_plan_id_seq OWNED BY public.purchase_plan.id;


--
-- Name: test_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test_data (
    id integer NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    sex text NOT NULL,
    birth date NOT NULL,
    age integer NOT NULL
);


--
-- Name: test_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.test_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: test_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.test_data_id_seq OWNED BY public.test_data.id;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- Name: messages_2026_03_24; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_24 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_25; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_25 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_26; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_26 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_27; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_27 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_28; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_28 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_29; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_29 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_30; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_30 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: iceberg_namespaces; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.iceberg_namespaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_name text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    catalog_id uuid NOT NULL
);


--
-- Name: iceberg_tables; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.iceberg_tables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    namespace_id uuid NOT NULL,
    bucket_name text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    location text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    remote_table_id text,
    shard_key text,
    shard_id text,
    catalog_id uuid NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: -
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: -
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: -
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: -
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: -
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: messages_2026_03_24; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_24 FOR VALUES FROM ('2026-03-24 00:00:00') TO ('2026-03-25 00:00:00');


--
-- Name: messages_2026_03_25; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_25 FOR VALUES FROM ('2026-03-25 00:00:00') TO ('2026-03-26 00:00:00');


--
-- Name: messages_2026_03_26; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_26 FOR VALUES FROM ('2026-03-26 00:00:00') TO ('2026-03-27 00:00:00');


--
-- Name: messages_2026_03_27; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_27 FOR VALUES FROM ('2026-03-27 00:00:00') TO ('2026-03-28 00:00:00');


--
-- Name: messages_2026_03_28; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_28 FOR VALUES FROM ('2026-03-28 00:00:00') TO ('2026-03-29 00:00:00');


--
-- Name: messages_2026_03_29; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_29 FOR VALUES FROM ('2026-03-29 00:00:00') TO ('2026-03-30 00:00:00');


--
-- Name: messages_2026_03_30; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_30 FOR VALUES FROM ('2026-03-30 00:00:00') TO ('2026-03-31 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: approval_doc_status id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_doc_status ALTER COLUMN id SET DEFAULT nextval('public.approval_doc_status_id_seq'::regclass);


--
-- Name: category id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category ALTER COLUMN id SET DEFAULT nextval('public."Category_id_seq"'::regclass);


--
-- Name: department id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.department ALTER COLUMN id SET DEFAULT nextval('public."Department_id_seq"'::regclass);


--
-- Name: inventory_adjustment id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_adjustment ALTER COLUMN id SET DEFAULT nextval('public.inventory_adjustment_id_seq'::regclass);


--
-- Name: inventory_adjustment_item id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_adjustment_item ALTER COLUMN id SET DEFAULT nextval('public.inventory_adjustment_item_id_seq'::regclass);


--
-- Name: inventory_balance id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_balance ALTER COLUMN id SET DEFAULT nextval('public.inventory_balance_id_seq'::regclass);


--
-- Name: inventory_issue id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_issue ALTER COLUMN id SET DEFAULT nextval('public.inventory_issue_id_seq'::regclass);


--
-- Name: inventory_issue_item id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_issue_item ALTER COLUMN id SET DEFAULT nextval('public.inventory_issue_item_id_seq'::regclass);


--
-- Name: inventory_item id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_item ALTER COLUMN id SET DEFAULT nextval('public.inventory_item_id_seq'::regclass);


--
-- Name: inventory_location id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_location ALTER COLUMN id SET DEFAULT nextval('public.inventory_location_id_seq'::regclass);


--
-- Name: inventory_movement id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_movement ALTER COLUMN id SET DEFAULT nextval('public.inventory_movement_id_seq'::regclass);


--
-- Name: inventory_period id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_period ALTER COLUMN id SET DEFAULT nextval('public.inventory_period_id_seq'::regclass);


--
-- Name: inventory_period_balance id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_period_balance ALTER COLUMN id SET DEFAULT nextval('public.inventory_period_balance_id_seq'::regclass);


--
-- Name: inventory_receipt id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_receipt ALTER COLUMN id SET DEFAULT nextval('public.inventory_receipt_id_seq'::regclass);


--
-- Name: inventory_receipt_item id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_receipt_item ALTER COLUMN id SET DEFAULT nextval('public.inventory_receipt_item_id_seq'::regclass);


--
-- Name: inventory_requisition id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_requisition ALTER COLUMN id SET DEFAULT nextval('public.inventory_requisition_id_seq'::regclass);


--
-- Name: inventory_requisition_item id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_requisition_item ALTER COLUMN id SET DEFAULT nextval('public.inventory_requisition_item_id_seq'::regclass);


--
-- Name: inventory_warehouse id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_warehouse ALTER COLUMN id SET DEFAULT nextval('public.inventory_warehouse_id_seq'::regclass);


--
-- Name: product id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public."Product_id_seq"'::regclass);


--
-- Name: purchase_approval id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_approval ALTER COLUMN id SET DEFAULT nextval('public.purchase_approval_id_seq'::regclass);


--
-- Name: purchase_approval_detail id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_approval_detail ALTER COLUMN id SET DEFAULT nextval('public.purchase_approval_detail_id_seq'::regclass);


--
-- Name: purchase_approval_inventory_link id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_approval_inventory_link ALTER COLUMN id SET DEFAULT nextval('public."PurchaseApprovalInventoryLink_id_seq"'::regclass);


--
-- Name: purchase_plan id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_plan ALTER COLUMN id SET DEFAULT nextval('public.purchase_plan_id_seq'::regclass);


--
-- Name: seller id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seller ALTER COLUMN id SET DEFAULT nextval('public."Seller_id_seq"'::regclass);


--
-- Name: test_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_data ALTER COLUMN id SET DEFAULT nextval('public.test_data_id_seq'::regclass);


--
-- Name: usage_plan id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usage_plan ALTER COLUMN id SET DEFAULT nextval('public."Survey_id_seq"'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: -
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Data for Name: extensions; Type: TABLE DATA; Schema: _realtime; Owner: -
--

COPY _realtime.extensions (id, type, settings, tenant_external_id, inserted_at, updated_at) FROM stdin;
53b4106d-e126-4464-9b82-d42b582fd0f7	postgres_cdc_rls	{"region": "us-east-1", "db_host": "ZP148Qnanu3FH115eFru4w==", "db_name": "sWBpZNdjggEPTQVlI52Zfw==", "db_port": "+enMDFi1J/3IrrquHHwUmA==", "db_user": "uxbEq/zz8DXVD53TOI1zmw==", "slot_name": "supabase_realtime_replication_slot", "db_password": "sWBpZNdjggEPTQVlI52Zfw==", "publication": "supabase_realtime", "ssl_enforced": false, "poll_interval_ms": 100, "poll_max_changes": 100, "poll_max_record_bytes": 1048576}	realtime-dev	2026-03-27 02:43:20	2026-03-27 02:43:20
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: _realtime; Owner: -
--

COPY _realtime.schema_migrations (version, inserted_at) FROM stdin;
20210706140551	2026-03-13 00:36:29
20220329161857	2026-03-13 00:36:29
20220410212326	2026-03-13 00:36:29
20220506102948	2026-03-13 00:36:29
20220527210857	2026-03-13 00:36:29
20220815211129	2026-03-13 00:36:29
20220815215024	2026-03-13 00:36:29
20220818141501	2026-03-13 00:36:29
20221018173709	2026-03-13 00:36:29
20221102172703	2026-03-13 00:36:29
20221223010058	2026-03-13 00:36:29
20230110180046	2026-03-13 00:36:29
20230810220907	2026-03-13 00:36:29
20230810220924	2026-03-13 00:36:29
20231024094642	2026-03-13 00:36:29
20240306114423	2026-03-13 00:36:29
20240418082835	2026-03-13 00:36:29
20240625211759	2026-03-13 00:36:29
20240704172020	2026-03-13 00:36:29
20240902173232	2026-03-13 00:36:29
20241106103258	2026-03-13 00:36:29
20250424203323	2026-03-13 00:36:29
20250613072131	2026-03-13 00:36:29
20250711044927	2026-03-13 00:36:29
20250811121559	2026-03-13 00:36:29
20250926223044	2026-03-13 00:36:29
20251204170944	2026-03-13 00:36:29
20251218000543	2026-03-13 00:36:29
20260209232800	2026-03-13 00:36:29
20260304000000	2026-03-13 00:36:29
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: _realtime; Owner: -
--

COPY _realtime.tenants (id, name, external_id, jwt_secret, max_concurrent_users, inserted_at, updated_at, max_events_per_second, postgres_cdc_default, max_bytes_per_second, max_channels_per_client, max_joins_per_second, suspend, jwt_jwks, notify_private_alpha, private_only, migrations_ran, broadcast_adapter, max_presence_events_per_second, max_payload_size_in_kb, max_client_presence_events_per_window, client_presence_window_ms, presence_enabled) FROM stdin;
a2850ebe-5b13-4393-8ff4-cbbb0b0b42a5	realtime-dev	realtime-dev	iNjicxc4+llvc9wovDvqymwfnj9teWMlyOIbJ8Fh6j2WNU8CIJ2ZgjR6MUIKqSmeDmvpsKLsZ9jgXJmQPpwL8w==	200	2026-03-27 02:43:20	2026-03-27 02:43:20	100	postgres_cdc_rls	100000	100	100	f	{"keys": [{"x": "M5Sjqn5zwC9Kl1zVfUUGvv9boQjCGd45G8sdopBExB4", "y": "P6IXMvA2WYXSHSOMTBH2jsw_9rrzGy89FjPf6oOsIxQ", "alg": "ES256", "crv": "P-256", "ext": true, "kid": "b81269f1-21d8-4f2e-b719-c2240a840d90", "kty": "EC", "use": "sig", "key_ops": ["verify"]}, {"k": "c3VwZXItc2VjcmV0LWp3dC10b2tlbi13aXRoLWF0LWxlYXN0LTMyLWNoYXJhY3RlcnMtbG9uZw", "kty": "oct"}]}	f	f	68	gen_rpc	1000	3000	\N	\N	f
\.


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: approval_doc_status; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.approval_doc_status (id, code, status, is_active) FROM stdin;
1	001	DRAFT	t
2	002	PENDING	t
3	003	APPROVED	t
4	004	REJECTED	t
5	005	CANCELLED	t
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.category (id, category, type, subtype, category_code, is_active) FROM stdin;
185	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	230	t
186	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	230	t
187	วัสดุใช้ไป	วัสดุยานพาหนะและขนส่ง	วัสดุยานพาหนะและขนส่ง	230	t
188	วัสดุใช้ไป	วัสดุยานพาหนะและขนส่ง	วัสดุยานพาหนะและขนส่ง-งบหน่วยงาน	230	t
189	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	230	t
190	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า-งบหน่วยงาน	230	t
191	วัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	230	t
192	วัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่-งบหน่วยงาน	230	t
193	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	230	t
194	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์-งบหน่วยงาน	230	t
195	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	230	t
196	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	230	t
197	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	230	t
198	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง-งบหน่วยงาน	230	t
199	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	230	t
200	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง-งบหน่วยงาน	230	t
201	วัสดุใช้ไป	วัสดุบริโภค	วัสดุบริโภค	230	t
202	วัสดุใช้ไป	วัสดุบริโภค	วัสดุบริโภค-งบหน่วยงาน	230	t
203	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	230	t
3	งบค่าเสื่อม	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา-งบระดับหน่วยบริการ	003	t
134	วัสดุทันตกรรม	วัสดุจัดฟัน	วัสดุจัดฟัน-ประมูล	002	t
114	ยา	ยาในบัญชียาหลัก	ED	012	t
176	ค่าใช้สอย	เงินชดเชยค่างานสิ่งก่อสร้าง	เงินชดเชยค่างานสิ่งก่อสร้าง	009	t
177	ค่าใช้สอย	ค่าประชาสัมพันธ์	ค่าประชาสัมพันธ์	009	t
178	ค่าใช้สอย	ค่าชดใช้ค่าเสียหาย	ค่าชดใช้ค่าเสียหาย	009	t
179	ค่าใช้สอย	ค่าใช้สอยอื่นๆ	ค่าใช้สอยอื่นๆ	009	t
180	ค่าสาธารณูปโภค	ค่าไฟฟ้า	ค่าไฟฟ้า	008	t
181	ค่าสาธารณูปโภค	ค่าน้ำประปาและน้ำบาดาล	ค่าน้ำประปาและน้ำบาดาล	008	t
182	ค่าสาธารณูปโภค	ค่าโทรศัพท์	ค่าโทรศัพท์	008	t
183	ค่าสาธารณูปโภค	ค่าบริการสื่อสารและโทรคมนาคม	ค่าบริการสื่อสารและโทรคมนาคม	008	t
184	ค่าสาธารณูปโภค	ค่าไปรษณีย์และขนส่ง	ค่าไปรษณีย์และขนส่ง	008	t
209	ค่าใช้จ่ายโครงการ	ค่าครุภัณฑ์	ค่าครุภัณฑ์	006	t
210	ค่าใช้จ่ายโครงการ	สิ่งก่อสร้าง	สิ่งก่อสร้าง	006	t
211	ค่าใช้จ่ายโครงการ	ค่าครุภัณฑ์ต่ำกว่าเกณฑ์	ค่าครุภัณฑ์ต่ำกว่าเกณฑ์	006	t
212	ค่าใช้จ่ายโครงการ	ค่าเบี้ยเลี้ยง	ค่าเบี้ยเลี้ยง	006	t
213	ค่าใช้จ่ายโครงการ	ค่าตอบแทน	ค่าตอบแทน	006	t
214	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมอาคารและสิ่งปลูกสร้าง	006	t
215	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์สำนักงาน	006	t
216	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์ยานพาหนะและขนส่ง	006	t
217	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์ไฟฟ้าและวิทยุ	006	t
218	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์โฆษณาและเผยแพร่	006	t
219	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์วิทยาศาสตร์และการแพทย์	006	t
264	ค่าใช้จ่ายโครงการ	วัสดุการแพทย์	วัสดุการแพทย์ห้องผ่าตัด	006	t
265	ค่าใช้จ่ายโครงการ	วัสดุการแพทย์	วัสดุการแพทย์ฟื้นฟูและสนับสนุน	006	t
269	ค่าใช้จ่ายโครงการ	วัสดุทันตกรรม	วัสดุจัดฟัน	006	t
207	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	230	t
4	งบค่าเสื่อม	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร-งบระดับเขตสุขภาพ	003	t
5	งบค่าเสื่อม	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร-งบระดับจังหวัด	003	t
6	งบค่าเสื่อม	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร-งบระดับหน่วยบริการ	003	t
7	งบค่าเสื่อม	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์-งบระดับเขตสุขภาพ	003	t
8	งบค่าเสื่อม	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์-งบระดับจังหวัด	003	t
9	งบค่าเสื่อม	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์-งบระดับหน่วยบริการ	003	t
10	งบค่าเสื่อม	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา-งบระดับเขตสุขภาพ	003	t
11	งบค่าเสื่อม	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา-งบระดับจังหวัด	003	t
12	งบค่าเสื่อม	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา-งบระดับหน่วยบริการ	003	t
13	งบค่าเสื่อม	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต-งบระดับเขตสุขภาพ	003	t
14	งบค่าเสื่อม	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต-งบระดับจังหวัด	003	t
15	งบค่าเสื่อม	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต-งบระดับหน่วยบริการ	003	t
16	งบค่าเสื่อม	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย-งบระดับเขตสุขภาพ	003	t
17	งบค่าเสื่อม	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย-งบระดับจังหวัด	003	t
18	งบค่าเสื่อม	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย-งบระดับหน่วยบริการ	003	t
19	งบค่าเสื่อม	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน-งบระดับเขตสุขภาพ	003	t
20	งบค่าเสื่อม	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน-งบระดับจังหวัด	003	t
21	งบค่าเสื่อม	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน-งบระดับหน่วยบริการ	003	t
22	งบค่าเสื่อม	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์-งบระดับเขตสุขภาพ	003	t
23	งบค่าเสื่อม	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์-งบระดับจังหวัด	003	t
24	งบค่าเสื่อม	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์-งบระดับหน่วยบริการ	003	t
25	งบค่าเสื่อม	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว-งบระดับเขตสุขภาพ	003	t
26	งบค่าเสื่อม	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว-งบระดับจังหวัด	003	t
27	งบค่าเสื่อม	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว-งบระดับหน่วยบริการ	003	t
28	งบค่าเสื่อม	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง-งบระดับเขตสุขภาพ	003	t
29	งบค่าเสื่อม	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง-งบระดับจังหวัด	003	t
30	งบค่าเสื่อม	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง-งบระดับหน่วยบริการ	003	t
31	งบค่าเสื่อม	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์-งบระดับเขตสุขภาพ	003	t
32	งบค่าเสื่อม	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์-งบระดับจังหวัด	003	t
2	งบค่าเสื่อม	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา-งบระดับจังหวัด	003	t
33	งบค่าเสื่อม	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์-งบระดับหน่วยบริการ	003	t
34	งบค่าเสื่อม	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน-งบระดับเขตสุขภาพ	003	t
35	งบค่าเสื่อม	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน-งบระดับจังหวัด	003	t
36	งบค่าเสื่อม	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน-งบระดับหน่วยบริการ	003	t
37	งบค่าเสื่อม	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่-งบระดับเขตสุขภาพ	003	t
38	งบค่าเสื่อม	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่-งบระดับจังหวัด	003	t
39	งบค่าเสื่อม	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่-งบระดับหน่วยบริการ	003	t
40	งบค่าเสื่อม	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน-งบระดับเขตสุขภาพ	003	t
41	งบค่าเสื่อม	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน-งบระดับจังหวัด	003	t
42	งบค่าเสื่อม	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน-งบระดับหน่วยบริการ	003	t
43	งบค่าเสื่อม	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ-งบระดับเขตสุขภาพ	003	t
44	งบค่าเสื่อม	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ-งบระดับจังหวัด	003	t
45	งบค่าเสื่อม	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ-งบระดับหน่วยบริการ	003	t
46	งบค่าเสื่อม	สิ่งก่อสร้าง	สิ่งก่อสร้าง-งบระดับเขตสุขภาพ	003	t
47	งบค่าเสื่อม	สิ่งก่อสร้าง	สิ่งก่อสร้าง-งบระดับจังหวัด	003	t
48	งบค่าเสื่อม	สิ่งก่อสร้าง	สิ่งก่อสร้าง-งบระดับหน่วยบริการ	003	t
49	งบค่าเสื่อม	ค่าเช่าเบ็ดเตล็ด	ค่าเช่าเบ็ดเตล็ด-งบระดับเขตสุขภาพ	003	t
50	งบค่าเสื่อม	ค่าเช่าเบ็ดเตล็ด	ค่าเช่าเบ็ดเตล็ด-งบระดับจังหวัด	003	t
51	งบค่าเสื่อม	ค่าเช่าเบ็ดเตล็ด	ค่าเช่าเบ็ดเตล็ด-งบระดับหน่วยบริการ	003	t
52	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา	005	t
53	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา-งบหน่วยงาน	005	t
54	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร	005	t
55	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร-งบหน่วยงาน	005	t
56	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์	005	t
57	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์-งบหน่วยงาน	005	t
58	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา	005	t
59	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา-งบหน่วยงาน	005	t
60	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต	005	t
61	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต-งบหน่วยงาน	005	t
62	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย	005	t
63	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย-งบหน่วยงาน	005	t
64	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน	005	t
65	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน-งบหน่วยงาน	005	t
66	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์	005	t
67	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์-งบหน่วยงาน	005	t
68	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว	005	t
69	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว-งบหน่วยงาน	005	t
70	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง	005	t
71	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง-งบหน่วยงาน	005	t
72	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	005	t
73	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์-งบหน่วยงาน	005	t
74	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน	005	t
75	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน-งบหน่วยงาน	005	t
76	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่	005	t
77	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่-งบหน่วยงาน	005	t
78	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน	005	t
79	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน-งบหน่วยงาน	005	t
80	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ	005	t
81	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ-งบหน่วยงาน	005	t
82	ครุภัณฑ์และสิ่งก่อสร้าง	สิ่งก่อสร้าง	สิ่งก่อสร้าง	005	t
83	ครุภัณฑ์และสิ่งก่อสร้าง	สิ่งก่อสร้าง	สิ่งก่อสร้าง-งบหน่วยงาน	005	t
84	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา	010	t
85	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา-งบหน่วยงาน	010	t
86	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร	010	t
87	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร-งบหน่วยงาน	010	t
88	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์	010	t
89	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์-งบหน่วยงาน	010	t
90	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา	010	t
91	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา-งบหน่วยงาน	010	t
92	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต	010	t
93	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต-งบหน่วยงาน	010	t
94	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย	010	t
95	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย-งบหน่วยงาน	010	t
96	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน	010	t
97	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน-งบหน่วยงาน	010	t
98	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์	010	t
99	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์-งบหน่วยงาน	010	t
100	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว	010	t
101	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว-งบหน่วยงาน	010	t
102	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง	010	t
103	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง-งบหน่วยงาน	010	t
104	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	010	t
105	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์-งบหน่วยงาน	010	t
106	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน	010	t
107	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน-งบหน่วยงาน	010	t
108	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่	010	t
109	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่-งบหน่วยงาน	010	t
110	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน	010	t
111	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน-งบหน่วยงาน	010	t
112	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ	010	t
113	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ-งบหน่วยงาน	010	t
115	ยา	ยานอกบัญชียาหลัก	NED	012	t
116	ยา	ยานอกแผน	ยานอกแผน	012	t
117	วัสดุการแพทย์	วัสดุการแพทย์ทั่วไป	วัสดุการแพทย์ทั่วไป	001	t
118	วัสดุการแพทย์	วัสดุการแพทย์ทั่วไป	วัสดุการแพทย์ทั่วไป-งบหน่วยงาน	001	t
119	วัสดุการแพทย์	วัสดุการแพทย์สูตินรีเวชกรรม	วัสดุการแพทย์สูตินรีเวชกรรม	001	t
120	วัสดุการแพทย์	วัสดุการแพทย์สูตินรีเวชกรรม	วัสดุการแพทย์สูตินรีเวชกรรม-งบหน่วยงาน	001	t
121	วัสดุการแพทย์	วัสดุการแพทย์กุมารเวชกรรม	วัสดุการแพทย์กุมารเวชกรรม	001	t
122	วัสดุการแพทย์	วัสดุการแพทย์กุมารเวชกรรม	วัสดุการแพทย์กุมารเวชกรรม-งบหน่วยงาน	001	t
123	วัสดุการแพทย์	วัสดุการแพทย์อายุรกรรม	วัสดุการแพทย์อายุรกรรม	001	t
124	วัสดุการแพทย์	วัสดุการแพทย์อายุรกรรม	วัสดุการแพทย์อายุรกรรม-งบหน่วยงาน	001	t
125	วัสดุการแพทย์	วัสดุการแพทย์ศัลยกรรม	วัสดุการแพทย์ศัลยกรรม	001	t
126	วัสดุการแพทย์	วัสดุการแพทย์ศัลยกรรม	วัสดุการแพทย์ศัลยกรรม-งบหน่วยงาน	001	t
127	วัสดุการแพทย์	วัสดุการแพทย์ศัลยกรรมกระดูกและข้อ	วัสดุการแพทย์ศัลยกรรมกระดูกและข้อ	001	t
128	วัสดุการแพทย์	วัสดุการแพทย์ศัลยกรรมกระดูกและข้อ	วัสดุการแพทย์ศัลยกรรมกระดูกและข้อ-งบหน่วยงาน	001	t
129	วัสดุการแพทย์	วัสดุการแพทย์สนับสนุน	วัสดุการแพทย์สนับสนุน	001	t
130	วัสดุการแพทย์	วัสดุการแพทย์สนับสนุน	วัสดุการแพทย์สนับสนุน-งบหน่วยงาน	001	t
131	วัสดุทันตกรรม	เครื่องมือทันตกรรม	เครื่องมือทันตกรรม	002	t
132	วัสดุทันตกรรม	เครื่องมือทันตกรรม	เครื่องมือทันตกรรม-ประมูล	002	t
133	วัสดุทันตกรรม	วัสดุจัดฟัน	วัสดุจัดฟัน	002	t
135	วัสดุทันตกรรม	วัสดุทันตกรรมทั่วไป	วัสดุทันตกรรมทั่วไป	002	t
136	วัสดุทันตกรรม	วัสดุทันตกรรมทั่วไป	วัสดุทันตกรรมทั่วไป-ประมูล	002	t
137	วัสดุทันตกรรม	วัสดุรากฟันเทียม	วัสดุรากฟันเทียม	002	t
138	วัสดุทันตกรรม	วัสดุรากฟันเทียม	วัสดุรากฟันเทียม-ประมูล	002	t
139	วัสดุทันตกรรม	เครื่องมือทันตกรรมรากฟันเทียม	เครื่องมือทันตกรรมรากฟันเทียม	002	t
140	วัสดุทันตกรรม	เครื่องมือทันตกรรมรากฟันเทียม	เครื่องมือทันตกรรมรากฟันเทียม-ประมูล	002	t
141	วัสดุเภสัชกรรม	วัสดุเภสัชกรรมทั่วไป	วัสดุเภสัชกรรมทั่วไป	004	t
142	วัสดุเภสัชกรรม	สารเคมี	สารเคมี	004	t
143	วัสดุวิทยาศาสตร์การแพทย์	Supply	Supply	007	t
144	วัสดุวิทยาศาสตร์การแพทย์	Reagent	Reagent	007	t
145	ค่าใช้สอย	ค่าซ่อมแซมอาคารและสิ่งปลูกสร้าง	ค่าซ่อมแซมอาคารและสิ่งปลูกสร้าง	009	t
146	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์สำนักงาน	ค่าซ่อมแซมครุภัณฑ์สำนักงาน	009	t
147	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์ยานพาหนะและขนส่ง	ค่าซ่อมแซมครุภัณฑ์ยานพาหนะและขนส่ง	009	t
148	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์ไฟฟ้าและวิทยุ	ค่าซ่อมแซมครุภัณฑ์ไฟฟ้าและวิทยุ	009	t
149	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์โฆษณาและเผยแพร่	ค่าซ่อมแซมครุภัณฑ์โฆษณาและเผยแพร่	009	t
150	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์วิทยาศาสตร์และการแพทย์	ค่าซ่อมแซมครุภัณฑ์วิทยาศาสตร์และการแพทย์	009	t
151	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์คอมพิวเตอร์	ค่าซ่อมแซมครุภัณฑ์คอมพิวเตอร์	009	t
152	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์อื่น	ค่าซ่อมแซมครุภัณฑ์อื่น	009	t
153	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาดูแลลิฟท์	ค่าจ้างเหมาบำรุงรักษาดูแลลิฟท์	009	t
154	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาสวนหย่อม	ค่าจ้างเหมาบำรุงรักษาสวนหย่อม	009	t
155	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาครุภัณฑ์วิทยาศาสตร์และการแพทย์	ค่าจ้างเหมาบำรุงรักษาครุภัณฑ์วิทยาศาสตร์และการแพทย์	009	t
156	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาระบบปรับอากาศ	ค่าจ้างเหมาบำรุงรักษาระบบปรับอากาศ	009	t
157	ค่าใช้สอย	ค่าจ้างเหมาซ่อมแซมบ้านพัก	ค่าจ้างเหมาซ่อมแซมบ้านพัก	009	t
158	ค่าใช้สอย	ค่าจ้างเหมาทำความสะอาด	ค่าจ้างเหมาทำความสะอาด	009	t
159	ค่าใช้สอย	ค่าจ้างเหมาประกอบอาหารผู้ป่วย	ค่าจ้างเหมาประกอบอาหารผู้ป่วย	009	t
160	ค่าใช้สอย	ค่าจ้างเหมารถ	ค่าจ้างเหมารถ	009	t
161	ค่าใช้สอย	ค่าจ้างเหมาดูแลความปลอดภัย	ค่าจ้างเหมาดูแลความปลอดภัย	009	t
162	ค่าใช้สอย	ค่าจ้างเหมาซักรีด	ค่าจ้างเหมาซักรีด	009	t
163	ค่าใช้สอย	ค่าจ้างเหมากำจัดขยะติดเชื้อ	ค่าจ้างเหมากำจัดขยะติดเชื้อ	009	t
164	ค่าใช้สอย	ค่าจ้างเหมาบริการทางการแพทย์	ค่าจ้างเหมาบริการทางการแพทย์	009	t
165	ค่าใช้สอย	ค่าจ้างเหมาบริการอื่น (สนับสนุน)	ค่าจ้างเหมาบริการอื่น (สนับสนุน)	009	t
166	ค่าใช้สอย	ค่าจ้างตรวจทางห้องปฏิบัติการ (Lab)	ค่าจ้างตรวจทางห้องปฏิบัติการ (Lab)	009	t
167	ค่าใช้สอย	ค่าจ้างตรวจเอ็กซเรย์ (X-Ray)	ค่าจ้างตรวจเอ็กซเรย์ (X-Ray)	009	t
168	ค่าใช้สอย	ค่าธรรมเนียมทางกฎหมาย	ค่าธรรมเนียมทางกฎหมาย	009	t
169	ค่าใช้สอย	ค่าธรรมเนียมธนาคาร	ค่าธรรมเนียมธนาคาร	009	t
170	ค่าใช้สอย	ค่าจ้างที่ปรึกษา	ค่าจ้างที่ปรึกษา	009	t
171	ค่าใช้สอย	ค่าเบี้ยประกันภัย	ค่าเบี้ยประกันภัย	009	t
172	ค่าใช้สอย	ค่าใช้จ่ายในการประชุม	ค่าใช้จ่ายในการประชุม	009	t
173	ค่าใช้สอย	ค่ารับรองและพิธีการ	ค่ารับรองและพิธีการ	009	t
174	ค่าใช้สอย	ค่าเช่าอสังหาริมทรัพย์	ค่าเช่าอสังหาริมทรัพย์	009	t
175	ค่าใช้สอย	ค่าเช่าเบ็ดเตล็ด	ค่าเช่าเบ็ดเตล็ด	009	t
220	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์คอมพิวเตอร์	006	t
221	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์อื่น	006	t
222	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาดูแลลิฟท์	006	t
223	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาสวนหย่อม	006	t
224	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาครุภัณฑ์วิทยาศาสตร์และการแพทย์	006	t
225	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาระบบปรับอากาศ	006	t
226	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาซ่อมแซมบ้านพัก	006	t
227	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาทำความสะอาด	006	t
228	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาประกอบอาหารผู้ป่วย	006	t
229	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมารถ	006	t
230	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาดูแลความปลอดภัย	006	t
231	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาซักรีด	006	t
232	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมากำจัดขยะติดเชื้อ	006	t
233	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาบริการทางการแพทย์	006	t
234	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาบริการอื่น (สนับสนุน)	006	t
235	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างตรวจทางห้องปฏิบัติการ (Lab)	006	t
236	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างตรวจเอ็กซเรย์ (X-Ray)	006	t
237	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าธรรมเนียมทางกฎหมาย	006	t
238	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าธรรมเนียมธนาคาร	006	t
239	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างที่ปรึกษา	006	t
240	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าเบี้ยประกันภัย	006	t
241	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าใช้จ่ายในการประชุม	006	t
242	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่ารับรองและพิธีการ	006	t
243	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าเช่าอสังหาริมทรัพย์	006	t
244	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าเช่าเบ็ดเตล็ด	006	t
245	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	เงินชดเชยค่างานสิ่งก่อสร้าง	006	t
246	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าประชาสัมพันธ์	006	t
247	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าชดใช้ค่าเสียหาย	006	t
248	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าใช้สอยอื่นๆ	006	t
249	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุสำนักงาน	006	t
250	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุยานพาหนะและขนส่ง	006	t
251	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุไฟฟ้า	006	t
252	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	006	t
253	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุคอมพิวเตอร์	006	t
254	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุงานบ้านงานครัว	006	t
255	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุช่างและก่อสร้าง	006	t
256	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุเชื้อเพลิง	006	t
257	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุบริโภค	006	t
258	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	006	t
259	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุการเกษตร	006	t
260	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุอื่นๆ	006	t
261	ค่าใช้จ่ายโครงการ	ยา	ยาในบัญชียาหลัก	006	t
262	ค่าใช้จ่ายโครงการ	ยา	ยานอกบัญชียาหลัก	006	t
263	ค่าใช้จ่ายโครงการ	วัสดุการแพทย์	วัสดุการแพทย์ทั่วไป	006	t
266	ค่าใช้จ่ายโครงการ	วัสดุการแพทย์	วัสดุการแพทย์ที่ใช้ในการป้องกันการติดเชื้อ	006	t
267	ค่าใช้จ่ายโครงการ	วัสดุการแพทย์	วัสดุการแพทย์ที่ใช้ในเทคโนโลยีทางการแพทย์	006	t
268	ค่าใช้จ่ายโครงการ	วัสดุทันตกรรม	เครื่องมือทันตกรรม	006	t
270	ค่าใช้จ่ายโครงการ	วัสดุทันตกรรม	วัสดุทันตกรรมทั่วไป	006	t
271	ค่าใช้จ่ายโครงการ	วัสดุทันตกรรม	วัสดุรากฟันเทียม	006	t
272	ค่าใช้จ่ายโครงการ	วัสดุเภสัชกรรม	วัสดุเภสัชกรรม	006	t
273	ค่าใช้จ่ายโครงการ	วัสดุเภสัชกรรม	สารเคมี	006	t
274	ค่าใช้จ่ายโครงการ	วัสดุวิทยาศาสตร์การแพทย์	วัสดุวิทยาศาสตร์การแพทย์ทั่วไป	006	t
275	ค่าใช้จ่ายโครงการ	วัสดุวิทยาศาสตร์การแพทย์	Supply	006	t
276	ค่าใช้จ่ายโครงการ	วัสดุวิทยาศาสตร์การแพทย์	Reagent	006	t
277	ค่าใช้จ่ายโครงการ	ค่าใช้จ่ายในการจัดประชุม	ค่าใช้สอย ค่าวัสดุ	006	t
278	ค่าใช้จ่ายโครงการ	ค่าใช้จ่ายในการจัดประชุม-อบรมเชิงปฏิบัติการ	ค่าตอบแทน ค่าใช้สอย ค่าวัสดุ	006	t
279	ค่าใช้จ่ายโครงการ	ค่าใช้จ่ายในการศึกษาดูงานนอกสถานที่	ค่าที่พัก ค่าเบี้ยเลี้ยง ค่าใช้สอย ค่าวัสดุ	006	t
280	ค่าใช้จ่ายโครงการ	ค่าใช้จ่ายในการประชุม-อบรมเชิงปฏิบัติการนอกสถานที่	ค่าที่พัก ค่าเบี้ยเลี้ยง ค่าตอบแทน ค่าใช้สอย ค่าวัสดุ	006	t
1	งบค่าเสื่อม	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา-งบระดับเขตสุขภาพ	003	t
204	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	230	t
205	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	230	t
206	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร-งบหน่วยงาน	230	t
208	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ-งบหน่วยงาน	230	t
\.


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.department (id, name, department_code, is_active) FROM stdin;
2	กลุ่มงานเทคนิคการแพทย์	0002	t
3	กลุ่มงานทันตกรรม	0003	t
4	กลุ่มงานเภสัชกรรม	0004	t
5	งานรังสีวิทยา	0005	t
6	กลุ่มงานเวชกรรมฟื้นฟู	0006	t
7	กลุ่มงานประกันสุขภาพ	0007	t
8	งานแพทย์แผนไทย	0008	t
9	กลุ่มงานสุขภาพจิต	0009	t
10	กลุ่มงานบริการด้านปฐมภูมิฯ	0010	t
11	กลุ่มการพยาบาล	0011	t
12	ศูนย์คุณภาพ	0012	t
13	งานผู้ป่วยนอก	0013	t
14	งานอุบัติเหตุฉุกเฉิน	0014	t
15	งานโรคไม่ติดต่อเรื้อรัง	0015	t
16	งานผู้ป่วยในชาย	0016	t
17	งานผู้ป่วยในหญิงและเด็ก	0017	t
18	งานห้องคลอด	0018	t
19	งานห้องผ่าตัด	0019	t
20	งานวิสัญญี	0020	t
21	งานจ่ายกลาง	0021	t
22	PCU_ร่วมใจ	0022	t
23	PCU_วังทอง	0023	t
24	งานแผนยุทธศาสตร์	0024	t
25	เรือนจำจังหวัด	0025	t
26	เรือนจำกลาง	0026	t
27	ทัณฑสถานหญิง	0027	t
28	รพ.สต.พันชาลี	0028	t
29	รพ.สต.บ้านสุพรรณพนมทอง	0029	t
30	รพ.สต.แม่ระกา	0030	t
31	รพ.สต.บ้านวังน้ำใส	0031	t
32	รพ.สต.บ้านหนองปรือ	0032	t
33	สอน.บ้านกลาง	0033	t
34	รพ.สต.บ้านใหม่ชัยเจริญ	0034	t
35	รพ.สต.บ้านดงพลวง	0035	t
36	รพ.สต.แก่งโสภา	0036	t
37	รพ.สต.ท่าหมื่นราม	0037	t
38	รพ.สต.บ้านหนองเตาอิฐ	0038	t
39	รพ.สต.วังนกแอ่น	0039	t
40	รพ.สต.บ้านน้ำพรม	0040	t
41	รพ.สต.บ้านไผ่ใหญ่	0041	t
42	รพ.สต.หนองพระ	0042	t
43	รพ.สต.ชัยนาม	0043	t
44	รพ.สต.ดินทอง	0044	t
45	รพ.สต.บ้านแสนสุขพัฒนา	0045	t
46	รพ.สต.วังพิกุล	0046	t
47	สสอ.วังทอง	0047	t
1	กลุ่มงานบริหารทั่วไป	0001	t
\.


--
-- Data for Name: inventory_adjustment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_adjustment (id, adjustment_no, adjustment_date, reason, status, created_by, approved_by, created_at) FROM stdin;
\.


--
-- Data for Name: inventory_adjustment_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_adjustment_item (id, adjustment_id, inventory_item_id, qty_diff, unit_cost, note) FROM stdin;
\.


--
-- Data for Name: inventory_balance; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_balance (id, inventory_item_id, on_hand_qty, reserved_qty, available_qty, avg_cost, last_movement_at, updated_at) FROM stdin;
4	4	5	0	5	850.00	2026-03-10 13:24:47.169769	2026-03-10 13:24:47.169769
3	3	5	0	5	1390.00	2026-03-07 17:28:17.098202	2026-03-07 17:28:17.098202
2	2	199	0	199	60.00	2026-03-07 17:20:55.832108	2026-03-07 17:46:24.429834
5	5	10	0	10	980.00	2026-03-07 18:04:06.555924	2026-03-07 18:04:06.555924
7	7	600	0	600	42.00	2026-03-07 18:29:36.711476	2026-03-07 18:29:36.711476
6	6	529	0	529	9.00	2026-03-07 18:17:31.840867	2026-03-09 14:03:03.873062
8	8	19	0	19	990.00	2026-03-09 14:01:35.338289	2026-03-09 14:15:53.577616
9	9	210	0	210	39.00	2026-03-09 14:37:30.189301	2026-03-09 14:38:57.533975
1	1	99	0	99	35.00	2026-03-09 14:39:53.01793	2026-03-09 14:39:53.01793
10	10	1	0	1	320.00	\N	2026-03-10 09:48:50.633911
11	11	9	0	9	70.00	\N	2026-03-10 09:48:50.633911
12	12	8	0	8	170.00	\N	2026-03-10 09:48:50.633911
13	13	44	0	44	150.00	\N	2026-03-10 09:48:50.633911
14	14	9	0	9	280.00	\N	2026-03-10 09:48:50.633911
15	15	5	0	5	0.00	\N	2026-03-10 09:48:50.633911
16	16	7	0	7	390.00	\N	2026-03-10 09:48:50.633911
17	17	7	0	7	390.00	\N	2026-03-10 09:48:50.633911
18	18	7	0	7	390.00	\N	2026-03-10 09:48:50.633911
19	19	4	0	4	350.00	\N	2026-03-10 09:48:50.633911
20	20	3	0	3	350.00	\N	2026-03-10 09:48:50.633911
21	21	2	0	2	350.00	\N	2026-03-10 09:48:50.633911
22	22	2	0	2	350.00	\N	2026-03-10 09:48:50.633911
23	23	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
24	24	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
25	25	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
26	26	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
27	27	10	0	10	890.00	\N	2026-03-10 09:48:50.633911
28	28	6	0	6	980.00	\N	2026-03-10 09:48:50.633911
29	29	4	0	4	390.00	\N	2026-03-10 09:48:50.633911
30	30	6	0	6	980.00	\N	2026-03-10 09:48:50.633911
31	31	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
32	32	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
33	33	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
34	34	156	0	156	6.00	\N	2026-03-10 09:48:50.633911
35	35	25	0	25	65.00	\N	2026-03-10 09:48:50.633911
36	36	65	0	65	35.00	\N	2026-03-10 09:48:50.633911
37	37	12	0	12	15.00	\N	2026-03-10 09:48:50.633911
38	38	6750	0	6750	1.00	\N	2026-03-10 09:48:50.633911
39	39	8	0	8	30.00	\N	2026-03-10 09:48:50.633911
40	40	10	0	10	25.00	\N	2026-03-10 09:48:50.633911
41	41	36	0	36	35.00	\N	2026-03-10 09:48:50.633911
42	42	27	0	27	50.00	\N	2026-03-10 09:48:50.633911
43	43	118	0	118	35.00	\N	2026-03-10 09:48:50.633911
44	44	145	0	145	65.00	\N	2026-03-10 09:48:50.633911
45	45	250	0	250	65.00	\N	2026-03-10 09:48:50.633911
46	46	15	0	15	50.00	\N	2026-03-10 09:48:50.633911
47	47	118	0	118	70.00	\N	2026-03-10 09:48:50.633911
48	48	80	0	80	70.00	\N	2026-03-10 09:48:50.633911
49	49	184	0	184	70.00	\N	2026-03-10 09:48:50.633911
50	50	105	0	105	60.00	\N	2026-03-10 09:48:50.633911
51	51	75	0	75	45.00	\N	2026-03-10 09:48:50.633911
52	52	146	0	146	45.00	\N	2026-03-10 09:48:50.633911
53	53	72	0	72	45.00	\N	2026-03-10 09:48:50.633911
54	54	230	0	230	45.00	\N	2026-03-10 09:48:50.633911
55	55	4	0	4	120.00	\N	2026-03-10 09:48:50.633911
56	56	4	0	4	45.00	\N	2026-03-10 09:48:50.633911
57	57	9	0	9	45.00	\N	2026-03-10 09:48:50.633911
58	58	81	0	81	45.00	\N	2026-03-10 09:48:50.633911
59	59	80	0	80	45.00	\N	2026-03-10 09:48:50.633911
60	60	341	0	341	45.00	\N	2026-03-10 09:48:50.633911
61	61	90	0	90	45.00	\N	2026-03-10 09:48:50.633911
62	62	9	0	9	65.00	\N	2026-03-10 09:48:50.633911
63	63	6	0	6	95.00	\N	2026-03-10 09:48:50.633911
64	64	8	0	8	130.00	\N	2026-03-10 09:48:50.633911
65	65	13	0	13	370.00	\N	2026-03-10 09:48:50.633911
66	66	14	0	14	430.00	\N	2026-03-10 09:48:50.633911
67	67	33	0	33	200.00	\N	2026-03-10 09:48:50.633911
68	68	11	0	11	120.00	\N	2026-03-10 09:48:50.633911
69	69	21	0	21	180.00	\N	2026-03-10 09:48:50.633911
70	70	43	0	43	35.00	\N	2026-03-10 09:48:50.633911
71	71	18	0	18	25.00	\N	2026-03-10 09:48:50.633911
72	72	23	0	23	35.00	\N	2026-03-10 09:48:50.633911
73	73	4	0	4	120.00	\N	2026-03-10 09:48:50.633911
74	74	6	0	6	70.00	\N	2026-03-10 09:48:50.633911
75	75	4	0	4	30.00	\N	2026-03-10 09:48:50.633911
76	76	23	0	23	25.00	\N	2026-03-10 09:48:50.633911
77	77	59	0	59	70.00	\N	2026-03-10 09:48:50.633911
78	78	5	0	5	80.00	\N	2026-03-10 09:48:50.633911
79	79	22	0	22	160.00	\N	2026-03-10 09:48:50.633911
80	80	42	0	42	15.00	\N	2026-03-10 09:48:50.633911
81	81	14	0	14	50.00	\N	2026-03-10 09:48:50.633911
82	82	9	0	9	60.00	\N	2026-03-10 09:48:50.633911
83	83	3	0	3	45.00	\N	2026-03-10 09:48:50.633911
84	84	1	0	1	290.00	\N	2026-03-10 09:48:50.633911
85	85	4	0	4	450.00	\N	2026-03-10 09:48:50.633911
86	86	6	0	6	300.00	\N	2026-03-10 09:48:50.633911
87	87	4	0	4	130.00	\N	2026-03-10 09:48:50.633911
88	88	4	0	4	160.00	\N	2026-03-10 09:48:50.633911
89	89	1	0	1	295.00	\N	2026-03-10 09:48:50.633911
90	90	5	0	5	110.00	\N	2026-03-10 09:48:50.633911
91	91	1	0	1	110.00	\N	2026-03-10 09:48:50.633911
92	92	1	0	1	145.00	\N	2026-03-10 09:48:50.633911
93	93	2	0	2	145.00	\N	2026-03-10 09:48:50.633911
94	94	15	0	15	145.00	\N	2026-03-10 09:48:50.633911
95	95	3	0	3	145.00	\N	2026-03-10 09:48:50.633911
96	96	11	0	11	45.00	\N	2026-03-10 09:48:50.633911
97	97	6	0	6	45.00	\N	2026-03-10 09:48:50.633911
98	98	8	0	8	95.00	\N	2026-03-10 09:48:50.633911
99	99	11	0	11	95.00	\N	2026-03-10 09:48:50.633911
100	100	15	0	15	95.00	\N	2026-03-10 09:48:50.633911
101	101	1	0	1	95.00	\N	2026-03-10 09:48:50.633911
102	102	40	0	40	800.00	\N	2026-03-10 09:48:50.633911
103	103	52	0	52	30.00	\N	2026-03-10 09:48:50.633911
104	104	80	0	80	2.00	\N	2026-03-10 09:48:50.633911
105	105	25	0	25	15.00	\N	2026-03-10 09:48:50.633911
106	106	35	0	35	130.00	\N	2026-03-10 09:48:50.633911
107	107	34	0	34	58.00	\N	2026-03-10 09:48:50.633911
108	108	2	0	2	100.00	\N	2026-03-10 09:48:50.633911
109	109	22	0	22	350.00	\N	2026-03-10 09:48:50.633911
110	110	6	0	6	65.00	\N	2026-03-10 09:48:50.633911
111	111	5	0	5	160.00	\N	2026-03-10 09:48:50.633911
112	112	1	0	1	130.00	\N	2026-03-10 09:48:50.633911
113	113	18	0	18	10.00	\N	2026-03-10 09:48:50.633911
114	114	74	0	74	20.00	\N	2026-03-10 09:48:50.633911
115	115	108	0	108	10.00	\N	2026-03-10 09:48:50.633911
116	116	18	0	18	20.00	\N	2026-03-10 09:48:50.633911
117	117	48	0	48	50.00	\N	2026-03-10 09:48:50.633911
118	118	26	0	26	16.00	\N	2026-03-10 09:48:50.633911
119	119	7	0	7	410.00	\N	2026-03-10 09:48:50.633911
120	120	2	0	2	265.00	\N	2026-03-10 09:48:50.633911
121	121	15	0	15	85.00	\N	2026-03-10 09:48:50.633911
122	122	1	0	1	110.00	\N	2026-03-10 09:48:50.633911
123	123	3	0	3	110.00	\N	2026-03-10 09:48:50.633911
124	124	7	0	7	110.00	\N	2026-03-10 09:48:50.633911
125	125	2	0	2	110.00	\N	2026-03-10 09:48:50.633911
126	126	7	0	7	35.00	\N	2026-03-10 09:48:50.633911
127	127	242	0	242	45.00	\N	2026-03-10 09:48:50.633911
128	128	31	0	31	25.00	\N	2026-03-10 09:48:50.633911
129	129	29	0	29	30.00	\N	2026-03-10 09:48:50.633911
130	130	1	0	1	150.00	\N	2026-03-10 09:48:50.633911
131	131	9	0	9	2000.00	\N	2026-03-10 09:48:50.633911
132	132	250	0	250	120.00	\N	2026-03-10 09:48:50.633911
133	133	270	0	270	50.00	\N	2026-03-10 09:48:50.633911
134	134	17	0	17	10.00	\N	2026-03-10 09:48:50.633911
135	135	7	0	7	95.00	\N	2026-03-10 09:48:50.633911
136	136	4	0	4	95.00	\N	2026-03-10 09:48:50.633911
137	137	6	0	6	95.00	\N	2026-03-10 09:48:50.633911
138	138	14	0	14	95.00	\N	2026-03-10 09:48:50.633911
139	139	61	0	61	120.00	\N	2026-03-10 09:48:50.633911
140	140	5	0	5	130.00	\N	2026-03-10 09:48:50.633911
141	141	59	0	59	65.00	\N	2026-03-10 09:48:50.633911
142	142	17	0	17	30.00	\N	2026-03-10 09:48:50.633911
143	143	35	0	35	20.00	\N	2026-03-10 09:48:50.633911
144	144	117	0	117	55.00	\N	2026-03-10 09:48:50.633911
145	145	26	0	26	40.00	\N	2026-03-10 09:48:50.633911
146	146	42	0	42	25.00	\N	2026-03-10 09:48:50.633911
147	147	86	0	86	20.00	\N	2026-03-10 09:48:50.633911
148	148	2	0	2	850.00	\N	2026-03-10 09:48:50.633911
149	149	2	0	2	200.00	\N	2026-03-10 09:48:50.633911
150	150	3	0	3	85.00	\N	2026-03-10 09:48:50.633911
151	151	3	0	3	360.00	\N	2026-03-10 09:48:50.633911
152	152	10	0	10	65.00	\N	2026-03-10 09:48:50.633911
153	153	1350	0	1350	1.00	\N	2026-03-10 09:48:50.633911
154	154	600	0	600	4.00	\N	2026-03-10 09:48:50.633911
155	155	100	0	100	4.00	\N	2026-03-10 09:48:50.633911
156	183	8	0	8	35.00	\N	2026-03-10 09:48:50.633911
157	156	1450	0	1450	4.00	\N	2026-03-10 09:48:50.633911
158	157	10	0	10	60.00	\N	2026-03-10 09:48:50.633911
159	158	16	0	16	60.00	\N	2026-03-10 09:48:50.633911
160	159	59	0	59	25.00	\N	2026-03-10 09:48:50.633911
161	160	42	0	42	30.00	\N	2026-03-10 09:48:50.633911
162	161	44	0	44	30.00	\N	2026-03-10 09:48:50.633911
163	162	45	0	45	45.00	\N	2026-03-10 09:48:50.633911
164	163	12	0	12	30.00	\N	2026-03-10 09:48:50.633911
165	164	2	0	2	35.00	\N	2026-03-10 09:48:50.633911
166	165	14	0	14	35.00	\N	2026-03-10 09:48:50.633911
167	166	26	0	26	35.00	\N	2026-03-10 09:48:50.633911
168	167	161	0	161	20.00	\N	2026-03-10 09:48:50.633911
169	168	4	0	4	2200.00	\N	2026-03-10 09:48:50.633911
170	169	12	0	12	400.00	\N	2026-03-10 09:48:50.633911
171	170	21	0	21	20.00	\N	2026-03-10 09:48:50.633911
172	171	1	0	1	25.00	\N	2026-03-10 09:48:50.633911
173	172	61	0	61	60.00	\N	2026-03-10 09:48:50.633911
174	173	12	0	12	1600.00	\N	2026-03-10 09:48:50.633911
175	174	10	0	10	40.00	\N	2026-03-10 09:48:50.633911
176	175	59	0	59	15.00	\N	2026-03-10 09:48:50.633911
177	176	173	0	173	15.00	\N	2026-03-10 09:48:50.633911
178	177	201	0	201	15.00	\N	2026-03-10 09:48:50.633911
179	178	24	0	24	25.00	\N	2026-03-10 09:48:50.633911
180	179	44	0	44	25.00	\N	2026-03-10 09:48:50.633911
181	180	1	0	1	25.00	\N	2026-03-10 09:48:50.633911
182	181	56	0	56	45.00	\N	2026-03-10 09:48:50.633911
183	182	64	0	64	45.00	\N	2026-03-10 09:48:50.633911
184	184	14	0	14	60.00	\N	2026-03-10 09:48:50.633911
185	185	3	0	3	350.00	\N	2026-03-10 09:48:50.633911
186	186	40	0	40	15.00	\N	2026-03-10 09:48:50.633911
187	187	20	0	20	15.00	\N	2026-03-10 09:48:50.633911
188	188	40	0	40	15.00	\N	2026-03-10 09:48:50.633911
189	189	20	0	20	15.00	\N	2026-03-10 09:48:50.633911
190	190	1000	0	1000	10.00	\N	2026-03-10 09:48:50.633911
191	191	34	0	34	55.00	\N	2026-03-10 09:48:50.633911
192	192	13	0	13	60.00	\N	2026-03-10 09:48:50.633911
193	193	9	0	9	75.00	\N	2026-03-10 09:48:50.633911
194	194	5	0	5	140.00	\N	2026-03-10 09:48:50.633911
195	195	4	0	4	120.00	\N	2026-03-10 09:48:50.633911
196	196	34	0	34	35.00	\N	2026-03-10 09:48:50.633911
197	197	42	0	42	25.00	\N	2026-03-10 09:48:50.633911
198	198	66	0	66	10.00	\N	2026-03-10 09:48:50.633911
199	199	15	0	15	10.00	\N	2026-03-10 09:48:50.633911
200	200	17	0	17	15.00	\N	2026-03-10 09:48:50.633911
201	201	17	0	17	15.00	\N	2026-03-10 09:48:50.633911
202	202	35	0	35	95.00	\N	2026-03-10 09:48:50.633911
203	203	429	0	429	200.00	\N	2026-03-10 09:48:50.633911
204	204	96	0	96	5.00	\N	2026-03-10 09:48:50.633911
205	205	194	0	194	5.00	\N	2026-03-10 09:48:50.633911
206	206	5	0	5	30.00	\N	2026-03-10 09:48:50.633911
207	207	29	0	29	65.00	\N	2026-03-10 09:48:50.633911
208	208	50	0	50	65.00	\N	2026-03-10 09:48:50.633911
209	209	24	0	24	50.00	\N	2026-03-10 09:48:50.633911
210	210	21	0	21	40.00	\N	2026-03-10 09:48:50.633911
212	212	15	0	15	15.00	\N	2026-03-10 09:48:50.633911
213	213	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
214	214	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
215	215	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
216	216	3	0	3	180.00	\N	2026-03-10 09:48:50.633911
217	217	3	0	3	590.00	\N	2026-03-10 09:48:50.633911
218	218	3	0	3	1350.00	\N	2026-03-10 09:48:50.633911
219	219	2	0	2	390.00	\N	2026-03-10 09:48:50.633911
220	220	2	0	2	890.00	\N	2026-03-10 09:48:50.633911
221	221	2	0	2	690.00	\N	2026-03-10 09:48:50.633911
222	222	2	0	2	990.00	\N	2026-03-10 09:48:50.633911
224	224	2	0	2	299.00	\N	2026-03-10 09:48:50.633911
225	225	1	0	1	1690.00	\N	2026-03-10 09:48:50.633911
226	226	7	0	7	1350.00	\N	2026-03-10 09:48:50.633911
228	228	7	0	7	1350.00	\N	2026-03-10 09:48:50.633911
211	211	4	0	4	15.00	2026-03-10 13:22:46.821769	2026-03-10 13:22:46.821769
223	223	0	0	0	2000.00	2026-03-10 13:22:46.821769	2026-03-10 13:22:46.821769
227	227	3	0	3	1350.00	2026-03-10 13:22:46.821769	2026-03-10 13:24:19.242484
229	229	3	0	3	420.00	2026-03-13 02:51:55.309857	2026-03-13 02:51:55.309857
\.


--
-- Data for Name: inventory_issue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_issue (id, issue_no, issue_date, requisition_id, requesting_department, status, issued_by, approved_by, note, created_at, requesting_department_code) FROM stdin;
1	ISS-1772878855829	2026-03-07 10:20:55.829	2	กลุ่มงานบริหารทั่วไป	POSTED	warehouse-admin	warehouse-admin	\N	2026-03-07 17:20:55.832108	0001
2	ISS-1772881226714	2026-03-07 11:00:26.714	4	กลุ่มงานบริหารทั่วไป	POSTED	warehouse-admin	warehouse-admin	\N	2026-03-07 18:00:26.716281	0001
3	ISS-1773039695336	2026-03-09 07:01:35.336	6	กลุ่มงานบริหารทั่วไป	POSTED	warehouse-admin	warehouse-admin	\N	2026-03-09 14:01:35.338289	0001
4	ISS-1773041993017	2026-03-09 07:39:53.017	1	กลุ่มงานบริหารทั่วไป	POSTED	warehouse-admin	warehouse-admin	\N	2026-03-09 14:39:53.01793	0001
5	ISS-1773123766822	2026-03-10 06:22:46.822	10	กลุ่มงานบริหารทั่วไป	POSTED	warehouse-admin	warehouse-admin	\N	2026-03-10 13:22:46.821769	0001
6	ISS-1773123887168	2026-03-10 06:24:47.168	4	กลุ่มงานบริหารทั่วไป	POSTED	warehouse-admin	warehouse-admin	\N	2026-03-10 13:24:47.169769	0001
\.


--
-- Data for Name: inventory_issue_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_issue_item (id, issue_id, requisition_item_id, inventory_item_id, issued_qty, unit_cost, total_cost) FROM stdin;
1	1	2	2	1	60.00	60.00
2	2	4	4	1	850.00	850.00
3	3	6	8	1	990.00	990.00
4	4	1	1	1	35.00	35.00
5	5	11	211	20	15.00	300.00
6	5	12	227	4	1350.00	5400.00
7	5	13	223	2	2000.00	4000.00
8	6	4	4	1	850.00	850.00
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_item (id, product_code, product_name, category, product_type, product_subtype, unit, warehouse_id, location_id, lot_no, expiry_date, standard_cost, is_active, created_at, updated_at) FROM stdin;
1	P230-000438	กระดาษเทอร์มอล สำหรับเครื่อง EDC ขนาด 57*40 มม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	35.00	t	2026-03-07 16:47:53.514728	2026-03-07 16:47:53.514728
2	P230-000440	กระดาษเทอร์มอล ขนาด 80*80 มม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	60.00	t	2026-03-07 17:19:22.144226	2026-03-07 17:19:22.144226
3	P230-001093	หมึก Printer Laser TN-2560	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	1390.00	t	2026-03-07 17:28:17.098202	2026-03-07 17:28:17.098202
4	P230-000937	หมึก Printer Laser PANTUM P2500	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	850.00	t	2026-03-07 17:53:32.450051	2026-03-07 17:53:32.450051
5	P230-001114	หมึก Printer Laser FUJI-XEROX CT202877 สีดำ	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	980.00	t	2026-03-07 18:04:06.555924	2026-03-07 18:04:06.555924
6	P230-000341	น้ำดื่ม ชนิดบรรจุแกลลอน ขนาด 18 ลิตร	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ถัง	1	\N	\N	\N	9.00	t	2026-03-07 18:17:31.840867	2026-03-07 18:17:31.840867
7	P230-000064	กระดาษเช็ดมือ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	1	\N	\N	\N	42.00	t	2026-03-07 18:29:36.711476	2026-03-07 18:29:36.711476
8	P230-000040	หมึก Printer Laser 107A	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	990.00	t	2026-03-09 13:59:07.611971	2026-03-09 13:59:07.611971
9	P230-000089	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีดำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	39.00	t	2026-03-09 14:37:30.189301	2026-03-09 14:37:30.189301
10	P230-000020	คีย์บอร์ด แบบ USB	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	320.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
11	P230-000021	ซองใส่ CD แบบใส (50 ซอง/แพค)	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	แพค	1	\N	\N	\N	70.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
12	P230-000022	ผ้าหมึก Printer ชนิดแคร่สั้น แบบ LQ300	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	170.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
13	P230-000023	ผ้าหมึก Printer ชนิดแคร่สั้น แบบ LQ310	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	150.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
14	P230-000024	แผ่น CD-R (50 ซอง/แพค)	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หลอด	1	\N	\N	\N	280.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
15	P230-000027	หมึก Printer Ink jet GT53 สีดำ	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	0.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
16	P230-000028	หมึก Printer Ink jet GT52 สีชมพู	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	390.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
17	P230-000029	หมึก Printer Ink jet GT52 สีฟ้า	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	390.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
18	P230-000030	หมึก Printer Ink jet GT52 สีเหลือง	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	390.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
19	P230-000031	หมึก Printer Ink jet L5190 สีชมพู	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
20	P230-000032	หมึก Printer Ink jet L5190 สีดำ	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
21	P230-000033	หมึก Printer Ink jet L5190 สีฟ้า	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
22	P230-000034	หมึก Printer Ink jet L5190 สีเหลือง	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
23	P230-000035	หมึก Printer Ink jet T6641 สีดำ	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
24	P230-000036	หมึก Printer Ink jet T6641 สีฟ้า	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
25	P230-000037	หมึก Printer Ink jet T6641 สีชมพู	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
26	P230-000038	หมึก Printer Ink jet T6641 สีเหลือง	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
27	P230-000042	หมึก Printer Laser 30A	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	890.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
28	P230-000044	หมึก Printer Laser 472	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	980.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
29	P230-000047	หมึก Printer Laser 83A	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	390.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
30	P230-000049	หมึก Printer Laser Fuji m285Z P235	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	980.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
31	P230-000057	หมึก Printer Ink jet Epson 003 สีชมพู	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
32	P230-000059	หมึก Printer Ink jet Epson 003 สีฟ้า	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
33	P230-000060	หมึก Printer Ink jet Epson 003 สีเหลือง	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
34	P230-000062	กระดาษชำระ ขนาดเล็ก	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	1	\N	\N	\N	6.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
35	P230-000063	กระดาษชำระ ชนิดม้วน แบบ 2 ชั้น ขนาดยาว 300 เมตร	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
36	P230-000069	ก้อนดับกลิ่น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
37	P230-000071	แก้วน้ำ แบบทรงสูง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
38	P230-000073	แก้วน้ำ ชนิดพลาสติก ขนาด 6 ออนซ์	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1	\N	\N	\N	1.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
39	P230-000074	แก้วน้ำ ชนิดอลูมิเนียม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
40	P230-000076	ขันน้ำ ชนิดพลาสติก แบบมีด้าม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
41	P230-000079	ช้อน ชนิดสแตนเลส แบบสั้น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	โหล	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
42	P230-000080	เชือก ชนิดปอแก้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	1	\N	\N	\N	50.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
43	P230-000082	ด้ามมีดโกน ชนิดพลาสติก แบบใช้แล้วทิ้ง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
44	P230-000087	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีเขียว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
45	P230-000088	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีเขียว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
46	P230-000090	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีดำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	50.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
47	P230-000092	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีแดง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	70.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
48	P230-000093	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีแดง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	70.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
49	P230-000094	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีเหลือง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	70.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
50	P230-000095	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีเหลือง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
51	P230-000098	ถุง ชนิดพลาสติก ขนาด 16*26 นิ้ว สีใส	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
52	P230-000099	ถุง ชนิดพลาสติก ขนาด 4.5*7 นิ้ว สีใส	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
53	P230-000100	ถุง ชนิดพลาสติก ขนาด 6*9 นิ้ว สีใส	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
54	P230-000101	ถุง ชนิดพลาสติก ขนาด 8*12 นิ้ว สีใส	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
55	P230-000103	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ L	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	120.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
56	P230-000106	ถุงมือ ชนิดยาง เบอร์ L สีส้ม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
57	P230-000107	ถุงมือ ชนิดยาง เบอร์ M สีส้ม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
58	P230-000111	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*24 นิ้ว สีขาว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
59	P230-000112	ถุงหิ้ว ชนิดพลาสติก ขนาด 15*30 นิ้ว สีขาว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
60	P230-000113	ถุงหิ้ว ชนิดพลาสติก ขนาด 8*16 นิ้ว สีขาว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
61	P230-000114	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*26 นิ้ว สีขาว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
62	P230-000115	ที่ตักขยะ ชนิดพลาสติก แบบมีด้ามจับ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
63	P230-000116	ที่ตักขยะสังกะสี ชนิดสังกะสี แบบมีด้ามจับ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
64	P230-000119	น้ำยา สำหรับเช็ดกระจก	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	1	\N	\N	\N	130.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
65	P230-000121	น้ำยา ชนิดสูตรน้ำ สำหรับดันฝุ่น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	1	\N	\N	\N	370.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
66	P230-000122	น้ำยา ชนิดสูตรน้ำมันใส สำหรับดันฝุ่น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	1	\N	\N	\N	430.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
67	P230-000123	น้ำยา สำหรับทำความสะอาดพื้น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	1	\N	\N	\N	200.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
68	P230-000124	น้ำยา สำหรับล้างจาน	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	1	\N	\N	\N	120.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
69	P230-000125	น้ำยา สำหรับล้างมือ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	1	\N	\N	\N	180.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
70	P230-000127	ใบมีดโกน แบบ 2 คม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่อง	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
71	P230-000128	ปืนยิงแก๊ส	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
72	P230-000129	แป้งฝุ่น สำหรับเด็ก ขนาด 180 กรัม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
73	P230-000130	แปรง ชนิดทองเหลือง สำหรับขัดพื้น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	120.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
74	P230-000131	แปรง ชนิดพลาสติก สำหรับขัดพื้นแบบมีด้ามยาว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	70.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
75	P230-000132	แปรง ชนิดพลาสติก สำหรับขัดห้องน้ำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
76	P230-000133	แปรง ชนิดขนอ่อน สำหรับซักผ้า	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
77	P230-000135	ผงซักฟอก ขนาด 800 กรัม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง	1	\N	\N	\N	70.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
78	P230-000138	ผ้าม็อบ สำหรับถูพื้น แบบเปียก ขนาด 12 นิ้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	1	\N	\N	\N	80.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
79	P230-000139	ผ้าห่ม สำหรับถูพื้น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	1	\N	\N	\N	160.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
80	P230-000141	ฝอย ชนิดแสตนเลส ขนาด 14 กรัม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
81	P230-000148	ไม้กวาด ชนิดดอกหญ้า	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	50.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
82	P230-000149	ไม้กวาด ชนิดทางมะพร้าว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
83	P230-000150	ไม้กวาด ชนิดทางมะพร้าว สำหรับกวาดหยากไย่	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
84	P230-000151	ไม้กวาด ชนิดพลาสติก สำหรับกวาดหยากไย่ แบบปรับระดับได้	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
85	P230-000152	ไม้ดันฝุ่น แบบด้ามไม้ พร้อมผ้าดันฝุ่น ขนาดยาว 24 นิ้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	450.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
86	P230-000153	ไม้ดันฝุ่น แบบด้ามอลูมิเนียม ขนาดยาว 24 นิ้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	300.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
87	P230-000154	ไม้ถูพื้น ขนาด 10 นิ้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	130.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
88	P230-000155	ไม้ปัดขนไก่ แบบด้ามพลาสติก	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	160.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
89	P230-000156	ไม้ยางรีดน้ำ ขนาด 18 นิ้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	295.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
90	P230-000157	ยางวง แบบเส้นเล็ก ขนาด 500 กรัม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ห่อ	1	\N	\N	\N	110.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
91	P230-000158	ยางวง แบบเส้นใหญ่ ขนาด 500 กรัม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ห่อ	1	\N	\N	\N	110.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
92	P230-000159	รองเท้า แบบบู๊ท เบอร์ 10 สีดำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	145.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
93	P230-000161	รองเท้า แบบบู๊ท เบอร์ 11 สีดำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	145.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
94	P230-000162	รองเท้า แบบบู๊ท เบอร์ 11.5 สีดำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	145.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
95	P230-000163	รองเท้า แบบบู๊ท เบอร์ 12 สีดำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	145.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
96	P230-000164	รองเท้า ชนิดฟองน้ำ เบอร์ 10	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
97	P230-000165	รองเท้า ชนิดฟองน้ำ เบอร์ 11	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
98	P230-000167	รองเท้า ชนิดยางพารา เบอร์ L	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
99	P230-000168	รองเท้า ชนิดยางพารา เบอร์ LL	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
100	P230-000169	รองเท้า ชนิดยางพารา เบอร์ M	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
101	P230-000170	รองเท้า ชนิดยางพารา เบอร์ XL	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
102	P230-000171	ลังถึง เบอร์ 36	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	1	\N	\N	\N	800.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
103	P230-000172	สก็อตไบร์ท แบบแผ่นเล็ก ขนาด 4.5*6 นิ้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แผ่น	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
104	P230-000174	สบู่ แบบก้อนเล็ก ขนาด 10 กรัม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อน	1	\N	\N	\N	2.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
105	P230-000175	สบู่ แบบก้อนใหญ่	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อน	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
106	P230-000177	สเปรย์ ชนิดสูตรน้ำ สำหรับฉีดมด ยุง ขนาด 600 มล.	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	1	\N	\N	\N	130.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
107	P230-000178	สเปรย์ สำหรับปรับอากาศ ขนาด 300 มล.	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	1	\N	\N	\N	58.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
108	P230-000183	เหยือกน้ำ ชนิดพลาสติก ขนาด 1,000 ซีซี	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1	\N	\N	\N	100.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
109	P230-000184	เอี๊ยม ชนิดพลาสติก แบบใช้แล้วทิ้ง ขนาดบรรจุ 100 ชิ้น/ถุง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง	1	\N	\N	\N	350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
110	P230-000343	น้ำหวาน สำหรับผู้ป่วยเบาหวาน สีแดง	วัสดุใช้ไป	วัสดุบริโภค	วัสดุบริโภค	ขวด	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
111	P230-000344	ไฟฉาย แบบหลอด LED	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กระบอก	1	\N	\N	\N	160.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
112	P230-000347	ถ่าน ชนิดอัลคาไลน์ ขนาด 9V	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	130.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
113	P230-000348	ถ่าน ชนิดธรรมดา ขนาด AA	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	10.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
114	P230-000349	ถ่าน ชนิดอัลคาไลน์ ขนาด AA	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	20.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
115	P230-000350	ถ่าน ชนิดธรรมดา ขนาด AAA	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	10.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
116	P230-000351	ถ่าน ชนิดอัลคาไลน์ ขนาด AAA	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	20.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
117	P230-000352	ถ่าน ชนิดอัลคาไลน์ ขนาดกลาง C	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	50.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
118	P230-000353	ถ่าน ชนิดธรรมดา ขนาดใหญ่ D	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	16.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
119	P230-000355	ปลั๊กไฟพ่วง แบบ 4 ช่อง 4 สวิตซ์ ยาว 3 เมตร	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	1	\N	\N	\N	410.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
120	P230-000421	กบเหลาดินสอ แบบหมุน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	265.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
121	P230-000422	กรรไกร ขนาด 8 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	85.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
122	P230-000424	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีขาว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	110.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
123	P230-000425	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีเขียว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	110.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
124	P230-000426	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีชมพู	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	110.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
125	P230-000428	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีเหลือง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	110.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
126	P230-000429	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
127	P230-000430	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1 นิ้ว 24x25 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
128	P230-000431	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1.5 นิ้ว 36x20 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
129	P230-000433	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 2 นิ้ว 20 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
130	P230-000435	กระดาษคาร์บอน สีน้ำเงิน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	150.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
131	P230-000436	กระดาษต่อเนื่อง แบบ 1 ชั้น ขนาด 15x11 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	2000.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
132	P230-000437	กระดาษถ่ายเอกสาร ขนาด A4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	1	\N	\N	\N	120.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
133	P230-000439	กระดาษเทอร์มอล สำหรับเครื่องวัดความดัน ขนาด 57*55 มม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	50.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
134	P230-000442	กระดาษบวกเลข สำหรับเครื่องคิดเลข ขนาด 2 1/4 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	10.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
135	P230-000443	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีเขียว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
136	P230-000444	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีชมพู	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
137	P230-000445	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีฟ้า	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
138	P230-000446	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีเหลือง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
139	P230-000447	กระดาษโรเนียว หนา 70 แกรม ขนาด A4 สีขาว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	1	\N	\N	\N	120.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
140	P230-000448	กระดาษโรเนียว หนา 80 แกรม ขนาด F4 สีขาว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	1	\N	\N	\N	130.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
141	P230-000451	กาว ชนิดแท่ง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่ง	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
142	P230-000452	กาว ชนิดน้ำ แบบป้าย ขนาด 560 ซีซี	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
143	P230-000453	กาว ชนิดน้ำ แบบหัวโฟม ขนาด 50 ซีซี	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่ง	1	\N	\N	\N	20.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
144	P230-000455	คลิปหนีบกระดาษ ขนาด #108 สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	55.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
145	P230-000456	คลิปหนีบกระดาษ ขนาด #109 สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	40.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
146	P230-000457	คลิปหนีบกระดาษ ขนาด #110 สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
147	P230-000458	คลิปหนีบกระดาษ ขนาด #111 สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	20.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
148	P230-000460	เครื่องคิดเลข ชนิด 2 ระบบ แบบ 12 หลัก	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	850.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
149	P230-000461	เครื่องเจาะกระดาษ แบบเจาะ 25 แผ่น	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	200.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
150	P230-000462	เครื่องเย็บกระดาษ ขนาด NO.10	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	85.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
151	P230-000463	เครื่องเย็บกระดาษ ขนาด NO.35	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	360.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
152	P230-000464	เชือก ชนิดพลาสติก ขนาดใหญ่ ยาว 180 ม. สี่ขาว-แดง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
153	P230-000465	ซองขาว แบบมีครุฑ ขนาด #9/125	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	1	\N	\N	\N	1.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
154	P230-000466	ซองน้ำตาล แบบมีครุฑ ขยายข้าง หนาพิเศษ ขนาด A4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	1	\N	\N	\N	4.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
155	P230-000467	ซองน้ำตาล แบบมีครุฑ ไม่ขยายข้าง หนาพิเศษ ขนาด A4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	1	\N	\N	\N	4.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
183	P230-000525	แปรง สำหรับลบกระดานไวท์บอร์ด	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
156	P230-000468	ซองน้ำตาล แบบมีครุฑ ขยายข้าง หนาพิเศษ ขนาด F4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	1	\N	\N	\N	4.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
157	P230-000470	ตรายาง สำหรั้บปั๊มวันที่ภาษาไทย	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
158	P230-000471	ตรายาง สำหรั้บปั๊มวันที่เลขไทย	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
159	P230-000474	เทปกาว ชนิด OPP ขนาด 2 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
160	P230-000476	เทปใส แบบแกนเล็ก ขนาด 1 นิ้ว 36 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
161	P230-000477	เทปใส แบบแกนใหญ่ ขนาด 1 นิ้ว 36 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
162	P230-000478	เทปใส แบบแกนใหญ่ ขนาด 2 นิ้ว 45 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
163	P230-000479	เทปใส แบบแกนเล็ก ขนาด 3/4 นิ้ว 36 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
164	P230-000484	แท่นประทับ แบบฝาโลหะ สีดำ #2	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
165	P230-000485	แท่นประทับ แบบฝาโลหะ สีแดง #2	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
166	P230-000486	แท่นประทับ แบบฝาโลหะ สีน้ำเงิน #2	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
167	P230-000492	น้ำยา สำหรับลบคำผิด ขนาด 7 มล.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่ง	1	\N	\N	\N	20.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
168	P230-000503	แบบฟอร์ม ชนิดเคมี 2 ชั้น Doctor's Order แบบต่อเนื่อง เคมี 2 ชั้น 9*11" (1,000 ชุด/กล่อง) ขนาด 9*11 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	2200.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
169	P230-000505	แบบฟอร์ม ปรอท แบบพิมพ์ 2 สี หนา 70 แกรม ขนาด A4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	400.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
170	P230-000506	ใบมีดคัตเตอร์ ขนาดเล็ก	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	20.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
171	P230-000507	ใบมีดคัตเตอร์ ขนาดใหญ่	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
172	P230-000509	แบบฟอร์ม ใบรับรองแพทย์ กรณีสมัครงาน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
173	P230-000510	แบบฟอร์ม ใบเสร็จรับเงิน (1,000 ชุด/กล่อง)	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	1600.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
174	P230-000514	ปากกา เขียนแผ่น CD สีน้ำเงิน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	40.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
175	P230-000515	ปากกา เคมี แบบ 2 หัว สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
176	P230-000516	ปากกา เคมี แบบ 2 หัว สีแดง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
177	P230-000517	ปากกา เคมี แบบ 2 หัว สีน้ำเงิน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
178	P230-000518	ปากกา ไวท์บอร์ด ตราม้า สีแดง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
179	P230-000521	ปากกา ไวท์บอร์ด ตราม้า สีน้ำเงิน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
180	P230-000522	ปากกา ไวท์บอร์ด PILOT สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
181	P230-000523	ป้ายลาเบล ชนิดสติ๊กเกอร์ ขนาด A5	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
182	P230-000524	ป้ายลาเบล ชนิดสติ๊กเกอร์ ขนาด A7	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
184	P230-000530	พลาสติกเคลือบบัตร ขนาด 6*95 ซม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
185	P230-000531	พลาสติกเคลือบบัตร หนา 125 ไมครอน ขนาด A4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
186	P230-000533	แฟ้ม แบบแขวน สีเขียว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
187	P230-000534	แฟ้ม แบบแขวน สีฟ้า	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
188	P230-000535	แฟ้ม แบบแขวน สีส้ม	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
189	P230-000536	แฟ้ม แบบแขวน สีเหลือง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
190	P230-000537	แฟ้ม เวชระเบียน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	10.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
191	P230-000538	แฟ้ม แบบสันแข็ง ขนาด 1 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	55.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
192	P230-000539	แฟ้ม แบบสันแข็ง ขนาด 2 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
193	P230-000540	แฟ้ม แบบสันแข็ง ขนาด 3 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	75.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
194	P230-000541	แฟ้ม เสนอเซ็นต์ ขนาด F4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	140.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
195	P230-000542	แฟ้ม ชนิดปกพลาสติก แบบหนีบ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	120.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
196	P230-000543	มีดคัตเตอร์ ชนิดด้ามสแตนเลส ขนาดเล็ก	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
197	P230-000544	มีดคัตเตอร์ ชนิดด้ามพลาสติก ขนาดใหญ่	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
198	P230-000546	ลวดเย็บกระดาษ เบอร์ 10	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	10.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
199	P230-000548	ลวดเย็บกระดาษ เบอร์ 35	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	10.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
200	P230-000550	ลวดเสียบกระดาษ ขนาดเล็ก เบอร์ 1	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
201	P230-000551	ลวดเสียบกระดาษ ขนาดใหญ่ เบอร์ 0	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
202	P230-000553	ลิ้นแฟ้ม ชนิดเหล็ก	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
203	P230-000560	สติ๊กเกอร์ แบบต่อเนื่อง สำหรับพิมพ์ชื่อผู้ป่วย ขนาด 6*2.5 ซม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	200.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
204	P230-000561	สติ๊กเกอร์ สำหรับติดชาร์ทผู้ป่วย สีฟ้า	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	1	\N	\N	\N	5.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
205	P230-000562	สติ๊กเกอร์ สำหรับติดชาร์ทผู้ป่วย สีเหลือง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	1	\N	\N	\N	5.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
206	P230-000566	สมุด ชนิดปกสี คู่มือเบิกจ่ายในราชการ 301	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
207	P230-000568	สมุด ชนิดหุ้มปก สำหรับทะเบียนหนังสือรับ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
208	P230-000569	สมุด ชนิดหุ้มปก สำหรับทะเบียนหนังสือส่ง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
209	P230-000572	สมุด ชนิดหุ้มปก แบบปกน้ำเงิน เบอร์ 1 หุ้มปก ขนาด 24x35 ซม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	1	\N	\N	\N	50.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
210	P230-000573	สมุด ชนิดหุ้มปก แบบปกน้ำเงิน เบอร์ 2 หุ้มปก ขนาด 19x31 ซม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	1	\N	\N	\N	40.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
211	P230-000578	หมึกเติม สำหรับแท่นประทับตรายาง สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
212	P230-000579	หมึกเติม สำหรับแท่นประทับตรายาง สีแดง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
213	P230-000712	หมึก Printer Ink jet BT5000C สีฟ้า	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
214	P230-000713	หมึก Printer Ink jet BT5000M สีชมพู	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
215	P230-000714	หมึก Printer Ink jet BT5000Y สีเหลือง	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
216	P230-000784	Flash drive แบบ USB ขนาด 16 Gb	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	180.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
217	P230-000938	หมึก Printer Laser BROTHER FAX2950	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	590.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
218	P230-000940	Power supply ขนาด 550W	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	1350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
219	P230-000942	สาย HDMI ชนิด 4K ขนาด 5 เมตร	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	1	\N	\N	\N	390.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
220	P230-000943	สาย HDMI ชนิด 4K ขนาด 10 เมตร	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	1	\N	\N	\N	890.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
221	P230-000944	กล่องใส่ Hardisk ขนาด 2.5 นิ้ว	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	690.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
222	P230-000945	คีม สำหรับเข้าหัว LAN	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	990.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
223	P230-000987	Hardisk External ขนาด 1 Tb	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	2000.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
224	P230-000989	MP3 player แบบ USB ขนาด 512 MB	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	299.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
225	P230-001106	Hardisk ชนิด SSD Internal ขนาด 500 Gb	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	1690.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
226	P230-001115	หมึก Printer Laser FUJI-XEROX CT203486 สีดำ	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	1350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
227	P230-001116	หมึก Printer Laser FUJI-XEROX CT203486 สีชมพู	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	1350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
228	P230-001117	หมึก Printer Laser FUJI-XEROX CT203486 สีเหลือง	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	1350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
229	P230-001174	พาน สำหรับจัดดอกไม้	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	420.00	t	2026-03-13 02:51:55.309857	2026-03-13 02:51:55.309857
\.


--
-- Data for Name: inventory_location; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_location (id, warehouse_id, location_code, location_name, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: inventory_movement; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_movement (id, inventory_item_id, movement_date, movement_type, qty_in, qty_out, unit_cost, total_cost, balance_qty_after, balance_value_after, reference_type, reference_id, reference_no, source_department, target_department, note, created_by, created_at) FROM stdin;
1	1	2026-03-07 09:47:53.516	PURCHASE_APPROVAL_RECEIPT	100	0	35.00	3500.00	100	3500.00	InventoryReceipt	1	IR-1772876873516	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 16:47:53.514728
2	2	2026-03-07 10:19:22.146	PURCHASE_APPROVAL_RECEIPT	200	0	60.00	12000.00	200	12000.00	InventoryReceipt	2	IR-1772878762146	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 17:19:22.144226
3	2	2026-03-07 10:20:55.829	ISSUE_APPROVED	0	1	60.00	60.00	199	11940.00	InventoryIssue	1	ISS-1772878855829	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-07 17:20:55.832108
4	3	2026-03-07 10:28:17.1	PURCHASE_APPROVAL_RECEIPT	5	0	1390.00	6950.00	5	6950.00	InventoryReceipt	3	IR-1772879297100	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 17:28:17.098202
5	2	2026-03-07 17:46:04.360453	REQUISITION_RESERVE	0	0	60.00	0.00	199	11940.00	InventoryRequisition	3	REQ-1772879277656	\N	กลุ่มงานบริหารทั่วไป	Reserved 1 items	Admin	2026-03-07 17:46:04.360453
6	2	2026-03-07 17:46:24.429834	REQUISITION_UNRESERVE	0	0	60.00	0.00	199	11940.00	InventoryRequisition	3	REQ-1772879277656	\N	กลุ่มงานบริหารทั่วไป	Unreserved 1 items due to cancellation	Admin	2026-03-07 17:46:24.429834
7	4	2026-03-07 10:53:32.451	PURCHASE_APPROVAL_RECEIPT	5	0	850.00	4250.00	5	4250.00	InventoryReceipt	4	IR-1772880812451	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 17:53:32.450051
8	4	2026-03-07 17:58:31.161224	REQUISITION_RESERVE	0	0	850.00	0.00	5	4250.00	InventoryRequisition	4	REQ-1772881083435	\N	กลุ่มงานบริหารทั่วไป	Reserved 2 items	Test User	2026-03-07 17:58:31.161224
9	4	2026-03-07 11:00:26.714	ISSUE_APPROVED	0	1	850.00	850.00	4	3400.00	InventoryIssue	2	ISS-1772881226714	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-07 18:00:26.716281
10	5	2026-03-07 11:04:06.558	PURCHASE_APPROVAL_RECEIPT	10	0	980.00	9800.00	10	9800.00	InventoryReceipt	5	IR-1772881446558	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 18:04:06.555924
11	6	2026-03-07 11:17:31.847	PURCHASE_APPROVAL_RECEIPT	529	0	9.00	4761.00	529	4761.00	InventoryReceipt	6	IR-1772882251847	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 18:17:31.840867
12	4	2026-03-07 11:29:22.612	PURCHASE_APPROVAL_RECEIPT	2	0	850.00	1700.00	6	5100.00	InventoryReceipt	7	IR-1772882962612	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 18:29:22.602531
13	7	2026-03-07 11:29:36.726	PURCHASE_APPROVAL_RECEIPT	600	0	42.00	25200.00	600	25200.00	InventoryReceipt	8	IR-1772882976726	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 18:29:36.711476
14	6	2026-03-07 18:31:01.286754	REQUISITION_RESERVE	0	0	9.00	0.00	529	4761.00	InventoryRequisition	5	REQ-1772882639640	\N	กลุ่มงานบริหารทั่วไป	Reserved 1 items	\N	2026-03-07 18:31:01.286754
15	8	2026-03-09 06:59:07.619	PURCHASE_APPROVAL_RECEIPT	20	0	990.00	19800.00	20	19800.00	InventoryReceipt	9	IR-1773039547618	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-09 13:59:07.611971
16	8	2026-03-09 14:00:49.718026	REQUISITION_RESERVE	0	0	990.00	0.00	20	19800.00	InventoryRequisition	6	REQ-1773039629252	\N	กลุ่มงานบริหารทั่วไป	Reserved 1 items	chrome-mcp-test	2026-03-09 14:00:49.718026
17	8	2026-03-09 07:01:35.336	ISSUE_APPROVED	0	1	990.00	990.00	19	18810.00	InventoryIssue	3	ISS-1773039695336	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-09 14:01:35.338289
18	6	2026-03-09 14:03:03.873062	REQUISITION_UNRESERVE	0	0	9.00	0.00	529	4761.00	InventoryRequisition	5	REQ-1772882639640	\N	กลุ่มงานบริหารทั่วไป	Unreserved 1 items due to cancellation	\N	2026-03-09 14:03:03.873062
19	8	2026-03-09 14:15:48.631119	REQUISITION_RESERVE	0	0	990.00	0.00	19	18810.00	InventoryRequisition	7	REQ-1773040521512	\N	กลุ่มงานบริหารทั่วไป	Reserved 1 items	test-approver	2026-03-09 14:15:48.631119
20	8	2026-03-09 14:15:53.577616	REQUISITION_UNRESERVE	0	0	990.00	0.00	19	18810.00	InventoryRequisition	7	REQ-1773040521512	\N	กลุ่มงานบริหารทั่วไป	Unreserved 1 items due to cancellation	test-user	2026-03-09 14:15:53.577616
21	9	2026-03-09 07:37:30.195	PURCHASE_APPROVAL_RECEIPT	210	0	39.00	8190.00	210	8190.00	InventoryReceipt	10	IR-1773041850195	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-09 14:37:30.189301
22	9	2026-03-09 14:38:42.061156	REQUISITION_RESERVE	0	0	39.00	0.00	210	8190.00	InventoryRequisition	8	REQ-1773041913295	\N	กลุ่มงานบริหารทั่วไป	Reserved 5 items	ผู้ทดสอบ TEST	2026-03-09 14:38:42.061156
23	9	2026-03-09 14:38:57.533975	REQUISITION_UNRESERVE	0	0	39.00	0.00	210	8190.00	InventoryRequisition	8	REQ-1773041913295	\N	กลุ่มงานบริหารทั่วไป	Unreserved 5 items due to cancellation	ผู้ทดสอบ TEST	2026-03-09 14:38:57.533975
24	1	2026-03-09 07:39:53.017	ISSUE_APPROVED	0	1	35.00	35.00	99	3465.00	InventoryIssue	4	ISS-1773041993017	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-09 14:39:53.01793
25	211	2026-03-10 13:16:41.994388	REQUISITION_RESERVE	0	0	15.00	0.00	24	360.00	InventoryRequisition	10	REQ-1773123276560	\N	กลุ่มงานบริหารทั่วไป	Reserved 20 items	\N	2026-03-10 13:16:41.994388
26	227	2026-03-10 13:16:41.994388	REQUISITION_RESERVE	0	0	1350.00	0.00	7	9450.00	InventoryRequisition	10	REQ-1773123276560	\N	กลุ่มงานบริหารทั่วไป	Reserved 5 items	\N	2026-03-10 13:16:41.994388
27	223	2026-03-10 13:16:41.994388	REQUISITION_RESERVE	0	0	2000.00	0.00	2	4000.00	InventoryRequisition	10	REQ-1773123276560	\N	กลุ่มงานบริหารทั่วไป	Reserved 2 items	\N	2026-03-10 13:16:41.994388
28	211	2026-03-10 06:22:46.822	ISSUE_APPROVED	0	20	15.00	300.00	4	60.00	InventoryIssue	5	ISS-1773123766822	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-10 13:22:46.821769
29	227	2026-03-10 06:22:46.822	ISSUE_APPROVED	0	4	1350.00	5400.00	3	4050.00	InventoryIssue	5	ISS-1773123766822	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-10 13:22:46.821769
30	223	2026-03-10 06:22:46.822	ISSUE_APPROVED	0	2	2000.00	4000.00	0	0.00	InventoryIssue	5	ISS-1773123766822	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-10 13:22:46.821769
31	227	2026-03-10 13:24:19.242484	REQUISITION_UNRESERVE	0	0	1350.00	0.00	3	4050.00	InventoryRequisition	10	REQ-1773123276560	\N	กลุ่มงานบริหารทั่วไป	Unreserved 1 items due to cancellation	\N	2026-03-10 13:24:19.242484
32	4	2026-03-10 06:24:47.168	ISSUE_APPROVED	0	1	850.00	850.00	5	4250.00	InventoryIssue	6	ISS-1773123887168	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-10 13:24:47.169769
33	229	2026-03-13 00:00:00	PURCHASE_APPROVAL_RECEIPT	3	0	420.00	1260.00	3	1260.00	InventoryReceipt	11	REC2026000300	กลุ่มงานบริหารทั่วไป	\N	Test receipt from frontend	FRONTEND_TEST	2026-03-13 02:51:55.309857
\.


--
-- Data for Name: inventory_period; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_period (id, period_year, period_month, status, closed_at, closed_by, created_at) FROM stdin;
\.


--
-- Data for Name: inventory_period_balance; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_period_balance (id, period_id, inventory_item_id, opening_qty, opening_value, closing_qty, closing_value) FROM stdin;
\.


--
-- Data for Name: inventory_receipt; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_receipt (id, receipt_no, receipt_date, receipt_type, status, vendor_name, source_reference_type, source_reference_id, source_reference_no, note, created_by, approved_by, created_at, updated_at) FROM stdin;
1	IR-1772876873516	2026-03-07 09:47:53.516	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1218	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 16:47:53.514728	2026-03-07 16:47:53.514728
2	IR-1772878762146	2026-03-07 10:19:22.146	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1217	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 17:19:22.144226	2026-03-07 17:19:22.144226
3	IR-1772879297100	2026-03-07 10:28:17.1	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1216	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 17:28:17.098202	2026-03-07 17:28:17.098202
4	IR-1772880812451	2026-03-07 10:53:32.451	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1215	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 17:53:32.450051	2026-03-07 17:53:32.450051
5	IR-1772881446558	2026-03-07 11:04:06.558	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1214	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 18:04:06.555924	2026-03-07 18:04:06.555924
6	IR-1772882251847	2026-03-07 11:17:31.847	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1212	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 18:17:31.840867	2026-03-07 18:17:31.840867
7	IR-1772882962612	2026-03-07 11:29:22.612	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1083	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 18:29:22.602531	2026-03-07 18:29:22.602531
8	IR-1772882976726	2026-03-07 11:29:36.726	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1211	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 18:29:36.711476	2026-03-07 18:29:36.711476
9	IR-1773039547618	2026-03-09 06:59:07.619	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1213	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-09 13:59:07.611971	2026-03-09 13:59:07.611971
10	IR-1773041850195	2026-03-09 07:37:30.195	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1204	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-09 14:37:30.189301	2026-03-09 14:37:30.189301
11	REC2026000300	2026-03-13 00:00:00	FROM_PURCHASE_APPROVAL	POSTED	Test Vendor	PurchaseApprovalDetail	2	APV2026000300	Test receipt from frontend	FRONTEND_TEST	\N	2026-03-13 02:51:55.309857	2026-03-13 02:51:55.309857
\.


--
-- Data for Name: inventory_receipt_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_receipt_item (id, receipt_id, inventory_item_id, purchase_approval_id, qty, unit_cost, total_cost, lot_no, expiry_date) FROM stdin;
1	11	229	2	3	420.00	1260.00	\N	\N
\.


--
-- Data for Name: inventory_requisition; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_requisition (id, requisition_no, request_date, requesting_department, status, requested_by, approved_by, approved_at, issued_by, issued_at, note, created_at, updated_at, requesting_department_code) FROM stdin;
2	REQ-1772878821224	2026-03-07 10:20:21.224	กลุ่มงานบริหารทั่วไป	ISSUED	Chrome MCP Tester	Chrome MCP Tester	2026-03-07 17:20:28.030484	warehouse-admin	2026-03-07 17:20:55.832108	\N	2026-03-07 17:20:21.225435	2026-03-07 17:20:55.832108	0001
3	REQ-1772879277656	2026-03-07 10:27:57.656	กลุ่มงานบริหารทั่วไป	CANCELLED	Final QA	Admin	2026-03-07 17:46:04.360453	\N	\N	Cancelled by Admin: Testing cancellation functionality	2026-03-07 17:27:57.655035	2026-03-07 17:46:24.429834	0001
6	REQ-1773039629252	2026-03-09 07:00:29.252	กลุ่มงานบริหารทั่วไป	ISSUED	chrome-mcp-test	chrome-mcp-test	2026-03-09 14:00:49.718026	warehouse-admin	2026-03-09 14:01:35.338289	\N	2026-03-09 14:00:29.252755	2026-03-09 14:01:35.338289	0001
5	REQ-1772882639640	2026-03-07 11:23:59.64	กลุ่มงานบริหารทั่วไป	CANCELLED	\N	\N	2026-03-07 18:31:01.286754	\N	\N	Cancelled by System	2026-03-07 18:23:59.640893	2026-03-09 14:03:03.873062	0001
7	REQ-1773040521512	2026-03-09 07:15:21.512	กลุ่มงานบริหารทั่วไป	CANCELLED	test-user	test-approver	2026-03-09 14:15:48.631119	\N	\N	Cancelled by test-user: MCP test cancel	2026-03-09 14:15:21.513147	2026-03-09 14:15:53.577616	0001
8	REQ-1773041913295	2026-03-09 07:38:33.295	กลุ่มงานบริหารทั่วไป	CANCELLED	ผู้ทดสอบ TEST	ผู้ทดสอบ TEST	2026-03-09 14:38:42.061156	\N	\N	Cancelled by ผู้ทดสอบ TEST	2026-03-09 14:38:33.296012	2026-03-09 14:38:57.533975	0001
1	REQ-1772876918097	2026-03-07 09:48:38.097	กลุ่มงานบริหารทั่วไป	ISSUED	warehouse-e2e	warehouse-e2e	2026-03-07 16:48:46.130618	warehouse-admin	2026-03-09 14:39:53.01793	\N	2026-03-07 16:48:38.098043	2026-03-09 14:39:53.01793	0001
9	REQ-1773112176498	2026-03-10 03:09:36.498	กลุ่มงานบริหารทั่วไป	CANCELLED	\N	\N	\N	\N	\N	Cancelled by System	2026-03-10 10:09:36.49971	2026-03-10 10:10:08.637745	0001
10	REQ-1773123276560	2026-03-10 06:14:36.56	กลุ่มงานบริหารทั่วไป	CANCELLED	\N	\N	2026-03-10 13:16:41.994388	warehouse-admin	2026-03-10 13:22:46.821769	Cancelled by System	2026-03-10 13:14:36.563138	2026-03-10 13:24:19.242484	0001
4	REQ-1772881083435	2026-03-07 10:58:03.435	กลุ่มงานบริหารทั่วไป	ISSUED	Test User	Test User	2026-03-07 17:58:31.161224	warehouse-admin	2026-03-10 13:24:47.169769	\N	2026-03-07 17:58:03.435709	2026-03-10 13:24:47.169769	0001
\.


--
-- Data for Name: inventory_requisition_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_requisition_item (id, requisition_id, inventory_item_id, requested_qty, approved_qty, issued_qty, unit_cost_at_issue, line_status, note) FROM stdin;
2	2	2	1	1	1	0.00	ISSUED	\N
3	3	2	1	1	0	0.00	CANCELLED	\N
6	6	8	1	1	1	0.00	ISSUED	\N
5	5	6	1	1	0	0.00	CANCELLED	\N
7	7	8	1	1	0	0.00	CANCELLED	test
8	8	9	5	5	0	0.00	CANCELLED	\N
1	1	1	1	1	1	0.00	ISSUED	\N
9	9	217	1	0	0	0.00	CANCELLED	\N
10	9	218	1	0	0	0.00	CANCELLED	\N
11	10	211	20	20	20	0.00	CANCELLED	\N
12	10	227	5	5	4	0.00	CANCELLED	\N
13	10	223	2	2	2	0.00	CANCELLED	\N
4	4	4	2	2	2	0.00	ISSUED	\N
\.


--
-- Data for Name: inventory_warehouse; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_warehouse (id, warehouse_code, warehouse_name, is_active, created_at, updated_at) FROM stdin;
1	MAIN	คลังกลาง	t	2026-03-07 16:11:02.414296	2026-03-07 16:11:02.414296
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product (id, code, category, name, type, subtype, unit, cost_price, sell_price, stock_balance, stock_value, seller_code, image, flag_activate, admin_note, is_active, purchase_department_id) FROM stdin;
20	P230-000020	วัสดุใช้ไป	คีย์บอร์ด แบบ USB	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	320.00	\N	0	0.00	\N	\N	t	\N	t	1
26	P230-000026	วัสดุใช้ไป	สาย LAN	หหห	หห	ห	0.00	\N	0	0.00	\N	\N	t	\N	t	11
51	P230-000051	วัสดุใช้ไป	หัว LAN	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1400.00	\N	0	0.00	\N	\N	t	\N	t	1
259	P230-000259	วัสดุใช้ไป	ราวพาดผ้า	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	85.00	\N	0	0.00	\N	\N	t	\N	t	11
360	P230-000360	วัสดุใช้ไป	Adaptor ขนาด 12V.	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	265.00	\N	0	0.00	\N	\N	t	\N	t	11
420	P230-000420	วัสดุใช้ไป	สาย VCT	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	1590.00	\N	0	0.00	\N	\N	t	\N	t	4
1269	P230-001269	วัสดุใช้ไป	บล๊อค ชนิด PVC ขนาด 4*4	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	225.00	\N	0	0.00	\N	\N	t	\N	t	4
814	P230-000814	วัสดุใช้ไป	แท่งกราวด์ ขนาด 1.8 ม.	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	160.00	\N	0	0.00	\N	\N	t	\N	t	11
849	P230-000849	วัสดุใช้ไป	HDMI extender	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	1390.00	\N	0	0.00	\N	\N	t	\N	t	4
1323	P230-001323	วัสดุใช้ไป	ฟองน้ำล้างรถ	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	120.00	\N	0	0.00	\N	\N	t	\N	t	1
977	P230-000977	วัสดุใช้ไป	ลวดเย็บกระดาษ เบอร์ 23/10	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	60.00	\N	0	0.00	\N	\N	t	\N	t	4
1025	P230-001025	วัสดุใช้ไป	สกรูปลายสว่าน ขนาด 8 x 1	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	20.00	\N	0	0.00	\N	\N	t	\N	t	4
1029	P230-001029	วัสดุใช้ไป	โคมไฟ ชนิดคู่ แบบออกไก่ ขนาด 2 x 40 watt.	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	320.00	\N	0	0.00	\N	\N	t	\N	t	4
1072	P230-001072	วัสดุใช้ไป	เหล็กนำ STN	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	45.00	\N	0	0.00	\N	\N	t	\N	t	11
21	P230-000021	วัสดุใช้ไป	ซองใส่ CD แบบใส (50 ซอง/แพค)	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	แพค	70.00	\N	0	0.00	\N	\N	t	\N	t	11
344	P230-000344	วัสดุใช้ไป	ไฟฉาย แบบหลอด LED	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กระบอก	160.00	\N	0	0.00	\N	\N	t	\N	t	11
1324	P230-001324	วัสดุใช้ไป	ที่รีดกระจกสำหรับรถยนต์	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	120.00	\N	0	0.00	\N	\N	t	\N	t	4
22	P230-000022	วัสดุใช้ไป	ผ้าหมึก Printer ชนิดแคร่สั้น แบบ LQ300	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	170.00	\N	0	0.00	\N	\N	t	\N	t	1
23	P230-000023	วัสดุใช้ไป	ผ้าหมึก Printer ชนิดแคร่สั้น แบบ LQ310	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	150.00	\N	0	0.00	\N	\N	t	\N	t	4
6	P230-000006	วัสดุใช้ไป	เข่ง ไม้ไผ่	วัสดุการเกษตร	วัสดุการเกษตร	ใบ	120.00	\N	0	0.00	\N	\N	t	\N	t	1
566	P230-000566	วัสดุใช้ไป	สมุด ชนิดปกสี คู่มือเบิกจ่ายในราชการ 301	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	30.00	\N	0	0.00	\N	\N	t	\N	t	11
756	P230-000756	วัสดุใช้ไป	ฝาครอบ ชนิด PVC	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	6.00	\N	0	0.00	\N	\N	t	\N	t	11
1066	P230-001066	วัสดุใช้ไป	สปริงเกอร์	วัสดุการเกษตร	วัสดุการเกษตร	ตัว	17.00	\N	0	0.00	\N	\N	t	\N	t	4
7	P230-000007	วัสดุใช้ไป	ครัช สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	680.00	\N	0	0.00	\N	\N	t	\N	t	1
8	P230-000008	วัสดุใช้ไป	ถ้วยรองใบมีด สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	480.00	\N	0	0.00	\N	\N	t	\N	t	4
9	P230-000009	วัสดุใช้ไป	จานรองประกับใบตัด สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	70.00	\N	0	0.00	\N	\N	t	\N	t	1
10	P230-000010	วัสดุใช้ไป	จานสตาร์ท สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	350.00	\N	0	0.00	\N	\N	t	\N	t	1
11	P230-000011	วัสดุใช้ไป	ลูกยางกดน้ำมัน สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	ลูก	50.00	\N	0	0.00	\N	\N	t	\N	t	4
12	P230-000012	วัสดุใช้ไป	โซ่ สำหรับเลื่อยยนต์ ขนาด 11.5 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	เส้น	630.00	\N	0	0.00	\N	\N	t	\N	t	1
13	P230-000013	วัสดุใช้ไป	กรรไกร ชนิดตัดต้นไม้ต่ำ สำหรับตัดแต่งกิ่ง	วัสดุการเกษตร	วัสดุการเกษตร	อัน	300.00	\N	0	0.00	\N	\N	t	\N	t	11
14	P230-000014	วัสดุใช้ไป	จาระบี สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	กระปุก	120.00	\N	0	0.00	\N	\N	t	\N	t	1
15	P230-000015	วัสดุใช้ไป	ใบมีด สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	100.00	\N	0	0.00	\N	\N	t	\N	t	11
16	P230-000016	วัสดุใช้ไป	เลื่อย ชนิดขอชัก สำหรับตัดแต่งกิ่ง	วัสดุการเกษตร	วัสดุการเกษตร	อัน	300.00	\N	0	0.00	\N	\N	t	\N	t	4
17	P230-000017	วัสดุใช้ไป	สายยาง สำหรับรดน้ำต้นไม้ ขนาด 5/8 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	เส้น	360.00	\N	0	0.00	\N	\N	t	\N	t	4
18	P230-000018	วัสดุใช้ไป	สายสะพาย สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	160.00	\N	0	0.00	\N	\N	t	\N	t	4
19	P230-000019	วัสดุใช้ไป	หัวเทียน สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	30.00	\N	0	0.00	\N	\N	t	\N	t	1
25	P230-000025	วัสดุใช้ไป	เม้าท์ แบบ USB	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	250.00	\N	0	0.00	\N	\N	t	\N	t	1
39	P230-000039	วัสดุใช้ไป	ยกเลิก หมึก Printer Ink jet T7741 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	700.00	\N	0	0.00	\N	\N	f	\N	t	1
40	P230-000040	วัสดุใช้ไป	หมึก Printer Laser 107A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	990.00	\N	0	0.00	\N	\N	t	\N	t	1
41	P230-000041	วัสดุใช้ไป	หมึก Printer Laser 225	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	430.00	\N	0	0.00	\N	\N	t	\N	t	1
43	P230-000043	วัสดุใช้ไป	หมึก Printer Laser 355	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	670.00	\N	0	0.00	\N	\N	t	\N	t	4
45	P230-000045	วัสดุใช้ไป	หมึก Printer Laser 48A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1190.00	\N	0	0.00	\N	\N	t	\N	t	11
2	P230-000002	วัสดุใช้ไป	ด้ามขวาน ชนิดไม้	วัสดุการเกษตร	วัสดุการเกษตร	อัน	100.00	\N	0	0.00			t		t	1
3	P230-000003	วัสดุใช้ไป	ประกับ สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	230.00	\N	0	0.00			t		f	11
4	P230-000004	วัสดุใช้ไป	มีด ชนิดเหล็ก แบบด้ามไม้	วัสดุการเกษตร	วัสดุการเกษตร	เล่ม	250.00	\N	0	0.00			t		t	4
5	P230-000005	วัสดุใช้ไป	สายเอ็น สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	ม้วน	630.00	\N	0	0.00			t		t	4
46	P230-000046	วัสดุใช้ไป	หมึก Printer Laser 79A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	690.00	\N	0	0.00	\N	\N	t	\N	t	11
48	P230-000048	วัสดุใช้ไป	หมึก Printer Laser 85A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	390.00	\N	0	0.00	\N	\N	t	\N	t	1
50	P230-000050	วัสดุใช้ไป	ยกเลิก หมึก Printer Laser TN-2060	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	490.00	\N	0	0.00	\N	\N	f	\N	t	1
52	P230-000052	วัสดุใช้ไป	ยกเลิก Hardisk ชนิด SATA/SSD External ขนาด 1 Tb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1800.00	\N	0	0.00	\N	\N	f	\N	t	1
53	P230-000053	วัสดุใช้ไป	ยกเลิก Hardisk ชนิด Surveillance สำหรับกล้องวงจรปิด (NVR) ขนาด 4 Tb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	3790.00	\N	0	0.00	\N	\N	f	\N	t	4
54	P230-000054	วัสดุใช้ไป	ยกเลิก สาย LAN ชนิด CAT5 ขนาด 305 เมตร/กล่อง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	2750.00	\N	0	0.00	\N	\N	f	\N	t	4
55	P230-000055	วัสดุใช้ไป	ยกเลิก หมึก Printer Laser 230A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	890.00	\N	0	0.00	\N	\N	f	\N	t	4
56	P230-000056	วัสดุใช้ไป	ยกเลิก หัว LAN ชนิด CAT5 10 อัน/pack	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	pack	60.00	\N	0	0.00	\N	\N	f	\N	t	4
414	P230-000414	วัสดุใช้ไป	สายไมค์ แบบพร้อมแจ๊ค	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	155.00	\N	0	0.00	\N	\N	t	\N	t	4
58	P230-000058	วัสดุใช้ไป	หมึก Printer Ink jet Epson 003 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N	t	11
61	P230-000061	วัสดุใช้ไป	กรวยกระดาษ สำหรับดื่มน้ำ ขนาดบรรจุ 5,000 ใบ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ลัง	900.00	\N	0	0.00	\N	\N	t	\N	t	4
64	P230-000064	วัสดุใช้ไป	กระดาษเช็ดมือ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	60.00	\N	0	0.00	\N	\N	t	\N	t	4
65	P230-000065	วัสดุใช้ไป	กระทะไฟฟ้า แบบเคลือบและมีซึ้ง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	1290.00	\N	0	0.00	\N	\N	t	\N	t	4
66	P230-000066	วัสดุใช้ไป	กระป๋องฉีดน้ำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	4
67	P230-000067	วัสดุใช้ไป	กล่องใส่กระดาษเช็ดมือ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	500.00	\N	0	0.00	\N	\N	t	\N	t	11
68	P230-000068	วัสดุใช้ไป	กล่องใส่สบู่เหลว แบบติดผนัง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	300.00	\N	0	0.00	\N	\N	t	\N	t	1
70	P230-000070	วัสดุใช้ไป	เกลือเม็ด	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	12.00	\N	0	0.00	\N	\N	t	\N	t	4
72	P230-000072	วัสดุใช้ไป	แก้วน้ำ ชนิดพลาสติก ขนาด 4 ออนซ์	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1.00	\N	0	0.00	\N	\N	t	\N	t	1
75	P230-000075	วัสดุใช้ไป	ขวดปั๊ม ชนิดพลาสติก สำหรับใส่น้ำยาแอลกอฮอล์	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขวด	40.00	\N	0	0.00	\N	\N	t	\N	t	1
77	P230-000077	วัสดุใช้ไป	ข่า	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	60.00	\N	0	0.00	\N	\N	t	\N	t	4
78	P230-000078	วัสดุใช้ไป	ขิง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	60.00	\N	0	0.00	\N	\N	t	\N	t	1
81	P230-000081	วัสดุใช้ไป	ด้ามมีดโกน ชนิดพลาสติก แบบปลี่ยนใบมีดได้	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	50.00	\N	0	0.00	\N	\N	t	\N	t	1
83	P230-000083	วัสดุใช้ไป	ตะกร้า ชนิดพลาสติก แบบทรงกลม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	250.00	\N	0	0.00	\N	\N	t	\N	t	11
823	P230-000823	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 17 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	155.00	\N	0	0.00	\N	\N	t	\N	t	4
84	P230-000084	วัสดุใช้ไป	ตะไคร้	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	50.00	\N	0	0.00	\N	\N	t	\N	t	11
85	P230-000085	วัสดุใช้ไป	เตา Hotplate แบบใช้ไฟฟ้า ขนาด 9 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ตัว	4000.00	\N	0	0.00	\N	\N	t	\N	t	4
86	P230-000086	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 42 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	890.00	\N	0	0.00	\N	\N	t	\N	t	11
91	P230-000091	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 18*22 นิ้ว สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	60.00	\N	0	0.00	\N	\N	t	\N	t	1
96	P230-000096	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 16*18 นิ้ว สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	60.00	\N	0	0.00	\N	\N	t	\N	t	4
97	P230-000097	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 28*40 นิ้ว สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	60.00	\N	0	0.00	\N	\N	t	\N	t	4
102	P230-000102	วัสดุใช้ไป	ถุงมือ ชนิด PVC	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N	t	1
104	P230-000104	วัสดุใช้ไป	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ M	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	120.00	\N	0	0.00	\N	\N	t	\N	t	4
105	P230-000105	วัสดุใช้ไป	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ L สีเขียว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	120.00	\N	0	0.00	\N	\N	t	\N	t	4
108	P230-000108	วัสดุใช้ไป	ถุงมือ ชนิดยาง แบบอเนกประสงค์ เบอร์ L	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N	t	1
109	P230-000109	วัสดุใช้ไป	ถุงมือ ชนิดยาง แบบอเนกประสงค์ เบอร์ M	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N	t	11
110	P230-000110	วัสดุใช้ไป	ถุง ชนิดพลาสติก ขนาด 30*40 นิ้ว สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	120.00	\N	0	0.00	\N	\N	t	\N	t	4
117	P230-000117	วัสดุใช้ไป	น้ำมันงาสกัดเย็น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขวด	300.00	\N	0	0.00	\N	\N	t	\N	t	4
118	P230-000118	วัสดุใช้ไป	น้ำมันมะพร้าว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	90.00	\N	0	0.00	\N	\N	t	\N	t	11
120	P230-000120	วัสดุใช้ไป	น้ำยา สำหรับซาวผ้า	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	250.00	\N	0	0.00	\N	\N	t	\N	t	1
126	P230-000126	วัสดุใช้ไป	ใบมะกรูด	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	50.00	\N	0	0.00	\N	\N	t	\N	t	1
134	P230-000134	วัสดุใช้ไป	แปรง ชนิดพลาสติก สำหรับล้างขวด	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	25.00	\N	0	0.00	\N	\N	t	\N	t	1
136	P230-000136	วัสดุใช้ไป	ผงซักฟอก สำหรับเครื่องซักผ้า ขนาด 25 กก.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กก.	1050.00	\N	0	0.00	\N	\N	t	\N	t	4
137	P230-000137	วัสดุใช้ไป	ผ้าม็อบ สำหรับดันฝุ่น ขนาด 24 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	200.00	\N	0	0.00	\N	\N	t	\N	t	4
140	P230-000140	วัสดุใช้ไป	แผ่นขัดพื้น ขนาด 18 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	400.00	\N	0	0.00	\N	\N	t	\N	t	1
142	P230-000142	วัสดุใช้ไป	ไพล	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	35.00	\N	0	0.00	\N	\N	t	\N	t	1
143	P230-000143	วัสดุใช้ไป	ฟองน้ำ แบบหุ้มตาข่าย	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	15.00	\N	0	0.00	\N	\N	t	\N	t	11
144	P230-000144	วัสดุใช้ไป	ฟอยล์ ขนาด 18 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	85.00	\N	0	0.00	\N	\N	t	\N	t	1
145	P230-000145	วัสดุใช้ไป	ไฟแช็ค	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	10.00	\N	0	0.00	\N	\N	t	\N	t	4
146	P230-000146	วัสดุใช้ไป	มะกรูด	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	40.00	\N	0	0.00	\N	\N	t	\N	t	11
147	P230-000147	วัสดุใช้ไป	มะนาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	100.00	\N	0	0.00	\N	\N	t	\N	t	11
160	P230-000160	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 10.5 สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N	t	4
187	P230-000187	วัสดุใช้ไป	ผ้าปูที่นอน (ยกเลิก)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	400.00	\N	0	0.00	\N	\N	f	\N	t	4
166	P230-000166	วัสดุใช้ไป	รองเท้า ชนิดฟองน้ำ เบอร์ 11.5	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N	t	4
173	P230-000173	วัสดุใช้ไป	สก็อตไบร์ท แบบแผ่นใหญ่ ขนาด 6*9 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แผ่น	30.00	\N	0	0.00	\N	\N	t	\N	t	1
406	P230-000406	วัสดุใช้ไป	ยกเลิก หลอดไฟ ชนิด LED ขนาด 22 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	155.00	\N	0	0.00	\N	\N	f	\N	t	11
176	P230-000176	วัสดุใช้ไป	สเปรย์ ชนิดสูตรน้ำ สำหรับฉีดมด ยุง ขนาด 300 มล.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	65.00	\N	0	0.00	\N	\N	t	\N	t	11
179	P230-000179	วัสดุใช้ไป	หม้อทะนน	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	15.00	\N	0	0.00	\N	\N	t	\N	t	11
180	P230-000180	วัสดุใช้ไป	หม้อหุงข้าว แบบใช้ไฟฟ้า ขนาด 3.8 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	2100.00	\N	0	0.00	\N	\N	t	\N	t	4
181	P230-000181	วัสดุใช้ไป	หม้อหุงข้าว แบบใช้ไฟฟ้า ขนาด 5 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	2500.00	\N	0	0.00	\N	\N	t	\N	t	1
182	P230-000182	วัสดุใช้ไป	หอมแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	80.00	\N	0	0.00	\N	\N	t	\N	t	4
185	P230-000185	วัสดุใช้ไป	กระจกเงา สำหรับแต่งตัว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	บาน	1990.00	\N	0	0.00	\N	\N	t	\N	t	11
186	P230-000186	วัสดุใช้ไป	เครื่องพ่นยา แบบใช้แบตเตอรี่ ขนาด 18 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	990.00	\N	0	0.00	\N	\N	t	\N	t	11
188	P230-000188	วัสดุใช้ไป	เต๊นท์ผ้าใบ แบบโค้งพร้อมโครงเหล็ก ขนาด 4*8 เมตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	หลัง	24500.00	\N	0	0.00	\N	\N	t	\N	t	1
189	P230-000189	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก สำหรับขยะติดเชื้อ แบบฝาเรียบ ขนาด 240 ลิตร สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	2390.00	\N	0	0.00	\N	\N	t	\N	t	4
190	P230-000190	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก สำหรับขยะติดเชื้อ แบบช่องทิ้ง ขนาด 240 ลิตร สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	2190.00	\N	0	0.00	\N	\N	t	\N	t	1
191	P230-000191	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 10 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	295.00	\N	0	0.00	\N	\N	t	\N	t	11
192	P230-000192	วัสดุใช้ไป	ถังน้ำ ชนิดพลาสติก แบบมีฝา สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	395.00	\N	0	0.00	\N	\N	t	\N	t	11
193	P230-000193	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 6*14 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	39.00	\N	0	0.00	\N	\N	t	\N	t	1
194	P230-000194	วัสดุใช้ไป	ที่นอน ชนิดฟองน้ำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	หลัง	1400.00	\N	0	0.00	\N	\N	t	\N	t	11
195	P230-000195	วัสดุใช้ไป	แทงค์น้ำ ขนาด 1000 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	4690.00	\N	0	0.00	\N	\N	t	\N	t	11
196	P230-000196	วัสดุใช้ไป	ผ้าปูที่นอน	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	299.00	\N	0	0.00	\N	\N	t	\N	t	1
197	P230-000197	วัสดุใช้ไป	ผ้าห่ม ขนาด 150 x 200 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	178.00	\N	0	0.00	\N	\N	t	\N	t	11
198	P230-000198	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 10	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N	t	1
199	P230-000199	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 10.5	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N	t	4
200	P230-000200	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 11	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N	t	1
201	P230-000201	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 11.5	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N	t	4
202	P230-000202	วัสดุใช้ไป	ราวตากผ้า ชนิดอลูมีเนียม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	950.00	\N	0	0.00	\N	\N	t	\N	t	11
203	P230-000203	วัสดุใช้ไป	หมอน ขนาด 19 x 29 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	190.00	\N	0	0.00	\N	\N	t	\N	t	4
204	P230-000204	วัสดุใช้ไป	ถุง ชนิดพลาสติก ขนาด 24*42 นิ้ว สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	240.00	\N	0	0.00	\N	\N	t	\N	t	11
205	P230-000205	วัสดุใช้ไป	พรมเช็ดเท้า ขนาด 40*60 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	370.00	\N	0	0.00	\N	\N	t	\N	t	4
206	P230-000206	วัสดุใช้ไป	พรมเช็ดเท้า แบบดักฝุ่น ขนาด 50*120 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	590.00	\N	0	0.00	\N	\N	t	\N	t	11
207	P230-000207	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	250.00	\N	0	0.00	\N	\N	t	\N	t	4
208	P230-000208	วัสดุใช้ไป	สายฉีดชำระ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	150.00	\N	0	0.00	\N	\N	t	\N	t	11
209	P230-000209	วัสดุใช้ไป	กล่องลอย ชนิดพลาสติก ขนาด 2*4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	19.00	\N	0	0.00	\N	\N	t	\N	t	11
210	P230-000210	วัสดุใช้ไป	กลอนประตู ชนิดสแตนเลส ขนาด 4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	11.00	\N	0	0.00	\N	\N	t	\N	t	11
211	P230-000211	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับซิงค์ ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	550.00	\N	0	0.00	\N	\N	t	\N	t	1
212	P230-000212	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบเดี่ยว ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	680.00	\N	0	0.00	\N	\N	t	\N	t	4
237	P230-000237	วัสดุใช้ไป	ตะปู ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ขีด	10.00	\N	0	0.00	\N	\N	t	\N	t	1
213	P230-000213	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	95.00	\N	0	0.00	\N	\N	t	\N	t	11
214	P230-000214	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบบอล ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	85.00	\N	0	0.00	\N	\N	t	\N	t	1
215	P230-000215	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับฝักบัว ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	160.00	\N	0	0.00	\N	\N	t	\N	t	11
216	P230-000216	วัสดุใช้ไป	ยกเลิก ก๊อกน้ำ ชนิดทองเหลือง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	120.00	\N	0	0.00	\N	\N	f	\N	t	11
217	P230-000217	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบสนาม ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	165.00	\N	0	0.00	\N	\N	t	\N	t	4
218	P230-000218	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่าง แบบเดี่ยว ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	650.00	\N	0	0.00	\N	\N	t	\N	t	4
219	P230-000219	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่างล้างจาน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	290.00	\N	0	0.00	\N	\N	t	\N	t	1
220	P230-000220	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่างล้างหน้า ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	450.00	\N	0	0.00	\N	\N	t	\N	t	4
221	P230-000221	วัสดุใช้ไป	กาว ชนิดประสาน สำหรับทาท่อ PVC ขนาด 250 กรัม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระปุก	176.00	\N	0	0.00	\N	\N	t	\N	t	11
222	P230-000222	วัสดุใช้ไป	กุญแจ ชนิดทองเหลือง แบบคล้อง คอยาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	66.00	\N	0	0.00	\N	\N	t	\N	t	4
223	P230-000223	วัสดุใช้ไป	กุญแจ ชนิดทองเหลือง แบบคล้อง ขนาด 38 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	105.00	\N	0	0.00	\N	\N	t	\N	t	4
224	P230-000224	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	9.00	\N	0	0.00	\N	\N	t	\N	t	11
225	P230-000225	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	13.00	\N	0	0.00	\N	\N	t	\N	t	11
226	P230-000226	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	19.00	\N	0	0.00	\N	\N	t	\N	t	11
227	P230-000227	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา เกลียวนอก ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	14.00	\N	0	0.00	\N	\N	t	\N	t	4
228	P230-000228	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา เกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	13.00	\N	0	0.00	\N	\N	t	\N	t	11
229	P230-000229	วัสดุใช้ไป	ข้องอ ชนิดทองเหลือง แบบ 90 องศา	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	38.00	\N	0	0.00	\N	\N	t	\N	t	1
230	P230-000230	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	15.00	\N	0	0.00	\N	\N	t	\N	t	11
231	P230-000231	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	7.00	\N	0	0.00	\N	\N	t	\N	t	1
232	P230-000232	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC แบบเกลียวนอก ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	9.00	\N	0	0.00	\N	\N	t	\N	t	4
233	P230-000233	วัสดุใช้ไป	ข้อต่อลด ชนิด PVC ขนาด 3/4 * 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	9.00	\N	0	0.00	\N	\N	t	\N	t	1
234	P230-000234	วัสดุใช้ไป	ขายึด ชนิดเหล็ก สำหรับแขวนโทรทัศน์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	990.00	\N	0	0.00	\N	\N	t	\N	t	1
235	P230-000235	วัสดุใช้ไป	ไขควง แบบกลม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	50.00	\N	0	0.00	\N	\N	t	\N	t	4
236	P230-000236	วัสดุใช้ไป	ตะไบ ชนิดแบน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	140.00	\N	0	0.00	\N	\N	t	\N	t	1
238	P230-000238	วัสดุใช้ไป	เต้ารับ ชนิด 3 ขา แบบคู่	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	85.00	\N	0	0.00	\N	\N	t	\N	t	4
239	P230-000239	วัสดุใช้ไป	โถส้วม แบบนั่งยอง ไม่มีฐาน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชด	730.00	\N	0	0.00	\N	\N	t	\N	t	11
240	P230-000240	วัสดุใช้ไป	ทราย ชนิดหยาบ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คิว	308.00	\N	0	0.00	\N	\N	t	\N	t	11
241	P230-000241	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	100.00	\N	0	0.00	\N	\N	t	\N	t	11
242	P230-000242	วัสดุใช้ไป	ชุดน้ำทิ้ง แบบกระปุก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	199.00	\N	0	0.00	\N	\N	t	\N	t	11
243	P230-000243	วัสดุใช้ไป	ท่อย่น ชนิดพลาสติก แบบ 2 in 1	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	135.00	\N	0	0.00	\N	\N	t	\N	t	4
244	P230-000244	วัสดุใช้ไป	ชุดกดชักโครก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	132.00	\N	0	0.00	\N	\N	t	\N	t	4
245	P230-000245	วัสดุใช้ไป	เทป สำหรับพันเกลียว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ม้วน	17.00	\N	0	0.00	\N	\N	t	\N	t	11
246	P230-000246	วัสดุใช้ไป	น๊อต สำหรับหัวฝา ขนาด 1/2*1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	2.50	\N	0	0.00	\N	\N	t	\N	t	11
247	P230-000247	วัสดุใช้ไป	น้ำกลั่นแบตเตอรี่ สำหรับแบตเตอรี่ ขนาด 1 ลิตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ขวด	25.00	\N	0	0.00	\N	\N	t	\N	t	11
248	P230-000248	วัสดุใช้ไป	บอลวาล์ว ชนิด PVC แบบสวม ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	135.00	\N	0	0.00	\N	\N	t	\N	t	1
249	P230-000249	วัสดุใช้ไป	บอลวาล์ว ชนิด PVC ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	44.00	\N	0	0.00	\N	\N	t	\N	t	1
250	P230-000250	วัสดุใช้ไป	บอลวาล์ว ชนิด PVC ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	72.00	\N	0	0.00	\N	\N	t	\N	t	11
251	P230-000251	วัสดุใช้ไป	บอลวาล์ว ชนิดเหล็ก แบบเกลียวนอก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	105.00	\N	0	0.00	\N	\N	t	\N	t	11
252	P230-000252	วัสดุใช้ไป	บานพับ แบบผีเสื้อ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	22.00	\N	0	0.00	\N	\N	t	\N	t	4
253	P230-000253	วัสดุใช้ไป	ปูน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	130.00	\N	0	0.00	\N	\N	t	\N	t	4
254	P230-000254	วัสดุใช้ไป	ฝักบัวอาบน้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	160.00	\N	0	0.00	\N	\N	t	\N	t	1
255	P230-000255	วัสดุใช้ไป	ฝาครอบ ชนิด PVC ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	7.00	\N	0	0.00	\N	\N	t	\N	t	1
256	P230-000256	วัสดุใช้ไป	พุก ชนิดเหล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	8.00	\N	0	0.00	\N	\N	t	\N	t	11
257	P230-000257	วัสดุใช้ไป	มือกดน้ำ แบบด้านข้าง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	95.00	\N	0	0.00	\N	\N	t	\N	t	11
258	P230-000258	วัสดุใช้ไป	ไม้อัด หนา 10 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	517.00	\N	0	0.00	\N	\N	t	\N	t	11
260	P230-000260	วัสดุใช้ไป	ลวด สำหรับผูกเหล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ม้วน	132.00	\N	0	0.00	\N	\N	t	\N	t	11
261	P230-000261	วัสดุใช้ไป	ลูกบิด สำหรับห้องน้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	220.00	\N	0	0.00	\N	\N	t	\N	t	11
262	P230-000262	วัสดุใช้ไป	ลูกลอย ชนิดงอ สำหรับแท๊งค์น้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	320.00	\N	0	0.00	\N	\N	t	\N	t	4
263	P230-000263	วัสดุใช้ไป	ล้อรถเข็น แบบสกรูคู่ ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	55.00	\N	0	0.00	\N	\N	t	\N	t	4
264	P230-000264	วัสดุใช้ไป	วาล์ว แบบครบชุด	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	359.00	\N	0	0.00	\N	\N	t	\N	t	11
1206	P230-001206	วัสดุใช้ไป	คาปาซิเตอร์ ขนาด 16UF 450V	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	430.00	\N	0	0.00	\N	\N	t	\N	t	11
265	P230-000265	วัสดุใช้ไป	วาล์ว สำหรับฝักบัว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	399.00	\N	0	0.00	\N	\N	t	\N	t	1
266	P230-000266	วัสดุใช้ไป	สะดืออ่าง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	45.00	\N	0	0.00	\N	\N	t	\N	t	1
267	P230-000267	วัสดุใช้ไป	สายฉีดชำระ แบบชุดเล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	150.00	\N	0	0.00	\N	\N	t	\N	t	11
268	P230-000268	วัสดุใช้ไป	สายน้ำดี ขนาด 18 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	60.00	\N	0	0.00	\N	\N	t	\N	t	4
269	P230-000269	วัสดุใช้ไป	สายน้ำดี ขนาด 20 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	60.00	\N	0	0.00	\N	\N	t	\N	t	11
270	P230-000270	วัสดุใช้ไป	สายน้ำดี ขนาด 24 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	65.00	\N	0	0.00	\N	\N	t	\N	t	11
271	P230-000271	วัสดุใช้ไป	สายน้ำดี ขนาด 40 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	90.00	\N	0	0.00	\N	\N	t	\N	t	4
272	P230-000272	วัสดุใช้ไป	สายฝักบัว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	95.00	\N	0	0.00	\N	\N	t	\N	t	11
273	P230-000273	วัสดุใช้ไป	สายยู ชนิดเหล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	17.00	\N	0	0.00	\N	\N	t	\N	t	11
274	P230-000274	วัสดุใช้ไป	สายยู ชนิดสแตนเลส	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	28.00	\N	0	0.00	\N	\N	t	\N	t	1
275	P230-000275	วัสดุใช้ไป	สีสเปรย์ สีขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	65.00	\N	0	0.00	\N	\N	t	\N	t	11
276	P230-000276	วัสดุใช้ไป	หิน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คิว	572.00	\N	0	0.00	\N	\N	t	\N	t	4
277	P230-000277	วัสดุใช้ไป	หินคลุก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คิว	517.00	\N	0	0.00	\N	\N	t	\N	t	11
278	P230-000278	วัสดุใช้ไป	เหล็ก แบบกล่อง ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	418.00	\N	0	0.00	\N	\N	t	\N	t	11
279	P230-000279	วัสดุใช้ไป	เหล็ก แบบฉาก ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	572.00	\N	0	0.00	\N	\N	t	\N	t	1
280	P230-000280	วัสดุใช้ไป	เหล็ก แบบตัวซี ขนาด 3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	561.00	\N	0	0.00	\N	\N	t	\N	t	4
281	P230-000281	วัสดุใช้ไป	เหล็ก แบบเพลท ขนาด 4*4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	50.00	\N	0	0.00	\N	\N	t	\N	t	4
282	P230-000282	วัสดุใช้ไป	สต๊อปวาล์ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	160.00	\N	0	0.00	\N	\N	t	\N	t	4
283	P230-000283	วัสดุใช้ไป	ล้อรถเข็น แบบเกลียว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	550.00	\N	0	0.00	\N	\N	t	\N	t	4
284	P230-000284	วัสดุใช้ไป	ฝาอุด ชนิด PVC ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	7.00	\N	0	0.00	\N	\N	t	\N	t	1
285	P230-000285	วัสดุใช้ไป	น้ำมันเอนกประสงค์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	115.00	\N	0	0.00	\N	\N	t	\N	t	1
286	P230-000286	วัสดุใช้ไป	สายน้ำดี ขนาด 22 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	72.00	\N	0	0.00	\N	\N	t	\N	t	4
287	P230-000287	วัสดุใช้ไป	โถส้วม แบบชักโครก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	2390.00	\N	0	0.00	\N	\N	t	\N	t	11
288	P230-000288	วัสดุใช้ไป	กุญแจ ชนิดทองเหลือง แบบคล้อง ขนาด 45 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	1045.00	\N	0	0.00	\N	\N	t	\N	t	4
417	P230-000417	วัสดุใช้ไป	แบตเตอรี่ สำหรับเครื่อง DRX	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	39100.00	\N	0	0.00	\N	\N	t	\N	t	4
289	P230-000289	วัสดุใช้ไป	เทอมินอล สำหรับต่อสาย	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	4.00	\N	0	0.00	\N	\N	t	\N	t	4
290	P230-000290	วัสดุใช้ไป	ทรอนิค	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	160.00	\N	0	0.00	\N	\N	t	\N	t	4
291	P230-000291	วัสดุใช้ไป	ลูกเสียบยาง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	10.00	\N	0	0.00	\N	\N	t	\N	t	4
292	P230-000292	วัสดุใช้ไป	รางหลอดไฟ ชนิดทรอนิค สำหรับหลอด LED	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	155.00	\N	0	0.00	\N	\N	t	\N	t	4
293	P230-000293	วัสดุใช้ไป	น๊อต แบบธุบ ขนาด 7 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	25.00	\N	0	0.00	\N	\N	t	\N	t	4
294	P230-000294	วัสดุใช้ไป	น๊อต แบบธุบ ขนาด 8 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	30.00	\N	0	0.00	\N	\N	t	\N	t	4
295	P230-000295	วัสดุใช้ไป	แหวน ชนิดเหล็ก แบบเหลี่ยม ขนาด 5/8 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	5.00	\N	0	0.00	\N	\N	t	\N	t	11
296	P230-000296	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	60.00	\N	0	0.00	\N	\N	t	\N	t	11
297	P230-000297	วัสดุใช้ไป	ยกเลิก ข้องอ ชนิด PVC หนา แบบ 90 องศา ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	88.00	\N	0	0.00	\N	\N	f	\N	t	1
298	P230-000298	วัสดุใช้ไป	สามทาง ชนิด PVC แบบลด ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	55.00	\N	0	0.00	\N	\N	t	\N	t	11
299	P230-000299	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อ	230.00	\N	0	0.00	\N	\N	t	\N	t	1
300	P230-000300	วัสดุใช้ไป	ยูเนียน ชนิด PVC ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	165.00	\N	0	0.00	\N	\N	t	\N	t	1
301	P230-000301	วัสดุใช้ไป	ตะแกรงน้ำมัน ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	12.00	\N	0	0.00	\N	\N	t	\N	t	4
302	P230-000302	วัสดุใช้ไป	ดอกสว่าน ขนาด 1/8	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ดอก	28.00	\N	0	0.00	\N	\N	t	\N	t	11
303	P230-000303	วัสดุใช้ไป	ปูนขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	70.00	\N	0	0.00	\N	\N	t	\N	t	11
304	P230-000304	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบดัช ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	550.00	\N	0	0.00	\N	\N	t	\N	t	1
305	P230-000305	วัสดุใช้ไป	น้ำยา สำหรับกำจัดมด ปลวก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	132.00	\N	0	0.00	\N	\N	t	\N	t	11
306	P230-000306	วัสดุใช้ไป	ยกเลิก สายน้ำดี	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	55.00	\N	0	0.00	\N	\N	f	\N	t	11
307	P230-000307	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบดัช ต่อล่าง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	638.00	\N	0	0.00	\N	\N	t	\N	t	1
308	P230-000308	วัสดุใช้ไป	นิปเปิ้ล ชนิดทองเหลือง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	22.00	\N	0	0.00	\N	\N	t	\N	t	11
309	P230-000309	วัสดุใช้ไป	ยกเลิก มินิวาล์ว ชนิดทองเหลือง แบบ 3 ทาง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	154.00	\N	0	0.00	\N	\N	f	\N	t	1
310	P230-000310	วัสดุใช้ไป	กิ๊บ ชนิดพลาสติก แบบก้ามปู ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	6.00	\N	0	0.00	\N	\N	t	\N	t	4
311	P230-000311	วัสดุใช้ไป	เกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	10.00	\N	0	0.00	\N	\N	t	\N	t	11
312	P230-000312	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 45 องศา ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	10.00	\N	0	0.00	\N	\N	t	\N	t	1
313	P230-000313	วัสดุใช้ไป	อิฐแดง ขนาดเล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก้อน	1.00	\N	0	0.00	\N	\N	t	\N	t	4
314	P230-000314	วัสดุใช้ไป	ยกเลิก ฝาบิด	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	150.00	\N	0	0.00	\N	\N	f	\N	t	4
315	P230-000315	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 6 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อ	2050.00	\N	0	0.00	\N	\N	t	\N	t	4
316	P230-000316	วัสดุใช้ไป	เกรียง สำหรับก่ออิฐ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ด้าม	72.00	\N	0	0.00	\N	\N	t	\N	t	4
317	P230-000317	วัสดุใช้ไป	ยกเลิก สีน้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	236.00	\N	0	0.00	\N	\N	f	\N	t	11
318	P230-000318	วัสดุใช้ไป	น้ำยาเคมีไข้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระปุก	105.00	\N	0	0.00	\N	\N	t	\N	t	11
319	P230-000319	วัสดุใช้ไป	กระดาษทราย ชนิดละเอียด เบอร์ xx	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	11.00	\N	0	0.00	\N	\N	t	\N	t	1
320	P230-000320	วัสดุใช้ไป	มินิวาล์ว ชนิดทองเหลือง แบบ 3 ทาง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	138.00	\N	0	0.00	\N	\N	t	\N	t	1
321	P230-000321	วัสดุใช้ไป	ซิลิโคน สีขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	หลอด	132.00	\N	0	0.00	\N	\N	t	\N	t	1
322	P230-000322	วัสดุใช้ไป	กาว ชนิดร้อน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	หลอด	28.00	\N	0	0.00	\N	\N	t	\N	t	4
323	P230-000323	วัสดุใช้ไป	สามทาง ชนิด PVC ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	8.00	\N	0	0.00	\N	\N	t	\N	t	4
324	P230-000324	วัสดุใช้ไป	กาว ชนิดประสาน สำหรับทาท่อ PVC ขนาด 50 กรัม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	45.00	\N	0	0.00	\N	\N	t	\N	t	4
325	P230-000325	วัสดุใช้ไป	ใบเลื่อย	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ใบ	45.00	\N	0	0.00	\N	\N	t	\N	t	1
326	P230-000326	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อ	55.00	\N	0	0.00	\N	\N	t	\N	t	11
327	P230-000327	วัสดุใช้ไป	อะคริลิค สำหรับกันซึม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อ้น	2848.00	\N	0	0.00	\N	\N	t	\N	t	1
328	P230-000328	วัสดุใช้ไป	ตาข่าย ชนิดไฟเบอร์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	460.00	\N	0	0.00	\N	\N	t	\N	t	4
329	P230-000329	วัสดุใช้ไป	ยกเลิก ชุดน้ำทิ้ง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	898.00	\N	0	0.00	\N	\N	f	\N	t	1
330	P230-000330	วัสดุใช้ไป	แก๊ส ชนิดถัง สำหรับงานแพทย์แผนไทย ขนาด 15 กก.	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ถัง	380.00	\N	0	0.00	\N	\N	t	\N	t	4
331	P230-000331	วัสดุใช้ไป	แก๊ส ชนิดถัง สำหรับงานจ่ายกลาง ขนาด 48 กก.	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ถัง	1500.00	\N	0	0.00	\N	\N	t	\N	t	4
332	P230-000332	วัสดุใช้ไป	แก๊ส ชนิดถัง สำหรับงานโรงครัว ขนาด 48 กก.	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ถัง	1500.00	\N	0	0.00	\N	\N	t	\N	t	1
333	P230-000333	วัสดุใช้ไป	น้ำมันเชื้อเพลิง ชนิดเบนซินแก๊สโซฮอลล์ 91	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ลิตร	40.00	\N	0	0.00	\N	\N	t	\N	t	1
334	P230-000334	วัสดุใช้ไป	น้ำมันเชื้อเพลิง ชนิดเบนซินแก๊สโซฮอลล์ 95	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ลิตร	40.00	\N	0	0.00	\N	\N	t	\N	t	4
335	P230-000335	วัสดุใช้ไป	น้ำมันเครื่อง ชนิด 2T	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	กระป๋อง	150.00	\N	0	0.00	\N	\N	t	\N	t	4
336	P230-000336	วัสดุใช้ไป	น้ำมันเครื่อง ชนิด 4T	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	กระป๋อง	185.00	\N	0	0.00	\N	\N	t	\N	t	4
337	P230-000337	วัสดุใช้ไป	น้ำมันเครื่อง ชนิด 6T	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	กระป๋อง	960.00	\N	0	0.00	\N	\N	t	\N	t	1
338	P230-000338	วัสดุใช้ไป	น้ำมันเชื้อเพลิง ชนิดดีเซล	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ลิตร	40.00	\N	0	0.00	\N	\N	t	\N	t	1
339	P230-000339	วัสดุใช้ไป	น้ำมันเชื้อเพลิง ชนิดเบนซิน 95	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ลิตร	40.00	\N	0	0.00	\N	\N	t	\N	t	1
340	P230-000340	วัสดุใช้ไป	น้ำมันเบรค ขนาด 500 มล.	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	กระป๋อง	295.00	\N	0	0.00	\N	\N	t	\N	t	11
418	P230-000418	วัสดุใช้ไป	สายโทรศัพท์	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	620.00	\N	0	0.00	\N	\N	t	\N	t	11
341	P230-000341	วัสดุใช้ไป	น้ำดื่ม ชนิดบรรจุแกลลอน ขนาด 18 ลิตร	วัสดุสำนักงาน	วัสดุสำนักงาน	ถัง	10.00	\N	0	0.00	\N	\N	t	\N	t	4
342	P230-000342	วัสดุใช้ไป	น้ำดื่ม ชนิดบรรจุขวด ขนาด 600 ซีซี	วัสดุสำนักงาน	วัสดุสำนักงาน	โหล	39.00	\N	0	0.00	\N	\N	t	\N	t	4
345	P230-000345	วัสดุใช้ไป	ถ่าน ชนิด Recharge ขนาด AA	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	600.00	\N	0	0.00	\N	\N	t	\N	t	4
346	P230-000346	วัสดุใช้ไป	ถ่าน ชนิด Recharge ขนาด AAA	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	600.00	\N	0	0.00	\N	\N	t	\N	t	4
354	P230-000354	วัสดุใช้ไป	แบตเตอรี่ แบบแห้ง สำหรับเครื่องสำรองไฟ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	1200.00	\N	0	0.00	\N	\N	t	\N	t	11
356	P230-000356	วัสดุใช้ไป	ปลั๊กไฟพ่วง แบบ 5 ช่อง 5 สวิตซ์ ยาว 3 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	410.00	\N	0	0.00	\N	\N	t	\N	t	11
357	P230-000357	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 18 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	100.00	\N	0	0.00	\N	\N	t	\N	t	11
358	P230-000358	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 22 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	155.00	\N	0	0.00	\N	\N	t	\N	t	4
359	P230-000359	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 9 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	110.00	\N	0	0.00	\N	\N	t	\N	t	4
361	P230-000361	วัสดุใช้ไป	กล่องเบรคเกอร์	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	15.00	\N	0	0.00	\N	\N	t	\N	t	1
362	P230-000362	วัสดุใช้ไป	กล่องลอย ชนิดพลาสติก ขนาด 2*4 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	15.00	\N	0	0.00	\N	\N	t	\N	t	1
363	P230-000363	วัสดุใช้ไป	กล่องลอย ชนิดพลาสติก ขนาด 4*4 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	18.00	\N	0	0.00	\N	\N	t	\N	t	4
364	P230-000364	วัสดุใช้ไป	ก้ามปู สำหรับล๊อคท่อ ขนาด 1/2 นิ้ว สีเหลือง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	5.00	\N	0	0.00	\N	\N	t	\N	t	1
365	P230-000365	วัสดุใช้ไป	กิ๊บ ชนิดพลาสติก สำหรับสายทีวี 3C	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N	t	11
366	P230-000366	วัสดุใช้ไป	ข้อต่อ ชนิดพลาสติก แบบโค้ง ขนาด 1/2 นิ้ว สีเหลือง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	8.00	\N	0	0.00	\N	\N	t	\N	t	11
367	P230-000367	วัสดุใช้ไป	ข้อต่อ ชนิดพลาสติก แบบโค้ง ขนาด 1/2 นิ้ว สีเหลือง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	6.00	\N	0	0.00	\N	\N	t	\N	t	11
368	P230-000368	วัสดุใช้ไป	ขาหลอดนีออน แบบครึ่งท่อน	วัสดุไฟฟ้า	วัสดุไฟฟ้า	คู่	25.00	\N	0	0.00	\N	\N	t	\N	t	1
369	P230-000369	วัสดุใช้ไป	ขาหลอดนีออน แบบล๊อค	วัสดุไฟฟ้า	วัสดุไฟฟ้า	คู่	25.00	\N	0	0.00	\N	\N	t	\N	t	4
370	P230-000370	วัสดุใช้ไป	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 10 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	110.00	\N	0	0.00	\N	\N	t	\N	t	11
371	P230-000371	วัสดุใช้ไป	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 15 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	160.00	\N	0	0.00	\N	\N	t	\N	t	1
372	P230-000372	วัสดุใช้ไป	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 6 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	50.00	\N	0	0.00	\N	\N	t	\N	t	4
373	P230-000373	วัสดุใช้ไป	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 8 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	60.00	\N	0	0.00	\N	\N	t	\N	t	4
374	P230-000374	วัสดุใช้ไป	ตะกั่วบัตกรี แบบปากกา ยาว 3 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	50.00	\N	0	0.00	\N	\N	t	\N	t	11
375	P230-000375	วัสดุใช้ไป	ตะปู สำหรับยิงฝ้า ขนาด 1*6 สีดำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	110.00	\N	0	0.00	\N	\N	t	\N	t	11
376	P230-000376	วัสดุใช้ไป	HDMI splitter ขนาด 8 port	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	1050.00	\N	0	0.00	\N	\N	t	\N	t	11
377	P230-000377	วัสดุใช้ไป	ตู้พลาสติก แบบกันน้ำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตู้	125.00	\N	0	0.00	\N	\N	t	\N	t	11
413	P230-000413	วัสดุใช้ไป	สายลำโพง แบบใส ขนาดใหญ่	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	10.00	\N	0	0.00	\N	\N	t	\N	t	4
378	P230-000378	วัสดุใช้ไป	ท่อสายไฟ ชนิด PVC แบบท่อตรง ขนาด 1/2 นิ้ว สีเหลือง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	55.00	\N	0	0.00	\N	\N	t	\N	t	1
379	P230-000379	วัสดุใช้ไป	เทป สำหรับฟันสายไฟ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	35.00	\N	0	0.00	\N	\N	t	\N	t	4
380	P230-000380	วัสดุใช้ไป	แท่งกราวด์	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	95.00	\N	0	0.00	\N	\N	t	\N	t	4
419	P230-000419	วัสดุใช้ไป	ยกเลิก ปลั๊กไฟ แบบฝัง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	25.00	\N	0	0.00	\N	\N	f	\N	t	11
381	P230-000381	วัสดุใช้ไป	บัลลาส ชนิดหลอดฮาโลเจน ขนาด 12V 35 Watt	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	745.00	\N	0	0.00	\N	\N	t	\N	t	11
382	P230-000382	วัสดุใช้ไป	เบรคเกอร์ ขนาด 30A	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	145.00	\N	0	0.00	\N	\N	t	\N	t	11
383	P230-000383	วัสดุใช้ไป	แบตเตอรี่ แบบแห้ง ขนาด 12V 7.5A	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ลูก	600.00	\N	0	0.00	\N	\N	t	\N	t	1
384	P230-000384	วัสดุใช้ไป	ปลั๊กไฟ แบบกราวคู่	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	55.00	\N	0	0.00	\N	\N	t	\N	t	1
385	P230-000385	วัสดุใช้ไป	ปลั๊กไฟ แบบตุ๊กตา	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	85.00	\N	0	0.00	\N	\N	t	\N	t	11
386	P230-000386	วัสดุใช้ไป	แป้นพลาสติก ขนาด 4*6 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	t	\N	t	11
387	P230-000387	วัสดุใช้ไป	พุก ชนิดพลาสติก เบอร์ 7	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N	t	1
388	P230-000388	วัสดุใช้ไป	ไมล์สาย	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	490.00	\N	0	0.00	\N	\N	t	\N	t	4
389	P230-000389	วัสดุใช้ไป	ปลั๊กไฟพ่วง ยาว 5 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	240.00	\N	0	0.00	\N	\N	t	\N	t	11
390	P230-000390	วัสดุใช้ไป	รางสายไฟ แบบมินิเท้งกิ้ง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	75.00	\N	0	0.00	\N	\N	t	\N	t	11
391	P230-000391	วัสดุใช้ไป	รางสายไฟ ยาว 2 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	90.00	\N	0	0.00	\N	\N	t	\N	t	1
392	P230-000392	วัสดุใช้ไป	ลูกเสียบ แบบตัวผู้	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	15.00	\N	0	0.00	\N	\N	t	\N	t	1
393	P230-000393	วัสดุใช้ไป	ลูกเสียบ แบบตัวเมีย	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	14.00	\N	0	0.00	\N	\N	t	\N	t	1
394	P230-000394	วัสดุใช้ไป	ไฟสนาม แบบสปอตไลท์ ขนาด 50W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	460.00	\N	0	0.00	\N	\N	t	\N	t	1
395	P230-000395	วัสดุใช้ไป	สวิทช์ไฟ แบบแสงแดด	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	180.00	\N	0	0.00	\N	\N	t	\N	t	11
396	P230-000396	วัสดุใช้ไป	สวิทช์ไฟ แบบฝัง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	25.00	\N	0	0.00	\N	\N	t	\N	t	4
397	P230-000397	วัสดุใช้ไป	สาย HDMI ขนาด 3 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	95.00	\N	0	0.00	\N	\N	t	\N	t	11
398	P230-000398	วัสดุใช้ไป	สาย HDMI ขนาด 5 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	155.00	\N	0	0.00	\N	\N	t	\N	t	4
399	P230-000399	วัสดุใช้ไป	สายดิน ขนาด 1*2.5 สีขาว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	950.00	\N	0	0.00	\N	\N	t	\N	t	1
400	P230-000400	วัสดุใช้ไป	สายดิน ขนาด 1*2.5 สีดำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	950.00	\N	0	0.00	\N	\N	t	\N	t	4
401	P230-000401	วัสดุใช้ไป	สายดิน	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	950.00	\N	0	0.00	\N	\N	t	\N	t	11
402	P230-000402	วัสดุใช้ไป	หน้ากากปลั๊กไฟ แบบ 2 ช่อง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	t	\N	t	1
403	P230-000403	วัสดุใช้ไป	หน้ากากปลั๊กไฟ แบบ 3 ช่อง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	15.00	\N	0	0.00	\N	\N	t	\N	t	1
404	P230-000404	วัสดุใช้ไป	หน้ากากปลั๊กไฟ แบบ 6 ช่อง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	33.00	\N	0	0.00	\N	\N	t	\N	t	4
405	P230-000405	วัสดุใช้ไป	ยกเลิก หลอดไฟ ชนิด LED ขนาด 18 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	72.00	\N	0	0.00	\N	\N	f	\N	t	1
407	P230-000407	วัสดุใช้ไป	หลอดไฟ ชนิดนีออน ขนาด 36 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	95.00	\N	0	0.00	\N	\N	t	\N	t	4
408	P230-000408	วัสดุใช้ไป	ปลั๊กไฟ แบบฝัง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	115.00	\N	0	0.00	\N	\N	t	\N	t	4
409	P230-000409	วัสดุใช้ไป	หน้ากากปลั๊กไฟ แบบ 1 ช่อง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	15.00	\N	0	0.00	\N	\N	t	\N	t	4
410	P230-000410	วัสดุใช้ไป	ไฟฉาย แบบหลอดไส้	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	250.00	\N	0	0.00	\N	\N	t	\N	t	11
411	P230-000411	วัสดุใช้ไป	ปลั๊กไฟ แบบตัวผู้	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	10.00	\N	0	0.00	\N	\N	t	\N	t	11
412	P230-000412	วัสดุใช้ไป	ลูกเซอร์กิต	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	95.00	\N	0	0.00	\N	\N	t	\N	t	11
415	P230-000415	วัสดุใช้ไป	กริ่ง แบบไร้สาย มีรีโมท	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	260.00	\N	0	0.00	\N	\N	t	\N	t	4
416	P230-000416	วัสดุใช้ไป	เพรสเซอร์สวิทช์	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	1050.00	\N	0	0.00	\N	\N	t	\N	t	1
423	P230-000423	วัสดุใช้ไป	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีส้ม	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N	t	4
427	P230-000427	วัสดุใช้ไป	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N	t	4
432	P230-000432	วัสดุใช้ไป	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1/2 นิ้ว 36x20 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	20.00	\N	0	0.00	\N	\N	t	\N	t	11
434	P230-000434	วัสดุใช้ไป	กระดาษไข สำหรับเครื่องโรเนียว	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1200.00	\N	0	0.00	\N	\N	t	\N	t	11
441	P230-000441	วัสดุใช้ไป	กระดาษบรุ๊ฟ ขนาด 31x43 นิ้ว สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	4.00	\N	0	0.00	\N	\N	t	\N	t	4
449	P230-000449	วัสดุใช้ไป	เทปกาว ชนิด 2 หน้า แบบบาง ขนาด 3/4 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	30.00	\N	0	0.00	\N	\N	t	\N	t	11
450	P230-000450	วัสดุใช้ไป	กาว แบบติดแน่น (ตราช้าง) ขนาด 3 กรัม	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	25.00	\N	0	0.00	\N	\N	t	\N	t	1
454	P230-000454	วัสดุใช้ไป	กาว ชนิดลาเท็กซ์ ขนาด 32 ออนซ์	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	60.00	\N	0	0.00	\N	\N	t	\N	t	11
459	P230-000459	วัสดุใช้ไป	คลิปหนีบกระดาษ ขนาด #112 สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N	t	11
469	P230-000469	วัสดุใช้ไป	ซองใส่บัตร ชนิดพลาสติก สำหรับบัตรคนต่างด้าว ขนาด 5.6x8.8 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	4.00	\N	0	0.00	\N	\N	t	\N	t	11
472	P230-000472	วัสดุใช้ไป	ชั้นอเนกประสงค์ ชนิดลวดเคลือบพลาสติก แบบ 3 ชั้น	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	900.00	\N	0	0.00	\N	\N	t	\N	t	4
473	P230-000473	วัสดุใช้ไป	ทะเบียนคุมเงินงบประมาณ	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	180.00	\N	0	0.00	\N	\N	t	\N	t	11
475	P230-000475	วัสดุใช้ไป	ยกเลิก เทปกาว ชนิด 2 หน้า	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	125.00	\N	0	0.00	\N	\N	f	\N	t	1
480	P230-000480	วัสดุใช้ไป	แท่นตัดกระดาษ ชนิดมือโยก แบบฐานไม้ ขนาด 13x15"	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1350.00	\N	0	0.00	\N	\N	t	\N	t	4
481	P230-000481	วัสดุใช้ไป	แท่นประทับ แบบฝาพลาสติก สีดำ #2	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	1
482	P230-000482	วัสดุใช้ไป	แท่นประทับ แบบฝาพลาสติก สีแดง #2	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	11
483	P230-000483	วัสดุใช้ไป	แท่นประทับ แบบฝาพลาสติก สีน้ำเงิน #2	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	11
487	P230-000487	วัสดุใช้ไป	ธง วปร. รัชกาลที่ 10 ขนาด 60*90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	40.00	\N	0	0.00	\N	\N	t	\N	t	1
488	P230-000488	วัสดุใช้ไป	ธงชาติ ขนาด 120*180 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	180.00	\N	0	0.00	\N	\N	t	\N	t	11
489	P230-000489	วัสดุใช้ไป	ธงชาติ ขนาด 60*90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	40.00	\N	0	0.00	\N	\N	t	\N	t	1
490	P230-000490	วัสดุใช้ไป	ธง สท. พระราชินี ขนาด 60*90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	40.00	\N	0	0.00	\N	\N	t	\N	t	4
591	P230-000591	วัสดุใช้ไป	ธงชาติ ขนาด 100*150 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	100.00	\N	0	0.00	\N	\N	t	\N	t	1
491	P230-000491	วัสดุใช้ไป	ธงฟ้า สก. พระพันปีหลวง ขนาด 60*90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	40.00	\N	0	0.00	\N	\N	t	\N	t	4
493	P230-000493	วัสดุใช้ไป	บัตรคิว สำหรับคิวรถ	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	7.00	\N	0	0.00	\N	\N	t	\N	t	1
494	P230-000494	วัสดุใช้ไป	บัตรนัดผู้ป่วย ขนาด 5*3.5 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ใบ	1.00	\N	0	0.00	\N	\N	t	\N	t	11
495	P230-000495	วัสดุใช้ไป	ยกเลิก บัตรนัดรักษา	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1400.00	\N	0	0.00	\N	\N	f	\N	t	4
496	P230-000496	วัสดุใช้ไป	บัตรประจำตัวผู้รับบริการ	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	1.00	\N	0	0.00	\N	\N	t	\N	t	1
497	P230-000497	วัสดุใช้ไป	บัตรคิว สำหรับผู้รับบริการกุมารเวชกรรม สีชมพู	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	25.00	\N	0	0.00	\N	\N	t	\N	t	1
498	P230-000498	วัสดุใช้ไป	บัตรคิว สำหรับผู้รับบริการทันตกรรม สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	25.00	\N	0	0.00	\N	\N	t	\N	t	4
499	P230-000499	วัสดุใช้ไป	บัตรคิว สำหรับผู้รับบริการทั่วไป สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	40.00	\N	0	0.00	\N	\N	t	\N	t	11
500	P230-000500	วัสดุใช้ไป	บัตรคิว สำหรับผู้รับบริการโรคเรื้อรัง สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	40.00	\N	0	0.00	\N	\N	t	\N	t	1
501	P230-000501	วัสดุใช้ไป	บัตรคิว สำหรับผู้รับบริการส่งเสริมสุขภาพ สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	40.00	\N	0	0.00	\N	\N	t	\N	t	4
502	P230-000502	วัสดุใช้ไป	บัตรคิว สำหรับแพทย์นัด สีส้ม	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	40.00	\N	0	0.00	\N	\N	t	\N	t	11
504	P230-000504	วัสดุใช้ไป	แบบฟอร์ม แจ้งรายการค่ารักษาพยาบาล	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1500.00	\N	0	0.00	\N	\N	t	\N	t	1
508	P230-000508	วัสดุใช้ไป	แบบฟอร์ม ใบรับรองแพทย์ กรณีป่วย	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	60.00	\N	0	0.00	\N	\N	t	\N	t	1
511	P230-000511	วัสดุใช้ไป	ปากกา Paint Marker ขนาด 0.8-1.2 mm สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	85.00	\N	0	0.00	\N	\N	t	\N	t	11
512	P230-000512	วัสดุใช้ไป	ปากกา Paint Marker ขนาด 0.8-1.2 mm สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	85.00	\N	0	0.00	\N	\N	t	\N	t	1
513	P230-000513	วัสดุใช้ไป	ปากกา Paint Marker ขนาด 4.0-8.5 mm สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	85.00	\N	0	0.00	\N	\N	t	\N	t	4
519	P230-000519	วัสดุใช้ไป	ปากกา ไวท์บอร์ด PILOT สีแดง	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	25.00	\N	0	0.00	\N	\N	t	\N	t	4
520	P230-000520	วัสดุใช้ไป	ปากกา ไวท์บอร์ด PILOT สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	25.00	\N	0	0.00	\N	\N	t	\N	t	1
526	P230-000526	วัสดุใช้ไป	ผงหมึก สำหรับเครื่องถ่ายเอกสาร สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	ตลับ	7800.00	\N	0	0.00	\N	\N	t	\N	t	1
527	P230-000527	วัสดุใช้ไป	ผงหมึก สำหรับเครื่องถ่ายเอกสาร สีแดง	วัสดุสำนักงาน	วัสดุสำนักงาน	ตลับ	16000.00	\N	0	0.00	\N	\N	t	\N	t	1
528	P230-000528	วัสดุใช้ไป	ผงหมึก สำหรับเครื่องถ่ายเอกสาร สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ตลับ	16000.00	\N	0	0.00	\N	\N	t	\N	t	1
529	P230-000529	วัสดุใช้ไป	ผงหมึก สำหรับเครื่องถ่ายเอกสาร สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	ตลับ	16000.00	\N	0	0.00	\N	\N	t	\N	t	1
532	P230-000532	วัสดุใช้ไป	พลาสติกใส แบบยืด	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	25.00	\N	0	0.00	\N	\N	t	\N	t	11
545	P230-000545	วัสดุใช้ไป	มีดคัตเตอร์ ชนิดด้ามสแตนเลส ขนาดใหญ่	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	45.00	\N	0	0.00	\N	\N	t	\N	t	4
547	P230-000547	วัสดุใช้ไป	ลวดเย็บกระดาษ เบอร์ 3	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	15.00	\N	0	0.00	\N	\N	t	\N	t	11
549	P230-000549	วัสดุใช้ไป	ลวดเย็บกระดาษ เบอร์ 8	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	10.00	\N	0	0.00	\N	\N	t	\N	t	4
552	P230-000552	วัสดุใช้ไป	ลิ้นแฟ้ม ชนิดพลาสติก	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	95.00	\N	0	0.00	\N	\N	t	\N	t	11
554	P230-000554	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	45.00	\N	0	0.00	\N	\N	t	\N	t	4
555	P230-000555	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	45.00	\N	0	0.00	\N	\N	t	\N	t	1
556	P230-000556	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีม่วง	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	45.00	\N	0	0.00	\N	\N	t	\N	t	11
557	P230-000557	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีส้ม	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	45.00	\N	0	0.00	\N	\N	t	\N	t	1
736	P230-000736	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 1 W สีแดง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	35.00	\N	0	0.00	\N	\N	t	\N	t	4
558	P230-000558	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	45.00	\N	0	0.00	\N	\N	t	\N	t	4
559	P230-000559	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สี่ขาวมัน	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	45.00	\N	0	0.00	\N	\N	t	\N	t	11
563	P230-000563	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดพลาสติก แบบใส ขนาดใหญ่ สีใสหลังเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	20.00	\N	0	0.00	\N	\N	t	\N	t	11
564	P230-000564	วัสดุใช้ไป	สมุด สำหรับ Refer คลอด (บส.08/1)	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	50.00	\N	0	0.00	\N	\N	t	\N	t	1
565	P230-000565	วัสดุใช้ไป	สมุด สำหรับ Refer ทั่วไป (บส.08)	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	50.00	\N	0	0.00	\N	\N	t	\N	t	1
567	P230-000567	วัสดุใช้ไป	สมุด สำหรับตรวจสุขภาพ	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	5.00	\N	0	0.00	\N	\N	t	\N	t	1
570	P230-000570	วัสดุใช้ไป	สมุด ชนิดหุ้มปก สำหรับบันทึกมุมมัน	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	250.00	\N	0	0.00	\N	\N	t	\N	t	11
571	P230-000571	วัสดุใช้ไป	สมุด สำหรับใบรับรองความพิการ	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	65.00	\N	0	0.00	\N	\N	t	\N	t	1
574	P230-000574	วัสดุใช้ไป	สมุด สำหรับประจำตัวผู้ป่วยนอก สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	18.00	\N	0	0.00	\N	\N	t	\N	t	11
575	P230-000575	วัสดุใช้ไป	สมุด สำหรับประจำตัวผู้ป่วยโรคปอด	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	30.00	\N	0	0.00	\N	\N	t	\N	t	4
576	P230-000576	วัสดุใช้ไป	หมึกพิมพ์ สำหรับเครื่องโรเนียว สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	500.00	\N	0	0.00	\N	\N	t	\N	t	4
577	P230-000577	วัสดุใช้ไป	หมึกเติม สำหรับแท่นประทับตรายาง สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	15.00	\N	0	0.00	\N	\N	t	\N	t	4
580	P230-000580	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบหูหิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ใบ	159.00	\N	0	0.00	\N	\N	t	\N	t	1
581	P230-000581	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบลิ้นชัก 4 ชั้น	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	280.00	\N	0	0.00	\N	\N	t	\N	t	11
582	P230-000582	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบ 3 ช่อง สำหรับใส่เอกสาร	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	230.00	\N	0	0.00	\N	\N	t	\N	t	1
583	P230-000583	วัสดุใช้ไป	เก้าอี้ ชนิดโครงเหล็ก สำหรับจัดเลี้ยง	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	859.00	\N	0	0.00	\N	\N	t	\N	t	4
584	P230-000584	วัสดุใช้ไป	ยกเลิก เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	259.00	\N	0	0.00	\N	\N	f	\N	t	1
585	P230-000585	วัสดุใช้ไป	ชั้นอเนกประสงค์ ชนิดพลาสติก แบบ 4 ลิ้นชัก	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	290.00	\N	0	0.00	\N	\N	t	\N	t	4
586	P230-000586	วัสดุใช้ไป	ซองใส่บัตร ชนิดพลาสติก	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	214.00	\N	0	0.00	\N	\N	t	\N	t	1
587	P230-000587	วัสดุใช้ไป	ตู้อเนกประสงค์ ชนิดพลาสติก แบบ 4 ลิ้นชัก	วัสดุสำนักงาน	วัสดุสำนักงาน	ตู้	740.00	\N	0	0.00	\N	\N	t	\N	t	4
588	P230-000588	วัสดุใช้ไป	โต๊ะเอนกประสงค์ แบบพับได้	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	1850.00	\N	0	0.00	\N	\N	t	\N	t	11
589	P230-000589	วัสดุใช้ไป	โต๊ะเอนกประสงค์	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	659.00	\N	0	0.00	\N	\N	t	\N	t	11
590	P230-000590	วัสดุใช้ไป	ที่แขวนตรายาง แบบ 2 ชั้น	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	98.00	\N	0	0.00	\N	\N	t	\N	t	11
592	P230-000592	วัสดุใช้ไป	ธง จภ. สมเด็จเจ้าฟ้าจุฬาภรณ์ฯ ขนาด 60*90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	50.00	\N	0	0.00	\N	\N	t	\N	t	1
593	P230-000593	วัสดุใช้ไป	พลาสติกใส หนา 0.20 มม. ขนาดกว้าง 2 เมตร ยาว 15 เมตร	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	2000.00	\N	0	0.00	\N	\N	t	\N	t	1
594	P230-000594	วัสดุใช้ไป	พลาสติกใส สำหรับหุ้มปก หนา 0.09 มม. ขนาดกว้าง 48 นิ้ว ยาว 75 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1500.00	\N	0	0.00	\N	\N	t	\N	t	1
595	P230-000595	วัสดุใช้ไป	ลวดเย็บกระดาษ เบอร์12/10	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	92.00	\N	0	0.00	\N	\N	t	\N	t	11
596	P230-000596	วัสดุใช้ไป	หนังสือ มาตรฐานโรงพยาบาลและบริการสุขภาพ ฉบับที่ 5	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	500.00	\N	0	0.00	\N	\N	t	\N	t	4
597	P230-000597	วัสดุใช้ไป	ยกเลิก กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีล้อ พร้อมฝาปิด ขนาด 100 ลิตร	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	429.00	\N	0	0.00	\N	\N	f	\N	t	1
598	P230-000598	วัสดุใช้ไป	เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	199.00	\N	0	0.00	\N	\N	t	\N	t	1
599	P230-000599	วัสดุใช้ไป	ยกเลิก พลาสติกใส หนา 0.20 มม. ขนาดกว้าง 2 เมตร ยาว 15 เมตร	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	2000.00	\N	0	0.00	\N	\N	f	\N	t	11
600	P230-000600	วัสดุใช้ไป	ชั้นวางรองเท้า แบบ 3 ชั้น	วัสดุสำนักงาน	วัสดุสำนักงาน	ชั้น	990.00	\N	0	0.00	\N	\N	t	\N	t	4
601	P230-000601	วัสดุใช้ไป	กระดาษการ์ด แบบพื้นด้าน ขนาด A4 สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	pack	100.00	\N	0	0.00	\N	\N	t	\N	t	1
602	P230-000602	วัสดุใช้ไป	เสาธง ชนิดไม้ ขนาดสูง 2 เมตร	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	65.00	\N	0	0.00	\N	\N	t	\N	t	1
603	P230-000603	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก ขนาด 33*26*23 ซม. สีใส	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	190.00	\N	0	0.00	\N	\N	t	\N	t	11
604	P230-000604	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก ขนาด 11.5*21*10.5 ซม. สีใส	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	59.00	\N	0	0.00	\N	\N	t	\N	t	11
605	P230-000605	วัสดุใช้ไป	ธง สธ. สมเด็จพระเทพฯ ขนาด 60*90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	40.00	\N	0	0.00	\N	\N	t	\N	t	11
606	P230-000606	วัสดุใช้ไป	กางเกงเด็กกลาง ผ้าย้อม ขนาดเด็ก 4-7 ปี สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	150.00	\N	0	0.00	\N	\N	t	\N	t	1
607	P230-000607	วัสดุใช้ไป	กางเกงเด็กเล็ก ผ้าย้อม ขนาดเด็ก 1-3 ปี สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	150.00	\N	0	0.00	\N	\N	t	\N	t	1
608	P230-000608	วัสดุใช้ไป	กางเกงผู้ใหญ่ ผ้าย้อม แบบมีเชือกผูก ขนาด XXL สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	235.00	\N	0	0.00	\N	\N	t	\N	t	11
609	P230-000609	วัสดุใช้ไป	กางเกงผู้ใหญ่ ผ้าย้อม แบบมีเชือกผูก ขนาด XL สีเม็ดมะปราง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	235.00	\N	0	0.00	\N	\N	t	\N	t	1
610	P230-000610	วัสดุใช้ไป	ชุดกระโปรงแพทย์ ผ้าโทเร แบบหญิง ขนาด L สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	450.00	\N	0	0.00	\N	\N	t	\N	t	11
611	P230-000611	วัสดุใช้ไป	ชุดเสื้อกางเกง ผ้าวินเซนต์ แบบเสื้อคอกลม และกางเกงเอวยางยืด ขนาด M สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	550.00	\N	0	0.00	\N	\N	t	\N	t	1
612	P230-000612	วัสดุใช้ไป	ชุดเสื้อกางเกง ผ้าวินเซนต์ แบบเสื้อคอกลม และกางเกงเอวยางยืด ขนาด S , M , L , XL สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	550.00	\N	0	0.00	\N	\N	t	\N	t	11
613	P230-000613	วัสดุใช้ไป	ชุดเสื้อกางเกง ผ้าวินเซนต์ แบบเสื้อคอกลม และกางเกงเอวยางยืด ขนาด S , L , XL , XXL สีฟ้า	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	550.00	\N	0	0.00	\N	\N	t	\N	t	4
614	P230-000614	วัสดุใช้ไป	ถุงเท้าคลอด ผ้าฟอกขาว แบบ 2 ชั้น ขนาด 18"x36"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	150.00	\N	0	0.00	\N	\N	t	\N	t	1
615	P230-000615	วัสดุใช้ไป	ปลอกหมอน ผ้าโทเร แบบพับใน 8 นิ้ว ขนาด 18"x25" สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	80.00	\N	0	0.00	\N	\N	t	\N	t	1
1171	P230-001171	วัสดุใช้ไป	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	เมตร	53.00	\N	0	0.00	\N	\N	t	\N	t	4
616	P230-000616	วัสดุใช้ไป	ปลอกหมอน ผ้าโทเร แบบพับใน 8 นิ้ว ขนาด 18"x25" สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	80.00	\N	0	0.00	\N	\N	t	\N	t	11
617	P230-000617	วัสดุใช้ไป	ปลอกหมอน ผ้าฟอกขาว แบบพับใน 8 นิ้ว ขนาด 18"x25"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	80.00	\N	0	0.00	\N	\N	t	\N	t	1
618	P230-000618	วัสดุใช้ไป	ผ้าขวางเตียง ผ้าฟอกขาว ขนาด 44"x72"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	290.00	\N	0	0.00	\N	\N	t	\N	t	11
619	P230-000619	วัสดุใช้ไป	ผ้าเช็ดตัวผืนใหญ่ ผ้าทอเดี่ยว 11 ปอนด์ แบบ 11 ปอนด์ ขนาด 30"x60" สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	250.00	\N	0	0.00	\N	\N	t	\N	t	4
620	P230-000620	วัสดุใช้ไป	ผ้าเช็ดตัวลดไข้ ผ้าทอเดี่ยว 0.95 ปอนด์ ขนาด 12"x12" สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	20.00	\N	0	0.00	\N	\N	t	\N	t	1
621	P230-000621	วัสดุใช้ไป	ผ้าเช็ดมือผ่าตัด ผ้าทอเดี่ยว 2.8 ปอนด์ ขนาด 15"x30" สีขาว	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	100.00	\N	0	0.00	\N	\N	t	\N	t	11
622	P230-000622	วัสดุใช้ไป	ยกเลิก ผ้าดิบ	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	พับ	50.00	\N	0	0.00	\N	\N	f	\N	t	11
623	P230-000623	วัสดุใช้ไป	ผ้าถุง ผ้าย้อม ขนาด 88"x40" สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	345.00	\N	0	0.00	\N	\N	t	\N	t	4
624	P230-000624	วัสดุใช้ไป	ผ้าถุง ผ้าวินเซนต์ ขนาด 88"x40" สีแดงเลือดนก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	345.00	\N	0	0.00	\N	\N	t	\N	t	11
625	P230-000625	วัสดุใช้ไป	ผ้าปิดตา แบบสามเหลี่ยม	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	65.00	\N	0	0.00	\N	\N	t	\N	t	1
626	P230-000626	วัสดุใช้ไป	ผ้าปูเตียง ผ้าโทเรหนา แบบปล่อยชาย ขนาด 100"x3 หลา สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	450.00	\N	0	0.00	\N	\N	t	\N	t	11
627	P230-000627	วัสดุใช้ไป	ผ้าปูเตียง ผ้าฟอกขาว แบบปล่อยชาย ขนาด 60"x3 หลา	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	210.00	\N	0	0.00	\N	\N	t	\N	t	11
628	P230-000628	วัสดุใช้ไป	ผ้าปูเตียง ผ้าโทเร แบบรัดมุม ขนาด 27"x74" สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	175.00	\N	0	0.00	\N	\N	t	\N	t	1
737	P230-000737	วัสดุใช้ไป	ปลั๊กไฟ แบบกราวเดี่ยว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	45.00	\N	0	0.00	\N	\N	t	\N	t	4
629	P230-000629	วัสดุใช้ไป	ผ้าปูรถนอน ผ้าย้อม แบบปล่อยชาย ขนาด 45"x3 หลา สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	170.00	\N	0	0.00	\N	\N	t	\N	t	4
630	P230-000630	วัสดุใช้ไป	ผ้าปูรถนอน ผ้าย้อม แบบปล่อยชาย ขนาด 45"x3 หลา สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	180.00	\N	0	0.00	\N	\N	t	\N	t	4
631	P230-000631	วัสดุใช้ไป	ผ้าผูกยึดผู้ป่วย ผ้าฟอกขาว ขนาดยาว 36"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เส้น	130.00	\N	0	0.00	\N	\N	t	\N	t	4
741	P230-000741	วัสดุใช้ไป	ปลั๊กอุด แบบอุด ขนาด 1/2 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	6.00	\N	0	0.00	\N	\N	t	\N	t	11
632	P230-000632	วัสดุใช้ไป	ผ้ายาง ชนิด 2 หน้า ขนาด 36"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ม้วน	920.00	\N	0	0.00	\N	\N	t	\N	t	11
633	P230-000633	วัสดุใช้ไป	ผ้ายาง ชนิดหนังเทียม ขนาด 36"x54"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	120.00	\N	0	0.00	\N	\N	t	\N	t	4
634	P230-000634	วัสดุใช้ไป	ผ้ายาง ชนิด 2 หน้า แบบเล็ก ขนาด 24"x24" สีชมพู-เขียว	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	100.00	\N	0	0.00	\N	\N	t	\N	t	11
635	P230-000635	วัสดุใช้ไป	ผ้าสวม Mayo ผ้าย้อม แบบ 2 ชั้น ขนาด 18" x72 " สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	245.00	\N	0	0.00	\N	\N	t	\N	t	1
347	P230-000347	วัสดุใช้ไป	ถ่าน ชนิดอัลคาไลน์ ขนาด 9V	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	130.00	\N	0	0.00	\N	\N	t	\N	t	11
636	P230-000636	วัสดุใช้ไป	ผ้าสี่เหลียม 1 ชั้น ผ้าย้อม แบบเจาะรูกลาง (4"x4") ขนาด 30"x30" สีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	80.00	\N	0	0.00	\N	\N	t	\N	t	4
637	P230-000637	วัสดุใช้ไป	ยกเลิก ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม แบบเจาะรูกลาง (4"x4") ขนาด 45"x60" สีเขียวแก่มุมสีขาว	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	210.00	\N	0	0.00	\N	\N	f	\N	t	1
638	P230-000638	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว แบบเจาะรูกลาง (4"x4") ขนาด 25"x25" มุมสีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	99.00	\N	0	0.00	\N	\N	t	\N	t	4
639	P230-000639	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว แบบเจาะรูกลาง (4"x4") ขนาด 44"x44" มุมสีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	180.00	\N	0	0.00	\N	\N	t	\N	t	4
640	P230-000640	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม แบบเจาะรูกลาง (4"x6") ขนาด 60"x100" สีเขียวแก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	420.00	\N	0	0.00	\N	\N	t	\N	t	11
641	P230-000641	วัสดุใช้ไป	ผ้ารองถาดสี่เหลี่ยม ผ้าฟอกขาว แบบ 2 ชั้น ขนาด 25"x25"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	99.00	\N	0	0.00	\N	\N	t	\N	t	11
642	P230-000642	วัสดุใช้ไป	ผ้ารองเทเครื่องมือ ผ้าฟอกขาว แบบสี่เหลียม 2 ชั้น ขนาด 44"x44"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	180.00	\N	0	0.00	\N	\N	t	\N	t	4
643	P230-000643	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว ผ้าสี่เหลี่ยม 2 ชั้น ผ้าฟอกขาวมุมสีม่วง 16"x16" (Supply) ขนาด 16"x16" มุมสีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	30.00	\N	0	0.00	\N	\N	t	\N	t	11
644	P230-000644	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว ผ้าสี่เหลี่ยม 2 ชั้น ผ้าฟอกขาวมุมสีม่วง 25"x25" (Supply) ขนาด 25"x25" มุมสีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	99.00	\N	0	0.00	\N	\N	t	\N	t	1
645	P230-000645	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาวมุมสีม่วง 44"x44" (OR) ขนาด 44"x44" มุมสีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	180.00	\N	0	0.00	\N	\N	t	\N	t	1
646	P230-000646	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลี่ยม 2 ชั้น ผ้าย้อมสีเขียวแก่ 25"x25" (OR) ขนาด 25"x25" สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	110.00	\N	0	0.00	\N	\N	t	\N	t	1
647	P230-000647	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลียม 2 ชั้น ผ้าย้อมสีเขียวแก่ 45"x60" (OR) ขนาด 45"x60" สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	395.00	\N	0	0.00	\N	\N	t	\N	t	1
685	P230-000685	วัสดุใช้ไป	ชั้นอเนกประสงค์ ชนิดตะแกรงเหล็ก แบบ 4 ชั้น ขนาด 90 x 45 x 160 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	1780.00	\N	0	0.00	\N	\N	t	\N	t	4
648	P230-000648	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลี่ยม 2 ชั้น ผ้าย้อมสีเขียวแก่มุมสีม่วง 44"x44" (OR) ขนาด 44"x44" สีเขียวแก่มุมสีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	310.00	\N	0	0.00	\N	\N	t	\N	t	11
649	P230-000649	วัสดุใช้ไป	ยกเลิก ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลี่ยม 2 ชั้น ผ้าย้อมสีม่วง 16"x16" (Dent ยกเลิกใช้แล้ว) ขนาด 16"x16" สีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	30.00	\N	0	0.00	\N	\N	f	\N	t	4
650	P230-000650	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลียม 2 ชั้น ผ้าย้อมสีม่วง 25"x25" (Dent) ขนาด 25"x25" สีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	90.00	\N	0	0.00	\N	\N	t	\N	t	11
651	P230-000651	วัสดุใช้ไป	ผ้าห่ม ผ้าทอเดี่ยว ขนาด 60"x80" สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	600.00	\N	0	0.00	\N	\N	t	\N	t	4
652	P230-000652	วัสดุใช้ไป	ผ้าห่อ Spore test ผ้าฟอกขาว แบบ 2 ชั้น ขนาด 16"x26"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	80.00	\N	0	0.00	\N	\N	t	\N	t	4
653	P230-000653	วัสดุใช้ไป	เสื้อกาวน์นอก ผ้าโทเรหนา แบบแขนสั้น ขนาด L , XL , XXL สีขา	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	550.00	\N	0	0.00	\N	\N	t	\N	t	11
654	P230-000654	วัสดุใช้ไป	เสื้อกาวน์ผ่าตัด ผ้าย้อม ขนาด XXL สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	450.00	\N	0	0.00	\N	\N	t	\N	t	1
655	P230-000655	วัสดุใช้ไป	เสื้อกาวน์ผ่าตัด ผ้าย้อม ขนาด XXL สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	450.00	\N	0	0.00	\N	\N	t	\N	t	1
656	P230-000656	วัสดุใช้ไป	เสื้อคลุมกิโมโน ผ้าโทเรหนา แบบแขนสั้น ขนาด XL สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	380.00	\N	0	0.00	\N	\N	t	\N	t	4
657	P230-000657	วัสดุใช้ไป	เสื้อคลุมกิโมโน ผ้าโทเรหนา แบบแขนสั้น ขนาด L , XL สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	380.00	\N	0	0.00	\N	\N	t	\N	t	11
658	P230-000658	วัสดุใช้ไป	ยกเลิก เสื้อคลุม ผ้าวินเซนต์ แบบแขนยาวจ๊ำแขน กระเป๋าในขวา ขนาด L สีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	500.00	\N	0	0.00	\N	\N	f	\N	t	1
659	P230-000659	วัสดุใช้ไป	เสื้อคลุม ผ้าวินเซนต์ แบบแขนยาวจ้ำแขน ขนาด L , XL สีขาว	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	500.00	\N	0	0.00	\N	\N	t	\N	t	11
660	P230-000660	วัสดุใช้ไป	เสื้อคลุม ผ้าวินเซนต์ แบบแขนยาวจ้ำแขน ขนาด L , XL สีน้ำเงิน	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	500.00	\N	0	0.00	\N	\N	t	\N	t	4
661	P230-000661	วัสดุใช้ไป	เสื้อคลุม ผ้าวินเซนต์ แบบแขนยาวจ้ำแขน ขนาด M , L , XL สีฟ้า	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	500.00	\N	0	0.00	\N	\N	t	\N	t	11
662	P230-000662	วัสดุใช้ไป	เสื้อเด็กกลาง ผ้าย้อม ขนาดเด็ก 4-7 ปี สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	150.00	\N	0	0.00	\N	\N	t	\N	t	4
663	P230-000663	วัสดุใช้ไป	เสื้อเด็กเล็ก ผ้าย้อม ขนาดเด็ก 1-3 ปี สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	150.00	\N	0	0.00	\N	\N	t	\N	t	1
664	P230-000664	วัสดุใช้ไป	เสื้อผู้ใหญ่ ผ้าย้อม แบบป้ายข้าง ขนาด XXL สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	250.00	\N	0	0.00	\N	\N	t	\N	t	1
665	P230-000665	วัสดุใช้ไป	เสื้อผู้ใหญ่ ผ้าวินเซนต์ แบบป้ายข้าง ขนาด XXL สีแดงเลือดนก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	250.00	\N	0	0.00	\N	\N	t	\N	t	11
666	P230-000666	วัสดุใช้ไป	เสื้อผู้ใหญ่ ผ้าวินเซนต์ แบบป้ายข้าง ขนาด XL สีเม็ดมะปราง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	250.00	\N	0	0.00	\N	\N	t	\N	t	11
667	P230-000667	วัสดุใช้ไป	เสื้อกางเกงแพทย์ ผ้าโทเร แบบคอวี และกางเกง ขนาด L สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	500.00	\N	0	0.00	\N	\N	t	\N	t	4
668	P230-000668	วัสดุใช้ไป	เสื้อกางเกงแพทย์ ผ้าวินเซนต์ แบบคอวี และกางเกง ขนาด XXL สีเม็ดมะปราง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	580.00	\N	0	0.00	\N	\N	t	\N	t	11
669	P230-000669	วัสดุใช้ไป	เสื้อกางเกงแพทย์ ผ้าวินเซนต์ แบบคอวี และกางเกง ขนาด XXXL สีเม็ดมะปราง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	650.00	\N	0	0.00	\N	\N	t	\N	t	4
348	P230-000348	วัสดุใช้ไป	ถ่าน ชนิดธรรมดา ขนาด AA	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	10.00	\N	0	0.00	\N	\N	t	\N	t	4
670	P230-000670	วัสดุใช้ไป	เอี๊ยม ผ้ายางหนังเทียม	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	195.00	\N	0	0.00	\N	\N	t	\N	t	1
671	P230-000671	วัสดุใช้ไป	ชุดสครับ ผ้าโทเรหนา แบบเสื้อคอวี และกางเกง ขนาด L คละสี	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุด	800.00	\N	0	0.00	\N	\N	t	\N	t	11
672	P230-000672	วัสดุใช้ไป	ชุดสครับ ผ้าโทเรหนา แบบเสื้อคอวี และกางเกง ขนาด M คละสี	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุด	800.00	\N	0	0.00	\N	\N	t	\N	t	4
673	P230-000673	วัสดุใช้ไป	ชุดสครับ ผ้าโทเรหนา แบบเสื้อคอวี และกางเกง ขนาด XL คละสี	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุด	800.00	\N	0	0.00	\N	\N	t	\N	t	4
674	P230-000674	วัสดุใช้ไป	ชุดสครับ ผ้าโทเรหนา แบบเสื้อคอวี และกางเกง ขนาด XXL คละสี	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุด	800.00	\N	0	0.00	\N	\N	t	\N	t	11
675	P230-000675	วัสดุใช้ไป	ตรายาง สำหรับปั๊มเจาะเลือดประจำปีผู้ป่วย	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	150.00	\N	0	0.00	\N	\N	t	\N	t	1
676	P230-000676	วัสดุใช้ไป	ตรายาง สำหรับปั๊มโทรเลื่อนนัด	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	180.00	\N	0	0.00	\N	\N	t	\N	t	11
677	P230-000677	วัสดุใช้ไป	ตรายาง สำหรับปั๊มบันทึกกิจกรรมในผู้ป่วยCOPD/Asthma	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	200.00	\N	0	0.00	\N	\N	t	\N	t	1
678	P230-000678	วัสดุใช้ไป	ตรายาง สำหรับปั๊มแนะนำสำหรับการเตรียมตัวเจาะเลือด	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	100.00	\N	0	0.00	\N	\N	t	\N	t	1
679	P230-000679	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 60 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถัง	995.00	\N	0	0.00	\N	\N	t	\N	t	11
680	P230-000680	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก ขนาด 60 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถัง	950.00	\N	0	0.00	\N	\N	t	\N	t	4
681	P230-000681	วัสดุใช้ไป	พรมเช็ดเท้า แบบดักฝุ่น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ผืน	350.00	\N	0	0.00	\N	\N	t	\N	t	4
682	P230-000682	วัสดุใช้ไป	ฉากกันห้อง แบบครึ่งกระจกใส ขัดลาย ขนาด 80*160 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ชุด	5500.00	\N	0	0.00	\N	\N	t	\N	t	1
683	P230-000683	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีหูหิ้ว ฝาปิดระบบล็อก 2 ด้าน ความจุ 19 ลิตร ขนาด 38.5 x 26 x 22 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ใบ	250.00	\N	0	0.00	\N	\N	t	\N	t	1
684	P230-000684	วัสดุใช้ไป	ตู้อเนกประสงค์ ชนิดพลาสติก แบบ 5 ชั้น ขนาด 17.5 × 24.5 × 27 ซม	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	475.00	\N	0	0.00	\N	\N	t	\N	t	4
686	P230-000686	วัสดุใช้ไป	ชั้นอเนกประสงค์ แบบ 4 ชั้น ขนาด 42 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	488.00	\N	0	0.00	\N	\N	t	\N	t	1
687	P230-000687	วัสดุใช้ไป	ที่วัดส่วนสูง แบบมีฐาน ขนาด 200 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ชุด	1750.00	\N	0	0.00	\N	\N	t	\N	t	1
688	P230-000688	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีหูหิ้ว ฝาปิดระบบล็อก 2 ด้าน ความจุ 19 ลิตร ขนาด 38.5 x 26 x 22 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ใบ	240.00	\N	0	0.00	\N	\N	t	\N	t	1
689	P230-000689	วัสดุใช้ไป	บันได ชนิดอลูมีเนียม แบบ 8 ขั้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง-งบหน่วยงาน	อัน	2550.00	\N	0	0.00	\N	\N	t	\N	t	4
690	P230-000690	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบฝาปิด ขนาด 50 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถัง	2150.00	\N	0	0.00	\N	\N	t	\N	t	11
691	P230-000691	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบฝาปิด ขนาด 40 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถัง	1700.00	\N	0	0.00	\N	\N	t	\N	t	4
692	P230-000692	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 35 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ใบ	750.00	\N	0	0.00	\N	\N	t	\N	t	11
693	P230-000693	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 18 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ใบ	500.00	\N	0	0.00	\N	\N	t	\N	t	11
694	P230-000694	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก ทรงสูง แบบมีล้อและมีฝา ขนาด 120 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ใบ	1800.00	\N	0	0.00	\N	\N	t	\N	t	1
695	P230-000695	วัสดุใช้ไป	กระดาษโน๊ต แบบมีกาว ขนาด 3x3 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	แพ็ค	30.00	\N	0	0.00	\N	\N	t	\N	t	4
696	P230-000696	วัสดุใช้ไป	กระดาษโน๊ต แบบมีกาว ขนาด 0.8x3 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	แพ็ค	25.00	\N	0	0.00	\N	\N	t	\N	t	4
697	P230-000697	วัสดุใช้ไป	รองเท้า ชนิดผ้ารังผึ้ง แบบ Slippers	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	คู่	110.00	\N	0	0.00	\N	\N	t	\N	t	11
698	P230-000698	วัสดุใช้ไป	พรมเช็ดเท้า ขนาด 45*70 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ผืน	499.00	\N	0	0.00	\N	\N	t	\N	t	1
699	P230-000699	วัสดุใช้ไป	พรมเช็ดเท้า ขนาด 45*120 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ผืน	830.00	\N	0	0.00	\N	\N	t	\N	t	11
700	P230-000700	วัสดุใช้ไป	อิฐ ประสาน ขนาด 10*10*30 ซม.	วัสดุการเกษตร	วัสดุการเกษตร	ก้อน	20.00	\N	0	0.00	\N	\N	t	\N	t	1
701	P230-000701	วัสดุใช้ไป	ดิน ชนิดถุงสำเร็จ สำหรับปลูกต้นไม้	วัสดุการเกษตร	วัสดุการเกษตร	ถุง	10.00	\N	0	0.00	\N	\N	t	\N	t	11
702	P230-000702	วัสดุใช้ไป	แบตเตอรี่ แบบชาร์จไฟ ขนาด 800 มิลลิแอมป์	วัสดุไฟฟ้า	วัสดุไฟฟ้า-งบหน่วยงาน	ก้อน	500.00	\N	0	0.00	\N	\N	t	\N	t	1
703	P230-000703	วัสดุใช้ไป	ตะกร้า ชนิดพลาสติก แบบทรงเหลี่ยม ขนาด 14 x 14.5 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ใบ	180.00	\N	0	0.00	\N	\N	t	\N	t	4
704	P230-000704	วัสดุใช้ไป	กระดาน White board ติดผนัง ขนาด 120 x 90 cm. แบบติดผนัง ขนาด 120 x 90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	แผ่น	1500.00	\N	0	0.00	\N	\N	t	\N	t	4
705	P230-000705	วัสดุใช้ไป	บันได ชนิดอเนกประสงค์ แบบ 20 ขั้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง-งบหน่วยงาน	ตัว	5900.00	\N	0	0.00	\N	\N	t	\N	t	4
706	P230-000706	วัสดุใช้ไป	ตะกร้า ชนิดพลาสติก แบบทรงกลมและมีหูหิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ใบ	250.00	\N	0	0.00	\N	\N	t	\N	t	11
707	P230-000707	วัสดุใช้ไป	แมกเนติก	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	730.00	\N	0	0.00	\N	\N	t	\N	t	11
708	P230-000708	วัสดุใช้ไป	โอเวอร์โหลด	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	970.00	\N	0	0.00	\N	\N	t	\N	t	4
709	P230-000709	วัสดุใช้ไป	ล้อรถเข็น แบบแป้นหมุน ขนาด 5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	265.00	\N	0	0.00	\N	\N	t	\N	t	11
710	P230-000710	วัสดุใช้ไป	ล้อรถเข็น แบบแป้นตาย ขนาด 5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	245.00	\N	0	0.00	\N	\N	t	\N	t	1
711	P230-000711	วัสดุใช้ไป	หมึก Printer Ink jet BT-D60 BK สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	350.00	\N	0	0.00	\N	\N	t	\N	t	4
715	P230-000715	วัสดุใช้ไป	หน้าจาน ชนิดเหล็ก แบบเกลียว ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	600.00	\N	0	0.00	\N	\N	t	\N	t	11
716	P230-000716	วัสดุใช้ไป	น๊อต สำหรับหน้าแปลน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	30.00	\N	0	0.00	\N	\N	t	\N	t	1
717	P230-000717	วัสดุใช้ไป	ยางประเก็น สำหรับหน้าแปลน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	120.00	\N	0	0.00	\N	\N	t	\N	t	1
775	P230-000775	วัสดุใช้ไป	สีน้ำ สีขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	95.00	\N	0	0.00	\N	\N	t	\N	t	1
718	P230-000718	วัสดุใช้ไป	ชุดกรองอากาศ (Silencer valve) สำหรับเครื่องเติมอากาศ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	19474.00	\N	0	0.00	\N	\N	t	\N	t	4
719	P230-000719	วัสดุใช้ไป	ชุดน้ำทิ้ง สำหรับอ่างล้างเครื่องมือ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	358.00	\N	0	0.00	\N	\N	t	\N	t	1
720	P230-000720	วัสดุใช้ไป	ลูกบิด ชนิดหัวกลม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	99.00	\N	0	0.00	\N	\N	t	\N	t	4
721	P230-000721	วัสดุใช้ไป	สามทาง ชนิด PVC แบบลด ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	18.00	\N	0	0.00	\N	\N	t	\N	t	4
722	P230-000722	วัสดุใช้ไป	กิ๊บ ชนิดพลาสติก สำหรับจับท่อ ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	4.00	\N	0	0.00	\N	\N	t	\N	t	4
723	P230-000723	วัสดุใช้ไป	ประตูน้ำ ชนิด PVC ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	350.00	\N	0	0.00	\N	\N	t	\N	t	11
724	P230-000724	วัสดุใช้ไป	ประตูน้ำ ชนิดทองเหลือง ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	295.00	\N	0	0.00	\N	\N	t	\N	t	11
725	P230-000725	วัสดุใช้ไป	สกรู ชนิดเกลียวปล่อย ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่อง	78.00	\N	0	0.00	\N	\N	t	\N	t	11
726	P230-000726	วัสดุใช้ไป	แปรงสลัดน้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ด้าม	60.00	\N	0	0.00	\N	\N	t	\N	t	1
727	P230-000727	วัสดุใช้ไป	ฟองน้ำ สำหรับฉาบปูน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	8.00	\N	0	0.00	\N	\N	t	\N	t	4
728	P230-000728	วัสดุใช้ไป	แผ่นขัดเอนกประสงค์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ม้วน	550.00	\N	0	0.00	\N	\N	t	\N	t	11
729	P230-000729	วัสดุใช้ไป	ไม้อัด หนา 15 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	715.00	\N	0	0.00	\N	\N	t	\N	t	11
730	P230-000730	วัสดุใช้ไป	คาบูเรเตอร์ สำหรับเครื่องตัดแต่งกิ่งไม้	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	520.00	\N	0	0.00	\N	\N	t	\N	t	11
731	P230-000731	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 6*14 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	42.00	\N	0	0.00	\N	\N	t	\N	t	1
732	P230-000732	วัสดุใช้ไป	แฟ้ม แบบแขวน สีม่วง	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	15.00	\N	0	0.00	\N	\N	t	\N	t	1
733	P230-000733	วัสดุใช้ไป	ขายึด ชนิดเหล็ก สำหรับอ่าง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	40.00	\N	0	0.00	\N	\N	t	\N	t	11
734	P230-000734	วัสดุใช้ไป	เทอร์โมฟิวส์ แบบ 188 องศา ขนาด 10A	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	10.00	\N	0	0.00	\N	\N	t	\N	t	11
735	P230-000735	วัสดุใช้ไป	เทอมินอล สำหรับต่อสายไฟ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	4.00	\N	0	0.00	\N	\N	t	\N	t	11
738	P230-000738	วัสดุใช้ไป	ยกเลิก กิ๊บ ชนิดพลาสติก	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	f	\N	t	11
739	P230-000739	วัสดุใช้ไป	กิ๊บ ชนิดพลาสติก สำหรับสายโทรศัพท์ 2C	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N	t	11
740	P230-000740	วัสดุใช้ไป	ใบพัดลม ขนาด 16 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	120.00	\N	0	0.00	\N	\N	t	\N	t	4
742	P230-000742	วัสดุใช้ไป	พวงมาลา ชนิดดอกไม้ประดิษฐ์	วัสดุสำนักงาน	วัสดุสำนักงาน	พวง	2000.00	\N	0	0.00	\N	\N	t	\N	t	4
743	P230-000743	วัสดุใช้ไป	น้ำยาฆ่าหญ้า แบบแกลลอน	วัสดุการเกษตร	วัสดุการเกษตร	แกลลอน	900.00	\N	0	0.00	\N	\N	t	\N	t	4
744	P230-000744	วัสดุใช้ไป	เข็มหมุด	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่่อง	65.00	\N	0	0.00	\N	\N	t	\N	t	4
745	P230-000745	วัสดุใช้ไป	ปุ่มกด สำหรับประตูรีโมทอัตโนมัติ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	3500.00	\N	0	0.00	\N	\N	t	\N	t	11
746	P230-000746	วัสดุใช้ไป	สมุด สำหรับลงนามถวายพระพร	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	600.00	\N	0	0.00	\N	\N	t	\N	t	11
349	P230-000349	วัสดุใช้ไป	ถ่าน ชนิดอัลคาไลน์ ขนาด AA	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	20.00	\N	0	0.00	\N	\N	t	\N	t	11
747	P230-000747	วัสดุใช้ไป	พระบรมฉายาลักษณ์ สมเด็จเจ้าฟ้าพัชรกิติยาภาฯ	วัสดุสำนักงาน	วัสดุสำนักงาน	บาน	1200.00	\N	0	0.00	\N	\N	t	\N	t	1
748	P230-000748	วัสดุใช้ไป	ไขควง สำหรับเช็คกระแสไฟฟ้า	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	135.00	\N	0	0.00	\N	\N	t	\N	t	1
749	P230-000749	วัสดุใช้ไป	ขาหลอดนีออน แบบสปริงหัวโต	วัสดุไฟฟ้า	วัสดุไฟฟ้า	คู่	35.00	\N	0	0.00	\N	\N	t	\N	t	4
750	P230-000750	วัสดุใช้ไป	ลูกเสียบ ชนิดขาแบน แบบยาง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	10.00	\N	0	0.00	\N	\N	t	\N	t	1
751	P230-000751	วัสดุใช้ไป	รางสายไฟ แบบ TT202	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	40.00	\N	0	0.00	\N	\N	t	\N	t	1
752	P230-000752	วัสดุใช้ไป	กิ๊บ ชนิดพลาสติก ขนาด 2*1.5 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	t	\N	t	11
753	P230-000753	วัสดุใช้ไป	ขั้วแป้นเกลียว ชนิดกระเบื้อง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	15.00	\N	0	0.00	\N	\N	t	\N	t	4
754	P230-000754	วัสดุใช้ไป	สายไฟ แบบแข็ง ขนาด 2*1.5 ยาว 20 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	280.00	\N	0	0.00	\N	\N	t	\N	t	4
755	P230-000755	วัสดุใช้ไป	รางสายไฟ แบบ TD204	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	90.00	\N	0	0.00	\N	\N	t	\N	t	1
757	P230-000757	วัสดุใช้ไป	กล่องโทรศัพท์	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	4
758	P230-000758	วัสดุใช้ไป	คอนเรนเซอร์ ขนาด 40/450V	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	250.00	\N	0	0.00	\N	\N	t	\N	t	11
759	P230-000759	วัสดุใช้ไป	คอนเรนเซอร์ ขนาด 30/300V	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	480.00	\N	0	0.00	\N	\N	t	\N	t	11
760	P230-000760	วัสดุใช้ไป	ขาหนีบ สำหรับสปอตไลท์	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	65.00	\N	0	0.00	\N	\N	t	\N	t	1
761	P230-000761	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 25 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	135.00	\N	0	0.00	\N	\N	t	\N	t	11
762	P230-000762	วัสดุใช้ไป	ลูกเสียบ ชนิดขาแบน แบบ 3 ตา	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	15.00	\N	0	0.00	\N	\N	t	\N	t	4
763	P230-000763	วัสดุใช้ไป	สายไฟ แบบอ่อน ขนาด 2*1	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	12.00	\N	0	0.00	\N	\N	t	\N	t	4
764	P230-000764	วัสดุใช้ไป	ฟิวส์ ชนิดสั้น แบบหลอด ขนาด 10A	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	20.00	\N	0	0.00	\N	\N	t	\N	t	4
765	P230-000765	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	35.00	\N	0	0.00	\N	\N	t	\N	t	4
766	P230-000766	วัสดุใช้ไป	สามทาง ชนิด PVC แบบลด ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	20.00	\N	0	0.00	\N	\N	t	\N	t	4
767	P230-000767	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 45 องศา ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	18.00	\N	0	0.00	\N	\N	t	\N	t	11
768	P230-000768	วัสดุใช้ไป	กาว ชนิดประสาน สำหรับทาท่อ PVC ขนาด 100 กรัม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	70.00	\N	0	0.00	\N	\N	t	\N	t	4
822	P230-000822	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 7 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	80.00	\N	0	0.00	\N	\N	t	\N	t	11
769	P230-000769	วัสดุใช้ไป	บอลวาล์ว ชนิด PVC แบบสวม ขนาด 3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	47.00	\N	0	0.00	\N	\N	t	\N	t	1
770	P230-000770	วัสดุใช้ไป	ข้อต่อลด ชนิด PVC ขนาด 3*1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	132.00	\N	0	0.00	\N	\N	t	\N	t	11
771	P230-000771	วัสดุใช้ไป	ยกเลิก ข้อต่อตรง ชนิด PVC แบบเกลียวนอก ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	15.00	\N	0	0.00	\N	\N	f	\N	t	4
772	P230-000772	วัสดุใช้ไป	ขายึด ชนิดเหล็ก สำหรับซิงค์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	40.00	\N	0	0.00	\N	\N	t	\N	t	11
773	P230-000773	วัสดุใช้ไป	วอลฟุตตี้ ขนาด 1 กก.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	121.00	\N	0	0.00	\N	\N	t	\N	t	1
774	P230-000774	วัสดุใช้ไป	สกรู ชนิดไดวอ ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่อง	95.00	\N	0	0.00	\N	\N	t	\N	t	1
776	P230-000776	วัสดุใช้ไป	ยงยิปซั่ม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	33.00	\N	0	0.00	\N	\N	t	\N	t	11
777	P230-000777	วัสดุใช้ไป	ลูกบิด สำหรับประตูทั่วไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	242.00	\N	0	0.00	\N	\N	t	\N	t	11
778	P230-000778	วัสดุใช้ไป	ลวดเชื่อม สำหรับสแตนเลส	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	15.00	\N	0	0.00	\N	\N	t	\N	t	11
779	P230-000779	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 10 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	295.00	\N	0	0.00	\N	\N	t	\N	t	1
780	P230-000780	วัสดุใช้ไป	เหล็ก ชนิดหนา 2.3 มม. แบบแผ่น ขนาด 4*8 ฟุต	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	1505.00	\N	0	0.00	\N	\N	t	\N	t	1
781	P230-000781	วัสดุใช้ไป	กลอนประตู ชนิดอลูมีเนียม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	550.00	\N	0	0.00	\N	\N	t	\N	t	11
782	P230-000782	วัสดุใช้ไป	สายยาง ขนาด 5/4 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	เส้น	2160.00	\N	0	0.00	\N	\N	t	\N	t	1
783	P230-000783	วัสดุใช้ไป	ถุงมือ ชนิดผ้า	วัสดุการเกษตร	วัสดุการเกษตร	คู่	98.00	\N	0	0.00	\N	\N	t	\N	t	11
785	P230-000785	วัสดุใช้ไป	พุก ชนิดพลาสติก เบอร์ 6	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N	t	11
786	P230-000786	วัสดุใช้ไป	ยางในจักรยาน ขนาด 26*1.95	วัสดุยานพาหนะและขนส่ง	วัสดุยานพาหนะและขนส่ง	เส้น	130.00	\N	0	0.00	\N	\N	t	\N	t	11
787	P230-000787	วัสดุใช้ไป	ยกเลิก ตู้พลาสติก แบบกันน้ำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตู้	135.00	\N	0	0.00	\N	\N	f	\N	t	11
788	P230-000788	วัสดุใช้ไป	เบรคเกอร์ ขนาด 20A	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	125.00	\N	0	0.00	\N	\N	t	\N	t	4
789	P230-000789	วัสดุใช้ไป	ข้อต่อ ชนิดพลาสติก สำหรับเข้ากล่อง ขนาด 1/2 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	24.00	\N	0	0.00	\N	\N	t	\N	t	4
790	P230-000790	วัสดุใช้ไป	กิ๊บ ชนิดทองเหลือง สำหรับรัดสายท่อแก็ส	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	15.00	\N	0	0.00	\N	\N	t	\N	t	4
791	P230-000791	วัสดุใช้ไป	สามทาง ชนิด PVC แบบลด ขนาด 1*1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	20.00	\N	0	0.00	\N	\N	t	\N	t	4
792	P230-000792	วัสดุใช้ไป	ยกเลิก ข้อต่อตรง ชนิด PVC ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	12.00	\N	0	0.00	\N	\N	f	\N	t	1
793	P230-000793	วัสดุใช้ไป	ข้อต่อลด ชนิด PVC ขนาด 1*1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	6.00	\N	0	0.00	\N	\N	t	\N	t	11
794	P230-000794	วัสดุใช้ไป	ข้อต่อสายยาง ชนิด PVC ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	12.00	\N	0	0.00	\N	\N	t	\N	t	11
795	P230-000795	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบเหยียบ วาล์วกลม ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	600.00	\N	0	0.00	\N	\N	t	\N	t	11
796	P230-000796	วัสดุใช้ไป	ฝักบัวอาบน้ำ แบบพร้อมวาล์วฝักบัว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	297.00	\N	0	0.00	\N	\N	t	\N	t	1
797	P230-000797	วัสดุใช้ไป	มือจับ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	24.00	\N	0	0.00	\N	\N	t	\N	t	11
798	P230-000798	วัสดุใช้ไป	ดอกสว่าน ชนิดเจาะคอนกรีต ขนาด 2 หุน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	90.00	\N	0	0.00	\N	\N	t	\N	t	1
799	P230-000799	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC แบบเกลียวนอก ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	9.00	\N	0	0.00	\N	\N	t	\N	t	1
800	P230-000800	วัสดุใช้ไป	กิ๊บ ชนิดทองเหลือง สำหรับรัดท่อ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	3.00	\N	0	0.00	\N	\N	t	\N	t	4
801	P230-000801	วัสดุใช้ไป	ลวดเชื่อม สำหรับเหล็ก ขนาด 2 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ห่อ	200.00	\N	0	0.00	\N	\N	t	\N	t	4
802	P230-000802	วัสดุใช้ไป	ใบตัด สำหรับตัดเหล็ก ขนาด 4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	22.00	\N	0	0.00	\N	\N	t	\N	t	11
803	P230-000803	วัสดุใช้ไป	ดอกสว่าน ขนาด 9/64	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ดอก	33.00	\N	0	0.00	\N	\N	t	\N	t	11
804	P230-000804	วัสดุใช้ไป	ปืนยิงซิลิโคน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ด้าม	95.00	\N	0	0.00	\N	\N	t	\N	t	11
805	P230-000805	วัสดุใช้ไป	กาว ชนิด 2 ตัน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	132.00	\N	0	0.00	\N	\N	t	\N	t	4
806	P230-000806	วัสดุใช้ไป	ไม้อัด หนา 8 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	420.00	\N	0	0.00	\N	\N	t	\N	t	1
807	P230-000807	วัสดุใช้ไป	ท่อสายไฟ ชนิด PVC แบบท่ออ่อน ขนาด 1/2 นิ้ว สีขาว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	17.00	\N	0	0.00	\N	\N	t	\N	t	1
808	P230-000808	วัสดุใช้ไป	กล่องพักสาย ชนิดพลาสติก แบบเหลี่ยม ขนาด 2/4 นิ้ว สีขาว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	t	\N	t	11
809	P230-000809	วัสดุใช้ไป	ข้อต่อตรง ชนิดเหล็ก ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	33.00	\N	0	0.00	\N	\N	t	\N	t	4
810	P230-000810	วัสดุใช้ไป	ยกเลิก ก๊อกน้ำ ชนิดทองเหลือง แบบดัช ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	440.00	\N	0	0.00	\N	\N	f	\N	t	1
811	P230-000811	วัสดุใช้ไป	บานพับ ขนาด 3*1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	17.00	\N	0	0.00	\N	\N	t	\N	t	4
812	P230-000812	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับซิงค์ แบบต่อหลัง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	275.00	\N	0	0.00	\N	\N	t	\N	t	4
813	P230-000813	วัสดุใช้ไป	เบาะหุ้มจักรยาน	วัสดุยานพาหนะและขนส่ง	วัสดุยานพาหนะและขนส่ง	อัน	180.00	\N	0	0.00	\N	\N	t	\N	t	4
815	P230-000815	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับแก้วชน แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	95.00	\N	0	0.00	\N	\N	t	\N	t	4
816	P230-000816	วัสดุใช้ไป	ชุดสายชำระ แบบรวมหัวฉีดและสายชำระ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	390.00	\N	0	0.00	\N	\N	t	\N	t	4
817	P230-000817	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	48.00	\N	0	0.00	\N	\N	t	\N	t	11
818	P230-000818	วัสดุใช้ไป	ข้อต่อลด ชนิด PVC ขนาด 3/4 * 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	10.00	\N	0	0.00	\N	\N	t	\N	t	1
819	P230-000819	วัสดุใช้ไป	ดอกสว่าน ชนิดเจาะคอนกรีต ขนาด 1/4 หุน 4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	55.00	\N	0	0.00	\N	\N	t	\N	t	1
820	P230-000820	วัสดุใช้ไป	มินิวาล์ว ชนิดทองเหลือง แบบเกลียวนอก ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	155.00	\N	0	0.00	\N	\N	t	\N	t	1
821	P230-000821	วัสดุใช้ไป	กระดาษชาร์ท หนา 450 แกรม สีเทา-ขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	20.00	\N	0	0.00	\N	\N	t	\N	t	11
824	P230-000824	วัสดุใช้ไป	สีน้ำมัน ชนิดทาภายนอก ขนาด 2.5 ลิตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	2490.00	\N	0	0.00	\N	\N	t	\N	t	4
825	P230-000825	วัสดุใช้ไป	สีน้ำมัน ชนิดทาภายใน ขนาด 1 ลิตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	1195.00	\N	0	0.00	\N	\N	t	\N	t	4
878	P230-000878	วัสดุใช้ไป	กรอบบัตรประจำตัว แบบแข็ง	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	12.00	\N	0	0.00	\N	\N	t	\N	t	11
826	P230-000826	วัสดุใช้ไป	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 2.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	65.00	\N	0	0.00	\N	\N	t	\N	t	11
827	P230-000827	วัสดุใช้ไป	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	95.00	\N	0	0.00	\N	\N	t	\N	t	4
828	P230-000828	วัสดุใช้ไป	ลูกกลิ้งทาสี ขนาด 10 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	79.00	\N	0	0.00	\N	\N	t	\N	t	4
829	P230-000829	วัสดุใช้ไป	ด้ามต่อ สำหรับต่อลูกกลิ้งทาสี ยาว 2 เมตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	109.00	\N	0	0.00	\N	\N	t	\N	t	4
830	P230-000830	วัสดุใช้ไป	แม่สี เบอร์ BV	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี.	1.50	\N	0	0.00	\N	\N	t	\N	t	1
831	P230-000831	วัสดุใช้ไป	แม่สี เบอร์ OK	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี.	1.50	\N	0	0.00	\N	\N	t	\N	t	11
832	P230-000832	วัสดุใช้ไป	แม่สี เบอร์ SS	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี.	2.00	\N	0	0.00	\N	\N	t	\N	t	11
833	P230-000833	วัสดุใช้ไป	แม่สี เบอร์ ST	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี.	2.50	\N	0	0.00	\N	\N	t	\N	t	1
834	P230-000834	วัสดุใช้ไป	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 3/4 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	11.50	\N	0	0.00	\N	\N	t	\N	t	1
835	P230-000835	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	150.00	\N	0	0.00	\N	\N	t	\N	t	4
836	P230-000836	วัสดุใช้ไป	ยูเนียน ชนิดเหล็ก ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	205.00	\N	0	0.00	\N	\N	t	\N	t	11
837	P230-000837	วัสดุใช้ไป	ยกเลิก ข้องอ ชนิด PVC หนา แบบ 90 องศา ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	40.00	\N	0	0.00	\N	\N	f	\N	t	1
838	P230-000838	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	28.00	\N	0	0.00	\N	\N	t	\N	t	4
839	P230-000839	วัสดุใช้ไป	เกลียวนอก ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	28.00	\N	0	0.00	\N	\N	t	\N	t	4
840	P230-000840	วัสดุใช้ไป	หนังสือ มาตฐาน SPA part I , II , III , IV	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	550.00	\N	0	0.00	\N	\N	t	\N	t	4
841	P230-000841	วัสดุใช้ไป	รางสายไฟ แบบ DT1225 นาโน	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	55.00	\N	0	0.00	\N	\N	t	\N	t	4
842	P230-000842	วัสดุใช้ไป	สต๊อปวาล์ว ชนิดลอย แบบหัวแก้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	160.00	\N	0	0.00	\N	\N	t	\N	t	1
843	P230-000843	วัสดุใช้ไป	สายน้ำดี ขนาด 32 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	75.00	\N	0	0.00	\N	\N	t	\N	t	1
844	P230-000844	วัสดุใช้ไป	จานเอ็น สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	130.00	\N	0	0.00	\N	\N	t	\N	t	1
845	P230-000845	วัสดุใช้ไป	กรรไกร สำหรับต้นไม้สูง สำหรับตัดแต่งกิ่ง ขนาด 1.5 เมตร	วัสดุการเกษตร	วัสดุการเกษตร	อัน	1790.00	\N	0	0.00	\N	\N	t	\N	t	11
846	P230-000846	วัสดุใช้ไป	ตะไบ ชนิดกลม สำหรับเลื่อยยนต์ ขนาด 3/8 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	อัน	180.00	\N	0	0.00	\N	\N	t	\N	t	4
847	P230-000847	วัสดุใช้ไป	ตะไบ ชนิดกลม สำหรับเลื่อยยนต์ ขนาด 4 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	อัน	260.00	\N	0	0.00	\N	\N	t	\N	t	1
848	P230-000848	วัสดุใช้ไป	ยกเลิก จารบี สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	กระป๋อง	100.00	\N	0	0.00	\N	\N	f	\N	t	1
850	P230-000850	วัสดุใช้ไป	มือจับ แบบก้านโยก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	1490.00	\N	0	0.00	\N	\N	t	\N	t	11
851	P230-000851	วัสดุใช้ไป	ยกเลิก ปากกา เขียนแผ่น CD สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	40.00	\N	0	0.00	\N	\N	f	\N	t	4
852	P230-000852	วัสดุใช้ไป	ยกเลิก ปากกา เขียนแผ่น CD สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	40.00	\N	0	0.00	\N	\N	f	\N	t	11
853	P230-000853	วัสดุใช้ไป	ชุดดรัมหมึก HP e77830 สำหรับเครื่องถ่ายเอกสาร	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	9500.00	\N	0	0.00	\N	\N	t	\N	t	4
854	P230-000854	วัสดุใช้ไป	เทปกาว ชนิด 2 หน้า แบบบาง ขนาด 1 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	132.00	\N	0	0.00	\N	\N	t	\N	t	4
855	P230-000855	วัสดุใช้ไป	ถังขยะ ชนิดสแตนเลส แบบเท้าเหยียบ ขนาด 20 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1690.00	\N	0	0.00	\N	\N	t	\N	t	1
856	P230-000856	วัสดุใช้ไป	สกรู ชนิดเกลียวปล่อย ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่อง	77.00	\N	0	0.00	\N	\N	t	\N	t	4
857	P230-000857	วัสดุใช้ไป	ดอกสว่าน ชนิดเจาะคอนกรีต ขนาด 6.5 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	94.00	\N	0	0.00	\N	\N	t	\N	t	11
858	P230-000858	วัสดุใช้ไป	รีเวท ขนาด (4-3)	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	31.00	\N	0	0.00	\N	\N	t	\N	t	11
859	P230-000859	วัสดุใช้ไป	ล้อรถเข็น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	660.00	\N	0	0.00	\N	\N	t	\N	t	4
860	P230-000860	วัสดุใช้ไป	กาว ชนิดยาง ขนาดเล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระปุก	83.00	\N	0	0.00	\N	\N	t	\N	t	4
861	P230-000861	วัสดุใช้ไป	ล้อรถเข็น ชนิดยาง แบบเกลียว ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	121.00	\N	0	0.00	\N	\N	t	\N	t	11
862	P230-000862	วัสดุใช้ไป	กระเบื้อง ชนิดลอนคู่ ขนาด 1.5 เมตร สีขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	70.00	\N	0	0.00	\N	\N	t	\N	t	11
863	P230-000863	วัสดุใช้ไป	สกรู ชนิดปลายสว่าน ขนาด 4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	3.50	\N	0	0.00	\N	\N	t	\N	t	1
864	P230-000864	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีล้อ พร้อมฝาปิด ขนาด 100 ลิตร	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	359.00	\N	0	0.00	\N	\N	t	\N	t	1
865	P230-000865	วัสดุใช้ไป	สายยาง ขนาด 1/2 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	เมตร	20.00	\N	0	0.00	\N	\N	t	\N	t	1
866	P230-000866	วัสดุใช้ไป	ยกเลิก หมึก Printer Laser Fuji Apeos C325/328 dw	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	f	\N	t	4
867	P230-000867	วัสดุใช้ไป	สกรู ชนิดปลายสว่าน ขนาด 8*3/4	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	20.00	\N	0	0.00	\N	\N	t	\N	t	11
868	P230-000868	วัสดุใช้ไป	น๊อต แบบเกลียวปล่อย ขนาด 7*1/2	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	15.00	\N	0	0.00	\N	\N	t	\N	t	4
869	P230-000869	วัสดุใช้ไป	พุก ชนิดพลาสติก แบบผีเสื้อ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	5.00	\N	0	0.00	\N	\N	t	\N	t	1
870	P230-000870	วัสดุใช้ไป	น๊อต แบบเกลียวปล่อย ขนาด 8*2	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	25.00	\N	0	0.00	\N	\N	t	\N	t	1
871	P230-000871	วัสดุใช้ไป	แม่สี เบอร์ CS04 สีดำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี	2.50	\N	0	0.00	\N	\N	t	\N	t	4
872	P230-000872	วัสดุใช้ไป	แม่สี เบอร์ CS06 สีน้ำเงิน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี	2.50	\N	0	0.00	\N	\N	t	\N	t	1
873	P230-000873	วัสดุใช้ไป	แม่สี เบอร์ CS08 สีแดงออกไซด์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี	1.75	\N	0	0.00	\N	\N	t	\N	t	11
874	P230-000874	วัสดุใช้ไป	ชุดแทงค์ HP e77830 สำหรับเครื่องถ่ายเอกสาร สี BK	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	6600.00	\N	0	0.00	\N	\N	t	\N	t	1
875	P230-000875	วัสดุใช้ไป	ชุดแทงค์ HP e77830 สำหรับเครื่องถ่ายเอกสาร สี C	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	6600.00	\N	0	0.00	\N	\N	t	\N	t	11
876	P230-000876	วัสดุใช้ไป	ชุดแทงค์ HP e77830 สำหรับเครื่องถ่ายเอกสาร สี M	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	6600.00	\N	0	0.00	\N	\N	t	\N	t	4
986	P230-000986	วัสดุใช้ไป	น้ำยาฆ่าหญ้า แบบขวด	วัสดุการเกษตร	วัสดุการเกษตร	ขวด	500.00	\N	0	0.00	\N	\N	t	\N	t	4
877	P230-000877	วัสดุใช้ไป	ชุดแทงค์ HP e77830 สำหรับเครื่องถ่ายเอกสาร สี Y	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	6600.00	\N	0	0.00	\N	\N	t	\N	t	4
879	P230-000879	วัสดุใช้ไป	สายคล้องคอ สำหรับบัตรประจำตัว	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	11
880	P230-000880	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	44.00	\N	0	0.00	\N	\N	t	\N	t	11
881	P230-000881	วัสดุใช้ไป	บอลวาล์ว ชนิด PVC ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	1265.00	\N	0	0.00	\N	\N	t	\N	t	4
882	P230-000882	วัสดุใช้ไป	แผ่นปิดรอยต่อ ขนาดม้วนใหญ่	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ม้วน	550.00	\N	0	0.00	\N	\N	t	\N	t	11
883	P230-000883	วัสดุใช้ไป	ล้อรถเข็น ชนิดบอล แบบเกลียว ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	155.00	\N	0	0.00	\N	\N	t	\N	t	1
884	P230-000884	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC แบบเกลียวนอก ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	26.00	\N	0	0.00	\N	\N	t	\N	t	4
885	P230-000885	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบลด ขนาด 13.5*2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	420.00	\N	0	0.00	\N	\N	t	\N	t	1
886	P230-000886	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบลด ขนาด 8.5*2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	227.00	\N	0	0.00	\N	\N	t	\N	t	1
887	P230-000887	วัสดุใช้ไป	ไฟสนาม แบบสปอตไลท์ ขนาด 2000 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	3890.00	\N	0	0.00	\N	\N	t	\N	t	4
888	P230-000888	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC ขนาด 3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	9.00	\N	0	0.00	\N	\N	t	\N	t	11
889	P230-000889	วัสดุใช้ไป	ยางรองชักโครก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	40.00	\N	0	0.00	\N	\N	t	\N	t	1
890	P230-000890	วัสดุใช้ไป	สายชักโครก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	65.00	\N	0	0.00	\N	\N	t	\N	t	11
891	P230-000891	วัสดุใช้ไป	ประตูน้ำ ชนิด PVC ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	220.00	\N	0	0.00	\N	\N	t	\N	t	4
892	P230-000892	วัสดุใช้ไป	กาว ชนิดประสาน สำหรับทาท่อ PVC ขนาด 500 กรัม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	300.00	\N	0	0.00	\N	\N	t	\N	t	4
893	P230-000893	วัสดุใช้ไป	ฝาครอบ ชนิด PVC ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	14.00	\N	0	0.00	\N	\N	t	\N	t	1
894	P230-000894	วัสดุใช้ไป	ฝาครอบ ชนิด PVC ขนาด 3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	9.00	\N	0	0.00	\N	\N	t	\N	t	4
895	P230-000895	วัสดุใช้ไป	ข้อต่อลด ชนิด PVC ขนาด 2*1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	44.00	\N	0	0.00	\N	\N	t	\N	t	11
896	P230-000896	วัสดุใช้ไป	ฟลัชวาล์ว ชนิดท่อโค้ง สำหรับโถชาย	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	679.00	\N	0	0.00	\N	\N	t	\N	t	11
897	P230-000897	วัสดุใช้ไป	ฝานั่งรองชักโครก ชนิดพลาสติก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	499.00	\N	0	0.00	\N	\N	t	\N	t	1
898	P230-000898	วัสดุใช้ไป	ตะแกรงรังผึ้ง ขนาด 2*1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	29.00	\N	0	0.00	\N	\N	t	\N	t	11
899	P230-000899	วัสดุใช้ไป	สีสะท้อนแสง ขนาด 3 ลิตร สีขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	820.00	\N	0	0.00	\N	\N	t	\N	t	11
900	P230-000900	วัสดุใช้ไป	สีสะท้อนแสง ขนาด 3 ลิตร สีดำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	850.00	\N	0	0.00	\N	\N	t	\N	t	11
901	P230-000901	วัสดุใช้ไป	สีน้ำมัน สีเทา	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	650.00	\N	0	0.00	\N	\N	t	\N	t	1
902	P230-000902	วัสดุใช้ไป	ทินเนอร์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	175.00	\N	0	0.00	\N	\N	t	\N	t	11
929	P230-000929	วัสดุใช้ไป	ดอกสว่าน ชนิดโรตารี่	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	380.00	\N	0	0.00	\N	\N	t	\N	t	4
903	P230-000903	วัสดุใช้ไป	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	85.00	\N	0	0.00	\N	\N	t	\N	t	4
904	P230-000904	วัสดุใช้ไป	สกรู ชนิดเกลียวปล่อย ขนาด 3.5*40 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่อง	36.00	\N	0	0.00	\N	\N	t	\N	t	11
905	P230-000905	วัสดุใช้ไป	อีพ๊อคซี่ สำหรับเสียบเหล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิโลกรัม	359.00	\N	0	0.00	\N	\N	t	\N	t	4
906	P230-000906	วัสดุใช้ไป	ดอกสว่าน ชนิดเจาะเหล็ก แบบ 19 ชิ้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	390.00	\N	0	0.00	\N	\N	t	\N	t	4
907	P230-000907	วัสดุใช้ไป	สายวัด ยาว 30 เมตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	639.00	\N	0	0.00	\N	\N	t	\N	t	1
908	P230-000908	วัสดุใช้ไป	มีดคัทเตอร์ แบบด้ามพลาสติก ยาว 18 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	149.00	\N	0	0.00	\N	\N	t	\N	t	4
909	P230-000909	วัสดุใช้ไป	ประแจเลื่อน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	255.00	\N	0	0.00	\N	\N	t	\N	t	4
910	P230-000910	วัสดุใช้ไป	ไขควง แบบสลับหัว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	109.00	\N	0	0.00	\N	\N	t	\N	t	4
911	P230-000911	วัสดุใช้ไป	ปากกา สำหรับตัดกระเบื้องและกระจก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	289.00	\N	0	0.00	\N	\N	t	\N	t	1
912	P230-000912	วัสดุใช้ไป	แปรง ชนิดลวด แบบรูปถ้วย ขนาด 3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	89.00	\N	0	0.00	\N	\N	t	\N	t	1
913	P230-000913	วัสดุใช้ไป	คีม ชนิดปากแหลม ขนาด 6 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	179.00	\N	0	0.00	\N	\N	t	\N	t	1
914	P230-000914	วัสดุใช้ไป	คีม ชนิดปากแหลม ขนาด 8 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	230.00	\N	0	0.00	\N	\N	t	\N	t	1
915	P230-000915	วัสดุใช้ไป	สกัด ชนิดปากแบน แบบด้ามยาง ขนาด 10 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	99.00	\N	0	0.00	\N	\N	t	\N	t	11
916	P230-000916	วัสดุใช้ไป	ไขควง แบบสลับหัว ขนาด 6 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	60.00	\N	0	0.00	\N	\N	t	\N	t	11
917	P230-000917	วัสดุใช้ไป	ประแจ แบบแหวนข้างปากตาย เบอร์ 21	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	99.00	\N	0	0.00	\N	\N	t	\N	t	4
918	P230-000918	วัสดุใช้ไป	มีดคัทเตอร์ แบบด้ามโลหะ ยาว 18 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	49.00	\N	0	0.00	\N	\N	t	\N	t	1
919	P230-000919	วัสดุใช้ไป	ชุด 6 เหลี่ยม แบบ 13 ชิ้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	599.00	\N	0	0.00	\N	\N	t	\N	t	11
920	P230-000920	วัสดุใช้ไป	คีม ชนิดปากตรง สำหรับล๊อค ขนาด 10 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	225.00	\N	0	0.00	\N	\N	t	\N	t	1
921	P230-000921	วัสดุใช้ไป	ไขควง แบบสลับหัว ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	59.00	\N	0	0.00	\N	\N	t	\N	t	1
922	P230-000922	วัสดุใช้ไป	ค้อน ชนิดเหล็ก แบบหงอน ด้ามไฟเบอร์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	169.00	\N	0	0.00	\N	\N	t	\N	t	11
923	P230-000923	วัสดุใช้ไป	ปากกา สำหรับเช็คกระแสไฟ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	139.00	\N	0	0.00	\N	\N	t	\N	t	1
924	P230-000924	วัสดุใช้ไป	ชุด 6 เหลี่ยม แบบ 9 ชิ้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	169.00	\N	0	0.00	\N	\N	t	\N	t	11
925	P230-000925	วัสดุใช้ไป	ด้ามกบไสไม้ แบบพร้อมลิ่ม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	30.00	\N	0	0.00	\N	\N	t	\N	t	11
926	P230-000926	วัสดุใช้ไป	คีม ชนิดปากเฉียง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	125.00	\N	0	0.00	\N	\N	t	\N	t	11
927	P230-000927	วัสดุใช้ไป	กรรไกร สำหรับตัดแผ่นโลหะ ขนาด 10 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	239.00	\N	0	0.00	\N	\N	t	\N	t	1
928	P230-000928	วัสดุใช้ไป	สิ่ว ชนิดเหล็ก แบบด้ามไม้	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	50.00	\N	0	0.00	\N	\N	t	\N	t	4
1099	P230-001099	วัสดุใช้ไป	สายไฟ แบบคอนโทรล	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	10.00	\N	0	0.00	\N	\N	t	\N	t	4
930	P230-000930	วัสดุใช้ไป	ประแจ แบบแหวนข้างปากตาย เบอร์ 14	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	69.00	\N	0	0.00	\N	\N	t	\N	t	1
931	P230-000931	วัสดุใช้ไป	ไขควง ซ่อมนาฬิกา แบบ 4 ชิ้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	89.00	\N	0	0.00	\N	\N	t	\N	t	11
932	P230-000932	วัสดุใช้ไป	กบไสไม้ ขนาด 8 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	260.00	\N	0	0.00	\N	\N	t	\N	t	11
933	P230-000933	วัสดุใช้ไป	ใบมีดกบไสไม้ ขนาด 1.3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	65.00	\N	0	0.00	\N	\N	t	\N	t	1
966	P230-000966	วัสดุใช้ไป	ยกเลิก แฟ้ม แบบแขวน สีม่วง	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	90.00	\N	0	0.00	\N	\N	f	\N	t	4
934	P230-000934	วัสดุใช้ไป	สกัด ชนิดปากแหลม แบบด้ามยาง ขนาด 10 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	99.00	\N	0	0.00	\N	\N	t	\N	t	4
935	P230-000935	วัสดุใช้ไป	เลื่อย ชนิดโครงเหล็ก ขนาด 12 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	115.00	\N	0	0.00	\N	\N	t	\N	t	4
936	P230-000936	วัสดุใช้ไป	หมึก Printer Laser TN 1000	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	390.00	\N	0	0.00	\N	\N	t	\N	t	11
937	P230-000937	วัสดุใช้ไป	หมึก Printer Laser PANTUM P2500	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	850.00	\N	0	0.00	\N	\N	t	\N	t	4
939	P230-000939	วัสดุใช้ไป	ถ่าน BIOS แบบ LR2032	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	55.00	\N	0	0.00	\N	\N	t	\N	t	1
941	P230-000941	วัสดุใช้ไป	Hardisk ชนิด SSD External ขนาด 240 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1090.00	\N	0	0.00	\N	\N	t	\N	t	4
946	P230-000946	วัสดุใช้ไป	หมึก Printer Laser Fuji Apeos C325/328 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N	t	11
947	P230-000947	วัสดุใช้ไป	หมึก Printer Laser Fuji Apeos C325/328 สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N	t	4
948	P230-000948	วัสดุใช้ไป	หมึก Printer Laser Fuji Apeos C325/328 สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N	t	4
949	P230-000949	วัสดุใช้ไป	หมึก Printer Laser Fuji Apeos C325/328 สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N	t	1
950	P230-000950	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ถัขนาด 3 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	390.00	\N	0	0.00	\N	\N	t	\N	t	4
951	P230-000951	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 5 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	390.00	\N	0	0.00	\N	\N	t	\N	t	4
952	P230-000952	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 6*14 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	60.00	\N	0	0.00	\N	\N	t	\N	t	1
953	P230-000953	วัสดุใช้ไป	ตะกร้า ชนิดหวาย แบบทรงเหลี่ยม ขนาด 30 x 20 x 9 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	200.00	\N	0	0.00	\N	\N	t	\N	t	4
954	P230-000954	วัสดุใช้ไป	ตะกร้า ชนิดพลาสติก แบบทรงเหลี่ยม ขนาด 32 x 21 x 14 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	250.00	\N	0	0.00	\N	\N	t	\N	t	1
955	P230-000955	วัสดุใช้ไป	สบู่ แบบเหลว สำหรับทารก ขนาด 850 ซีซี.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขวด	60.00	\N	0	0.00	\N	\N	t	\N	t	4
956	P230-000956	วัสดุใช้ไป	หวี สำหรับเด็ก	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	30.00	\N	0	0.00	\N	\N	t	\N	t	1
985	P230-000985	วัสดุใช้ไป	เมล็ดพันธ์ดอกไม้	วัสดุการเกษตร	วัสดุการเกษตร	กิโลกรัม	500.00	\N	0	0.00	\N	\N	t	\N	t	11
957	P230-000957	วัสดุใช้ไป	ตะกร้า สำหรับใส่อุปกรณ์อาบน้ำเด็ก	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	40.00	\N	0	0.00	\N	\N	t	\N	t	4
958	P230-000958	วัสดุใช้ไป	กะละมัง สำหรับอาบน้ำเด็ก	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	260.00	\N	0	0.00	\N	\N	t	\N	t	4
959	P230-000959	วัสดุใช้ไป	กระติกน้ำแข็ง ขนาด 10 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	200.00	\N	0	0.00	\N	\N	t	\N	t	11
960	P230-000960	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*20 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	60.00	\N	0	0.00	\N	\N	t	\N	t	1
961	P230-000961	วัสดุใช้ไป	น้ำกลั่นแบตเตอรี่ สำหรับเครื่องนึ่ง EO ขนาด 1 ลิตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ขวด	200.00	\N	0	0.00	\N	\N	t	\N	t	11
962	P230-000962	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 40 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	120.00	\N	0	0.00	\N	\N	t	\N	t	1
963	P230-000963	วัสดุใช้ไป	ปลั๊กไฟพ่วง แบบ 4 ช่อง 4 สวิตซ์ ยาว 10 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	399.00	\N	0	0.00	\N	\N	t	\N	t	4
964	P230-000964	วัสดุใช้ไป	กรอบรูป ขนาด 4x6 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	200.00	\N	0	0.00	\N	\N	t	\N	t	11
965	P230-000965	วัสดุใช้ไป	พู่กัน เบอร์8	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	40.00	\N	0	0.00	\N	\N	t	\N	t	11
967	P230-000967	วัสดุใช้ไป	เทปกาว ชนิดแลกซีน ขนาด 1.5 นิ้ว ยาว 8 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	30.00	\N	0	0.00	\N	\N	t	\N	t	4
968	P230-000968	วัสดุใช้ไป	กระดาษการ์ด หนา 150 แกรม ขนาด A4 สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	120.00	\N	0	0.00	\N	\N	t	\N	t	11
969	P230-000969	วัสดุใช้ไป	กระดาษการ์ด หนา 150 แกรม ขนาด A4 สีชมพู	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	120.00	\N	0	0.00	\N	\N	t	\N	t	11
970	P230-000970	วัสดุใช้ไป	กระดาษการ์ด หนา 150 แกรม ขนาด A4 สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	120.00	\N	0	0.00	\N	\N	t	\N	t	1
971	P230-000971	วัสดุใช้ไป	เครื่องเย็บกระดาษ ขนาดใหญ่	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	2500.00	\N	0	0.00	\N	\N	t	\N	t	4
972	P230-000972	วัสดุใช้ไป	กระดาษโน๊ต แบบมีกาว ขนาด 7.5x 7.5 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	80.00	\N	0	0.00	\N	\N	t	\N	t	1
973	P230-000973	วัสดุใช้ไป	กระดาษโน๊ต แบบมีกาว ขนาด 2.5x 7.5 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	80.00	\N	0	0.00	\N	\N	t	\N	t	1
974	P230-000974	วัสดุใช้ไป	กระดาษการ์ด หนา 180 แกรม แบบมีกลิ่นหอม ขนาด A4 สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	120.00	\N	0	0.00	\N	\N	t	\N	t	4
975	P230-000975	วัสดุใช้ไป	กระดาษการ์ด หนา 180 แกรม แบบมีกลิ่นหอม ขนาด A4 สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	120.00	\N	0	0.00	\N	\N	t	\N	t	4
976	P230-000976	วัสดุใช้ไป	กระดาษการ์ด หนา 180 แกรม แบบมีกลิ่นหอม ขนาด A4 สีชมพู	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	120.00	\N	0	0.00	\N	\N	t	\N	t	1
978	P230-000978	วัสดุใช้ไป	เสื้อกาวน์ แบบกันน้ำ	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	490.00	\N	0	0.00	\N	\N	t	\N	t	4
979	P230-000979	วัสดุใช้ไป	ใบหินเจียร แบบหนา ขนาด 4 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	ใบ	350.00	\N	0	0.00	\N	\N	t	\N	t	4
980	P230-000980	วัสดุใช้ไป	ลวดมัดเหล็ก	วัสดุการเกษตร	วัสดุการเกษตร	ม้วน	120.00	\N	0	0.00	\N	\N	t	\N	t	1
981	P230-000981	วัสดุใช้ไป	คีม สำหรับมัดลวด	วัสดุการเกษตร	วัสดุการเกษตร	อัน	100.00	\N	0	0.00	\N	\N	t	\N	t	11
982	P230-000982	วัสดุใช้ไป	ไขควง ชนิดปากแฉก	วัสดุการเกษตร	วัสดุการเกษตร	อัน	180.00	\N	0	0.00	\N	\N	t	\N	t	1
983	P230-000983	วัสดุใช้ไป	ไขควง ชนิดปากแบน	วัสดุการเกษตร	วัสดุการเกษตร	อัน	180.00	\N	0	0.00	\N	\N	t	\N	t	4
984	P230-000984	วัสดุใช้ไป	เชือก ชนิดป่านมะนิลา ขนาด 18 มม. สีขาว	วัสดุการเกษตร	วัสดุการเกษตร	เมตร	450.00	\N	0	0.00	\N	\N	t	\N	t	4
1257	P230-001257	วัสดุใช้ไป	โคมไฟโรงงาน ขนาด 18 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	478.00	\N	0	0.00	\N	\N	t	\N	t	1
988	P230-000988	วัสดุใช้ไป	Hardisk ชนิด SSD External ขนาด 500 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เครื่อง	3000.00	\N	0	0.00	\N	\N	t	\N	t	11
990	P230-000990	วัสดุใช้ไป	เสื้อผู้ป่วยแขนสั้น ชนิดกระดุมหรือเชือกผูก แบบผ่าหลัง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	400.00	\N	0	0.00	\N	\N	t	\N	t	4
991	P230-000991	วัสดุใช้ไป	เสื้อกั๊ก สะท้อนแสง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	300.00	\N	0	0.00	\N	\N	t	\N	t	11
992	P230-000992	วัสดุใช้ไป	บอร์ด สำหรับผังบุคลากร ขนาด 50 x 70 ซม.	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	อัน	550.00	\N	0	0.00	\N	\N	t	\N	t	11
993	P230-000993	วัสดุใช้ไป	ป้ายชื่อ สำหรับหน่วยงาน	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ชิ้น	4000.00	\N	0	0.00	\N	\N	t	\N	t	1
994	P230-000994	วัสดุใช้ไป	ยกเลิก ถังขยะ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1000.00	\N	0	0.00	\N	\N	f	\N	t	1
995	P230-000995	วัสดุใช้ไป	ถังผ้า สำหรับผู้ป่วยห้องพิเศษ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1000.00	\N	0	0.00	\N	\N	t	\N	t	11
996	P230-000996	วัสดุใช้ไป	ถังผ้า สำหรับผู้ป่วยสามัญ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1500.00	\N	0	0.00	\N	\N	t	\N	t	11
997	P230-000997	วัสดุใช้ไป	โมเดลอาหาร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	7500.00	\N	0	0.00	\N	\N	t	\N	t	4
998	P230-000998	วัสดุใช้ไป	กล่องพลาสติก ทรงสี่เหลี่ยม แบบพร้อมหูหิ้วและฝาปิดระบบล๊อค	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	220.00	\N	0	0.00	\N	\N	t	\N	t	1
999	P230-000999	วัสดุใช้ไป	หมอน สำหรับรองให้นมบุตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	500.00	\N	0	0.00	\N	\N	t	\N	t	4
1000	P230-001000	วัสดุใช้ไป	กล่องพลาสติก ทรงสี่เหลี่ยม แบบมีฝาปิด ขนาด 100 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	500.00	\N	0	0.00	\N	\N	t	\N	t	4
1001	P230-001001	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก ถังขยะพลาสติก ขนาดไม่น้อยกว่า 60 ลิตร แบบเท้าเหยียบ ขนาด 60 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถัง	1500.00	\N	0	0.00	\N	\N	t	\N	t	1
1002	P230-001002	วัสดุใช้ไป	กล่องรองเท้า แบบฝาหน้า	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่อง	150.00	\N	0	0.00	\N	\N	t	\N	t	11
1003	P230-001003	วัสดุใช้ไป	กระจกเงา ขนาด 55 x 90 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	บาน	2090.00	\N	0	0.00	\N	\N	t	\N	t	11
1004	P230-001004	วัสดุใช้ไป	ตะกร้า แบบทรงเหลี่ยม ขนาด 37.5 x 26.5 x 14.2 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	159.00	\N	0	0.00	\N	\N	t	\N	t	1
1005	P230-001005	วัสดุใช้ไป	รองเท้า แบบ Slippers ขนาด Free size	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	259.00	\N	0	0.00	\N	\N	t	\N	t	11
1006	P230-001006	วัสดุใช้ไป	ผ้าขนหนู ขนาด 24 x 48 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	โหล	1200.00	\N	0	0.00	\N	\N	t	\N	t	1
1007	P230-001007	วัสดุใช้ไป	มู่ลี่ ชนิดไวนิล ขนาด 120 x 160 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	750.00	\N	0	0.00	\N	\N	t	\N	t	11
1008	P230-001008	วัสดุใช้ไป	เก้าอี้ ชนิดพลาสติก เกรด A สำหรับผู้ป่วย	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	500.00	\N	0	0.00	\N	\N	t	\N	t	4
1009	P230-001009	วัสดุใช้ไป	นาฬิกา แบบแขวนผนัง	วัสดุสำนักงาน	วัสดุสำนักงาน	เรือน	400.00	\N	0	0.00	\N	\N	t	\N	t	1
1010	P230-001010	วัสดุใช้ไป	ยกเลิก เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	290.00	\N	0	0.00	\N	\N	f	\N	t	4
1011	P230-001011	วัสดุใช้ไป	ตู้อเนกประสงค์ ชนิดพลาสติก แบบ 7 ชั้น ขนาด A4	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1000.00	\N	0	0.00	\N	\N	t	\N	t	1
1012	P230-001012	วัสดุใช้ไป	เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	350.00	\N	0	0.00	\N	\N	t	\N	t	4
1013	P230-001013	วัสดุใช้ไป	ยกเลิก เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	290.00	\N	0	0.00	\N	\N	f	\N	t	1
1014	P230-001014	วัสดุใช้ไป	ป้ายอะคริลิค ขนาด 12 x 25 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	170.00	\N	0	0.00	\N	\N	t	\N	t	11
1015	P230-001015	วัสดุใช้ไป	ป้ายอะคริลิค ขนาด 10 x 15 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	150.00	\N	0	0.00	\N	\N	t	\N	t	11
1016	P230-001016	วัสดุใช้ไป	ป้ายอะคริลิค ขนาด 20 x 50 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	300.00	\N	0	0.00	\N	\N	t	\N	t	4
1017	P230-001017	วัสดุใช้ไป	ป้ายอะคริลิค ขนาด 15 x 15 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ชิ้น	170.00	\N	0	0.00	\N	\N	t	\N	t	1
1018	P230-001018	วัสดุใช้ไป	ชั้นอเนกประสงค์ ชนิดพลาสติก	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	300.00	\N	0	0.00	\N	\N	t	\N	t	1
1019	P230-001019	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก สำหรับเก็บเครื่องมือ ขนาด 12 นิ้ว สีใส	วัสดุสำนักงาน	วัสดุสำนักงาน	ใบ	300.00	\N	0	0.00	\N	\N	t	\N	t	4
1020	P230-001020	วัสดุใช้ไป	ชาร์ททะเบียนผู้ป่วย แบบอลูมีเนียม	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	600.00	\N	0	0.00	\N	\N	t	\N	t	4
1021	P230-001021	วัสดุใช้ไป	กรวยจราจร ชนิดพับเก็บได้ พลาสติก ขนาด 42 ซม.	วัสดุอื่นๆ	วัสดุอื่นๆ	กรวย	350.00	\N	0	0.00	\N	\N	t	\N	t	11
1022	P230-001022	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่าง แบบกากบาท ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	520.00	\N	0	0.00	\N	\N	t	\N	t	11
1136	P230-001136	วัสดุใช้ไป	เบรคเกอร์ ขนาด 60A	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	650.00	\N	0	0.00	\N	\N	t	\N	t	11
1023	P230-001023	วัสดุใช้ไป	ตะแกรงน้ำทิ้ง แบบสแตนเลส ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	12.00	\N	0	0.00	\N	\N	t	\N	t	1
1024	P230-001024	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับซิงค์ แบบใบพาย ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	550.00	\N	0	0.00	\N	\N	t	\N	t	11
1026	P230-001026	วัสดุใช้ไป	สกรูปลายสว่าน ขนาด 8 x 2	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	25.00	\N	0	0.00	\N	\N	t	\N	t	4
1027	P230-001027	วัสดุใช้ไป	สกรูปลายสว่าน ขนาด 3/4	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	20.00	\N	0	0.00	\N	\N	t	\N	t	4
1028	P230-001028	วัสดุใช้ไป	ตระแกรง ชนิดพลาสติก แบบก้างปลารังผึ้ง ขนาดกลาง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	t	\N	t	4
1030	P230-001030	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 10 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	75.00	\N	0	0.00	\N	\N	t	\N	t	4
1031	P230-001031	วัสดุใช้ไป	สีน้ำมัน สีทองคำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	385.00	\N	0	0.00	\N	\N	t	\N	t	1
1032	P230-001032	วัสดุใช้ไป	กาว ชนิด epoxy	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	132.00	\N	0	0.00	\N	\N	t	\N	t	1
1033	P230-001033	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับซิงค์ แบบต่อล่าง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	605.00	\N	0	0.00	\N	\N	t	\N	t	11
1034	P230-001034	วัสดุใช้ไป	ยกเลิก ไมค์โครโฟน แบบไร้สาย	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ชุด	2900.00	\N	0	0.00	\N	\N	f	\N	t	4
1035	P230-001035	วัสดุใช้ไป	แบตเตอรี่ ขนาด 4V 5AH DEL	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ลูก	219.00	\N	0	0.00	\N	\N	t	\N	t	11
1036	P230-001036	วัสดุใช้ไป	ป้ายชื่อ แบบสามเหลี่ยม ขนาด 4x12 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	95.00	\N	0	0.00	\N	\N	t	\N	t	4
1037	P230-001037	วัสดุใช้ไป	ก้างปลา	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	t	\N	t	4
1038	P230-001038	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	1485.00	\N	0	0.00	\N	\N	t	\N	t	4
1039	P230-001039	วัสดุใช้ไป	เกลียวเร่ง ขนาด 3 หุน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	60.00	\N	0	0.00	\N	\N	t	\N	t	4
1040	P230-001040	วัสดุใช้ไป	หน้ากากปลั๊กไฟ แบบกันน้ำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	56.00	\N	0	0.00	\N	\N	t	\N	t	1
1041	P230-001041	วัสดุใช้ไป	ถังปูน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ใบ	50.00	\N	0	0.00	\N	\N	t	\N	t	1
1042	P230-001042	วัสดุใช้ไป	เทปพิมพ์	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	600.00	\N	0	0.00	\N	\N	t	\N	t	1
1043	P230-001043	วัสดุใช้ไป	กระดาษถ่ายเอกสาร ขนาด A3	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	265.00	\N	0	0.00	\N	\N	t	\N	t	11
1044	P230-001044	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีขาวด้าน	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	125.00	\N	0	0.00	\N	\N	t	\N	t	11
1045	P230-001045	วัสดุใช้ไป	แผ่นรองตัด ขนาด 30*45 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	240.00	\N	0	0.00	\N	\N	t	\N	t	11
1046	P230-001046	วัสดุใช้ไป	ถังน้ำดื่ม ชนิดพลาสติก ขนาด 20 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	100.00	\N	0	0.00	\N	\N	t	\N	t	1
1047	P230-001047	วัสดุใช้ไป	กิ๊บ ชนิดทองเหลือง สำหรับสายสลิง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	7.00	\N	0	0.00	\N	\N	t	\N	t	11
1048	P230-001048	วัสดุใช้ไป	กาว ชนิดซิลิโคน สำหรับยาแนว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	50.00	\N	0	0.00	\N	\N	t	\N	t	1
1049	P230-001049	วัสดุใช้ไป	ถุงมือ ชนิดถัก แบบเคลือบไนไตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	11
1050	P230-001050	วัสดุใช้ไป	น้ำยา สำหรับประสานคอนกรีต	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	219.00	\N	0	0.00	\N	\N	t	\N	t	11
1051	P230-001051	วัสดุใช้ไป	น้ำยา สำหรับขจัดท่อตัน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	230.00	\N	0	0.00	\N	\N	t	\N	t	1
1137	P230-001137	วัสดุใช้ไป	หน้ากากปลั๊กไฟ แบบ 4 ช่อง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	30.00	\N	0	0.00	\N	\N	t	\N	t	11
1052	P230-001052	วัสดุใช้ไป	เกล็ดโซดาไฟ สำหรับขจัดท่อตัน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	69.00	\N	0	0.00	\N	\N	t	\N	t	4
1053	P230-001053	วัสดุใช้ไป	สเปร์ย ชนิดโฟม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	359.00	\N	0	0.00	\N	\N	t	\N	t	11
1054	P230-001054	วัสดุใช้ไป	สามทาง ชนิด PVC แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	20.00	\N	0	0.00	\N	\N	t	\N	t	11
1055	P230-001055	วัสดุใช้ไป	น๊อต แบบเกลียว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	30.00	\N	0	0.00	\N	\N	t	\N	t	11
1056	P230-001056	วัสดุใช้ไป	ลวด	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิโลกรัม	70.00	\N	0	0.00	\N	\N	t	\N	t	11
1057	P230-001057	วัสดุใช้ไป	น๊อต ขนาด 2 หุน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิโลกรัม	100.00	\N	0	0.00	\N	\N	t	\N	t	1
1058	P230-001058	วัสดุใช้ไป	ท่อน้ำ ชนิดเหล็ก แบบตรง ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	1285.00	\N	0	0.00	\N	\N	t	\N	t	4
1059	P230-001059	วัสดุใช้ไป	นิปเปิ้ล ชนิดเหล็ก ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	110.00	\N	0	0.00	\N	\N	t	\N	t	1
1060	P230-001060	วัสดุใช้ไป	ข้องอ ชนิดเหล็ก แบบ 90 องศา ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	160.00	\N	0	0.00	\N	\N	t	\N	t	1
1061	P230-001061	วัสดุใช้ไป	สามทาง ชนิดเหล็ก แบบลด ขนาด 1*1/3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	220.00	\N	0	0.00	\N	\N	t	\N	t	11
1062	P230-001062	วัสดุใช้ไป	Ram BUS 2666 DDR4 ขนาด 8 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	790.00	\N	0	0.00	\N	\N	t	\N	t	4
1063	P230-001063	วัสดุใช้ไป	กุญแจ แบบบิด สำหรับบานเลื่อน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	570.00	\N	0	0.00	\N	\N	t	\N	t	1
1064	P230-001064	วัสดุใช้ไป	ปืนฉีด สำหรับปั้มลม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	320.00	\N	0	0.00	\N	\N	t	\N	t	4
1065	P230-001065	วัสดุใช้ไป	บันได ชนิดไม้ไผ่ แบบ 13 ขั้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	900.00	\N	0	0.00	\N	\N	t	\N	t	11
1067	P230-001067	วัสดุใช้ไป	ข้อต่อ ชนิดเหล็ก สำหรับต่อสายยาง ขนาด 1/2 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	ตัว	28.00	\N	0	0.00	\N	\N	t	\N	t	11
1068	P230-001068	วัสดุใช้ไป	สาย Printer แบบ USB ขนาดยาว 5 เมตร	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	159.00	\N	0	0.00	\N	\N	t	\N	t	11
1069	P230-001069	วัสดุใช้ไป	สาย Printer แบบ USB ขนาดยาว 10 เมตร	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	220.00	\N	0	0.00	\N	\N	t	\N	t	4
1070	P230-001070	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่างล้างหน้า แบบหางปลา ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	590.00	\N	0	0.00	\N	\N	t	\N	t	11
1071	P230-001071	วัสดุใช้ไป	แม่สี เบอร์ 9RC	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	260.00	\N	0	0.00	\N	\N	t	\N	t	4
1073	P230-001073	วัสดุใช้ไป	ไมค์โครโฟน แบบมีสาย	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ตัว	790.00	\N	0	0.00	\N	\N	t	\N	t	11
1074	P230-001074	วัสดุใช้ไป	ไมค์โครโฟน ชนิดคู่ แบบไร้สาย	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ชุด	890.00	\N	0	0.00	\N	\N	t	\N	t	1
1075	P230-001075	วัสดุใช้ไป	หลอดไฟ ชนิด LED แบบฟูลเซ็ท ขนาด 16 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	295.00	\N	0	0.00	\N	\N	t	\N	t	1
1076	P230-001076	วัสดุใช้ไป	สาย RCA2 ขนาด 1.8 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	65.00	\N	0	0.00	\N	\N	t	\N	t	1
1077	P230-001077	วัสดุใช้ไป	กระจกโค้ง สำหรับมุมอับสายตา ขนาด 80 ซม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	980.00	\N	0	0.00	\N	\N	t	\N	t	11
1078	P230-001078	วัสดุใช้ไป	แบตเตอรี่ สำหรับเครื่องเอกซเรย์เคลื่อนที่ ขนาด 12V 9Ah	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชิ้น	2400.00	\N	0	0.00	\N	\N	t	\N	t	4
1079	P230-001079	วัสดุใช้ไป	ชุดหูฝานั่งรองชักโครก ชนิดพลาสติก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	650.00	\N	0	0.00	\N	\N	t	\N	t	1
1080	P230-001080	วัสดุใช้ไป	สกรู ชนิดไดวอ ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่อง	95.00	\N	0	0.00	\N	\N	t	\N	t	11
1081	P230-001081	วัสดุใช้ไป	สกรู ชนิดหัวบล๊อค แบบปลายแหลม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	3.50	\N	0	0.00	\N	\N	t	\N	t	11
1082	P230-001082	วัสดุใช้ไป	กาว ชนิดยาง ขนาดใหญ่	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระปุก	144.00	\N	0	0.00	\N	\N	t	\N	t	1
1083	P230-001083	วัสดุใช้ไป	จอบ ชนิดเหล็ก แบบด้ามไม้	วัสดุการเกษตร	วัสดุการเกษตร	อัน	295.00	\N	0	0.00	\N	\N	t	\N	t	1
1084	P230-001084	วัสดุใช้ไป	เสียม ชนิดเหล็ก แบบด้ามไม้	วัสดุการเกษตร	วัสดุการเกษตร	อัน	315.00	\N	0	0.00	\N	\N	t	\N	t	1
1085	P230-001085	วัสดุใช้ไป	บันได ชนิดอลูมีเนียม แบบ 5 ขั้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	1090.00	\N	0	0.00	\N	\N	t	\N	t	4
1086	P230-001086	วัสดุใช้ไป	ป้าย ชนิดอลูมีเนียม ห้ามจอดรถ สีสท้อนแสง	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	แผ่น	535.00	\N	0	0.00	\N	\N	t	\N	t	11
1087	P230-001087	วัสดุใช้ไป	ป้าย ชนิดอลูมีเนียม ระวังสายไฟฟ้าแรงสูง สีสท้อนแสง	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	แผ่น	535.00	\N	0	0.00	\N	\N	t	\N	t	1
1088	P230-001088	วัสดุใช้ไป	ตาข่าย สำหรับกันสัตว์ปีนเสาไฟฟ้า ขนาด 45*65 ซม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	650.00	\N	0	0.00	\N	\N	t	\N	t	4
1089	P230-001089	วัสดุใช้ไป	กระดาษถ่ายเอกสาร ขนาด A5	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	65.00	\N	0	0.00	\N	\N	t	\N	t	11
1090	P230-001090	วัสดุใช้ไป	สายยาง ขนาด 5/8 นิ้ว ยาว 20 เมตร	วัสดุการเกษตร	วัสดุการเกษตร	เส้น	590.00	\N	0	0.00	\N	\N	t	\N	t	1
1091	P230-001091	วัสดุใช้ไป	ป้ายตราสัญลักษณ์ วปร. แบบพร้อมฐานตั้งโต๊ะ	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	650.00	\N	0	0.00	\N	\N	t	\N	t	1
1092	P230-001092	วัสดุใช้ไป	บันได ชนิดอลูมีเนียม แบบ 4 ขั้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	2190.00	\N	0	0.00	\N	\N	t	\N	t	1
1093	P230-001093	วัสดุใช้ไป	หมึก Printer Laser TN-2560	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1390.00	\N	0	0.00	\N	\N	t	\N	t	11
1094	P230-001094	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับตู้คูลเลอร์ ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	390.00	\N	0	0.00	\N	\N	t	\N	t	1
1122	P230-001122	วัสดุใช้ไป	หลอดไฟ ชนิด LED แบบโซล่าเซล ขนาดใหญ่ ขนาด 535 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	400.00	\N	0	0.00	\N	\N	t	\N	t	1
1095	P230-001095	วัสดุใช้ไป	กุญแจ แบบขอสับ สำหรับบานเลื่อน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	450.00	\N	0	0.00	\N	\N	t	\N	t	4
1096	P230-001096	วัสดุใช้ไป	คีม ชนิดปากงอ สำหรับหนีบแหวน ขนาด 6 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	215.00	\N	0	0.00	\N	\N	t	\N	t	4
1097	P230-001097	วัสดุใช้ไป	คีม สำหรับปลอกสายไฟ ขนาด 9 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	200.00	\N	0	0.00	\N	\N	t	\N	t	11
1098	P230-001098	วัสดุใช้ไป	สายดิน ขนาด 1*2.5 สีเขียว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	12.00	\N	0	0.00	\N	\N	t	\N	t	1
1100	P230-001100	วัสดุใช้ไป	แท่งกราวด์ สำหรับโหลดทองแดง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	65.00	\N	0	0.00	\N	\N	t	\N	t	4
1101	P230-001101	วัสดุใช้ไป	หางปลา สำหรับสายคอนโทรล	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	270.00	\N	0	0.00	\N	\N	t	\N	t	1
1102	P230-001102	วัสดุใช้ไป	ยางปั๊มท่อน้ำ ขนาดหน้าใหญ่	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	110.00	\N	0	0.00	\N	\N	t	\N	t	4
1103	P230-001103	วัสดุใช้ไป	ผ้าใบคลุมเต้นท์ แบบโค้ง ขนาด 4*8 เมตร	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	13375.00	\N	0	0.00	\N	\N	t	\N	t	11
1104	P230-001104	วัสดุใช้ไป	ขันน้ำ ชนิดพลาสติก แบบไม่มีด้าม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	25.00	\N	0	0.00	\N	\N	t	\N	t	11
1105	P230-001105	วัสดุใช้ไป	ท่อสูบน้ำ ชนิดผ้าใบ PVC ขนาด 2 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	เมตร	80.00	\N	0	0.00	\N	\N	t	\N	t	11
1107	P230-001107	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบ 4 ช่อง และฝาล๊อค ขนาด 37.5 x 25.6 x 10 ซม. สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	159.00	\N	0	0.00	\N	\N	t	\N	t	1
1108	P230-001108	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบ 6 ช่อง และฝาล๊อค ขนาด 55.5 x 25.6 x 10 ซม. สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	199.00	\N	0	0.00	\N	\N	t	\N	t	4
1109	P230-001109	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีฝาล๊อค ขนาด 70.5 ลิตร สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	309.00	\N	0	0.00	\N	\N	t	\N	t	4
1110	P230-001110	วัสดุใช้ไป	ท่อน้ำ ชนิดเหล็ก ขนาด 2.5 นิ้ว สีดำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อ	1050.00	\N	0	0.00	\N	\N	t	\N	t	4
1111	P230-001111	วัสดุใช้ไป	น๊อต แบบเกลียวปล่อย ขนาด 7*1.5	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N	t	1
1112	P230-001112	วัสดุใช้ไป	ตะแกรงน้ำทิ้ง แบบสแตนเลส ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	11.00	\N	0	0.00	\N	\N	t	\N	t	1
1113	P230-001113	วัสดุใช้ไป	ปูน สำหรับยาแนว สีขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	50.00	\N	0	0.00	\N	\N	t	\N	t	4
1118	P230-001118	วัสดุใช้ไป	ราวจับ ชนิดสแตนเลส สำหรับจับกันลื่น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	1159.00	\N	0	0.00	\N	\N	t	\N	t	1
1119	P230-001119	วัสดุใช้ไป	กล่องกระดาษชำระ ชนิดพลาสติก สำหรับห้องน้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	219.00	\N	0	0.00	\N	\N	t	\N	t	1
1120	P230-001120	วัสดุใช้ไป	หลอดไฟ ชนิด LED แบบไฟฉุกเฉินโซล่าเซล ขนาด 180 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	180.00	\N	0	0.00	\N	\N	t	\N	t	4
1121	P230-001121	วัสดุใช้ไป	ไฟฉุกเฉิน ชนิด LED ขนาด 2*6 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	1890.00	\N	0	0.00	\N	\N	t	\N	t	4
1123	P230-001123	วัสดุใช้ไป	ปลั๊กไฟพ่วง พร้อมล้อเก็บสายไฟ แบบ 4 ช่อง ขนาด 3600 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	2090.00	\N	0	0.00	\N	\N	t	\N	t	1
1124	P230-001124	วัสดุใช้ไป	สามทาง ชนิด PVC ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	70.00	\N	0	0.00	\N	\N	t	\N	t	11
1125	P230-001125	วัสดุใช้ไป	กระถาง พร้อมจานรอง สำหรับปลูกต้นไม้ ขนาด 9 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	ชุด	220.00	\N	0	0.00	\N	\N	t	\N	t	4
1126	P230-001126	วัสดุใช้ไป	รางสายไฟ แบบ TD205	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	85.00	\N	0	0.00	\N	\N	t	\N	t	4
1127	P230-001127	วัสดุใช้ไป	ก้านกดน้ำ แบบ BT007	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	149.00	\N	0	0.00	\N	\N	t	\N	t	4
1128	P230-001128	วัสดุใช้ไป	ก้านกดน้ำ แบบ BT008	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	109.00	\N	0	0.00	\N	\N	t	\N	t	1
1129	P230-001129	วัสดุใช้ไป	แผ่นเจียร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	25.00	\N	0	0.00	\N	\N	t	\N	t	11
1130	P230-001130	วัสดุใช้ไป	Memory card ชนิด Micro SD ขนาด 32 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	199.00	\N	0	0.00	\N	\N	t	\N	t	1
1131	P230-001131	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	6.00	\N	0	0.00	\N	\N	t	\N	t	4
1132	P230-001132	วัสดุใช้ไป	สายเทป แบบร่อง ยาว 2 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	50.00	\N	0	0.00	\N	\N	t	\N	t	1
1133	P230-001133	วัสดุใช้ไป	หลอดไฟ ชนิด LED แบบตาแมว ขนาด 5 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	120.00	\N	0	0.00	\N	\N	t	\N	t	1
1134	P230-001134	วัสดุใช้ไป	สวิทช์ไฟ แบบ 2 จังหวะ ขนาด 22 มิลลิเมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	65.00	\N	0	0.00	\N	\N	t	\N	t	11
1135	P230-001135	วัสดุใช้ไป	ฝาอุดปลั๊กไฟ ชนิดพลาสติก	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	10.00	\N	0	0.00	\N	\N	t	\N	t	1
1138	P230-001138	วัสดุใช้ไป	แบตเตอรี่ แบบกึ่งแห้ง สำหรับรถยนต์ ขนาด 12V 80Ah	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	3400.00	\N	0	0.00	\N	\N	t	\N	t	4
1139	P230-001139	วัสดุใช้ไป	ข้อต่อตรง ชนิดทองเหลือง แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	1
1140	P230-001140	วัสดุใช้ไป	ข้องอ ชนิดทองเหลือง แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	45.00	\N	0	0.00	\N	\N	t	\N	t	11
1141	P230-001141	วัสดุใช้ไป	เทป สำหรับกั้นเขต ขนาด 70 มม. ยาว 500 เมตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ม้วน	299.00	\N	0	0.00	\N	\N	t	\N	t	4
1142	P230-001142	วัสดุใช้ไป	กล่องเก็บของ ชนิดพลาสติก แบบ 18 ช่อง ขนาด 12 x 23.5 x 3 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	59.00	\N	0	0.00	\N	\N	t	\N	t	11
1143	P230-001143	วัสดุใช้ไป	พัดลมดูดอากาศ ขนาด 12 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	1390.00	\N	0	0.00	\N	\N	t	\N	t	1
1144	P230-001144	วัสดุใช้ไป	เชือก ชนิดไนล่อน	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	100.00	\N	0	0.00	\N	\N	t	\N	t	1
1145	P230-001145	วัสดุใช้ไป	พุก ชนิดตะกั่ว แบบพร้อมน๊อต	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	15.00	\N	0	0.00	\N	\N	t	\N	t	11
1146	P230-001146	วัสดุใช้ไป	กันชน สำหรับประตู	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	44.00	\N	0	0.00	\N	\N	t	\N	t	1
1147	P230-001147	วัสดุใช้ไป	ผ้าสำหรับทำความสะอาด ขนาด 30 x 40 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	195.00	\N	0	0.00	\N	\N	t	\N	t	1
1148	P230-001148	วัสดุใช้ไป	ไม้ดันฝุ่น แบบผ้าไมโครไฟเบอร์ ขนาดยาว 16 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	429.00	\N	0	0.00	\N	\N	t	\N	t	11
1149	P230-001149	วัสดุใช้ไป	ลูกปืนประตู สำหรับบานผลัก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	450.00	\N	0	0.00	\N	\N	t	\N	t	1
1150	P230-001150	วัสดุใช้ไป	เทปกาว ชนิดบิวทิว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	769.00	\N	0	0.00	\N	\N	t	\N	t	11
1151	P230-001151	วัสดุใช้ไป	ล้อรถเข็น แบบสกรูหมุน ขนาด 3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	190.00	\N	0	0.00	\N	\N	t	\N	t	1
1152	P230-001152	วัสดุใช้ไป	ล้อรถเข็น แบบสกรูหมุน มีเบรค ขนาด 3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	225.00	\N	0	0.00	\N	\N	t	\N	t	4
1153	P230-001153	วัสดุใช้ไป	ล้อรถเข็น แบบสกรูหมุน ขนาด 4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	209.00	\N	0	0.00	\N	\N	t	\N	t	11
1154	P230-001154	วัสดุใช้ไป	กระบอกเพชร สำหรับเจาะผนัง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	590.00	\N	0	0.00	\N	\N	t	\N	t	4
1155	P230-001155	วัสดุใช้ไป	มิเตอร์น้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	520.00	\N	0	0.00	\N	\N	t	\N	t	1
1156	P230-001156	วัสดุใช้ไป	กิ๊บ รัดสายไฟ เบอร์ 4	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แพค	10.00	\N	0	0.00	\N	\N	t	\N	t	11
1157	P230-001157	วัสดุใช้ไป	ตะปู ขนาด 3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แพค	10.00	\N	0	0.00	\N	\N	t	\N	t	1
1158	P230-001158	วัสดุใช้ไป	มิเตอร์ไฟฟ้า	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	550.00	\N	0	0.00	\N	\N	t	\N	t	11
1159	P230-001159	วัสดุใช้ไป	แค้ม แบบคู่	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	30.00	\N	0	0.00	\N	\N	t	\N	t	1
1160	P230-001160	วัสดุใช้ไป	แค้ม แบบเดี่ยว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	23.00	\N	0	0.00	\N	\N	t	\N	t	11
1161	P230-001161	วัสดุใช้ไป	กล่องอเนกประสงค์ สำหรับเก็บนมผง ขนาด 2300 มล.	วัสดุสำนักงาน	วัสดุสำนักงาน	ใบ	425.00	\N	0	0.00	\N	\N	t	\N	t	1
1162	P230-001162	วัสดุใช้ไป	ตู้อเนกประสงค์ ชนิดพลาสติก แบบมีลิ้นชักและล้อ ขนาด 42.10 x 35.80 x 105.50 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ตู้	899.00	\N	0	0.00	\N	\N	t	\N	t	1
1163	P230-001163	วัสดุใช้ไป	เก้าอี้กลม ชนิดพลาสติก	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	149.00	\N	0	0.00	\N	\N	t	\N	t	11
1240	P230-001240	วัสดุใช้ไป	กล่องเครื่องมือ 30ช่อง	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	750.00	\N	0	0.00	\N	\N	t	\N	t	1
1164	P230-001164	วัสดุใช้ไป	แผ่นสมาร์ทบอร์ด หนา 6 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	275.00	\N	0	0.00	\N	\N	t	\N	t	4
1165	P230-001165	วัสดุใช้ไป	ชุดทรานเฟอร์เบลล์ HP e77830 สำหรับเครื่องถ่ายเอกสาร	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	16000.00	\N	0	0.00	\N	\N	t	\N	t	1
1166	P230-001166	วัสดุใช้ไป	สักหลาดหมึก สำหรับเครื่องคิดเลข	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	180.00	\N	0	0.00	\N	\N	t	\N	t	11
1167	P230-001167	วัสดุใช้ไป	ถ่าน ชนิดอัลคาไลน์ แบบ CR2032 ขนาด 3V	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	32.00	\N	0	0.00	\N	\N	t	\N	t	11
1168	P230-001168	วัสดุใช้ไป	ฉากกั้นห้อง แบบทึบ ขนาด 240 x 250 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	6300.00	\N	0	0.00	\N	\N	t	\N	t	1
1169	P230-001169	วัสดุใช้ไป	ชุดผ้าปูที่นอน พร้อมผ้านวมและปลอกหมอน	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุด	965.00	\N	0	0.00	\N	\N	t	\N	t	11
1170	P230-001170	วัสดุใช้ไป	หมอนข้าง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ใบ	219.00	\N	0	0.00	\N	\N	t	\N	t	1
1172	P230-001172	วัสดุใช้ไป	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	เมตร	53.00	\N	0	0.00	\N	\N	t	\N	t	4
1173	P230-001173	วัสดุใช้ไป	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	เมตร	53.00	\N	0	0.00	\N	\N	t	\N	t	4
1174	P230-001174	วัสดุใช้ไป	พาน สำหรับจัดดอกไม้	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	420.00	\N	0	0.00	\N	\N	t	\N	t	11
1175	P230-001175	วัสดุใช้ไป	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีม่วงเข้ม	วัสดุสำนักงาน	วัสดุสำนักงาน	เมตร	53.00	\N	0	0.00	\N	\N	t	\N	t	4
1176	P230-001176	วัสดุใช้ไป	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีม่วงอ่อน	วัสดุสำนักงาน	วัสดุสำนักงาน	เมตร	53.00	\N	0	0.00	\N	\N	t	\N	t	4
1177	P230-001177	วัสดุใช้ไป	คาบูเรเตอร์ สำหรับเครื่องตัดตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	ชุด	1700.00	\N	0	0.00	\N	\N	t	\N	t	1
1178	P230-001178	วัสดุใช้ไป	พัดลมดูดอากาศ ขนาด 8 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	990.00	\N	0	0.00	\N	\N	t	\N	t	4
1179	P230-001179	วัสดุใช้ไป	ลูกลอย สำหรับเครื่องปั๊มน้ำไฟฟ้า	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	520.00	\N	0	0.00	\N	\N	t	\N	t	11
1180	P230-001180	วัสดุใช้ไป	โคมไฟ แบบปีกอลูมีเนียม ขนาด 1 x 40	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	500.00	\N	0	0.00	\N	\N	t	\N	t	11
1181	P230-001181	วัสดุใช้ไป	ลูกลอยไฟฟ้า แบบหัวนก	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	480.00	\N	0	0.00	\N	\N	t	\N	t	4
1182	P230-001182	วัสดุใช้ไป	สี สำหรับทาฝ้า สีขาว ขนาด 2.5 Gallon	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	1705.00	\N	0	0.00	\N	\N	t	\N	t	1
1183	P230-001183	วัสดุใช้ไป	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	20.00	\N	0	0.00	\N	\N	t	\N	t	4
1184	P230-001184	วัสดุใช้ไป	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	25.00	\N	0	0.00	\N	\N	t	\N	t	4
1185	P230-001185	วัสดุใช้ไป	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	30.00	\N	0	0.00	\N	\N	t	\N	t	1
1186	P230-001186	วัสดุใช้ไป	ท่อหด สำหรับหุ้มสายไฟ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	10.00	\N	0	0.00	\N	\N	t	\N	t	4
1187	P230-001187	วัสดุใช้ไป	Color box สำหรับ Printer M282nw no.206a สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ชุด	1250.00	\N	0	0.00	\N	\N	t	\N	t	1
1188	P230-001188	วัสดุใช้ไป	Color box สำหรับ Printer M282nw no.206a สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ชุด	1250.00	\N	0	0.00	\N	\N	t	\N	t	11
1189	P230-001189	วัสดุใช้ไป	Color box สำหรับ Printer M282nw no.206a สีแดง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ชุด	1250.00	\N	0	0.00	\N	\N	t	\N	t	1
1190	P230-001190	วัสดุใช้ไป	Color box สำหรับ Printer M282nw no.206a สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ชุด	1250.00	\N	0	0.00	\N	\N	t	\N	t	11
1191	P230-001191	วัสดุใช้ไป	ตะขอ แบบเกลียว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	2.50	\N	0	0.00	\N	\N	t	\N	t	4
1192	P230-001192	วัสดุใช้ไป	เกลียวเร่ง ชนิดเหล็ก ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	0.50	\N	0	0.00	\N	\N	t	\N	t	1
1193	P230-001193	วัสดุใช้ไป	กระเบื้อง ชนิดแผ่นเรียบ หนา 6 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	275.00	\N	0	0.00	\N	\N	t	\N	t	11
1194	P230-001194	วัสดุใช้ไป	น้ำยา สำหรับขจัดคราบ (Cement residual parts)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขวด	980.00	\N	0	0.00	\N	\N	t	\N	t	4
1195	P230-001195	วัสดุใช้ไป	ยางชะลอความเร็วรถ ขนาด 100 x 10 x 2 ซม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	379.00	\N	0	0.00	\N	\N	t	\N	t	4
1196	P230-001196	วัสดุใช้ไป	หลอดไฟ ชนิดนีออน แบบวงกลม สำหรับโคมไฟซาลาเปา ขนาด 48 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ดวง	180.00	\N	0	0.00	\N	\N	t	\N	t	4
1197	P230-001197	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 13 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ดวง	110.00	\N	0	0.00	\N	\N	t	\N	t	4
1198	P230-001198	วัสดุใช้ไป	ชุดปะเอนกประสงค์ สำหรับซ่อมโซฟา	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	80.00	\N	0	0.00	\N	\N	t	\N	t	11
1199	P230-001199	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 45 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	859.00	\N	0	0.00	\N	\N	t	\N	t	4
1200	P230-001200	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบลิ้นชัก 3 ชั้น ขนาด 30*36*50 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	499.00	\N	0	0.00	\N	\N	t	\N	t	1
1201	P230-001201	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบลิ้นชัก 3 ชั้น ขนาด 30*36*35 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	425.00	\N	0	0.00	\N	\N	t	\N	t	4
1202	P230-001202	วัสดุใช้ไป	Ram BUS 2666 DDR4 ขนาด 4 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	850.00	\N	0	0.00	\N	\N	t	\N	t	1
1203	P230-001203	วัสดุใช้ไป	โคมไฟ แบบดาวไลท์ หลอด LED ขนาด 5 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	130.00	\N	0	0.00	\N	\N	t	\N	t	1
1204	P230-001204	วัสดุใช้ไป	ขาหนีบกระจก ชนิดสแตนเลส	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	135.00	\N	0	0.00	\N	\N	t	\N	t	1
1205	P230-001205	วัสดุใช้ไป	กระจกใส หนา 3 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	480.00	\N	0	0.00	\N	\N	t	\N	t	4
1207	P230-001207	วัสดุใช้ไป	สายยาง สำหรับที่นอนลม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	85.00	\N	0	0.00	\N	\N	t	\N	t	4
1208	P230-001208	วัสดุใช้ไป	กระดาษโฟโต้ A4 180 แกรม	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	120.00	\N	0	0.00	\N	\N	t	\N	t	1
1209	P230-001209	วัสดุใช้ไป	กระดาษการ์ดหอม สีขาว A4 180 แกรม	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	120.00	\N	0	0.00	\N	\N	t	\N	t	1
1210	P230-001210	วัสดุใช้ไป	กระดาษการ์ดขาว A4 150 แกรม	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	120.00	\N	0	0.00	\N	\N	t	\N	t	11
1211	P230-001211	วัสดุใช้ไป	กระดาษสติ๊กเกอร์ ขาวมัน A4 90 แกรม	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	120.00	\N	0	0.00	\N	\N	t	\N	t	1
1212	P230-001212	วัสดุใช้ไป	ถาดอาหารสแตนเลส พร้อมฝาปิด 5 ช่อง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	500.00	\N	0	0.00	\N	\N	t	\N	t	1
1213	P230-001213	วัสดุใช้ไป	ถาดเสริฟเหลี่ยม 10 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	250.00	\N	0	0.00	\N	\N	t	\N	t	4
1214	P230-001214	วัสดุใช้ไป	ถ้วยสแตนเลสพร้อมฝาปิด ขนาด 16 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถ้วย	300.00	\N	0	0.00	\N	\N	t	\N	t	1
1215	P230-001215	วัสดุใช้ไป	กล่องพลาสติกฝาล็อค 60 ลิตร	วัสดุสำนักงาน	วัสดุสำนักงาน	ใบ	500.00	\N	0	0.00	\N	\N	t	\N	t	4
1216	P230-001216	วัสดุใช้ไป	ถุงมือยางยาว แบบรัดข้อ เบอร์ S	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	120.00	\N	0	0.00	\N	\N	t	\N	t	1
1217	P230-001217	วัสดุใช้ไป	ผ้าขวางเตียง ผ้าฟอกขาว 42"x72" ( Wช/Wญ/LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	290.00	\N	0	0.00	\N	\N	t	\N	t	1
1218	P230-001218	วัสดุใช้ไป	ผ้าถุง ผ้าคอมทวิว สีแดงเลือดนก สรว 88"x40" (LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	350.00	\N	0	0.00	\N	\N	t	\N	t	11
1219	P230-001219	วัสดุใช้ไป	ผ้าปูเตียง ปล่อยชาย ผ้าโทเรหนา สีเขียวโศก (แผนไทย) 100"x108'' (แผนไทย)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	650.00	\N	0	0.00	\N	\N	t	\N	t	4
1220	P230-001220	วัสดุใช้ไป	ผ้าปูเตียง ปล่อยชาย ผ้าฟอกขาว 58"x108" ( Wช/Wญ/LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	400.00	\N	0	0.00	\N	\N	t	\N	t	4
1221	P230-001221	วัสดุใช้ไป	ผ้าปูรถนอน ปล่อยชาย ผ้าย้อมสีเขียวโศก 42"x108"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	400.00	\N	0	0.00	\N	\N	t	\N	t	11
1222	P230-001222	วัสดุใช้ไป	ผ้าปูรถนอน ปล่อยชาย ผ้าย้อมสีเขียวแก่ 42"x108" (ER)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	400.00	\N	0	0.00	\N	\N	t	\N	t	4
1223	P230-001223	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น เจาะรูกลาง (4"x6") ผ้าย้อมสีเขียวแก่ 58"x100 " (OR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	1200.00	\N	0	0.00	\N	\N	t	\N	t	11
1224	P230-001224	วัสดุใช้ไป	เสื้อผู้ใหญ่ ป้ายข้าง ผ้าคอมทวิว สีแดงเลือดนก XXL (LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	350.00	\N	0	0.00	\N	\N	t	\N	t	4
1225	P230-001225	วัสดุใช้ไป	เสื้อผู้ใหญ่ ป้ายข้าง ผ้าคอมทวิว สีม่วง XL (แผนไทย)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	280.00	\N	0	0.00	\N	\N	t	\N	t	1
1226	P230-001226	วัสดุใช้ไป	เสื้อผู้ใหญ่ ป้ายข้าง ผ้าคอมทวิว สีเขียว XL ( Wช/Wญ/LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	300.00	\N	0	0.00	\N	\N	t	\N	t	11
1227	P230-001227	วัสดุใช้ไป	เสื้อผู้ใหญ่ ป้ายข้าง ผ้าคอมทวิว สีเขียว XXL ( Wช/Wญ/LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	300.00	\N	0	0.00	\N	\N	t	\N	t	1
1228	P230-001228	วัสดุใช้ไป	กางเกงผู้ใหญ่ มีเชือกผูก ผ้าคอมทวิว สีเขียว XL ( Wช/Wญ/LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	300.00	\N	0	0.00	\N	\N	t	\N	t	4
1256	P230-001256	วัสดุใช้ไป	ไฟสนาม แบบสปอตไลท์ ขนาด 70W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	1290.00	\N	0	0.00	\N	\N	t	\N	t	1
1229	P230-001229	วัสดุใช้ไป	กางเกงผู้ใหญ่ มีเชือกผูก ผ้าคอมทวิว สีเขียว XXL ( Wช/Wญ/LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	300.00	\N	0	0.00	\N	\N	t	\N	t	11
1230	P230-001230	วัสดุใช้ไป	ผ้าถุง ผ้าคอมทวิว สีแดงเลือดนก สรว 88"x40" (LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	300.00	\N	0	0.00	\N	\N	t	\N	t	11
1231	P230-001231	วัสดุใช้ไป	นาฬิกาจับเวลา	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	900.00	\N	0	0.00	\N	\N	t	\N	t	1
1232	P230-001232	วัสดุใช้ไป	เสื้อกาวน์ยาว	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	ตัว	550.00	\N	0	0.00	\N	\N	t	\N	t	11
1233	P230-001233	วัสดุใช้ไป	ตะกร้า	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	อัน	30.00	\N	0	0.00	\N	\N	t	\N	t	1
1234	P230-001234	วัสดุใช้ไป	กระติ๊กน้ำแข็ง 5 ลิตร ใส่วัคซีนและยาเย็น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	อัน	175.00	\N	0	0.00	\N	\N	t	\N	t	4
1235	P230-001235	วัสดุใช้ไป	ชุดถ้วยกาแฟ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ชุด	139.00	\N	0	0.00	\N	\N	t	\N	t	1
1236	P230-001236	วัสดุใช้ไป	กล่องเก็บของ	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	419.00	\N	0	0.00	\N	\N	t	\N	t	11
1237	P230-001237	วัสดุใช้ไป	ตระกร้าผ้าเหลี่ยมมีฝาหูหิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	329.00	\N	0	0.00	\N	\N	t	\N	t	1
1238	P230-001238	วัสดุใช้ไป	USB MP3 รวมเพลงฮิต	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่-งบหน่วยงาน	อัน	299.00	\N	0	0.00	\N	\N	t	\N	t	4
1239	P230-001239	วัสดุใช้ไป	กระดิ่งไร้สายแบบเสียบปลั๊ก	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	890.00	\N	0	0.00	\N	\N	t	\N	t	4
1241	P230-001241	วัสดุใช้ไป	ฟิล์มสูญกาศพิมพ์ลาย	วัสดุอื่นๆ	วัสดุอื่นๆ-งบหน่วยงาน	ชุด	500.00	\N	0	0.00	\N	\N	t	\N	t	1
1242	P230-001242	วัสดุใช้ไป	หมอนหนุนศรีษะสำหรับผู้ป่วย	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	อัน	400.00	\N	0	0.00	\N	\N	t	\N	t	4
1243	P230-001243	วัสดุใช้ไป	สายรัด NST	วัสดุอื่นๆ	วัสดุอื่นๆ-งบหน่วยงาน	อัน	1380.00	\N	0	0.00	\N	\N	t	\N	t	4
1244	P230-001244	วัสดุใช้ไป	หมอนให้นมบุตร	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	อัน	300.00	\N	0	0.00	\N	\N	t	\N	t	11
1245	P230-001245	วัสดุใช้ไป	ป้ายชื่อ สำหรับพวงกุญแจ	วัสดุสำนักงาน	วัสดุสำนักงาน	pack	95.00	\N	0	0.00	\N	\N	t	\N	t	11
1246	P230-001246	วัสดุใช้ไป	หลอดไฟ ชนิดนีออน ขนาด 8 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	100.00	\N	0	0.00	\N	\N	t	\N	t	11
1247	P230-001247	วัสดุใช้ไป	หลอดไฟ ชนิดนีออน ขนาด 22 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	120.00	\N	0	0.00	\N	\N	t	\N	t	4
1248	P230-001248	วัสดุใช้ไป	อะไหล่เครื่องฉีดน้ำไฟฟ้า	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	100.00	\N	0	0.00	\N	\N	t	\N	t	1
1249	P230-001249	วัสดุใช้ไป	ตัวล๊อคบานเลื่อนกระจก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	160.00	\N	0	0.00	\N	\N	t	\N	t	4
1250	P230-001250	วัสดุใช้ไป	กระจกบานเกล็ด ขนาด 4*36 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	65.00	\N	0	0.00	\N	\N	t	\N	t	11
1251	P230-001251	วัสดุใช้ไป	รีเวท ขนาด 1/8*5/16	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	pack	25.00	\N	0	0.00	\N	\N	t	\N	t	4
1252	P230-001252	วัสดุใช้ไป	รีเวท ขนาด 1/8*3/8	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	pack	25.00	\N	0	0.00	\N	\N	t	\N	t	1
1253	P230-001253	วัสดุใช้ไป	กุญแจประตูบานเลื่อนสวิง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	650.00	\N	0	0.00	\N	\N	t	\N	t	11
1254	P230-001254	วัสดุใช้ไป	ชุดฝักบัว แบบ Rain shower	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	3590.00	\N	0	0.00	\N	\N	t	\N	t	11
1255	P230-001255	วัสดุใช้ไป	กะละมังซักผ้า ชนิดพลาสติก ขนาด 40 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	80.00	\N	0	0.00	\N	\N	t	\N	t	1
1258	P230-001258	วัสดุใช้ไป	ผงยิบซัม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิโลกรัม	33.00	\N	0	0.00	\N	\N	t	\N	t	11
1259	P230-001259	วัสดุใช้ไป	ตะปูคอนกรีต	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่อง	18.00	\N	0	0.00	\N	\N	t	\N	t	1
1260	P230-001260	วัสดุใช้ไป	ใบตัด ชนิดไฟเบอร์ ขนาด 14 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	110.00	\N	0	0.00	\N	\N	t	\N	t	4
1261	P230-001261	วัสดุใช้ไป	กาวตะปู	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	หลอด	132.00	\N	0	0.00	\N	\N	t	\N	t	1
1262	P230-001262	วัสดุใช้ไป	ลูกบล๊อค เบอร์ 8	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	55.00	\N	0	0.00	\N	\N	t	\N	t	11
1263	P230-001263	วัสดุใช้ไป	เหล็กเส้น ขนาด 6 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	132.00	\N	0	0.00	\N	\N	t	\N	t	11
1264	P230-001264	วัสดุใช้ไป	ราวแขวน ขนาด 75 ซม. (งบหน่วยงาน ward หญิง)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	560.50	\N	0	0.00	\N	\N	t	\N	t	4
1265	P230-001265	วัสดุใช้ไป	ถังขยะพลาสติก แบบฝาเหยียบ ขนาด 50 ลิตร (งบหน่วยงาน ward หญิง)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	499.00	\N	0	0.00	\N	\N	t	\N	t	11
1266	P230-001266	วัสดุใช้ไป	ถังขยะพลาสติก แบบฝาเหยียบ ขนาด 80 ลิตร (งบหน่วยงาน ward หญิง)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	699.00	\N	0	0.00	\N	\N	t	\N	t	11
1267	P230-001267	วัสดุใช้ไป	ถังขยะสแตนเลส แบบฝาเหยียบ ขนาด 30 ลิตร (งบหน่วยงาน ward หญิง)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1590.00	\N	0	0.00	\N	\N	t	\N	t	1
1268	P230-001268	วัสดุใช้ไป	ถังขยะสแตนเลส แบบฝาเหยียบ ขนาด 30 ลิตร (งบหน่วยงานห้องคลอด)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	2590.00	\N	0	0.00	\N	\N	t	\N	t	4
1270	P230-001270	วัสดุใช้ไป	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 4 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	30.00	\N	0	0.00	\N	\N	t	\N	t	4
1271	P230-001271	วัสดุใช้ไป	สาย THW ขนาด 1*2.5	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	1090.00	\N	0	0.00	\N	\N	t	\N	t	11
1272	P230-001272	วัสดุใช้ไป	ประตูน้ำ ขนาด 3 x 5.5 นิ้ว สำหรับบ่อสูบตะกอน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	8900.00	\N	0	0.00	\N	\N	t	\N	t	4
1273	P230-001273	วัสดุใช้ไป	ชั้นวางของเอนกประสงค์ 3 ชั้น แบบมีล้อ (งานทันตกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	1290.00	\N	0	0.00	\N	\N	t	\N	t	11
1274	P230-001274	วัสดุใช้ไป	แผงกั้นจราจร ขนาด 1.5 เมตร แบบไม่มีล้อ	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	1550.00	\N	0	0.00	\N	\N	t	\N	t	4
1275	P230-001275	วัสดุใช้ไป	กรวยจราจร  ชนิดพลาสติก ขนาด 70 ซม.	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	299.00	\N	0	0.00	\N	\N	t	\N	t	1
1276	P230-001276	วัสดุใช้ไป	ตะแกรงใสของอเนกประสงค์ ขนาด 21.3*29.3*9 ซม. (งานเภสัชกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	39.00	\N	0	0.00	\N	\N	t	\N	t	1
1277	P230-001277	วัสดุใช้ไป	ตะแกรงใสของอเนกประสงค์ ขนาด 24*33.5*9 ซม. (งานเภสัชกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	49.00	\N	0	0.00	\N	\N	t	\N	t	1
1278	P230-001278	วัสดุใช้ไป	ตะแกรงใสของอเนกประสงค์ ขนาด 25.5*37.5*14.5 ซม. (งานเภสัชกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	59.00	\N	0	0.00	\N	\N	t	\N	t	1
1279	P230-001279	วัสดุใช้ไป	ตู้ลิ้นชักพลาสติก แบบ 4 ชั้น ขนาด 40*50*104 ซม. (งานเภสัชกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	170.00	\N	0	0.00	\N	\N	t	\N	t	11
1280	P230-001280	วัสดุใช้ไป	ตู้ลิ้นชักพลาสติก แบบ 3 ชั้น ขนาด 15.5*20*23 ซม. (งานเภสัชกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	990.00	\N	0	0.00	\N	\N	t	\N	t	1
1281	P230-001281	วัสดุใช้ไป	ตู้ลิ้นชักพลาสติก แบบ 4 ชั้น ขนาด 18*27*27 ซม. (งานเภสัชกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	97.00	\N	0	0.00	\N	\N	t	\N	t	1
1282	P230-001282	วัสดุใช้ไป	ปลั๊กไฟพ่วง แบบ 4 ช่อง 4 สวิตซ์ ยาว 5 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	365.00	\N	0	0.00	\N	\N	t	\N	t	4
1283	P230-001283	วัสดุใช้ไป	สามทาง ชนิดทองเหลือง แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	58.00	\N	0	0.00	\N	\N	t	\N	t	1
1284	P230-001284	วัสดุใช้ไป	กระจกส่องตัว (งานเทคนิคการแพทย์)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1735.00	\N	0	0.00	\N	\N	t	\N	t	11
1285	P230-001285	วัสดุใช้ไป	กล่องบรรจุตัวอย่าง (งานเทคนิคการแพทย์)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	253.00	\N	0	0.00	\N	\N	t	\N	t	4
1286	P230-001286	วัสดุใช้ไป	ชั้นวางรองเท้า (งานเทคนิคการแพทย์)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	599.00	\N	0	0.00	\N	\N	t	\N	t	4
1287	P230-001287	วัสดุใช้ไป	ชั้นวางของแบบมีล้อเลื่อน (งานเทคนิคการแพทย์)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	695.00	\N	0	0.00	\N	\N	t	\N	t	4
1288	P230-001288	วัสดุใช้ไป	ขาวางลำโพง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	420.00	\N	0	0.00	\N	\N	t	\N	t	11
1289	P230-001289	วัสดุใช้ไป	ฟิล์มยืด (งานแพทย์แผนไทย)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	25.00	\N	0	0.00	\N	\N	t	\N	t	4
1290	P230-001290	วัสดุใช้ไป	ชุดกรวยอิมฮอฟฟ์/กรวยตกตะกอน (Imhoff cone) ขนาด 1000 ml พร้อมขาตั้ง (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	วัสดุอื่นๆ	วัสดุอื่นๆ	ชุุด	8185.50	\N	0	0.00	\N	\N	t	\N	t	4
1291	P230-001291	วัสดุใช้ไป	ชุดทดสอบโคลิฟอร์มแบคทีเรีย (SI-2) (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	วัสดุอื่นๆ	วัสดุอื่นๆ	กล่อง	1000.00	\N	0	0.00	\N	\N	t	\N	t	1
1292	P230-001292	วัสดุใช้ไป	น้ำยาตรวจเชื้อโคลิฟอร์มแบคทีเรียขั้นต้นในน้ำและน้ำแข็ง (อ11) (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	วัสดุอื่นๆ	วัสดุอื่นๆ	กล่อง	1000.00	\N	0	0.00	\N	\N	t	\N	t	4
1293	P230-001293	วัสดุใช้ไป	คลอรีนน้ำ ขนาด 20 กิโลกรัม (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	วัสดุอื่นๆ	วัสดุอื่นๆ	ถัง	760.00	\N	0	0.00	\N	\N	t	\N	t	11
1294	P230-001294	วัสดุใช้ไป	คลอรีนผง 65% ขนาด 50 กิโลกรัม (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	วัสดุอื่นๆ	วัสดุอื่นๆ	ถัง	4200.00	\N	0	0.00	\N	\N	t	\N	t	4
1295	P230-001295	วัสดุใช้ไป	USB RJ45 extension	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ชุด	290.00	\N	0	0.00	\N	\N	t	\N	t	4
1296	P230-001296	วัสดุใช้ไป	ผ้าใบ สำหรับคลุมเต้นท์จั่ว ขนาด 5x12 เมตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	21892.20	\N	0	0.00	\N	\N	t	\N	t	1
1297	P230-001297	วัสดุใช้ไป	ท่อเป่าปอดแกนกระดาษสำหรับเครื่องเป่าปอด	วัสดุอื่นๆ	วัสดุอื่นๆ	ชิ้น	6.50	\N	0	0.00	\N	\N	t	\N	t	11
1298	P230-001298	วัสดุใช้ไป	ป้ายบอกตำแหน่งถังดับเพลิง ขนาด 15 x 15 x 30 ซม. แบบพับ มองเห็นได้ทั้ง 2 ด้าน	วัสดุอื่นๆ	วัสดุอื่นๆ	ชิ้น	485.00	\N	0	0.00	\N	\N	t	\N	t	11
1299	P230-001299	วัสดุใช้ไป	ถังดับเพลิง ชนิดเหลวระเหย BF2000 ขนาด 15 lbs	วัสดุอื่นๆ	วัสดุอื่นๆ	ชิ้น	4495.00	\N	0	0.00	\N	\N	t	\N	t	4
1300	P230-001300	วัสดุใช้ไป	ป้ายวิธีการใช้ถังดับเพลิง แบบอลูมิเนียม ขนาด 30 x 45 ซม.	วัสดุอื่นๆ	วัสดุอื่นๆ	ชิ้น	785.00	\N	0	0.00	\N	\N	t	\N	t	4
1301	P230-001301	วัสดุใช้ไป	น้ำยาล้างห้องน้ำ ขนาด 3.5 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	180.00	\N	0	0.00	\N	\N	t	\N	t	11
1302	P230-001302	วัสดุใช้ไป	น้ำยาล้างห้องน้ำ ขนาด 900 ซีซี	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขวด	55.00	\N	0	0.00	\N	\N	t	\N	t	4
1303	P230-001303	วัสดุใช้ไป	สาย THW ขนาด 1*2.5 สีแดง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	15.00	\N	0	0.00	\N	\N	t	\N	t	1
1304	P230-001304	วัสดุใช้ไป	สาย THW ขนาด 1*2.5 สีดำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	13.00	\N	0	0.00	\N	\N	t	\N	t	1
1305	P230-001305	วัสดุใช้ไป	สาย THW ขนาด 1*2.5 สีเขียว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	15.00	\N	0	0.00	\N	\N	t	\N	t	1
1306	P230-001306	วัสดุใช้ไป	หัวแจ๊คตัวผู้ ขนาด 3.5 มม/4 pole	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	20.00	\N	0	0.00	\N	\N	t	\N	t	4
1307	P230-001307	วัสดุใช้ไป	สวิทช์ควบคุมการไหลของปั๊มน้ำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	1050.00	\N	0	0.00	\N	\N	t	\N	t	4
1308	P230-001308	วัสดุใช้ไป	ยางมะตอย แบบสำเร็จรูป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	89.00	\N	0	0.00	\N	\N	t	\N	t	11
1309	P230-001309	วัสดุใช้ไป	ผงย่อยจุลินทรีย์ สำหรับสุขภัณฑ์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	189.00	\N	0	0.00	\N	\N	t	\N	t	4
1310	P230-001310	วัสดุใช้ไป	ซิลิโคน แบบมีกรด ขนาด 300 มล.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	หลอด	199.00	\N	0	0.00	\N	\N	t	\N	t	11
1311	P230-001311	วัสดุใช้ไป	ป้ายบอกทางหนีไฟ ขนาด 20 x 30 ซม.	วัสดุอื่นๆ	วัสดุอื่นๆ	ป้าย	300.00	\N	0	0.00	\N	\N	t	\N	t	1
1312	P230-001312	วัสดุใช้ไป	ป้ายจุดรวมพล ขนาด 80 x 100 ซม.	วัสดุอื่นๆ	วัสดุอื่นๆ	ป้าย	6900.00	\N	0	0.00	\N	\N	t	\N	t	11
1313	P230-001313	วัสดุใช้ไป	สาย VGA to VGA ยาว 5 เมตร	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	250.00	\N	0	0.00	\N	\N	t	\N	t	1
1314	P230-001314	วัสดุใช้ไป	ตะกร้าล้อลาก สำหรับใส่ผ้า ขนาด 51*39*63.5  cm	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	350.00	\N	0	0.00	\N	\N	t	\N	t	1
1315	P230-001315	วัสดุใช้ไป	ไส้กรองน้ำเรซิน (งานจ่ายกลาง)	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	1200.00	\N	0	0.00	\N	\N	t	\N	t	1
1316	P230-001316	วัสดุใช้ไป	ไส้กรองน้ำคาร์บอน (งานจ่ายกลาง)	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	1200.00	\N	0	0.00	\N	\N	t	\N	t	4
1317	P230-001317	วัสดุใช้ไป	ไส้กรอง PP20 (งานจ่ายกลาง)	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	1200.00	\N	0	0.00	\N	\N	t	\N	t	1
1318	P230-001318	วัสดุใช้ไป	ฟิวเตอร์งเมมเบรนกรองน้ำ RO (งานจ่ายกลาง)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1200.00	\N	0	0.00	\N	\N	t	\N	t	11
1319	P230-001319	วัสดุใช้ไป	ที่วัดลมยาง	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	600.00	\N	0	0.00	\N	\N	t	\N	t	4
1320	P230-001320	วัสดุใช้ไป	น้ำยาเคลือบเงารถ	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	300.00	\N	0	0.00	\N	\N	t	\N	t	1
1321	P230-001321	วัสดุใช้ไป	น้ำยาเช็ดรถ	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	300.00	\N	0	0.00	\N	\N	t	\N	t	4
1322	P230-001322	วัสดุใช้ไป	ผ้าเช็ดรถ	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	120.00	\N	0	0.00	\N	\N	t	\N	t	11
1325	P230-001325	วัสดุใช้ไป	เสียม ชนิดเหล็ก แบบด้ามไม้ ขนาด 2 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	อัน	350.00	\N	0	0.00	\N	\N	t	\N	t	1
1326	P230-001326	วัสดุใช้ไป	ตะไบสามเหลี่ยม	วัสดุการเกษตร	วัสดุการเกษตร	อัน	350.00	\N	0	0.00	\N	\N	t	\N	t	4
1327	P230-001327	วัสดุใช้ไป	บาร์เลท่อย ขนาด 11.5 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	อัน	350.00	\N	0	0.00	\N	\N	t	\N	t	11
1328	P230-001328	วัสดุใช้ไป	แผ่นโฟมจิ๊กซอว์ แบบ ABC ขนาด 29*29 ซม. (PCU วังทอง)	วัสดุอื่นๆ	วัสดุอื่นๆ	ชุด	310.00	\N	0	0.00	\N	\N	t	\N	t	4
1329	P230-001329	วัสดุใช้ไป	แผ่นโฟมจิ๊กซอว์ แบบ ก-ฮ ขนาด 29*29 ซม. (PCU วังทอง)	วัสดุอื่นๆ	วัสดุอื่นๆ	ชุด	390.00	\N	0	0.00	\N	\N	t	\N	t	11
24	P230-000024	วัสดุใช้ไป	แผ่น CD-R (50 ซอง/แพค)	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หลอด	280.00	\N	0	0.00	\N	\N	t	\N	t	11
27	P230-000027	วัสดุใช้ไป	หมึก Printer Ink jet GT53 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	0.00	\N	0	0.00	\N	\N	t	\N	t	4
28	P230-000028	วัสดุใช้ไป	หมึก Printer Ink jet GT52 สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	390.00	\N	0	0.00	\N	\N	t	\N	t	4
29	P230-000029	วัสดุใช้ไป	หมึก Printer Ink jet GT52 สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	390.00	\N	0	0.00	\N	\N	t	\N	t	1
30	P230-000030	วัสดุใช้ไป	หมึก Printer Ink jet GT52 สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	390.00	\N	0	0.00	\N	\N	t	\N	t	4
31	P230-000031	วัสดุใช้ไป	หมึก Printer Ink jet L5190 สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	350.00	\N	0	0.00	\N	\N	t	\N	t	1
32	P230-000032	วัสดุใช้ไป	หมึก Printer Ink jet L5190 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	350.00	\N	0	0.00	\N	\N	t	\N	t	4
33	P230-000033	วัสดุใช้ไป	หมึก Printer Ink jet L5190 สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	350.00	\N	0	0.00	\N	\N	t	\N	t	1
34	P230-000034	วัสดุใช้ไป	หมึก Printer Ink jet L5190 สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	350.00	\N	0	0.00	\N	\N	t	\N	t	11
35	P230-000035	วัสดุใช้ไป	หมึก Printer Ink jet T6641 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N	t	11
36	P230-000036	วัสดุใช้ไป	หมึก Printer Ink jet T6641 สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N	t	4
37	P230-000037	วัสดุใช้ไป	หมึก Printer Ink jet T6641 สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N	t	11
38	P230-000038	วัสดุใช้ไป	หมึก Printer Ink jet T6641 สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N	t	1
42	P230-000042	วัสดุใช้ไป	หมึก Printer Laser 30A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	890.00	\N	0	0.00	\N	\N	t	\N	t	11
44	P230-000044	วัสดุใช้ไป	หมึก Printer Laser 472	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	980.00	\N	0	0.00	\N	\N	t	\N	t	1
47	P230-000047	วัสดุใช้ไป	หมึก Printer Laser 83A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	390.00	\N	0	0.00	\N	\N	t	\N	t	11
49	P230-000049	วัสดุใช้ไป	หมึก Printer Laser Fuji m285Z P235	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	980.00	\N	0	0.00	\N	\N	t	\N	t	1
57	P230-000057	วัสดุใช้ไป	หมึก Printer Ink jet Epson 003 สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N	t	4
537	P230-000537	วัสดุใช้ไป	แฟ้ม เวชระเบียน	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	10.00	\N	0	0.00	\N	\N	t	\N	t	1
59	P230-000059	วัสดุใช้ไป	หมึก Printer Ink jet Epson 003 สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N	t	1
60	P230-000060	วัสดุใช้ไป	หมึก Printer Ink jet Epson 003 สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N	t	1
62	P230-000062	วัสดุใช้ไป	กระดาษชำระ ขนาดเล็ก	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	6.00	\N	0	0.00	\N	\N	t	\N	t	1
63	P230-000063	วัสดุใช้ไป	กระดาษชำระ ชนิดม้วน แบบ 2 ชั้น ขนาดยาว 300 เมตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	65.00	\N	0	0.00	\N	\N	t	\N	t	4
69	P230-000069	วัสดุใช้ไป	ก้อนดับกลิ่น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อน	35.00	\N	0	0.00	\N	\N	t	\N	t	4
71	P230-000071	วัสดุใช้ไป	แก้วน้ำ แบบทรงสูง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	15.00	\N	0	0.00	\N	\N	t	\N	t	4
73	P230-000073	วัสดุใช้ไป	แก้วน้ำ ชนิดพลาสติก ขนาด 6 ออนซ์	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1.00	\N	0	0.00	\N	\N	t	\N	t	4
74	P230-000074	วัสดุใช้ไป	แก้วน้ำ ชนิดอลูมิเนียม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	30.00	\N	0	0.00	\N	\N	t	\N	t	1
76	P230-000076	วัสดุใช้ไป	ขันน้ำ ชนิดพลาสติก แบบมีด้าม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	25.00	\N	0	0.00	\N	\N	t	\N	t	4
79	P230-000079	วัสดุใช้ไป	ช้อน ชนิดสแตนเลส แบบสั้น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	โหล	35.00	\N	0	0.00	\N	\N	t	\N	t	4
80	P230-000080	วัสดุใช้ไป	เชือก ชนิดปอแก้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	50.00	\N	0	0.00	\N	\N	t	\N	t	1
82	P230-000082	วัสดุใช้ไป	ด้ามมีดโกน ชนิดพลาสติก แบบใช้แล้วทิ้ง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	11
87	P230-000087	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีเขียว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	65.00	\N	0	0.00	\N	\N	t	\N	t	1
88	P230-000088	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีเขียว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	65.00	\N	0	0.00	\N	\N	t	\N	t	11
89	P230-000089	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	50.00	\N	0	0.00	\N	\N	t	\N	t	11
90	P230-000090	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	50.00	\N	0	0.00	\N	\N	t	\N	t	11
92	P230-000092	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	70.00	\N	0	0.00	\N	\N	t	\N	t	1
93	P230-000093	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	70.00	\N	0	0.00	\N	\N	t	\N	t	4
94	P230-000094	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีเหลือง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	70.00	\N	0	0.00	\N	\N	t	\N	t	4
95	P230-000095	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีเหลือง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	60.00	\N	0	0.00	\N	\N	t	\N	t	11
98	P230-000098	วัสดุใช้ไป	ถุง ชนิดพลาสติก ขนาด 16*26 นิ้ว สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N	t	11
99	P230-000099	วัสดุใช้ไป	ถุง ชนิดพลาสติก ขนาด 4.5*7 นิ้ว สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N	t	11
100	P230-000100	วัสดุใช้ไป	ถุง ชนิดพลาสติก ขนาด 6*9 นิ้ว สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N	t	11
101	P230-000101	วัสดุใช้ไป	ถุง ชนิดพลาสติก ขนาด 8*12 นิ้ว สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N	t	4
103	P230-000103	วัสดุใช้ไป	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ L	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	120.00	\N	0	0.00	\N	\N	t	\N	t	1
106	P230-000106	วัสดุใช้ไป	ถุงมือ ชนิดยาง เบอร์ L สีส้ม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N	t	4
107	P230-000107	วัสดุใช้ไป	ถุงมือ ชนิดยาง เบอร์ M สีส้ม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N	t	11
111	P230-000111	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*24 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N	t	1
112	P230-000112	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 15*30 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N	t	4
113	P230-000113	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 8*16 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N	t	11
114	P230-000114	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*26 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N	t	11
115	P230-000115	วัสดุใช้ไป	ที่ตักขยะ ชนิดพลาสติก แบบมีด้ามจับ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	65.00	\N	0	0.00	\N	\N	t	\N	t	4
116	P230-000116	วัสดุใช้ไป	ที่ตักขยะสังกะสี ชนิดสังกะสี แบบมีด้ามจับ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	95.00	\N	0	0.00	\N	\N	t	\N	t	4
119	P230-000119	วัสดุใช้ไป	น้ำยา สำหรับเช็ดกระจก	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	130.00	\N	0	0.00	\N	\N	t	\N	t	11
121	P230-000121	วัสดุใช้ไป	น้ำยา ชนิดสูตรน้ำ สำหรับดันฝุ่น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	370.00	\N	0	0.00	\N	\N	t	\N	t	1
122	P230-000122	วัสดุใช้ไป	น้ำยา ชนิดสูตรน้ำมันใส สำหรับดันฝุ่น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	430.00	\N	0	0.00	\N	\N	t	\N	t	11
123	P230-000123	วัสดุใช้ไป	น้ำยา สำหรับทำความสะอาดพื้น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	200.00	\N	0	0.00	\N	\N	t	\N	t	1
124	P230-000124	วัสดุใช้ไป	น้ำยา สำหรับล้างจาน	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	120.00	\N	0	0.00	\N	\N	t	\N	t	11
125	P230-000125	วัสดุใช้ไป	น้ำยา สำหรับล้างมือ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	180.00	\N	0	0.00	\N	\N	t	\N	t	11
127	P230-000127	วัสดุใช้ไป	ใบมีดโกน แบบ 2 คม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่อง	35.00	\N	0	0.00	\N	\N	t	\N	t	4
128	P230-000128	วัสดุใช้ไป	ปืนยิงแก๊ส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	25.00	\N	0	0.00	\N	\N	t	\N	t	1
129	P230-000129	วัสดุใช้ไป	แป้งฝุ่น สำหรับเด็ก ขนาด 180 กรัม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	35.00	\N	0	0.00	\N	\N	t	\N	t	1
130	P230-000130	วัสดุใช้ไป	แปรง ชนิดทองเหลือง สำหรับขัดพื้น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	120.00	\N	0	0.00	\N	\N	t	\N	t	1
131	P230-000131	วัสดุใช้ไป	แปรง ชนิดพลาสติก สำหรับขัดพื้นแบบมีด้ามยาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	70.00	\N	0	0.00	\N	\N	t	\N	t	11
132	P230-000132	วัสดุใช้ไป	แปรง ชนิดพลาสติก สำหรับขัดห้องน้ำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	30.00	\N	0	0.00	\N	\N	t	\N	t	4
171	P230-000171	วัสดุใช้ไป	ลังถึง เบอร์ 36	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	800.00	\N	0	0.00	\N	\N	t	\N	t	11
133	P230-000133	วัสดุใช้ไป	แปรง ชนิดขนอ่อน สำหรับซักผ้า	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	25.00	\N	0	0.00	\N	\N	t	\N	t	4
135	P230-000135	วัสดุใช้ไป	ผงซักฟอก ขนาด 800 กรัม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง	70.00	\N	0	0.00	\N	\N	t	\N	t	11
138	P230-000138	วัสดุใช้ไป	ผ้าม็อบ สำหรับถูพื้น แบบเปียก ขนาด 12 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	80.00	\N	0	0.00	\N	\N	t	\N	t	11
139	P230-000139	วัสดุใช้ไป	ผ้าห่ม สำหรับถูพื้น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	160.00	\N	0	0.00	\N	\N	t	\N	t	11
141	P230-000141	วัสดุใช้ไป	ฝอย ชนิดแสตนเลส ขนาด 14 กรัม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	15.00	\N	0	0.00	\N	\N	t	\N	t	1
148	P230-000148	วัสดุใช้ไป	ไม้กวาด ชนิดดอกหญ้า	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	50.00	\N	0	0.00	\N	\N	t	\N	t	1
149	P230-000149	วัสดุใช้ไป	ไม้กวาด ชนิดทางมะพร้าว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	60.00	\N	0	0.00	\N	\N	t	\N	t	1
150	P230-000150	วัสดุใช้ไป	ไม้กวาด ชนิดทางมะพร้าว สำหรับกวาดหยากไย่	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	45.00	\N	0	0.00	\N	\N	t	\N	t	1
151	P230-000151	วัสดุใช้ไป	ไม้กวาด ชนิดพลาสติก สำหรับกวาดหยากไย่ แบบปรับระดับได้	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	290.00	\N	0	0.00	\N	\N	t	\N	t	4
152	P230-000152	วัสดุใช้ไป	ไม้ดันฝุ่น แบบด้ามไม้ พร้อมผ้าดันฝุ่น ขนาดยาว 24 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	450.00	\N	0	0.00	\N	\N	t	\N	t	4
153	P230-000153	วัสดุใช้ไป	ไม้ดันฝุ่น แบบด้ามอลูมิเนียม ขนาดยาว 24 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	300.00	\N	0	0.00	\N	\N	t	\N	t	1
154	P230-000154	วัสดุใช้ไป	ไม้ถูพื้น ขนาด 10 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	130.00	\N	0	0.00	\N	\N	t	\N	t	1
155	P230-000155	วัสดุใช้ไป	ไม้ปัดขนไก่ แบบด้ามพลาสติก	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	160.00	\N	0	0.00	\N	\N	t	\N	t	11
156	P230-000156	วัสดุใช้ไป	ไม้ยางรีดน้ำ ขนาด 18 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	295.00	\N	0	0.00	\N	\N	t	\N	t	4
157	P230-000157	วัสดุใช้ไป	ยางวง แบบเส้นเล็ก ขนาด 500 กรัม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N	t	4
158	P230-000158	วัสดุใช้ไป	ยางวง แบบเส้นใหญ่ ขนาด 500 กรัม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N	t	1
159	P230-000159	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 10 สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N	t	1
161	P230-000161	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 11 สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N	t	4
162	P230-000162	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 11.5 สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N	t	1
163	P230-000163	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 12 สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N	t	1
164	P230-000164	วัสดุใช้ไป	รองเท้า ชนิดฟองน้ำ เบอร์ 10	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N	t	11
165	P230-000165	วัสดุใช้ไป	รองเท้า ชนิดฟองน้ำ เบอร์ 11	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N	t	11
167	P230-000167	วัสดุใช้ไป	รองเท้า ชนิดยางพารา เบอร์ L	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	95.00	\N	0	0.00	\N	\N	t	\N	t	1
168	P230-000168	วัสดุใช้ไป	รองเท้า ชนิดยางพารา เบอร์ LL	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	95.00	\N	0	0.00	\N	\N	t	\N	t	1
169	P230-000169	วัสดุใช้ไป	รองเท้า ชนิดยางพารา เบอร์ M	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	95.00	\N	0	0.00	\N	\N	t	\N	t	1
170	P230-000170	วัสดุใช้ไป	รองเท้า ชนิดยางพารา เบอร์ XL	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	95.00	\N	0	0.00	\N	\N	t	\N	t	1
172	P230-000172	วัสดุใช้ไป	สก็อตไบร์ท แบบแผ่นเล็ก ขนาด 4.5*6 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แผ่น	30.00	\N	0	0.00	\N	\N	t	\N	t	11
174	P230-000174	วัสดุใช้ไป	สบู่ แบบก้อนเล็ก ขนาด 10 กรัม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อน	2.00	\N	0	0.00	\N	\N	t	\N	t	4
175	P230-000175	วัสดุใช้ไป	สบู่ แบบก้อนใหญ่	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อน	15.00	\N	0	0.00	\N	\N	t	\N	t	11
177	P230-000177	วัสดุใช้ไป	สเปรย์ ชนิดสูตรน้ำ สำหรับฉีดมด ยุง ขนาด 600 มล.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	130.00	\N	0	0.00	\N	\N	t	\N	t	1
178	P230-000178	วัสดุใช้ไป	สเปรย์ สำหรับปรับอากาศ ขนาด 300 มล.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	58.00	\N	0	0.00	\N	\N	t	\N	t	4
183	P230-000183	วัสดุใช้ไป	เหยือกน้ำ ชนิดพลาสติก ขนาด 1,000 ซีซี	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	100.00	\N	0	0.00	\N	\N	t	\N	t	11
184	P230-000184	วัสดุใช้ไป	เอี๊ยม ชนิดพลาสติก แบบใช้แล้วทิ้ง ขนาดบรรจุ 100 ชิ้น/ถุง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง	350.00	\N	0	0.00	\N	\N	t	\N	t	11
343	P230-000343	วัสดุใช้ไป	น้ำหวาน สำหรับผู้ป่วยเบาหวาน สีแดง	วัสดุบริโภค	วัสดุบริโภค	ขวด	65.00	\N	0	0.00	\N	\N	t	\N	t	11
350	P230-000350	วัสดุใช้ไป	ถ่าน ชนิดธรรมดา ขนาด AAA	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	10.00	\N	0	0.00	\N	\N	t	\N	t	1
351	P230-000351	วัสดุใช้ไป	ถ่าน ชนิดอัลคาไลน์ ขนาด AAA	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	20.00	\N	0	0.00	\N	\N	t	\N	t	11
352	P230-000352	วัสดุใช้ไป	ถ่าน ชนิดอัลคาไลน์ ขนาดกลาง C	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	50.00	\N	0	0.00	\N	\N	t	\N	t	11
353	P230-000353	วัสดุใช้ไป	ถ่าน ชนิดธรรมดา ขนาดใหญ่ D	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	16.00	\N	0	0.00	\N	\N	t	\N	t	11
355	P230-000355	วัสดุใช้ไป	ปลั๊กไฟพ่วง แบบ 4 ช่อง 4 สวิตซ์ ยาว 3 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	410.00	\N	0	0.00	\N	\N	t	\N	t	11
421	P230-000421	วัสดุใช้ไป	กบเหลาดินสอ แบบหมุน	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	265.00	\N	0	0.00	\N	\N	t	\N	t	4
422	P230-000422	วัสดุใช้ไป	กรรไกร ขนาด 8 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	85.00	\N	0	0.00	\N	\N	t	\N	t	1
424	P230-000424	วัสดุใช้ไป	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N	t	1
425	P230-000425	วัสดุใช้ไป	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N	t	11
426	P230-000426	วัสดุใช้ไป	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีชมพู	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N	t	4
428	P230-000428	วัสดุใช้ไป	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N	t	1
429	P230-000429	วัสดุใช้ไป	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	35.00	\N	0	0.00	\N	\N	t	\N	t	4
430	P230-000430	วัสดุใช้ไป	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1 นิ้ว 24x25 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	45.00	\N	0	0.00	\N	\N	t	\N	t	11
431	P230-000431	วัสดุใช้ไป	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1.5 นิ้ว 36x20 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	25.00	\N	0	0.00	\N	\N	t	\N	t	4
433	P230-000433	วัสดุใช้ไป	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 2 นิ้ว 20 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	30.00	\N	0	0.00	\N	\N	t	\N	t	4
435	P230-000435	วัสดุใช้ไป	กระดาษคาร์บอน สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	150.00	\N	0	0.00	\N	\N	t	\N	t	4
470	P230-000470	วัสดุใช้ไป	ตรายาง สำหรั้บปั๊มวันที่ภาษาไทย	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	60.00	\N	0	0.00	\N	\N	t	\N	t	1
436	P230-000436	วัสดุใช้ไป	กระดาษต่อเนื่อง แบบ 1 ชั้น ขนาด 15x11 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	2000.00	\N	0	0.00	\N	\N	t	\N	t	4
437	P230-000437	วัสดุใช้ไป	กระดาษถ่ายเอกสาร ขนาด A4	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	120.00	\N	0	0.00	\N	\N	t	\N	t	1
438	P230-000438	วัสดุใช้ไป	กระดาษเทอร์มอล สำหรับเครื่อง EDC ขนาด 57*40 มม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	90.00	\N	0	0.00	\N	\N	t	\N	t	1
439	P230-000439	วัสดุใช้ไป	กระดาษเทอร์มอล สำหรับเครื่องวัดความดัน ขนาด 57*55 มม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	50.00	\N	0	0.00	\N	\N	t	\N	t	11
440	P230-000440	วัสดุใช้ไป	กระดาษเทอร์มอล ขนาด 80*80 มม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	60.00	\N	0	0.00	\N	\N	t	\N	t	4
442	P230-000442	วัสดุใช้ไป	กระดาษบวกเลข สำหรับเครื่องคิดเลข ขนาด 2 1/4 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	10.00	\N	0	0.00	\N	\N	t	\N	t	1
443	P230-000443	วัสดุใช้ไป	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	95.00	\N	0	0.00	\N	\N	t	\N	t	1
444	P230-000444	วัสดุใช้ไป	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีชมพู	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	95.00	\N	0	0.00	\N	\N	t	\N	t	1
445	P230-000445	วัสดุใช้ไป	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	95.00	\N	0	0.00	\N	\N	t	\N	t	11
446	P230-000446	วัสดุใช้ไป	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	95.00	\N	0	0.00	\N	\N	t	\N	t	11
447	P230-000447	วัสดุใช้ไป	กระดาษโรเนียว หนา 70 แกรม ขนาด A4 สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	120.00	\N	0	0.00	\N	\N	t	\N	t	1
448	P230-000448	วัสดุใช้ไป	กระดาษโรเนียว หนา 80 แกรม ขนาด F4 สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	130.00	\N	0	0.00	\N	\N	t	\N	t	11
451	P230-000451	วัสดุใช้ไป	กาว ชนิดแท่ง	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่ง	65.00	\N	0	0.00	\N	\N	t	\N	t	11
452	P230-000452	วัสดุใช้ไป	กาว ชนิดน้ำ แบบป้าย ขนาด 560 ซีซี	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	30.00	\N	0	0.00	\N	\N	t	\N	t	11
453	P230-000453	วัสดุใช้ไป	กาว ชนิดน้ำ แบบหัวโฟม ขนาด 50 ซีซี	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่ง	20.00	\N	0	0.00	\N	\N	t	\N	t	4
455	P230-000455	วัสดุใช้ไป	คลิปหนีบกระดาษ ขนาด #108 สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	55.00	\N	0	0.00	\N	\N	t	\N	t	11
456	P230-000456	วัสดุใช้ไป	คลิปหนีบกระดาษ ขนาด #109 สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	40.00	\N	0	0.00	\N	\N	t	\N	t	11
457	P230-000457	วัสดุใช้ไป	คลิปหนีบกระดาษ ขนาด #110 สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	25.00	\N	0	0.00	\N	\N	t	\N	t	11
458	P230-000458	วัสดุใช้ไป	คลิปหนีบกระดาษ ขนาด #111 สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N	t	11
460	P230-000460	วัสดุใช้ไป	เครื่องคิดเลข ชนิด 2 ระบบ แบบ 12 หลัก	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	850.00	\N	0	0.00	\N	\N	t	\N	t	4
461	P230-000461	วัสดุใช้ไป	เครื่องเจาะกระดาษ แบบเจาะ 25 แผ่น	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	200.00	\N	0	0.00	\N	\N	t	\N	t	4
462	P230-000462	วัสดุใช้ไป	เครื่องเย็บกระดาษ ขนาด NO.10	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	85.00	\N	0	0.00	\N	\N	t	\N	t	11
463	P230-000463	วัสดุใช้ไป	เครื่องเย็บกระดาษ ขนาด NO.35	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	360.00	\N	0	0.00	\N	\N	t	\N	t	1
464	P230-000464	วัสดุใช้ไป	เชือก ชนิดพลาสติก ขนาดใหญ่ ยาว 180 ม. สี่ขาว-แดง	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	65.00	\N	0	0.00	\N	\N	t	\N	t	1
465	P230-000465	วัสดุใช้ไป	ซองขาว แบบมีครุฑ ขนาด #9/125	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	1.00	\N	0	0.00	\N	\N	t	\N	t	11
466	P230-000466	วัสดุใช้ไป	ซองน้ำตาล แบบมีครุฑ ขยายข้าง หนาพิเศษ ขนาด A4	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	4.00	\N	0	0.00	\N	\N	t	\N	t	11
467	P230-000467	วัสดุใช้ไป	ซองน้ำตาล แบบมีครุฑ ไม่ขยายข้าง หนาพิเศษ ขนาด A4	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	4.00	\N	0	0.00	\N	\N	t	\N	t	4
468	P230-000468	วัสดุใช้ไป	ซองน้ำตาล แบบมีครุฑ ขยายข้าง หนาพิเศษ ขนาด F4	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	4.00	\N	0	0.00	\N	\N	t	\N	t	11
471	P230-000471	วัสดุใช้ไป	ตรายาง สำหรั้บปั๊มวันที่เลขไทย	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	60.00	\N	0	0.00	\N	\N	t	\N	t	4
474	P230-000474	วัสดุใช้ไป	เทปกาว ชนิด OPP ขนาด 2 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	25.00	\N	0	0.00	\N	\N	t	\N	t	4
476	P230-000476	วัสดุใช้ไป	เทปใส แบบแกนเล็ก ขนาด 1 นิ้ว 36 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	30.00	\N	0	0.00	\N	\N	t	\N	t	4
477	P230-000477	วัสดุใช้ไป	เทปใส แบบแกนใหญ่ ขนาด 1 นิ้ว 36 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	30.00	\N	0	0.00	\N	\N	t	\N	t	11
478	P230-000478	วัสดุใช้ไป	เทปใส แบบแกนใหญ่ ขนาด 2 นิ้ว 45 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	45.00	\N	0	0.00	\N	\N	t	\N	t	4
479	P230-000479	วัสดุใช้ไป	เทปใส แบบแกนเล็ก ขนาด 3/4 นิ้ว 36 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	30.00	\N	0	0.00	\N	\N	t	\N	t	4
484	P230-000484	วัสดุใช้ไป	แท่นประทับ แบบฝาโลหะ สีดำ #2	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	1
485	P230-000485	วัสดุใช้ไป	แท่นประทับ แบบฝาโลหะ สีแดง #2	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	4
486	P230-000486	วัสดุใช้ไป	แท่นประทับ แบบฝาโลหะ สีน้ำเงิน #2	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	11
492	P230-000492	วัสดุใช้ไป	น้ำยา สำหรับลบคำผิด ขนาด 7 มล.	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่ง	20.00	\N	0	0.00	\N	\N	t	\N	t	4
503	P230-000503	วัสดุใช้ไป	แบบฟอร์ม ชนิดเคมี 2 ชั้น Doctor's Order แบบต่อเนื่อง เคมี 2 ชั้น 9*11" (1,000 ชุด/กล่อง) ขนาด 9*11 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	2200.00	\N	0	0.00	\N	\N	t	\N	t	1
505	P230-000505	วัสดุใช้ไป	แบบฟอร์ม ปรอท แบบพิมพ์ 2 สี หนา 70 แกรม ขนาด A4	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	400.00	\N	0	0.00	\N	\N	t	\N	t	1
506	P230-000506	วัสดุใช้ไป	ใบมีดคัตเตอร์ ขนาดเล็ก	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N	t	4
507	P230-000507	วัสดุใช้ไป	ใบมีดคัตเตอร์ ขนาดใหญ่	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	25.00	\N	0	0.00	\N	\N	t	\N	t	1
509	P230-000509	วัสดุใช้ไป	แบบฟอร์ม ใบรับรองแพทย์ กรณีสมัครงาน	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	60.00	\N	0	0.00	\N	\N	t	\N	t	4
510	P230-000510	วัสดุใช้ไป	แบบฟอร์ม ใบเสร็จรับเงิน (1,000 ชุด/กล่อง)	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1600.00	\N	0	0.00	\N	\N	t	\N	t	4
514	P230-000514	วัสดุใช้ไป	ปากกา เขียนแผ่น CD สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	40.00	\N	0	0.00	\N	\N	t	\N	t	1
515	P230-000515	วัสดุใช้ไป	ปากกา เคมี แบบ 2 หัว สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	15.00	\N	0	0.00	\N	\N	t	\N	t	1
516	P230-000516	วัสดุใช้ไป	ปากกา เคมี แบบ 2 หัว สีแดง	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	15.00	\N	0	0.00	\N	\N	t	\N	t	11
517	P230-000517	วัสดุใช้ไป	ปากกา เคมี แบบ 2 หัว สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	15.00	\N	0	0.00	\N	\N	t	\N	t	4
518	P230-000518	วัสดุใช้ไป	ปากกา ไวท์บอร์ด ตราม้า สีแดง	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	25.00	\N	0	0.00	\N	\N	t	\N	t	1
521	P230-000521	วัสดุใช้ไป	ปากกา ไวท์บอร์ด ตราม้า สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	25.00	\N	0	0.00	\N	\N	t	\N	t	11
522	P230-000522	วัสดุใช้ไป	ปากกา ไวท์บอร์ด PILOT สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	25.00	\N	0	0.00	\N	\N	t	\N	t	1
523	P230-000523	วัสดุใช้ไป	ป้ายลาเบล ชนิดสติ๊กเกอร์ ขนาด A5	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	45.00	\N	0	0.00	\N	\N	t	\N	t	4
524	P230-000524	วัสดุใช้ไป	ป้ายลาเบล ชนิดสติ๊กเกอร์ ขนาด A7	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	45.00	\N	0	0.00	\N	\N	t	\N	t	11
525	P230-000525	วัสดุใช้ไป	แปรง สำหรับลบกระดานไวท์บอร์ด	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	4
530	P230-000530	วัสดุใช้ไป	พลาสติกเคลือบบัตร ขนาด 6*95 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	60.00	\N	0	0.00	\N	\N	t	\N	t	11
531	P230-000531	วัสดุใช้ไป	พลาสติกเคลือบบัตร หนา 125 ไมครอน ขนาด A4	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	350.00	\N	0	0.00	\N	\N	t	\N	t	4
533	P230-000533	วัสดุใช้ไป	แฟ้ม แบบแขวน สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	15.00	\N	0	0.00	\N	\N	t	\N	t	4
534	P230-000534	วัสดุใช้ไป	แฟ้ม แบบแขวน สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	15.00	\N	0	0.00	\N	\N	t	\N	t	11
535	P230-000535	วัสดุใช้ไป	แฟ้ม แบบแขวน สีส้ม	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	15.00	\N	0	0.00	\N	\N	t	\N	t	4
536	P230-000536	วัสดุใช้ไป	แฟ้ม แบบแขวน สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	15.00	\N	0	0.00	\N	\N	t	\N	t	4
538	P230-000538	วัสดุใช้ไป	แฟ้ม แบบสันแข็ง ขนาด 1 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	55.00	\N	0	0.00	\N	\N	t	\N	t	1
539	P230-000539	วัสดุใช้ไป	แฟ้ม แบบสันแข็ง ขนาด 2 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	60.00	\N	0	0.00	\N	\N	t	\N	t	11
540	P230-000540	วัสดุใช้ไป	แฟ้ม แบบสันแข็ง ขนาด 3 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	75.00	\N	0	0.00	\N	\N	t	\N	t	1
541	P230-000541	วัสดุใช้ไป	แฟ้ม เสนอเซ็นต์ ขนาด F4	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	140.00	\N	0	0.00	\N	\N	t	\N	t	11
542	P230-000542	วัสดุใช้ไป	แฟ้ม ชนิดปกพลาสติก แบบหนีบ	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	120.00	\N	0	0.00	\N	\N	t	\N	t	4
543	P230-000543	วัสดุใช้ไป	มีดคัตเตอร์ ชนิดด้ามสแตนเลส ขนาดเล็ก	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N	t	1
544	P230-000544	วัสดุใช้ไป	มีดคัตเตอร์ ชนิดด้ามพลาสติก ขนาดใหญ่	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	25.00	\N	0	0.00	\N	\N	t	\N	t	1
546	P230-000546	วัสดุใช้ไป	ลวดเย็บกระดาษ เบอร์ 10	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	10.00	\N	0	0.00	\N	\N	t	\N	t	1
548	P230-000548	วัสดุใช้ไป	ลวดเย็บกระดาษ เบอร์ 35	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	10.00	\N	0	0.00	\N	\N	t	\N	t	1
550	P230-000550	วัสดุใช้ไป	ลวดเสียบกระดาษ ขนาดเล็ก เบอร์ 1	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	15.00	\N	0	0.00	\N	\N	t	\N	t	4
551	P230-000551	วัสดุใช้ไป	ลวดเสียบกระดาษ ขนาดใหญ่ เบอร์ 0	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	15.00	\N	0	0.00	\N	\N	t	\N	t	1
553	P230-000553	วัสดุใช้ไป	ลิ้นแฟ้ม ชนิดเหล็ก	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	95.00	\N	0	0.00	\N	\N	t	\N	t	1
560	P230-000560	วัสดุใช้ไป	สติ๊กเกอร์ แบบต่อเนื่อง สำหรับพิมพ์ชื่อผู้ป่วย ขนาด 6*2.5 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	200.00	\N	0	0.00	\N	\N	t	\N	t	11
561	P230-000561	วัสดุใช้ไป	สติ๊กเกอร์ สำหรับติดชาร์ทผู้ป่วย สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	5.00	\N	0	0.00	\N	\N	t	\N	t	4
562	P230-000562	วัสดุใช้ไป	สติ๊กเกอร์ สำหรับติดชาร์ทผู้ป่วย สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	5.00	\N	0	0.00	\N	\N	t	\N	t	4
568	P230-000568	วัสดุใช้ไป	สมุด ชนิดหุ้มปก สำหรับทะเบียนหนังสือรับ	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	65.00	\N	0	0.00	\N	\N	t	\N	t	11
569	P230-000569	วัสดุใช้ไป	สมุด ชนิดหุ้มปก สำหรับทะเบียนหนังสือส่ง	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	65.00	\N	0	0.00	\N	\N	t	\N	t	4
572	P230-000572	วัสดุใช้ไป	สมุด ชนิดหุ้มปก แบบปกน้ำเงิน เบอร์ 1 หุ้มปก ขนาด 24x35 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	50.00	\N	0	0.00	\N	\N	t	\N	t	11
573	P230-000573	วัสดุใช้ไป	สมุด ชนิดหุ้มปก แบบปกน้ำเงิน เบอร์ 2 หุ้มปก ขนาด 19x31 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	40.00	\N	0	0.00	\N	\N	t	\N	t	1
578	P230-000578	วัสดุใช้ไป	หมึกเติม สำหรับแท่นประทับตรายาง สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	15.00	\N	0	0.00	\N	\N	t	\N	t	11
579	P230-000579	วัสดุใช้ไป	หมึกเติม สำหรับแท่นประทับตรายาง สีแดง	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	15.00	\N	0	0.00	\N	\N	t	\N	t	4
712	P230-000712	วัสดุใช้ไป	หมึก Printer Ink jet BT5000C สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	290.00	\N	0	0.00	\N	\N	t	\N	t	1
713	P230-000713	วัสดุใช้ไป	หมึก Printer Ink jet BT5000M สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	290.00	\N	0	0.00	\N	\N	t	\N	t	1
714	P230-000714	วัสดุใช้ไป	หมึก Printer Ink jet BT5000Y สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	290.00	\N	0	0.00	\N	\N	t	\N	t	1
784	P230-000784	วัสดุใช้ไป	Flash drive แบบ USB ขนาด 16 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	180.00	\N	0	0.00	\N	\N	t	\N	t	4
938	P230-000938	วัสดุใช้ไป	หมึก Printer Laser BROTHER FAX2950	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	590.00	\N	0	0.00	\N	\N	t	\N	t	1
940	P230-000940	วัสดุใช้ไป	Power supply ขนาด 550W	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1350.00	\N	0	0.00	\N	\N	t	\N	t	11
942	P230-000942	วัสดุใช้ไป	สาย HDMI ชนิด 4K ขนาด 5 เมตร	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	390.00	\N	0	0.00	\N	\N	t	\N	t	11
943	P230-000943	วัสดุใช้ไป	สาย HDMI ชนิด 4K ขนาด 10 เมตร	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	890.00	\N	0	0.00	\N	\N	t	\N	t	1
944	P230-000944	วัสดุใช้ไป	กล่องใส่ Hardisk ขนาด 2.5 นิ้ว	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	690.00	\N	0	0.00	\N	\N	t	\N	t	11
945	P230-000945	วัสดุใช้ไป	คีม สำหรับเข้าหัว LAN	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	990.00	\N	0	0.00	\N	\N	t	\N	t	4
987	P230-000987	วัสดุใช้ไป	Hardisk External ขนาด 1 Tb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	2000.00	\N	0	0.00	\N	\N	t	\N	t	11
989	P230-000989	วัสดุใช้ไป	MP3 player แบบ USB ขนาด 512 MB	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	299.00	\N	0	0.00	\N	\N	t	\N	t	4
1106	P230-001106	วัสดุใช้ไป	Hardisk ชนิด SSD Internal ขนาด 500 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1690.00	\N	0	0.00	\N	\N	t	\N	t	11
1114	P230-001114	วัสดุใช้ไป	หมึก Printer Laser FUJI-XEROX CT202877 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	980.00	\N	0	0.00	\N	\N	t	\N	t	4
1115	P230-001115	วัสดุใช้ไป	หมึก Printer Laser FUJI-XEROX CT203486 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N	t	1
1116	P230-001116	วัสดุใช้ไป	หมึก Printer Laser FUJI-XEROX CT203486 สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N	t	4
1117	P230-001117	วัสดุใช้ไป	หมึก Printer Laser FUJI-XEROX CT203486 สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N	t	11
1	P230-000001	วัสดุใช้ไป	ขวาน ชนิดเหล็ก แบบด้ามไม้	วัสดุการเกษตร	วัสดุการเกษตร	อัน	200.00	\N	0	0.00			t		t	11
\.


--
-- Data for Name: purchase_approval; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.purchase_approval (id, approve_code, doc_no, doc_date, status, total_amount, total_items, prepared_by, approved_by, approved_at, notes, created_by, created_at, updated_by, updated_at, version, doc_seq, pending_note, budget_year, seller_id, is_inspection) FROM stdin;
\.


--
-- Data for Name: purchase_approval_backup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.purchase_approval_backup (id, approval_id, department, record_number, request_date, product_name, product_code, category, product_type, product_subtype, requested_quantity, unit, price_per_unit, total_value, over_plan_case, requester, approver, budget_year, created_at, updated_at, department_code) FROM stdin;
1	\N	\N	\N	2026-03-12	เสียม ชนิดเหล็ก แบบด้ามไม้ ขนาด 2 นิ้ว	P230-001325	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	\N	อัน	350.00	0.00	\N	\N	\N	2569	2026-03-12 23:17:46.071349	2026-03-12 23:17:46.071349	\N
2	\N	\N	\N	2026-03-12	เสื้อกาวน์ยาว	P230-001232	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	\N	ตัว	0.00	0.00	\N	\N	\N	2569	2026-03-12 23:18:09.440374	2026-03-12 23:18:09.440374	\N
\.


--
-- Data for Name: purchase_approval_detail; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.purchase_approval_detail (id, purchase_approval_id, purchase_plan_id, line_number, status, approved_quantity, approved_amount, remarks, created_by, created_at, updated_by, updated_at, version, proposed_quantity, proposed_amount) FROM stdin;
\.


--
-- Data for Name: purchase_approval_inventory_link; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.purchase_approval_inventory_link (id, purchase_approval_id, inventory_receipt_status, received_qty, last_receipt_id, created_at, updated_at, purchase_approval_detail_id) FROM stdin;
\.


--
-- Data for Name: purchase_approval_inventory_link_backup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.purchase_approval_inventory_link_backup (id, purchase_approval_id, inventory_receipt_status, received_qty, last_receipt_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: purchase_plan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.purchase_plan (id, inventory_qty, qouta_qty, purchase_qty) FROM stdin;
1	0	15	15
2	0	2	2
3	0	3	3
4	0	2	2
5	0	4	4
6	0	8	8
7	0	1	1
8	0	10	10
9	0	4	4
10	0	4	4
11	0	1	1
12	0	10	10
13	0	2	2
14	0	3	3
15	0	2	2
16	0	2	2
17	0	20	20
18	0	10	10
19	0	22	22
20	0	1	1
21	0	1	1
22	0	9	9
23	0	13	13
24	0	4	4
25	0	4	4
26	0	4	4
27	0	90	90
28	0	30	30
29	0	34	34
30	0	3	3
31	0	4	4
32	0	1	1
33	0	2	2
34	0	144	144
35	0	1	1
36	0	5	5
37	0	5	5
38	0	6	6
39	0	6	6
40	0	6	6
41	0	15	15
42	0	20	20
43	0	829	829
44	0	4722	4722
45	0	1	1
46	0	50	50
47	0	4	4
48	0	3	3
49	0	375	375
50	0	6	6
51	0	10000	10000
52	0	13	13
53	0	8	8
54	0	90	90
55	0	165	165
56	0	480	480
57	0	8	8
58	0	16	16
59	0	555	555
60	0	674	674
61	0	1587	1587
62	0	671	671
63	0	1094	1094
64	0	239	239
65	0	444	444
66	0	1005	1005
67	0	2	2
68	0	193	193
69	0	67	67
70	0	85	85
71	0	150	150
72	0	5	5
73	0	35	35
74	0	52	52
75	0	57	57
76	0	61	61
77	0	7	7
78	0	4	4
79	0	356	356
80	0	50	50
81	0	989	989
82	0	662	662
83	0	26	26
84	0	8	8
85	0	14	14
86	0	2	2
87	0	72	72
88	0	42	42
89	0	346	346
90	0	144	144
91	0	184	184
92	0	77	77
93	0	8	8
94	0	40	40
95	0	32	32
96	0	58	58
97	0	72	72
98	0	14	14
99	0	921	921
100	0	41	41
101	0	83	83
102	0	24	24
103	0	5	5
104	0	50	50
105	0	269	269
106	0	72	72
107	0	114	114
108	0	16	16
109	0	16	16
110	0	12	12
111	0	12	12
112	0	17	17
113	0	20	20
114	0	17	17
115	0	3	3
116	0	78	78
117	0	55	55
118	0	8	8
119	0	13	13
120	0	27	27
121	0	31	31
122	0	14	14
123	0	5	5
124	0	2	2
125	0	1244	1244
126	0	286	286
127	0	100	100
128	0	8	8
129	0	4	4
130	0	57	57
131	0	180	180
132	0	60	60
133	0	2	2
134	0	2	2
135	0	56	56
136	0	66	66
137	0	6	6
138	0	10	10
139	0	100	100
140	0	1	1
141	0	2	2
142	0	5	5
143	0	3	3
144	0	5	5
145	0	1	1
146	0	20	20
147	0	10	10
148	0	8	8
149	0	16	16
150	0	20	20
151	0	3	3
152	0	8	8
153	0	2	2
154	0	2	2
155	0	6	6
156	0	6	6
157	0	40	40
158	0	10	10
159	0	4	4
160	0	1	1
161	0	1	1
162	0	1	1
163	0	2	2
164	0	20	20
165	0	35	35
166	0	24	24
167	0	6	6
168	0	6	6
169	0	2	2
170	0	10	10
171	0	2	2
172	0	4	4
173	0	20	20
174	0	1	1
175	0	2	2
176	0	5	5
177	0	5	5
178	0	8	8
179	0	15	15
180	0	2	2
181	0	15	15
182	0	15	15
183	0	2	2
184	0	10	10
185	0	3	3
186	0	5	5
187	0	6	6
188	0	5	5
189	0	2	2
190	0	2	2
191	0	2	2
192	0	1	1
193	0	3	3
194	0	4	4
195	0	2	2
196	0	5	5
197	0	4	4
198	0	20	20
199	0	2	2
200	0	4	4
201	0	7	7
202	0	4	4
203	0	1	1
204	0	6	6
205	0	20	20
206	0	10	10
207	0	1	1
208	0	1956	1956
209	0	2	2
210	0	2	2
211	0	2	2
212	0	13894	13894
213	0	1	1
214	0	12000	12000
215	0	470	470
216	0	86	86
217	0	15	15
218	0	30	30
219	0	128	128
220	0	721	721
221	0	102	102
222	0	362	362
223	0	100	100
224	0	54	54
225	0	5	5
226	0	52	52
227	0	20	20
228	0	12	12
229	0	260	260
230	0	50	50
231	0	20	20
232	0	20	20
233	0	120	120
234	0	10	10
235	0	20	20
236	0	20	20
237	0	2	2
238	0	2	2
239	0	2	2
240	0	2	2
241	0	2	2
242	0	5	5
243	0	2	2
244	0	4	4
245	0	20	20
246	0	10	10
247	0	5	5
248	0	5	5
249	0	55	55
250	0	10	10
251	0	12	12
252	0	1	1
253	0	10	10
254	0	2	2
255	0	24	24
256	0	2	2
257	0	10	10
258	0	20	20
259	0	40	40
260	0	6	6
261	0	2	2
262	0	8	8
263	0	4	4
264	0	79	79
265	0	2	2
266	0	6	6
267	0	32	32
268	0	26	26
269	0	46	46
270	0	29	29
271	0	5	5
272	0	754	754
273	0	713	713
274	0	23	23
275	0	86	86
276	0	10	10
277	0	14	14
278	0	1223	1223
279	0	240	240
280	0	214	214
281	0	700	700
282	0	1	1
283	0	1	1
284	0	317	317
285	0	73	73
286	0	15	15
287	0	33	33
288	0	2	2
289	0	2	2
290	0	46	46
291	0	76	76
292	0	288	288
293	0	21	21
294	0	31	31
295	0	13	13
296	0	9	9
297	0	39	39
298	0	17	17
299	0	2	2
300	0	740	740
301	0	350	350
302	0	2380	2380
303	0	320	320
304	0	1650	1650
305	0	15	15
306	0	6	6
307	0	4	4
308	0	96	96
309	0	6	6
310	0	49	49
311	0	145	145
312	0	72	72
313	0	94	94
314	0	4	4
315	0	5	5
316	0	5	5
317	0	24	24
318	0	1	1
319	0	1	1
320	0	8	8
321	0	4	4
322	0	4	4
323	0	116	116
324	0	12	12
325	0	12	12
326	0	1	1
327	0	5	5
328	0	22	22
329	0	20	20
330	0	4	4
331	0	5	5
332	0	2	2
333	0	14	14
334	0	66	66
335	0	122	122
336	0	331	331
337	0	50	50
338	0	113	113
339	0	115	115
340	0	112	112
341	0	5	5
342	0	74	74
343	0	4	4
344	0	3	3
345	0	1	1
346	0	1	1
347	0	1	1
348	0	16	16
349	0	12	12
350	0	2	2
351	0	4000	4000
352	0	17	17
353	0	18	18
354	0	30	30
355	0	32	32
356	0	8	8
357	0	7	7
358	0	65	65
359	0	482	482
360	0	7	7
361	0	250	250
362	0	305	305
363	0	286	286
364	0	2	2
365	0	2	2
366	0	6	6
367	0	1	1
368	0	1000	1000
369	0	5	5
370	0	5	5
371	0	10	10
372	0	13	13
373	0	34	34
374	0	1320	1320
375	0	20	20
376	0	30	30
377	0	11	11
378	0	5	5
379	0	16	16
380	0	2	2
381	0	1	1
382	0	6	6
383	0	6	6
384	0	1	1
385	0	2	2
386	0	20	20
387	0	13	13
388	0	1	1
389	0	1	1
390	0	250	250
391	0	40	40
392	0	40	40
393	0	80	80
394	0	100	100
395	0	150	150
396	0	40	40
397	0	100	100
398	0	80	80
399	0	150	150
400	0	300	300
401	0	80	80
402	0	300	300
403	0	80	80
404	0	6	6
405	0	300	300
406	0	250	250
407	0	100	100
408	0	100	100
409	0	300	300
410	0	40	40
411	0	80	80
412	0	4	4
413	0	4	4
414	0	4	4
415	0	2	2
416	0	1	1
417	0	20	20
418	0	6	6
419	0	6	6
420	0	20	20
421	0	10	10
422	0	1	1
423	0	2	2
424	0	2	2
425	0	6	6
426	0	6	6
427	0	6	6
428	0	6	6
429	0	2	2
430	0	7	7
431	0	7	7
432	0	4	4
433	0	12	12
434	0	2	2
435	0	1	1
436	0	2	2
437	0	5	5
438	0	2	2
439	0	10	10
440	0	4	4
441	0	6	6
442	0	3	3
443	0	2	2
444	0	2	2
445	0	2	2
446	0	7	7
447	0	20	20
448	0	2	2
449	0	2	2
450	0	5	5
451	0	30	30
452	0	1	1
453	0	4	4
454	0	40	40
455	0	2	2
456	0	5	5
457	0	5	5
458	0	20	20
459	0	40	40
460	0	8	8
461	0	1	1
462	0	1	1
463	0	15	15
464	0	10	10
465	0	20	20
466	0	6	6
467	0	10	10
468	0	2	2
469	0	150	150
470	0	150	150
471	0	60	60
472	0	2	2
473	0	2	2
474	0	3	3
475	0	1	1
476	0	1	1
477	0	10	10
478	0	3	3
479	0	19	19
480	0	2	2
481	0	2	2
482	0	2	2
483	0	1	1
484	0	150	150
485	0	150	150
486	0	5	5
487	0	2	2
488	0	3	3
489	0	10	10
490	0	3	3
491	0	2	2
492	0	2	2
493	0	2	2
494	0	14	14
495	0	200	200
496	0	1	1
497	0	1	1
498	0	1	1
499	0	1	1
500	0	15	15
501	0	11	11
502	0	55	55
503	0	12	12
504	0	6	6
505	0	6	6
506	0	6	6
507	0	6	6
508	0	100	100
509	0	658	658
510	0	2	2
511	0	6	6
512	0	1	1
513	0	1	1
514	0	4	4
515	0	20	20
516	0	4	4
517	0	10	10
518	0	1	1
519	0	4	4
520	0	2	2
521	0	1	1
522	0	2	2
523	0	1	1
524	0	2	2
525	0	2	2
526	0	1	1
527	0	12	12
528	0	5	5
529	0	2	2
530	0	1	1
531	0	1	1
532	0	36	36
533	0	48	48
534	0	4	4
535	0	5	5
536	0	1	1
537	0	2	2
538	0	5	5
539	0	30	30
540	0	4	4
541	0	2	2
542	0	4	4
543	0	10	10
544	0	4	4
545	0	10	10
546	0	10	10
547	0	20	20
548	0	3	3
549	0	5	5
550	0	1	1
551	0	2	2
552	0	2	2
553	0	1	1
554	0	1	1
555	0	5	5
556	0	5	5
557	0	1	1
558	0	2	2
559	0	2	2
560	0	2	2
561	0	10	10
562	0	8	8
563	0	4	4
564	0	4	4
565	0	4	4
566	0	1	1
567	0	46	46
568	0	1	1
569	0	1	1
570	0	20	20
571	0	20	20
572	0	4	4
573	0	150	150
574	0	300	300
575	0	100	100
576	0	40	40
577	0	100	100
578	0	20	20
579	0	100	100
580	0	200	200
581	0	100	100
582	0	200	200
583	0	5	5
584	0	3	3
585	0	6	6
586	0	4	4
587	0	4	4
588	0	4	4
589	0	2	2
590	0	6	6
591	0	4	4
592	0	70	70
593	0	50	50
594	0	2	2
595	0	3	3
596	0	15	15
597	0	1	1
598	0	1	1
599	0	5	5
600	0	2	2
601	0	10	10
602	0	2	2
603	0	10	10
604	0	2	2
605	0	3	3
606	0	2	2
607	0	5	5
608	0	1	1
609	0	4	4
610	0	4	4
611	0	2	2
612	0	4	4
613	0	2	2
614	0	2	2
615	0	5	5
616	0	10	10
617	0	2	2
618	0	2	2
619	0	2	2
620	0	8	8
621	0	20	20
622	0	50	50
623	0	30	30
624	0	10	10
625	0	1	1
626	0	10	10
627	0	10	10
628	0	20	20
629	0	1	1
630	0	1	1
631	0	2	2
632	0	1	1
633	0	1	1
634	0	1	1
635	0	50	50
636	0	5	5
637	0	5	5
638	0	10	10
639	0	10	10
640	0	1	1
641	0	3	3
642	0	12	12
643	0	12	12
644	0	28	28
645	0	6	6
646	0	2	2
647	0	18	18
648	0	18	18
649	0	24	24
650	0	12	12
651	0	11	11
652	0	4	4
653	0	6	6
654	0	3	3
655	0	5	5
656	0	4	4
658	0	10	10
\.


--
-- Data for Name: seller; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seller (id, code, prefix, name, business, address, phone, fax, mobile, is_active) FROM stdin;
1	st001	บริษัท	บริษัท ทดสอบ จำกัด						t
2	st002	ห้างหุ้นส่วนจำกัด	ห้างหุ้นส่วนจำกัด ทดสอบ						t
3	st003	บริษัท	บริษัท วัสดุการแพทย์ ก ไก่						t
\.


--
-- Data for Name: test_data; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.test_data (id, first_name, last_name, sex, birth, age) FROM stdin;
1	สมชาย	ใจดี	ชาย	1990-02-14	36
2	กมลชนก	ศรีสุข	หญิง	1992-07-03	33
3	ปกรณ์	จันทรา	ชาย	1988-11-21	37
4	ธิดารัตน์	มณีวงศ์	หญิง	1995-01-10	31
5	ชยพล	รุ่งเรือง	ชาย	1993-05-18	32
6	พิมพ์ชนก	อารีย์	หญิง	1991-09-27	34
7	จิรายุ	วงษ์ทอง	ชาย	1987-12-05	38
8	ศศิธร	วัฒนกูล	หญิง	1994-04-08	31
9	วรพงษ์	เกษมสุข	ชาย	1996-08-15	29
10	อาทิตยา	จำรูญ	หญิง	1990-10-30	35
\.


--
-- Data for Name: usage_plan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usage_plan (id, product_code, requested_amount, approved_quota, budget_year, sequence_no, created_at, updated_at, requesting_dept_code, purchase_plan_id, plan_flag) FROM stdin;
1233	P230-001233	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0002	\N	ในแผน
1234	P230-001234	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0002	\N	ในแผน
21	P230-000021	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
3347	P230-000003	5	0	2569	2	2026-03-10 23:11:27.301158	2026-03-10 23:11:27.301158	0001	\N	ในแผน
3345	P230-000008	1	1	2569	2	2026-03-10 22:18:13.799425	2026-03-27 07:19:29.144057	0001	7	ในแผน
22	P230-000022	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
24	P230-000024	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
28	P230-000028	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
29	P230-000029	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
30	P230-000030	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
31	P230-000031	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
32	P230-000032	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
33	P230-000033	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
3392	P230-000844	10	10	2569	1	2026-03-27 08:23:21.904804	2026-03-27 08:23:21.904804	0001	658	นอกแผน
39	P230-000039	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
43	P230-000043	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
45	P230-000045	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
23	P230-000023	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	18	ในแผน
25	P230-000025	22	22	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	19	ในแผน
50	P230-000050	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
52	P230-000052	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
53	P230-000053	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
54	P230-000054	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
55	P230-000055	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
70	P230-000070	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
72	P230-000072	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
74	P230-000074	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
3356	AUTO-DUP-1773189065718	1	0	2569	1	2026-03-11 07:31:05.776726	2026-03-11 07:31:05.776726	0013	\N	ในแผน
78	P230-000078	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
81	P230-000081	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
83	P230-000083	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
84	P230-000084	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
91	P230-000091	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
59	P230-000059	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	39	ในแผน
60	P230-000060	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	40	ในแผน
3357	AUTO-DUP-1773189065718	1	0	2569	2	2026-03-11 07:31:05.812981	2026-03-11 07:31:05.812981	0013	\N	ในแผน
97	P230-000097	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
102	P230-000102	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
105	P230-000105	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
110	P230-000110	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
61	P230-000061	15	15	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	41	ในแผน
117	P230-000117	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
118	P230-000118	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
120	P230-000120	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
126	P230-000126	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
130	P230-000130	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
136	P230-000136	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
142	P230-000142	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
146	P230-000146	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
147	P230-000147	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
62	P230-000062	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	42	ในแผน
160	P230-000160	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
162	P230-000162	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
163	P230-000163	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
166	P230-000166	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
167	P230-000167	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
169	P230-000169	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
385	P230-000385	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
182	P230-000182	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
185	P230-000185	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
186	P230-000186	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
187	P230-000187	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
189	P230-000189	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
190	P230-000190	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
63	P230-000063	819	819	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	43	ในแผน
64	P230-000064	4722	4722	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	44	ในแผน
65	P230-000065	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	45	ในแผน
192	P230-000192	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
194	P230-000194	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
196	P230-000196	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
198	P230-000198	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
199	P230-000199	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
200	P230-000200	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
201	P230-000201	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
202	P230-000202	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
204	P230-000204	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
205	P230-000205	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
212	P230-000212	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
213	P230-000213	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
214	P230-000214	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
215	P230-000215	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
216	P230-000216	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
218	P230-000218	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
219	P230-000219	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
222	P230-000222	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
224	P230-000224	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
225	P230-000225	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
229	P230-000229	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
232	P230-000232	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
234	P230-000234	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
235	P230-000235	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
236	P230-000236	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
238	P230-000238	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
239	P230-000239	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
240	P230-000240	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
250	P230-000250	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
252	P230-000252	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
253	P230-000253	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
256	P230-000256	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
257	P230-000257	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
258	P230-000258	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
259	P230-000259	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
260	P230-000260	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
271	P230-000271	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
273	P230-000273	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
276	P230-000276	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
278	P230-000278	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
279	P230-000279	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
280	P230-000280	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
360	P230-000360	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
284	P230-000284	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
285	P230-000285	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
287	P230-000287	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
289	P230-000289	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
292	P230-000292	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
293	P230-000293	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
294	P230-000294	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
295	P230-000295	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
296	P230-000296	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
297	P230-000297	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
298	P230-000298	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
301	P230-000301	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
302	P230-000302	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
303	P230-000303	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
305	P230-000305	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
306	P230-000306	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
307	P230-000307	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
309	P230-000309	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
311	P230-000311	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
313	P230-000313	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
314	P230-000314	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
66	P230-000066	50	50	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	46	ในแผน
67	P230-000067	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	47	ในแผน
315	P230-000315	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
316	P230-000316	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
317	P230-000317	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
318	P230-000318	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
319	P230-000319	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
323	P230-000323	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
328	P230-000328	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
329	P230-000329	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
331	P230-000331	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
332	P230-000332	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
333	P230-000333	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
339	P230-000339	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
345	P230-000345	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
346	P230-000346	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
68	P230-000068	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	48	ในแผน
69	P230-000069	375	375	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	49	ในแผน
362	P230-000362	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
366	P230-000366	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
367	P230-000367	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
376	P230-000376	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
381	P230-000381	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
388	P230-000388	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
390	P230-000390	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
392	P230-000392	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
393	P230-000393	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
395	P230-000395	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
397	P230-000397	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
398	P230-000398	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
400	P230-000400	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
401	P230-000401	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
405	P230-000405	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
406	P230-000406	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
410	P230-000410	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
411	P230-000411	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
412	P230-000412	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
413	P230-000413	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
414	P230-000414	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
415	P230-000415	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
416	P230-000416	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
417	P230-000417	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
418	P230-000418	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
419	P230-000419	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
420	P230-000420	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
71	P230-000071	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	50	ในแผน
73	P230-000073	10000	10000	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	51	ในแผน
436	P230-000436	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
441	P230-000441	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
442	P230-000442	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
444	P230-000444	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
445	P230-000445	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
448	P230-000448	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
452	P230-000452	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
75	P230-000075	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	52	ในแผน
3366	P230-000075	5	5	2569	2	2026-03-11 13:55:53.760851	2026-03-27 07:19:29.144057	0001	52	ในแผน
76	P230-000076	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	53	ในแผน
3348	P230-000596	50	0	2569	1	2026-03-10 23:23:05.926782	2026-03-10 23:23:05.926782	0011	\N	ในแผน
473	P230-000473	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
79	P230-000079	90	90	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	54	ในแผน
80	P230-000080	165	165	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	55	ในแผน
82	P230-000082	480	480	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	56	ในแผน
481	P230-000481	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
490	P230-000490	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
491	P230-000491	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
493	P230-000493	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
494	P230-000494	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
495	P230-000495	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
496	P230-000496	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
85	P230-000085	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	57	ในแผน
3372	P230-000085	2	2	2569	2	2026-03-12 21:23:16.300536	2026-03-27 07:19:29.144057	0001	57	ในแผน
86	P230-000086	16	16	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	58	ในแผน
497	P230-000497	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
498	P230-000498	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
499	P230-000499	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
501	P230-000501	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
504	P230-000504	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
505	P230-000505	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
508	P230-000508	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
509	P230-000509	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
87	P230-000087	555	555	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	59	ในแผน
88	P230-000088	674	674	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	60	ในแผน
523	P230-000523	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
533	P230-000533	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
534	P230-000534	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
535	P230-000535	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
536	P230-000536	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
89	P230-000089	1587	1587	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	61	ในแผน
90	P230-000090	671	671	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	62	ในแผน
92	P230-000092	1094	1094	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	63	ในแผน
542	P230-000542	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
549	P230-000549	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
553	P230-000553	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
554	P230-000554	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
555	P230-000555	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
556	P230-000556	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
557	P230-000557	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
558	P230-000558	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
560	P230-000560	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
561	P230-000561	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
562	P230-000562	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
564	P230-000564	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
566	P230-000566	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
571	P230-000571	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
582	P230-000582	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
93	P230-000093	239	239	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	64	ในแผน
94	P230-000094	444	444	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	65	ในแผน
95	P230-000095	1005	1005	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	66	ในแผน
583	P230-000583	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
584	P230-000584	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
586	P230-000586	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
589	P230-000589	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
591	P230-000591	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
592	P230-000592	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
593	P230-000593	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
594	P230-000594	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
596	P230-000596	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
598	P230-000598	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
599	P230-000599	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
601	P230-000601	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
602	P230-000602	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
603	P230-000603	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
96	P230-000096	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	67	ในแผน
98	P230-000098	193	193	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	68	ในแผน
604	P230-000604	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
605	P230-000605	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
606	P230-000606	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
607	P230-000607	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
609	P230-000609	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
610	P230-000610	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
611	P230-000611	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
612	P230-000612	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
613	P230-000613	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
614	P230-000614	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
615	P230-000615	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
617	P230-000617	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
618	P230-000618	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
99	P230-000099	67	67	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	69	ในแผน
621	P230-000621	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
622	P230-000622	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
624	P230-000624	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
625	P230-000625	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
626	P230-000626	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
629	P230-000629	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
632	P230-000632	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
633	P230-000633	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
634	P230-000634	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
635	P230-000635	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
774	P230-000774	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
100	P230-000100	85	85	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	70	ในแผน
637	P230-000637	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
639	P230-000639	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
707	P230-000707	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
643	P230-000643	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
101	P230-000101	150	150	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	71	ในแผน
3379	P230-000102	5	5	2569	1	2026-03-14 08:03:04.888915	2026-03-27 07:19:29.144057	0016	72	ในแผน
103	P230-000103	14	14	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	73	ในแผน
649	P230-000649	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
650	P230-000650	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
652	P230-000652	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
653	P230-000653	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
654	P230-000654	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
655	P230-000655	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
656	P230-000656	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
657	P230-000657	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
658	P230-000658	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
660	P230-000660	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
661	P230-000661	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
662	P230-000662	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
776	P230-000776	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
3344	P230-000103	11	11	2569	1	2026-03-10 09:21:19.507184	2026-03-27 07:19:29.144057	0002	73	ในแผน
3368	P230-000103	10	10	2569	2	2026-03-11 13:57:00.587993	2026-03-27 07:19:29.144057	0001	73	ในแผน
104	P230-000104	30	30	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	74	ในแผน
3374	P230-000104	10	10	2569	1	2026-03-12 23:21:01.111498	2026-03-27 07:19:29.144057	0011	74	ในแผน
3375	P230-000104	10	10	2569	2	2026-03-12 23:21:01.141327	2026-03-27 07:19:29.144057	0011	74	ในแผน
663	P230-000663	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
664	P230-000664	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
665	P230-000665	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
666	P230-000666	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
667	P230-000667	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
668	P230-000668	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
669	P230-000669	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
670	P230-000670	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
744	P230-000744	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
671	P230-000671	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
672	P230-000672	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
673	P230-000673	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
674	P230-000674	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
708	P230-000708	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
106	P230-000106	47	47	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	75	ในแผน
3343	P230-000106	20	10	2569	1	2026-03-10 09:21:19.507182	2026-03-27 07:19:29.144057	0002	75	ในแผน
715	P230-000715	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
716	P230-000716	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
717	P230-000717	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
718	P230-000718	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
775	P230-000775	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
722	P230-000722	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
723	P230-000723	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
724	P230-000724	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
726	P230-000726	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
727	P230-000727	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
709	P230-000709	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	423	ในแผน
710	P230-000710	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	424	ในแผน
711	P230-000711	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	425	ในแผน
728	P230-000728	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
729	P230-000729	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
730	P230-000730	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
732	P230-000732	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
734	P230-000734	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
738	P230-000738	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
739	P230-000739	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
740	P230-000740	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
742	P230-000742	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
745	P230-000745	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
746	P230-000746	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
747	P230-000747	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
748	P230-000748	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
750	P230-000750	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
751	P230-000751	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
753	P230-000753	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
755	P230-000755	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
756	P230-000756	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
757	P230-000757	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
758	P230-000758	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
759	P230-000759	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
760	P230-000760	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
761	P230-000761	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
762	P230-000762	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
763	P230-000763	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
764	P230-000764	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
765	P230-000765	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
766	P230-000766	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
767	P230-000767	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
771	P230-000771	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
772	P230-000772	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
780	P230-000780	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
785	P230-000785	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
786	P230-000786	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
787	P230-000787	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
791	P230-000791	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
792	P230-000792	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
795	P230-000795	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
796	P230-000796	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
798	P230-000798	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
803	P230-000803	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
804	P230-000804	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
805	P230-000805	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
806	P230-000806	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
809	P230-000809	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
810	P230-000810	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
811	P230-000811	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
812	P230-000812	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
813	P230-000813	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
814	P230-000814	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
817	P230-000817	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
819	P230-000819	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
107	P230-000107	61	61	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	76	ในแผน
108	P230-000108	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	77	ในแผน
821	P230-000821	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
824	P230-000824	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
825	P230-000825	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
826	P230-000826	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
827	P230-000827	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
828	P230-000828	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
829	P230-000829	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
830	P230-000830	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
831	P230-000831	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
832	P230-000832	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
833	P230-000833	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
835	P230-000835	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
836	P230-000836	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
837	P230-000837	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
838	P230-000838	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
840	P230-000840	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
841	P230-000841	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
842	P230-000842	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
843	P230-000843	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
848	P230-000848	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
849	P230-000849	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
851	P230-000851	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
852	P230-000852	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
853	P230-000853	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
856	P230-000856	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
857	P230-000857	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
858	P230-000858	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
860	P230-000860	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
3384	P230-000104	3	2	2569	1	2026-03-22 08:12:43.234548	2026-03-27 07:19:29.144057	0002	74	ในแผน
862	P230-000862	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
863	P230-000863	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
864	P230-000864	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
865	P230-000865	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
866	P230-000866	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
869	P230-000869	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
870	P230-000870	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
871	P230-000871	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
872	P230-000872	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
873	P230-000873	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
874	P230-000874	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
875	P230-000875	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
876	P230-000876	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
877	P230-000877	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
881	P230-000881	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
882	P230-000882	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
885	P230-000885	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
886	P230-000886	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
887	P230-000887	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
889	P230-000889	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
890	P230-000890	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
891	P230-000891	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
896	P230-000896	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
898	P230-000898	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
899	P230-000899	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
900	P230-000900	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
901	P230-000901	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
902	P230-000902	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
903	P230-000903	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
905	P230-000905	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
908	P230-000908	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
909	P230-000909	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
910	P230-000910	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
911	P230-000911	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
913	P230-000913	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
914	P230-000914	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
915	P230-000915	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
916	P230-000916	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
917	P230-000917	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
918	P230-000918	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
919	P230-000919	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
920	P230-000920	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
921	P230-000921	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
922	P230-000922	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
3367	P230-000108	5	5	2569	2	2026-03-11 13:56:23.966474	2026-03-27 07:19:29.144057	0001	77	ในแผน
923	P230-000923	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
924	P230-000924	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
925	P230-000925	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
926	P230-000926	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
927	P230-000927	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
928	P230-000928	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
929	P230-000929	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
930	P230-000930	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
931	P230-000931	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
932	P230-000932	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
933	P230-000933	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
934	P230-000934	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
940	P230-000940	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
941	P230-000941	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
942	P230-000942	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
943	P230-000943	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
944	P230-000944	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
945	P230-000945	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
950	P230-000950	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
951	P230-000951	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
953	P230-000953	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
954	P230-000954	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
955	P230-000955	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
956	P230-000956	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
957	P230-000957	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
958	P230-000958	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
959	P230-000959	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
961	P230-000961	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
962	P230-000962	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
964	P230-000964	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
965	P230-000965	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
966	P230-000966	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
967	P230-000967	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
968	P230-000968	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
969	P230-000969	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
970	P230-000970	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
971	P230-000971	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
972	P230-000972	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
973	P230-000973	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
974	P230-000974	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
975	P230-000975	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
976	P230-000976	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
977	P230-000977	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
978	P230-000978	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
979	P230-000979	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
980	P230-000980	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
981	P230-000981	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
982	P230-000982	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
983	P230-000983	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
985	P230-000985	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
986	P230-000986	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
3383	P230-000120	20	2	2569	1	2026-03-22 08:12:43.219484	2026-03-27 07:19:29.144057	0002	86	ในแผน
988	P230-000988	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
989	P230-000989	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
991	P230-000991	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
993	P230-000993	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
994	P230-000994	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
995	P230-000995	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
996	P230-000996	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
997	P230-000997	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
998	P230-000998	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
999	P230-000999	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1000	P230-001000	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1001	P230-001001	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1002	P230-001002	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1003	P230-001003	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1004	P230-001004	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1005	P230-001005	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1006	P230-001006	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1007	P230-001007	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1008	P230-001008	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
109	P230-000109	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	78	ในแผน
1010	P230-001010	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1011	P230-001011	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1012	P230-001012	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1013	P230-001013	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1014	P230-001014	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1015	P230-001015	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1016	P230-001016	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1017	P230-001017	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1018	P230-001018	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1019	P230-001019	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1020	P230-001020	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1022	P230-001022	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1023	P230-001023	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1025	P230-001025	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1026	P230-001026	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1027	P230-001027	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1028	P230-001028	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1029	P230-001029	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1030	P230-001030	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1032	P230-001032	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1033	P230-001033	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1034	P230-001034	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1035	P230-001035	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1036	P230-001036	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1037	P230-001037	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1038	P230-001038	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1039	P230-001039	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1040	P230-001040	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1041	P230-001041	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1043	P230-001043	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1044	P230-001044	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1045	P230-001045	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1046	P230-001046	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1047	P230-001047	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1053	P230-001053	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1054	P230-001054	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1056	P230-001056	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1058	P230-001058	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1061	P230-001061	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1062	P230-001062	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1063	P230-001063	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1064	P230-001064	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1065	P230-001065	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1068	P230-001068	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1069	P230-001069	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1070	P230-001070	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1071	P230-001071	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1072	P230-001072	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1073	P230-001073	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1074	P230-001074	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1075	P230-001075	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1076	P230-001076	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1078	P230-001078	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1079	P230-001079	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1080	P230-001080	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1129	P230-001129	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1081	P230-001081	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1082	P230-001082	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1085	P230-001085	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1086	P230-001086	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1087	P230-001087	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1088	P230-001088	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1090	P230-001090	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1091	P230-001091	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1092	P230-001092	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1095	P230-001095	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1096	P230-001096	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1097	P230-001097	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1098	P230-001098	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1099	P230-001099	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1100	P230-001100	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1101	P230-001101	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1103	P230-001103	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1104	P230-001104	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1105	P230-001105	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1107	P230-001107	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1108	P230-001108	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1109	P230-001109	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1110	P230-001110	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1111	P230-001111	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
111	P230-000111	356	356	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	79	ในแผน
1115	P230-001115	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1116	P230-001116	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1117	P230-001117	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1118	P230-001118	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1119	P230-001119	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1120	P230-001120	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1121	P230-001121	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1122	P230-001122	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1123	P230-001123	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1124	P230-001124	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1125	P230-001125	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1127	P230-001127	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1131	P230-001131	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1138	P230-001138	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1142	P230-001142	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1197	P230-001197	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1144	P230-001144	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1145	P230-001145	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1146	P230-001146	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1147	P230-001147	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1148	P230-001148	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1149	P230-001149	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1150	P230-001150	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1151	P230-001151	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1152	P230-001152	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1153	P230-001153	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1154	P230-001154	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1155	P230-001155	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1161	P230-001161	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1162	P230-001162	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1163	P230-001163	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1164	P230-001164	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1165	P230-001165	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1166	P230-001166	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1167	P230-001167	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1168	P230-001168	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1169	P230-001169	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1170	P230-001170	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1171	P230-001171	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1172	P230-001172	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1173	P230-001173	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1174	P230-001174	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1175	P230-001175	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1176	P230-001176	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
3377	P230-000001	2	2	2569	1	2026-03-14 08:02:35.282831	2026-03-27 07:19:29.144057	0011	1	ในแผน
3380	P230-000001	3	3	2569	1	2026-03-14 08:03:24.086509	2026-03-27 07:19:29.144057	0015	1	ในแผน
1177	P230-001177	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1180	P230-001180	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1182	P230-001182	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1183	P230-001183	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1184	P230-001184	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1185	P230-001185	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1191	P230-001191	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1192	P230-001192	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1193	P230-001193	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1194	P230-001194	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1195	P230-001195	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1196	P230-001196	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
3360	P230-000001	1	1	2569	2	2026-03-11 07:48:27.395608	2026-03-27 07:19:29.144057	0001	1	ในแผน
3387	P230-000001	10	8	2569	1	2026-03-27 06:13:05.750944	2026-03-27 07:19:29.144057	0002	1	ในแผน
1200	P230-001200	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1201	P230-001201	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1203	P230-001203	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
702	P230-000702	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0010	\N	ในแผน
703	P230-000703	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0010	\N	ในแผน
704	P230-000704	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0010	\N	ในแผน
705	P230-000705	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0010	\N	ในแผน
9	P230-000009	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
10	P230-000010	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1204	P230-001204	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1207	P230-001207	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1208	P230-001208	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1209	P230-001209	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
3361	P230-000002	1	1	2569	2	2026-03-11 07:48:27.402221	2026-03-27 07:19:29.144057	0001	2	ในแผน
4	P230-000004	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	4	ในแผน
3364	P230-000012	1	1	2569	2	2026-03-11 07:49:43.428032	2026-03-27 07:19:29.144057	0001	9	ในแผน
1210	P230-001210	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1211	P230-001211	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1212	P230-001212	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1216	P230-001216	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1218	P230-001218	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1219	P230-001219	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1225	P230-001225	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
14	P230-000014	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	11	ในแผน
1303	P230-001303	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1230	P230-001230	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
15	P230-000015	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	12	ในแผน
2	P230-000002	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1	P230-000001	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	1	ในแผน
3	P230-000003	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	3	ในแผน
1290	P230-001290	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1295	P230-001295	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1296	P230-001296	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1297	P230-001297	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
16	P230-000016	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	13	ในแผน
1298	P230-001298	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
11	P230-000011	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
34	P230-000034	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
56	P230-000056	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
77	P230-000077	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
145	P230-000145	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
3358	P230-001329	1	0	2569	1	2026-03-11 07:33:19.065882	2026-03-12 23:43:01.013603	0011	\N	ในแผน
3370	P230-000002	1	1	2569	1	2026-03-11 21:34:43.775513	2026-03-27 07:19:29.144057	0027	2	ในแผน
3369	P230-000003	1	1	2569	1	2026-03-11 21:34:43.767598	2026-03-27 07:19:29.144057	0014	3	ในแผน
12	P230-000012	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	9	ในแผน
13	P230-000013	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	10	ในแผน
17	P230-000017	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	14	ในแผน
18	P230-000018	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	15	ในแผน
1136	P230-001136	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
990	P230-000990	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1031	P230-001031	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1243	P230-001243	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0018	\N	ในแผน
1299	P230-001299	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1300	P230-001300	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1301	P230-001301	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1302	P230-001302	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1304	P230-001304	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1305	P230-001305	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1310	P230-001310	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1311	P230-001311	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1312	P230-001312	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1313	P230-001313	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
19	P230-000019	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	16	ในแผน
20	P230-000020	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	17	ในแผน
3388	P230-000028	10	9	2569	1	2026-03-27 06:13:05.760817	2026-03-27 07:19:29.144057	0002	22	ในแผน
1328	P230-001328	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
685	P230-000685	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0013	\N	ในแผน
686	P230-000686	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0013	\N	ในแผน
688	P230-000688	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0013	\N	ในแผน
689	P230-000689	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0013	\N	ในแผน
690	P230-000690	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0016	\N	ในแผน
691	P230-000691	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0016	\N	ในแผน
692	P230-000692	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0016	\N	ในแผน
693	P230-000693	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0016	\N	ในแผน
35	P230-000035	13	13	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	23	ในแผน
36	P230-000036	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	24	ในแผน
37	P230-000037	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	25	ในแผน
694	P230-000694	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0016	\N	ในแผน
680	P230-000680	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0017	\N	ในแผน
682	P230-000682	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0017	\N	ในแผน
683	P230-000683	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0017	\N	ในแผน
684	P230-000684	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0017	\N	ในแผน
695	P230-000695	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0008	\N	ในแผน
696	P230-000696	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0008	\N	ในแผน
676	P230-000676	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0015	\N	ในแผน
677	P230-000677	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0015	\N	ในแผน
1240	P230-001240	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0018	\N	ในแผน
38	P230-000038	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	26	ในแผน
1242	P230-001242	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0018	\N	ในแผน
1244	P230-001244	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0018	\N	ในแผน
735	P230-000735	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
7	P230-000007	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
8	P230-000008	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1206	P230-001206	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1306	P230-001306	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1307	P230-001307	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
1308	P230-001308	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
5	P230-000005	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	5	ในแผน
6	P230-000006	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	6	ในแผน
26	P230-000026	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	20	ในแผน
27	P230-000027	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	21	ในแผน
1309	P230-001309	0	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001	\N	ในแผน
3349	P230-000063	50	10	2569	1	2026-03-11 00:29:45.838887	2026-03-27 07:19:29.144057	0003	43	ในแผน
3378	P230-000085	2	2	2569	1	2026-03-14 08:02:50.332027	2026-03-27 07:19:29.144057	0004	57	ในแผน
3381	P230-000343	20	20	2569	2	2026-03-15 10:33:23.65314	2026-03-27 07:19:29.144057	0001	216	ในแผน
3382	P230-000432	10	10	2569	2	2026-03-15 10:53:41.191553	2026-03-27 07:19:29.144057	0001	274	ในแผน
1329	P230-001329	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	656	ในแผน
3376	P230-000011	\N	10	2569	2	2026-03-14 08:01:55.905645	2026-03-27 07:19:29.144057	0001	8	ในแผน
40	P230-000040	90	90	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	27	ในแผน
41	P230-000041	30	30	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	28	ในแผน
42	P230-000042	34	34	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	29	ในแผน
44	P230-000044	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	30	ในแผน
46	P230-000046	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	31	ในแผน
47	P230-000047	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	32	ในแผน
48	P230-000048	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	33	ในแผน
49	P230-000049	144	144	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	34	ในแผน
51	P230-000051	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	35	ในแผน
3342	P230-000053	10	5	2569	2	2026-03-10 09:21:19.502329	2026-03-27 07:19:29.144057	0001	36	ในแผน
57	P230-000057	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	37	ในแผน
58	P230-000058	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	38	ในแผน
112	P230-000112	50	50	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	80	ในแผน
113	P230-000113	989	989	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	81	ในแผน
114	P230-000114	662	662	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	82	ในแผน
115	P230-000115	26	26	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	83	ในแผน
116	P230-000116	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	84	ในแผน
3386	P230-000116	3	3	2569	2	2026-03-22 08:46:13.457795	2026-03-27 07:19:29.144057	0001	84	ในแผน
119	P230-000119	14	14	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	85	ในแผน
121	P230-000121	72	72	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	87	ในแผน
122	P230-000122	42	42	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	88	ในแผน
123	P230-000123	346	346	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	89	ในแผน
124	P230-000124	144	144	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	90	ในแผน
125	P230-000125	184	184	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	91	ในแผน
127	P230-000127	77	77	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	92	ในแผน
128	P230-000128	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	93	ในแผน
129	P230-000129	40	40	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	94	ในแผน
131	P230-000131	32	32	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	95	ในแผน
132	P230-000132	58	58	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	96	ในแผน
133	P230-000133	72	72	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	97	ในแผน
134	P230-000134	14	14	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	98	ในแผน
135	P230-000135	921	921	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	99	ในแผน
137	P230-000137	41	41	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	100	ในแผน
138	P230-000138	83	83	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	101	ในแผน
139	P230-000139	24	24	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	102	ในแผน
140	P230-000140	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	103	ในแผน
141	P230-000141	50	50	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	104	ในแผน
143	P230-000143	269	269	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	105	ในแผน
144	P230-000144	72	72	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	106	ในแผน
148	P230-000148	114	114	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	107	ในแผน
149	P230-000149	16	16	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	108	ในแผน
150	P230-000150	16	16	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	109	ในแผน
151	P230-000151	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	110	ในแผน
152	P230-000152	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	111	ในแผน
153	P230-000153	17	17	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	112	ในแผน
154	P230-000154	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	113	ในแผน
155	P230-000155	17	17	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	114	ในแผน
156	P230-000156	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	115	ในแผน
157	P230-000157	52	52	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	116	ในแผน
3389	P230-000157	10	8	2569	1	2026-03-27 06:13:05.766343	2026-03-27 07:19:29.144057	0002	116	ในแผน
3390	P230-000157	20	18	2569	1	2026-03-27 06:22:07.16578	2026-03-27 07:19:29.144057	0007	116	ในแผน
158	P230-000158	55	55	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	117	ในแผน
159	P230-000159	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	118	ในแผน
161	P230-000161	13	13	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	119	ในแผน
164	P230-000164	27	27	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	120	ในแผน
165	P230-000165	31	31	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	121	ในแผน
168	P230-000168	14	14	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	122	ในแผน
170	P230-000170	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	123	ในแผน
171	P230-000171	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	124	ในแผน
172	P230-000172	1244	1244	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	125	ในแผน
173	P230-000173	286	286	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	126	ในแผน
174	P230-000174	100	100	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	127	ในแผน
175	P230-000175	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	128	ในแผน
176	P230-000176	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	129	ในแผน
177	P230-000177	57	57	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	130	ในแผน
178	P230-000178	180	180	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	131	ในแผน
179	P230-000179	60	60	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	132	ในแผน
180	P230-000180	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	133	ในแผน
181	P230-000181	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	134	ในแผน
183	P230-000183	56	56	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	135	ในแผน
184	P230-000184	66	66	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	136	ในแผน
188	P230-000188	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	137	ในแผน
3346	P230-000188	5	5	2569	1	2026-03-10 22:50:24.089795	2026-03-27 07:19:29.144057	0011	137	ในแผน
191	P230-000191	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	138	ในแผน
193	P230-000193	100	100	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	139	ในแผน
195	P230-000195	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	140	ในแผน
197	P230-000197	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	141	ในแผน
203	P230-000203	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	142	ในแผน
206	P230-000206	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	143	ในแผน
207	P230-000207	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	144	ในแผน
208	P230-000208	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	145	ในแผน
209	P230-000209	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	146	ในแผน
210	P230-000210	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	147	ในแผน
211	P230-000211	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	148	ในแผน
217	P230-000217	16	16	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	149	ในแผน
220	P230-000220	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	150	ในแผน
221	P230-000221	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	151	ในแผน
223	P230-000223	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	152	ในแผน
226	P230-000226	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	153	ในแผน
227	P230-000227	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	154	ในแผน
228	P230-000228	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	155	ในแผน
230	P230-000230	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	156	ในแผน
231	P230-000231	40	40	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	157	ในแผน
233	P230-000233	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	158	ในแผน
237	P230-000237	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	159	ในแผน
241	P230-000241	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	160	ในแผน
242	P230-000242	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	161	ในแผน
243	P230-000243	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	162	ในแผน
244	P230-000244	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	163	ในแผน
245	P230-000245	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	164	ในแผน
246	P230-000246	35	35	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	165	ในแผน
247	P230-000247	24	24	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	166	ในแผน
248	P230-000248	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	167	ในแผน
249	P230-000249	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	168	ในแผน
251	P230-000251	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	169	ในแผน
3352	P230-000252	10	10	2569	1	2026-03-11 00:39:07.086046	2026-03-27 07:19:29.144057	0010	170	ในแผน
254	P230-000254	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	171	ในแผน
255	P230-000255	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	172	ในแผน
261	P230-000261	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	173	ในแผน
262	P230-000262	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	174	ในแผน
263	P230-000263	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	175	ในแผน
264	P230-000264	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	176	ในแผน
265	P230-000265	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	177	ในแผน
266	P230-000266	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	178	ในแผน
267	P230-000267	15	15	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	179	ในแผน
268	P230-000268	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	180	ในแผน
269	P230-000269	15	15	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	181	ในแผน
270	P230-000270	15	15	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	182	ในแผน
272	P230-000272	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	183	ในแผน
274	P230-000274	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	184	ในแผน
275	P230-000275	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	185	ในแผน
277	P230-000277	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	186	ในแผน
281	P230-000281	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	187	ในแผน
282	P230-000282	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	188	ในแผน
283	P230-000283	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	189	ในแผน
286	P230-000286	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	190	ในแผน
288	P230-000288	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	191	ในแผน
290	P230-000290	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	192	ในแผน
291	P230-000291	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	193	ในแผน
299	P230-000299	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	194	ในแผน
300	P230-000300	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	195	ในแผน
304	P230-000304	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	196	ในแผน
308	P230-000308	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	197	ในแผน
310	P230-000310	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	198	ในแผน
312	P230-000312	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	199	ในแผน
320	P230-000320	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	200	ในแผน
321	P230-000321	7	7	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	201	ในแผน
322	P230-000322	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	202	ในแผน
324	P230-000324	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	203	ในแผน
325	P230-000325	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	204	ในแผน
326	P230-000326	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	205	ในแผน
327	P230-000327	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	206	ในแผน
330	P230-000330	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	207	ในแผน
334	P230-000334	1956	1956	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	208	ในแผน
335	P230-000335	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	209	ในแผน
336	P230-000336	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	210	ในแผน
337	P230-000337	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	211	ในแผน
338	P230-000338	13894	13894	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	212	ในแผน
340	P230-000340	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	213	ในแผน
341	P230-000341	12000	12000	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	214	ในแผน
342	P230-000342	470	470	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	215	ในแผน
343	P230-000343	56	56	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	216	ในแผน
3351	P230-000343	10	10	2569	1	2026-03-11 00:38:52.950089	2026-03-27 07:19:29.144057	0002	216	ในแผน
344	P230-000344	15	15	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	217	ในแผน
347	P230-000347	30	30	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	218	ในแผน
348	P230-000348	128	128	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	219	ในแผน
349	P230-000349	721	721	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	220	ในแผน
350	P230-000350	102	102	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	221	ในแผน
351	P230-000351	362	362	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	222	ในแผน
352	P230-000352	100	100	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	223	ในแผน
353	P230-000353	54	54	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	224	ในแผน
354	P230-000354	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	225	ในแผน
355	P230-000355	52	52	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	226	ในแผน
356	P230-000356	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	227	ในแผน
357	P230-000357	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	228	ในแผน
358	P230-000358	260	260	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	229	ในแผน
359	P230-000359	50	50	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	230	ในแผน
361	P230-000361	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	231	ในแผน
363	P230-000363	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	232	ในแผน
364	P230-000364	120	120	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	233	ในแผน
365	P230-000365	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	234	ในแผน
368	P230-000368	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	235	ในแผน
369	P230-000369	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	236	ในแผน
370	P230-000370	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	237	ในแผน
371	P230-000371	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	238	ในแผน
372	P230-000372	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	239	ในแผน
373	P230-000373	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	240	ในแผน
374	P230-000374	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	241	ในแผน
375	P230-000375	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	242	ในแผน
377	P230-000377	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	243	ในแผน
378	P230-000378	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	244	ในแผน
379	P230-000379	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	245	ในแผน
380	P230-000380	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	246	ในแผน
382	P230-000382	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	247	ในแผน
383	P230-000383	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	248	ในแผน
384	P230-000384	55	55	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	249	ในแผน
386	P230-000386	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	250	ในแผน
387	P230-000387	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	251	ในแผน
389	P230-000389	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	252	ในแผน
391	P230-000391	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	253	ในแผน
394	P230-000394	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	254	ในแผน
396	P230-000396	24	24	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	255	ในแผน
399	P230-000399	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	256	ในแผน
402	P230-000402	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	257	ในแผน
403	P230-000403	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	258	ในแผน
404	P230-000404	40	40	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	259	ในแผน
407	P230-000407	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	260	ในแผน
408	P230-000408	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	261	ในแผน
409	P230-000409	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	262	ในแผน
421	P230-000421	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	263	ในแผน
422	P230-000422	79	79	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	264	ในแผน
423	P230-000423	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	265	ในแผน
424	P230-000424	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	266	ในแผน
425	P230-000425	32	32	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	267	ในแผน
426	P230-000426	26	26	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	268	ในแผน
427	P230-000427	25	25	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	269	ในแผน
3385	P230-000427	30	21	2569	2	2026-03-22 08:46:13.451601	2026-03-27 07:19:29.144057	0001	269	ในแผน
428	P230-000428	29	29	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	270	ในแผน
429	P230-000429	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	271	ในแผน
430	P230-000430	754	754	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	272	ในแผน
431	P230-000431	713	713	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	273	ในแผน
432	P230-000432	13	13	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	274	ในแผน
433	P230-000433	86	86	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	275	ในแผน
434	P230-000434	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	276	ในแผน
435	P230-000435	14	14	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	277	ในแผน
437	P230-000437	1223	1223	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	278	ในแผน
438	P230-000438	240	240	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	279	ในแผน
439	P230-000439	214	214	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	280	ในแผน
440	P230-000440	700	700	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	281	ในแผน
443	P230-000443	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	282	ในแผน
446	P230-000446	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	283	ในแผน
447	P230-000447	317	317	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	284	ในแผน
449	P230-000449	73	73	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	285	ในแผน
450	P230-000450	15	15	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	286	ในแผน
451	P230-000451	33	33	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	287	ในแผน
453	P230-000453	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	288	ในแผน
454	P230-000454	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	289	ในแผน
455	P230-000455	46	46	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	290	ในแผน
456	P230-000456	76	76	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	291	ในแผน
457	P230-000457	288	288	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	292	ในแผน
458	P230-000458	21	21	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	293	ในแผน
459	P230-000459	31	31	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	294	ในแผน
460	P230-000460	13	13	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	295	ในแผน
461	P230-000461	9	9	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	296	ในแผน
462	P230-000462	39	39	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	297	ในแผน
463	P230-000463	17	17	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	298	ในแผน
464	P230-000464	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	299	ในแผน
465	P230-000465	740	740	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	300	ในแผน
466	P230-000466	350	350	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	301	ในแผน
467	P230-000467	2380	2380	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	302	ในแผน
468	P230-000468	320	320	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	303	ในแผน
469	P230-000469	1650	1650	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	304	ในแผน
470	P230-000470	15	15	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	305	ในแผน
471	P230-000471	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	306	ในแผน
472	P230-000472	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	307	ในแผน
474	P230-000474	96	96	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	308	ในแผน
475	P230-000475	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	309	ในแผน
476	P230-000476	49	49	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	310	ในแผน
477	P230-000477	145	145	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	311	ในแผน
478	P230-000478	72	72	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	312	ในแผน
479	P230-000479	94	94	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	313	ในแผน
480	P230-000480	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	314	ในแผน
482	P230-000482	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	315	ในแผน
483	P230-000483	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	316	ในแผน
484	P230-000484	24	24	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	317	ในแผน
485	P230-000485	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	318	ในแผน
486	P230-000486	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	319	ในแผน
487	P230-000487	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	320	ในแผน
488	P230-000488	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	321	ในแผน
489	P230-000489	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	322	ในแผน
492	P230-000492	116	116	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	323	ในแผน
500	P230-000500	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	324	ในแผน
502	P230-000502	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	325	ในแผน
503	P230-000503	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	326	ในแผน
506	P230-000506	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	327	ในแผน
507	P230-000507	22	22	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	328	ในแผน
510	P230-000510	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	329	ในแผน
511	P230-000511	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	330	ในแผน
512	P230-000512	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	331	ในแผน
513	P230-000513	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	332	ในแผน
514	P230-000514	14	14	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	333	ในแผน
515	P230-000515	66	66	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	334	ในแผน
516	P230-000516	122	122	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	335	ในแผน
517	P230-000517	331	331	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	336	ในแผน
518	P230-000518	50	50	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	337	ในแผน
519	P230-000519	113	113	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	338	ในแผน
520	P230-000520	115	115	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	339	ในแผน
521	P230-000521	112	112	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	340	ในแผน
522	P230-000522	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	341	ในแผน
524	P230-000524	74	74	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	342	ในแผน
525	P230-000525	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	343	ในแผน
526	P230-000526	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	344	ในแผน
527	P230-000527	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	345	ในแผน
528	P230-000528	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	346	ในแผน
529	P230-000529	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	347	ในแผน
530	P230-000530	16	16	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	348	ในแผน
531	P230-000531	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	349	ในแผน
532	P230-000532	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	350	ในแผน
537	P230-000537	4000	4000	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	351	ในแผน
538	P230-000538	17	17	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	352	ในแผน
539	P230-000539	18	18	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	353	ในแผน
540	P230-000540	30	30	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	354	ในแผน
541	P230-000541	32	32	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	355	ในแผน
543	P230-000543	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	356	ในแผน
544	P230-000544	7	7	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	357	ในแผน
545	P230-000545	65	65	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	358	ในแผน
546	P230-000546	482	482	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	359	ในแผน
547	P230-000547	7	7	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	360	ในแผน
548	P230-000548	250	250	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	361	ในแผน
550	P230-000550	305	305	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	362	ในแผน
551	P230-000551	286	286	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	363	ในแผน
552	P230-000552	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	364	ในแผน
559	P230-000559	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	365	ในแผน
563	P230-000563	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	366	ในแผน
565	P230-000565	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	367	ในแผน
567	P230-000567	1000	1000	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	368	ในแผน
568	P230-000568	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	369	ในแผน
569	P230-000569	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	370	ในแผน
570	P230-000570	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	371	ในแผน
572	P230-000572	13	13	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	372	ในแผน
573	P230-000573	34	34	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	373	ในแผน
574	P230-000574	1320	1320	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	374	ในแผน
575	P230-000575	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	375	ในแผน
576	P230-000576	30	30	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	376	ในแผน
577	P230-000577	11	11	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	377	ในแผน
578	P230-000578	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	378	ในแผน
579	P230-000579	16	16	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	379	ในแผน
580	P230-000580	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	380	ในแผน
581	P230-000581	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	381	ในแผน
585	P230-000585	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	382	ในแผน
587	P230-000587	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	383	ในแผน
588	P230-000588	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	384	ในแผน
590	P230-000590	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	385	ในแผน
595	P230-000595	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	386	ในแผน
3354	P230-000596	8	8	2569	2	2026-03-11 07:23:54.259223	2026-03-27 07:19:29.144057	0001	387	ในแผน
3365	P230-000596	5	5	2569	2	2026-03-11 07:54:18.954205	2026-03-27 07:19:29.144057	0011	387	ในแผน
597	P230-000597	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	388	ในแผน
600	P230-000600	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	389	ในแผน
608	P230-000608	250	250	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	390	ในแผน
616	P230-000616	40	40	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	391	ในแผน
619	P230-000619	40	40	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	392	ในแผน
620	P230-000620	80	80	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	393	ในแผน
623	P230-000623	100	100	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	394	ในแผน
627	P230-000627	150	150	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	395	ในแผน
628	P230-000628	40	40	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	396	ในแผน
630	P230-000630	100	100	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	397	ในแผน
631	P230-000631	80	80	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	398	ในแผน
636	P230-000636	150	150	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	399	ในแผน
638	P230-000638	300	300	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	400	ในแผน
640	P230-000640	80	80	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	401	ในแผน
641	P230-000641	300	300	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	402	ในแผน
642	P230-000642	80	80	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	403	ในแผน
3371	P230-000643	10	6	2569	1	2026-03-12 21:23:16.252535	2026-03-27 07:19:29.144057	0003	404	ในแผน
644	P230-000644	300	300	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	405	ในแผน
645	P230-000645	250	250	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	406	ในแผน
646	P230-000646	100	100	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	407	ในแผน
647	P230-000647	100	100	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	408	ในแผน
648	P230-000648	300	300	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	409	ในแผน
651	P230-000651	40	40	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	410	ในแผน
659	P230-000659	80	80	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	411	ในแผน
675	P230-000675	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0015	412	ในแผน
678	P230-000678	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0015	413	ในแผน
679	P230-000679	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0017	414	ในแผน
681	P230-000681	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0017	415	ในแผน
687	P230-000687	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0013	416	ในแผน
697	P230-000697	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0008	417	ในแผน
698	P230-000698	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0008	418	ในแผน
699	P230-000699	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0008	419	ในแผน
700	P230-000700	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	420	ในแผน
701	P230-000701	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	421	ในแผน
3362	P230-000707	1	1	2569	2	2026-03-11 07:48:58.748691	2026-03-27 07:19:29.144057	0001	422	ในแผน
712	P230-000712	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	426	ในแผน
713	P230-000713	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	427	ในแผน
714	P230-000714	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	428	ในแผน
719	P230-000719	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	429	ในแผน
720	P230-000720	7	7	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	430	ในแผน
721	P230-000721	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	431	ในแผน
3353	P230-000721	2	2	2569	2	2026-03-11 07:23:54.254066	2026-03-27 07:19:29.144057	0001	431	ในแผน
725	P230-000725	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	432	ในแผน
731	P230-000731	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	433	ในแผน
733	P230-000733	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	434	ในแผน
736	P230-000736	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	435	ในแผน
737	P230-000737	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	436	ในแผน
741	P230-000741	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	437	ในแผน
743	P230-000743	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	438	ในแผน
749	P230-000749	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	439	ในแผน
752	P230-000752	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	440	ในแผน
754	P230-000754	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	441	ในแผน
768	P230-000768	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	442	ในแผน
769	P230-000769	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	443	ในแผน
770	P230-000770	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	444	ในแผน
773	P230-000773	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	445	ในแผน
777	P230-000777	7	7	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	446	ในแผน
778	P230-000778	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	447	ในแผน
779	P230-000779	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	448	ในแผน
781	P230-000781	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	449	ในแผน
782	P230-000782	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	450	ในแผน
783	P230-000783	30	30	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	451	ในแผน
784	P230-000784	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	452	ในแผน
788	P230-000788	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	453	ในแผน
789	P230-000789	40	40	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	454	ในแผน
790	P230-000790	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	455	ในแผน
793	P230-000793	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	456	ในแผน
794	P230-000794	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	457	ในแผน
797	P230-000797	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	458	ในแผน
799	P230-000799	40	40	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	459	ในแผน
800	P230-000800	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	460	ในแผน
801	P230-000801	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	461	ในแผน
802	P230-000802	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	462	ในแผน
807	P230-000807	15	15	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	463	ในแผน
808	P230-000808	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	464	ในแผน
815	P230-000815	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	465	ในแผน
816	P230-000816	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	466	ในแผน
818	P230-000818	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	467	ในแผน
820	P230-000820	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	468	ในแผน
822	P230-000822	150	150	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	469	ในแผน
823	P230-000823	150	150	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	470	ในแผน
834	P230-000834	60	60	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	471	ในแผน
839	P230-000839	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	472	ในแผน
844	P230-000844	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	473	ในแผน
845	P230-000845	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	474	ในแผน
846	P230-000846	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	475	ในแผน
847	P230-000847	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	476	ในแผน
850	P230-000850	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	477	ในแผน
854	P230-000854	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	478	ในแผน
855	P230-000855	19	19	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	479	ในแผน
859	P230-000859	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	480	ในแผน
861	P230-000861	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	481	ในแผน
867	P230-000867	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	482	ในแผน
868	P230-000868	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	483	ในแผน
878	P230-000878	150	150	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	484	ในแผน
879	P230-000879	150	150	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	485	ในแผน
880	P230-000880	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	486	ในแผน
883	P230-000883	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	487	ในแผน
884	P230-000884	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	488	ในแผน
888	P230-000888	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	489	ในแผน
892	P230-000892	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	490	ในแผน
893	P230-000893	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	491	ในแผน
894	P230-000894	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	492	ในแผน
895	P230-000895	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	493	ในแผน
897	P230-000897	14	14	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	494	ในแผน
904	P230-000904	200	200	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	495	ในแผน
906	P230-000906	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	496	ในแผน
907	P230-000907	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	497	ในแผน
912	P230-000912	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	498	ในแผน
935	P230-000935	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	499	ในแผน
936	P230-000936	15	15	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	500	ในแผน
937	P230-000937	11	11	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	501	ในแผน
938	P230-000938	55	55	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	502	ในแผน
939	P230-000939	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	503	ในแผน
946	P230-000946	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	504	ในแผน
947	P230-000947	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	505	ในแผน
948	P230-000948	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	506	ในแผน
949	P230-000949	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	507	ในแผน
952	P230-000952	100	100	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	508	ในแผน
960	P230-000960	658	658	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	509	ในแผน
963	P230-000963	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	510	ในแผน
984	P230-000984	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	511	ในแผน
987	P230-000987	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	512	ในแผน
992	P230-000992	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	513	ในแผน
1009	P230-001009	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	514	ในแผน
1021	P230-001021	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	515	ในแผน
1024	P230-001024	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	516	ในแผน
1042	P230-001042	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	517	ในแผน
1048	P230-001048	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	518	ในแผน
1049	P230-001049	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	519	ในแผน
1050	P230-001050	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	520	ในแผน
1051	P230-001051	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	521	ในแผน
1052	P230-001052	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	522	ในแผน
1055	P230-001055	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	523	ในแผน
1057	P230-001057	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	524	ในแผน
1059	P230-001059	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	525	ในแผน
1060	P230-001060	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	526	ในแผน
1066	P230-001066	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	527	ในแผน
1067	P230-001067	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	528	ในแผน
1077	P230-001077	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	529	ในแผน
1083	P230-001083	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	530	ในแผน
1084	P230-001084	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	531	ในแผน
1089	P230-001089	36	36	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	532	ในแผน
1093	P230-001093	48	48	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	533	ในแผน
1094	P230-001094	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	534	ในแผน
1102	P230-001102	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	535	ในแผน
1106	P230-001106	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	536	ในแผน
1112	P230-001112	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	537	ในแผน
1113	P230-001113	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	538	ในแผน
1114	P230-001114	30	30	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	539	ในแผน
1126	P230-001126	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	540	ในแผน
1128	P230-001128	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	541	ในแผน
1130	P230-001130	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	542	ในแผน
1132	P230-001132	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	543	ในแผน
1133	P230-001133	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	544	ในแผน
1134	P230-001134	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	545	ในแผน
1135	P230-001135	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	546	ในแผน
1137	P230-001137	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	547	ในแผน
1139	P230-001139	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	548	ในแผน
1140	P230-001140	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	549	ในแผน
1141	P230-001141	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	550	ในแผน
1143	P230-001143	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	551	ในแผน
1156	P230-001156	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	552	ในแผน
1157	P230-001157	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	553	ในแผน
1158	P230-001158	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	554	ในแผน
1159	P230-001159	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	555	ในแผน
1160	P230-001160	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	556	ในแผน
3355	P230-001174	1	1	2569	2	2026-03-11 07:23:54.259688	2026-03-27 07:19:29.144057	0001	557	ในแผน
1178	P230-001178	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	558	ในแผน
1179	P230-001179	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	559	ในแผน
1181	P230-001181	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	560	ในแผน
1186	P230-001186	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	561	ในแผน
1187	P230-001187	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	562	ในแผน
1188	P230-001188	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	563	ในแผน
1189	P230-001189	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	564	ในแผน
1190	P230-001190	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	565	ในแผน
1198	P230-001198	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	566	ในแผน
1199	P230-001199	46	46	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	567	ในแผน
1202	P230-001202	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	568	ในแผน
1205	P230-001205	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	569	ในแผน
1213	P230-001213	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	570	ในแผน
1214	P230-001214	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	571	ในแผน
1215	P230-001215	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	572	ในแผน
1217	P230-001217	150	150	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	573	ในแผน
1220	P230-001220	300	300	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	574	ในแผน
1221	P230-001221	100	100	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	575	ในแผน
1222	P230-001222	40	40	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	576	ในแผน
1223	P230-001223	100	100	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	577	ในแผน
1224	P230-001224	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	578	ในแผน
1226	P230-001226	100	100	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	579	ในแผน
1227	P230-001227	200	200	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	580	ในแผน
1228	P230-001228	100	100	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	581	ในแผน
1229	P230-001229	200	200	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	582	ในแผน
1231	P230-001231	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0002	583	ในแผน
1232	P230-001232	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0002	584	ในแผน
3332	P230-001232	1	2	2569	2	2026-03-06 14:39:47.78097	2026-03-27 07:19:29.144057	0002	584	ในแผน
1235	P230-001235	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0012	585	ในแผน
1236	P230-001236	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0012	586	ในแผน
1237	P230-001237	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0012	587	ในแผน
1238	P230-001238	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0012	588	ในแผน
1239	P230-001239	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0018	589	ในแผน
1241	P230-001241	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0018	590	ในแผน
1245	P230-001245	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	591	ในแผน
1246	P230-001246	70	70	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	592	ในแผน
1247	P230-001247	50	50	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	593	ในแผน
1248	P230-001248	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	594	ในแผน
1249	P230-001249	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	595	ในแผน
1250	P230-001250	15	15	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	596	ในแผน
1251	P230-001251	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	597	ในแผน
1252	P230-001252	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	598	ในแผน
1253	P230-001253	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	599	ในแผน
1254	P230-001254	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	600	ในแผน
1255	P230-001255	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	601	ในแผน
1256	P230-001256	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	602	ในแผน
1257	P230-001257	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	603	ในแผน
1258	P230-001258	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	604	ในแผน
1259	P230-001259	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	605	ในแผน
1260	P230-001260	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	606	ในแผน
1261	P230-001261	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	607	ในแผน
1262	P230-001262	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	608	ในแผน
1263	P230-001263	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	609	ในแผน
1264	P230-001264	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	610	ในแผน
1265	P230-001265	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	611	ในแผน
1266	P230-001266	4	4	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	612	ในแผน
1267	P230-001267	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	613	ในแผน
1268	P230-001268	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	614	ในแผน
1269	P230-001269	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	615	ในแผน
1270	P230-001270	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	616	ในแผน
1271	P230-001271	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	617	ในแผน
1272	P230-001272	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	618	ในแผน
1273	P230-001273	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	619	ในแผน
1274	P230-001274	8	8	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	620	ในแผน
1275	P230-001275	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	621	ในแผน
1276	P230-001276	50	50	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	622	ในแผน
1277	P230-001277	30	30	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	623	ในแผน
1278	P230-001278	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	624	ในแผน
1279	P230-001279	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	625	ในแผน
1280	P230-001280	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	626	ในแผน
1281	P230-001281	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	627	ในแผน
1282	P230-001282	20	20	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	628	ในแผน
1283	P230-001283	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	629	ในแผน
1284	P230-001284	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	630	ในแผน
1285	P230-001285	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	631	ในแผน
1286	P230-001286	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	632	ในแผน
1287	P230-001287	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	633	ในแผน
1288	P230-001288	1	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	634	ในแผน
1289	P230-001289	50	50	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	635	ในแผน
1291	P230-001291	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	636	ในแผน
1292	P230-001292	5	5	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	637	ในแผน
1293	P230-001293	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	638	ในแผน
1294	P230-001294	10	10	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	639	ในแผน
3330	P230-001312	1	1	2569	\N	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	640	ในแผน
1314	P230-001314	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	641	ในแผน
1315	P230-001315	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	642	ในแผน
1316	P230-001316	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	643	ในแผน
1317	P230-001317	28	28	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	644	ในแผน
1318	P230-001318	6	6	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	645	ในแผน
1319	P230-001319	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	646	ในแผน
1320	P230-001320	18	18	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	647	ในแผน
1321	P230-001321	18	18	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	648	ในแผน
1322	P230-001322	24	24	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	649	ในแผน
1323	P230-001323	12	12	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	650	ในแผน
1324	P230-001324	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	651	ในแผน
3331	P230-001324	10	1	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0015	651	ในแผน
3333	P230-001324	1	1	2569	1	2026-03-06 14:51:10.023273	2026-03-27 07:19:29.144057	0013	651	ในแผน
3334	P230-001324	7	7	2569	2	2026-03-07 15:33:55.374249	2026-03-27 07:19:29.144057	0001	651	ในแผน
1325	P230-001325	2	2	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	652	ในแผน
3336	P230-001325	2	2	2569	1	2026-03-07 15:41:06.532328	2026-03-27 07:19:29.144057	0013	652	ในแผน
1326	P230-001326	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	653	ในแผน
3335	P230-001326	3	3	2569	1	2026-03-07 15:41:06.532165	2026-03-27 07:19:29.144057	0002	653	ในแผน
1327	P230-001327	3	3	2569	1	2026-03-06 14:26:06.795182	2026-03-27 07:19:29.144057	0001	654	ในแผน
3337	P230-001328	5	5	2569	1	2026-03-07 15:41:06.53378	2026-03-27 07:19:29.144057	0017	655	ในแผน
3359	P230-001329	1	1	2569	2	2026-03-11 07:33:32.500566	2026-03-27 07:19:29.144057	0011	656	ในแผน
3363	P230-001329	2	2	2569	1	2026-03-11 07:49:03.011831	2026-03-27 07:19:29.144057	0013	656	ในแผน
\.


--
-- Data for Name: messages_2026_03_24; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_24 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_25; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_25 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_26; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_26 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_27; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_27 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_28; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_28 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_29; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_29 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_30; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_30 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-03-13 00:36:30
20211116045059	2026-03-13 00:36:30
20211116050929	2026-03-13 00:36:30
20211116051442	2026-03-13 00:36:30
20211116212300	2026-03-13 00:36:30
20211116213355	2026-03-13 00:36:30
20211116213934	2026-03-13 00:36:30
20211116214523	2026-03-13 00:36:30
20211122062447	2026-03-13 00:36:30
20211124070109	2026-03-13 00:36:30
20211202204204	2026-03-13 00:36:30
20211202204605	2026-03-13 00:36:30
20211210212804	2026-03-13 00:36:30
20211228014915	2026-03-13 00:36:30
20220107221237	2026-03-13 00:36:30
20220228202821	2026-03-13 00:36:30
20220312004840	2026-03-13 00:36:30
20220603231003	2026-03-13 00:36:30
20220603232444	2026-03-13 00:36:30
20220615214548	2026-03-13 00:36:30
20220712093339	2026-03-13 00:36:30
20220908172859	2026-03-13 00:36:30
20220916233421	2026-03-13 00:36:30
20230119133233	2026-03-13 00:36:30
20230128025114	2026-03-13 00:36:30
20230128025212	2026-03-13 00:36:30
20230227211149	2026-03-13 00:36:30
20230228184745	2026-03-13 00:36:30
20230308225145	2026-03-13 00:36:30
20230328144023	2026-03-13 00:36:30
20231018144023	2026-03-13 00:36:30
20231204144023	2026-03-13 00:36:30
20231204144024	2026-03-13 00:36:30
20231204144025	2026-03-13 00:36:30
20240108234812	2026-03-13 00:36:30
20240109165339	2026-03-13 00:36:30
20240227174441	2026-03-13 00:36:30
20240311171622	2026-03-13 00:36:30
20240321100241	2026-03-13 00:36:30
20240401105812	2026-03-13 00:36:30
20240418121054	2026-03-13 00:36:30
20240523004032	2026-03-13 00:36:30
20240618124746	2026-03-13 00:36:30
20240801235015	2026-03-13 00:36:30
20240805133720	2026-03-13 00:36:30
20240827160934	2026-03-13 00:36:30
20240919163303	2026-03-13 00:36:30
20240919163305	2026-03-13 00:36:30
20241019105805	2026-03-13 00:36:31
20241030150047	2026-03-13 00:36:31
20241108114728	2026-03-13 00:36:31
20241121104152	2026-03-13 00:36:31
20241130184212	2026-03-13 00:36:31
20241220035512	2026-03-13 00:36:31
20241220123912	2026-03-13 00:36:31
20241224161212	2026-03-13 00:36:31
20250107150512	2026-03-13 00:36:31
20250110162412	2026-03-13 00:36:31
20250123174212	2026-03-13 00:36:31
20250128220012	2026-03-13 00:36:31
20250506224012	2026-03-13 00:36:31
20250523164012	2026-03-13 00:36:31
20250714121412	2026-03-13 00:36:31
20250905041441	2026-03-13 00:36:31
20251103001201	2026-03-13 00:36:31
20251120212548	2026-03-13 00:36:31
20251120215549	2026-03-13 00:36:31
20260218120000	2026-03-13 00:36:31
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: iceberg_namespaces; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.iceberg_namespaces (id, bucket_name, name, created_at, updated_at, metadata, catalog_id) FROM stdin;
\.


--
-- Data for Name: iceberg_tables; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.iceberg_tables (id, namespace_id, bucket_name, name, location, created_at, updated_at, remote_table_id, shard_key, shard_id, catalog_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-03-13 00:36:33.887611
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-03-13 00:36:33.894268
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-03-13 00:36:33.897078
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-03-13 00:36:33.904299
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-03-13 00:36:33.908817
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-03-13 00:36:33.911308
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-03-13 00:36:33.915146
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-03-13 00:36:33.918
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-03-13 00:36:33.920643
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-03-13 00:36:33.922958
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-03-13 00:36:33.926072
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-03-13 00:36:33.929014
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-03-13 00:36:33.93238
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-03-13 00:36:33.935704
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-03-13 00:36:33.93881
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-03-13 00:36:33.948159
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-03-13 00:36:33.950985
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-03-13 00:36:33.953744
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-03-13 00:36:33.956004
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-03-13 00:36:33.959011
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-03-13 00:36:33.961753
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-03-13 00:36:33.966457
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-03-13 00:36:33.971905
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-03-13 00:36:33.976859
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-03-13 00:36:33.979698
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-03-13 00:36:33.982766
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-03-13 00:36:33.985223
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-03-13 00:36:33.988066
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-03-13 00:36:33.990354
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-03-13 00:36:33.993103
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-03-13 00:36:33.995303
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-03-13 00:36:33.998048
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-03-13 00:36:34.000223
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-03-13 00:36:34.002933
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-03-13 00:36:34.005316
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-03-13 00:36:34.007934
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-03-13 00:36:34.009966
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-03-13 00:36:34.012513
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-03-13 00:36:34.015159
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-03-13 00:36:34.023926
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-03-13 00:36:34.026112
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-03-13 00:36:34.028642
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-03-13 00:36:34.03071
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-03-13 00:36:34.033309
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-03-13 00:36:34.03534
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-03-13 00:36:34.038834
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-03-13 00:36:34.043089
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-03-13 00:36:34.04598
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-03-13 00:36:34.048527
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-03-13 00:36:34.06228
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-03-13 00:36:34.064903
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-03-13 00:36:34.076874
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-03-13 00:36:34.07902
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-03-13 00:36:34.082878
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-03-13 00:36:34.085333
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-03-13 00:36:34.087298
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-03-13 00:36:34.09065
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: -
--

COPY supabase_functions.hooks (id, hook_table_id, hook_name, created_at, request_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: supabase_functions; Owner: -
--

COPY supabase_functions.migrations (version, inserted_at) FROM stdin;
initial	2026-03-13 00:36:20.214136+00
20210809183423_update_grants	2026-03-13 00:36:20.214136+00
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: Category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Category_id_seq"', 281, true);


--
-- Name: Department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Department_id_seq"', 48, true);


--
-- Name: Product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Product_id_seq"', 1, false);


--
-- Name: PurchaseApprovalInventoryLink_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."PurchaseApprovalInventoryLink_id_seq"', 1, false);


--
-- Name: Seller_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Seller_id_seq"', 5, true);


--
-- Name: Survey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Survey_id_seq"', 3392, true);


--
-- Name: approval_doc_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.approval_doc_status_id_seq', 5, true);


--
-- Name: inventory_adjustment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_adjustment_id_seq', 1, false);


--
-- Name: inventory_adjustment_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_adjustment_item_id_seq', 1, false);


--
-- Name: inventory_balance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_balance_id_seq', 229, true);


--
-- Name: inventory_issue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_issue_id_seq', 6, true);


--
-- Name: inventory_issue_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_issue_item_id_seq', 8, true);


--
-- Name: inventory_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_item_id_seq', 229, true);


--
-- Name: inventory_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_location_id_seq', 1, false);


--
-- Name: inventory_movement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_movement_id_seq', 33, true);


--
-- Name: inventory_period_balance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_period_balance_id_seq', 1, false);


--
-- Name: inventory_period_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_period_id_seq', 1, false);


--
-- Name: inventory_receipt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_receipt_id_seq', 11, true);


--
-- Name: inventory_receipt_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_receipt_item_id_seq', 1, true);


--
-- Name: inventory_requisition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_requisition_id_seq', 10, true);


--
-- Name: inventory_requisition_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_requisition_item_id_seq', 13, true);


--
-- Name: inventory_warehouse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_warehouse_id_seq', 1, true);


--
-- Name: purchase_approval_approval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.purchase_approval_approval_id_seq', 102, true);


--
-- Name: purchase_approval_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.purchase_approval_detail_id_seq', 1, false);


--
-- Name: purchase_approval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.purchase_approval_id_seq', 1, false);


--
-- Name: purchase_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.purchase_plan_id_seq', 658, true);


--
-- Name: test_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.test_data_id_seq', 10, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: -
--

SELECT pg_catalog.setval('supabase_functions.hooks_id_seq', 1, false);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: -
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: -
--

ALTER TABLE ONLY _realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: -
--

ALTER TABLE ONLY _realtime.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: category Category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);


--
-- Name: department Department_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT "Department_pkey" PRIMARY KEY (id);


--
-- Name: inventory_adjustment_item InventoryAdjustmentItem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_adjustment_item
    ADD CONSTRAINT "InventoryAdjustmentItem_pkey" PRIMARY KEY (id);


--
-- Name: inventory_adjustment InventoryAdjustment_adjustmentNo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_adjustment
    ADD CONSTRAINT "InventoryAdjustment_adjustmentNo_key" UNIQUE (adjustment_no);


--
-- Name: inventory_adjustment InventoryAdjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_adjustment
    ADD CONSTRAINT "InventoryAdjustment_pkey" PRIMARY KEY (id);


--
-- Name: inventory_balance InventoryBalance_inventoryItemId_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_balance
    ADD CONSTRAINT "InventoryBalance_inventoryItemId_key" UNIQUE (inventory_item_id);


--
-- Name: inventory_balance InventoryBalance_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_balance
    ADD CONSTRAINT "InventoryBalance_pkey" PRIMARY KEY (id);


--
-- Name: inventory_issue_item InventoryIssueItem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_issue_item
    ADD CONSTRAINT "InventoryIssueItem_pkey" PRIMARY KEY (id);


--
-- Name: inventory_issue InventoryIssue_issueNo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_issue
    ADD CONSTRAINT "InventoryIssue_issueNo_key" UNIQUE (issue_no);


--
-- Name: inventory_issue InventoryIssue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_issue
    ADD CONSTRAINT "InventoryIssue_pkey" PRIMARY KEY (id);


--
-- Name: inventory_item InventoryItem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT "InventoryItem_pkey" PRIMARY KEY (id);


--
-- Name: inventory_location InventoryLocation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_location
    ADD CONSTRAINT "InventoryLocation_pkey" PRIMARY KEY (id);


--
-- Name: inventory_movement InventoryMovement_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_movement
    ADD CONSTRAINT "InventoryMovement_pkey" PRIMARY KEY (id);


--
-- Name: inventory_period_balance InventoryPeriodBalance_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_period_balance
    ADD CONSTRAINT "InventoryPeriodBalance_pkey" PRIMARY KEY (id);


--
-- Name: inventory_period InventoryPeriod_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_period
    ADD CONSTRAINT "InventoryPeriod_pkey" PRIMARY KEY (id);


--
-- Name: inventory_receipt_item InventoryReceiptItem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_receipt_item
    ADD CONSTRAINT "InventoryReceiptItem_pkey" PRIMARY KEY (id);


--
-- Name: inventory_receipt InventoryReceipt_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_receipt
    ADD CONSTRAINT "InventoryReceipt_pkey" PRIMARY KEY (id);


--
-- Name: inventory_receipt InventoryReceipt_receiptNo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_receipt
    ADD CONSTRAINT "InventoryReceipt_receiptNo_key" UNIQUE (receipt_no);


--
-- Name: inventory_requisition_item InventoryRequisitionItem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_requisition_item
    ADD CONSTRAINT "InventoryRequisitionItem_pkey" PRIMARY KEY (id);


--
-- Name: inventory_requisition InventoryRequisition_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_requisition
    ADD CONSTRAINT "InventoryRequisition_pkey" PRIMARY KEY (id);


--
-- Name: inventory_requisition InventoryRequisition_requisitionNo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_requisition
    ADD CONSTRAINT "InventoryRequisition_requisitionNo_key" UNIQUE (requisition_no);


--
-- Name: inventory_warehouse InventoryWarehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_warehouse
    ADD CONSTRAINT "InventoryWarehouse_pkey" PRIMARY KEY (id);


--
-- Name: inventory_warehouse InventoryWarehouse_warehouseCode_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_warehouse
    ADD CONSTRAINT "InventoryWarehouse_warehouseCode_key" UNIQUE (warehouse_code);


--
-- Name: product Product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT "Product_pkey" PRIMARY KEY (id);


--
-- Name: purchase_approval_inventory_link PurchaseApprovalInventoryLink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_approval_inventory_link
    ADD CONSTRAINT "PurchaseApprovalInventoryLink_pkey" PRIMARY KEY (id);


--
-- Name: seller Seller_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seller
    ADD CONSTRAINT "Seller_pkey" PRIMARY KEY (id);


--
-- Name: usage_plan Survey_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usage_plan
    ADD CONSTRAINT "Survey_pkey" PRIMARY KEY (id);


--
-- Name: approval_doc_status approval_doc_status_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_doc_status
    ADD CONSTRAINT approval_doc_status_code_key UNIQUE (code);


--
-- Name: approval_doc_status approval_doc_status_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_doc_status
    ADD CONSTRAINT approval_doc_status_pkey PRIMARY KEY (id);


--
-- Name: approval_doc_status approval_doc_status_status_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_doc_status
    ADD CONSTRAINT approval_doc_status_status_key UNIQUE (status);


--
-- Name: department department_department_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_department_code_key UNIQUE (department_code);


--
-- Name: inventory_location inventory_location_warehouse_id_location_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_location
    ADD CONSTRAINT inventory_location_warehouse_id_location_code_key UNIQUE (warehouse_id, location_code);


--
-- Name: inventory_period_balance inventory_period_balance_unique_item_per_period; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_period_balance
    ADD CONSTRAINT inventory_period_balance_unique_item_per_period UNIQUE (period_id, inventory_item_id);


--
-- Name: inventory_period inventory_period_unique_period; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_period
    ADD CONSTRAINT inventory_period_unique_period UNIQUE (period_year, period_month);


--
-- Name: purchase_approval purchase_approval_approve_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_approval
    ADD CONSTRAINT purchase_approval_approve_code_key UNIQUE (approve_code);


--
-- Name: purchase_approval_detail purchase_approval_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_approval_detail
    ADD CONSTRAINT purchase_approval_detail_pkey PRIMARY KEY (id);


--
-- Name: purchase_approval_detail purchase_approval_detail_unique_plan_per_approval; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_approval_detail
    ADD CONSTRAINT purchase_approval_detail_unique_plan_per_approval UNIQUE (purchase_approval_id, purchase_plan_id);


--
-- Name: purchase_approval purchase_approval_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_approval
    ADD CONSTRAINT purchase_approval_pkey PRIMARY KEY (id);


--
-- Name: purchase_plan purchase_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_plan
    ADD CONSTRAINT purchase_plan_pkey PRIMARY KEY (id);


--
-- Name: test_data test_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_data
    ADD CONSTRAINT test_data_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_24 messages_2026_03_24_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_24
    ADD CONSTRAINT messages_2026_03_24_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_25 messages_2026_03_25_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_25
    ADD CONSTRAINT messages_2026_03_25_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_26 messages_2026_03_26_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_26
    ADD CONSTRAINT messages_2026_03_26_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_27 messages_2026_03_27_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_27
    ADD CONSTRAINT messages_2026_03_27_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_28 messages_2026_03_28_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_28
    ADD CONSTRAINT messages_2026_03_28_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_29 messages_2026_03_29_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_29
    ADD CONSTRAINT messages_2026_03_29_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_30 messages_2026_03_30_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_30
    ADD CONSTRAINT messages_2026_03_30_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: iceberg_namespaces iceberg_namespaces_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_pkey PRIMARY KEY (id);


--
-- Name: iceberg_tables iceberg_tables_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: -
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: -
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: extensions_tenant_external_id_index; Type: INDEX; Schema: _realtime; Owner: -
--

CREATE INDEX extensions_tenant_external_id_index ON _realtime.extensions USING btree (tenant_external_id);


--
-- Name: extensions_tenant_external_id_type_index; Type: INDEX; Schema: _realtime; Owner: -
--

CREATE UNIQUE INDEX extensions_tenant_external_id_type_index ON _realtime.extensions USING btree (tenant_external_id, type);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _realtime; Owner: -
--

CREATE UNIQUE INDEX tenants_external_id_index ON _realtime.tenants USING btree (external_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: Product_code_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Product_code_key" ON public.product USING btree (code);


--
-- Name: Seller_code_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Seller_code_key" ON public.seller USING btree (code);


--
-- Name: idx_approval_doc_status_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_doc_status_code ON public.approval_doc_status USING btree (code);


--
-- Name: idx_approval_doc_status_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_doc_status_status ON public.approval_doc_status USING btree (status);


--
-- Name: idx_product_purchase_department_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_purchase_department_id ON public.product USING btree (purchase_department_id);


--
-- Name: idx_purchase_approval_approve_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_approve_code ON public.purchase_approval USING btree (approve_code);


--
-- Name: idx_purchase_approval_budget_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_budget_year ON public.purchase_approval USING btree (budget_year);


--
-- Name: idx_purchase_approval_detail_proposed_amount; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_detail_proposed_amount ON public.purchase_approval_detail USING btree (proposed_amount);


--
-- Name: idx_purchase_approval_detail_proposed_quantity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_detail_proposed_quantity ON public.purchase_approval_detail USING btree (proposed_quantity);


--
-- Name: idx_purchase_approval_detail_purchase_approval_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_detail_purchase_approval_id ON public.purchase_approval_detail USING btree (purchase_approval_id);


--
-- Name: idx_purchase_approval_detail_purchase_plan_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_detail_purchase_plan_id ON public.purchase_approval_detail USING btree (purchase_plan_id);


--
-- Name: idx_purchase_approval_detail_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_detail_status ON public.purchase_approval_detail USING btree (status);


--
-- Name: idx_purchase_approval_doc_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_doc_date ON public.purchase_approval USING btree (doc_date);


--
-- Name: idx_purchase_approval_doc_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_doc_no ON public.purchase_approval USING btree (doc_no);


--
-- Name: idx_purchase_approval_inventory_link_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_inventory_link_detail_id ON public.purchase_approval_inventory_link USING btree (purchase_approval_detail_id);


--
-- Name: idx_purchase_approval_inventory_link_detail_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_purchase_approval_inventory_link_detail_unique ON public.purchase_approval_inventory_link USING btree (purchase_approval_detail_id);


--
-- Name: idx_purchase_approval_is_inspection; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_is_inspection ON public.purchase_approval USING btree (is_inspection);


--
-- Name: idx_purchase_approval_seller_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_seller_id ON public.purchase_approval USING btree (seller_id);


--
-- Name: idx_purchase_approval_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_approval_status ON public.purchase_approval USING btree (status);


--
-- Name: inventory_item_unique_product_wh_location_lot; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX inventory_item_unique_product_wh_location_lot ON public.inventory_item USING btree (product_code, warehouse_id, COALESCE(location_id, 0), COALESCE(lot_no, ''::text));


--
-- Name: inventory_movement_item_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_movement_item_date_idx ON public.inventory_movement USING btree (inventory_item_id, movement_date DESC);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_24_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_24_inserted_at_topic_idx ON realtime.messages_2026_03_24 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_25_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_25_inserted_at_topic_idx ON realtime.messages_2026_03_25 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_26_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_26_inserted_at_topic_idx ON realtime.messages_2026_03_26 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_27_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_27_inserted_at_topic_idx ON realtime.messages_2026_03_27 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_28_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_28_inserted_at_topic_idx ON realtime.messages_2026_03_28 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_29_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_29_inserted_at_topic_idx ON realtime.messages_2026_03_29 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_30_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_30_inserted_at_topic_idx ON realtime.messages_2026_03_30 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_iceberg_namespaces_bucket_id; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_iceberg_namespaces_bucket_id ON storage.iceberg_namespaces USING btree (catalog_id, name);


--
-- Name: idx_iceberg_tables_location; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_iceberg_tables_location ON storage.iceberg_tables USING btree (location);


--
-- Name: idx_iceberg_tables_namespace_id; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_iceberg_tables_namespace_id ON storage.iceberg_tables USING btree (catalog_id, namespace_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: -
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: -
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: messages_2026_03_24_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_24_inserted_at_topic_idx;


--
-- Name: messages_2026_03_24_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_24_pkey;


--
-- Name: messages_2026_03_25_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_25_inserted_at_topic_idx;


--
-- Name: messages_2026_03_25_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_25_pkey;


--
-- Name: messages_2026_03_26_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_26_inserted_at_topic_idx;


--
-- Name: messages_2026_03_26_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_26_pkey;


--
-- Name: messages_2026_03_27_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_27_inserted_at_topic_idx;


--
-- Name: messages_2026_03_27_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_27_pkey;


--
-- Name: messages_2026_03_28_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_28_inserted_at_topic_idx;


--
-- Name: messages_2026_03_28_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_28_pkey;


--
-- Name: messages_2026_03_29_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_29_inserted_at_topic_idx;


--
-- Name: messages_2026_03_29_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_29_pkey;


--
-- Name: messages_2026_03_30_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_30_inserted_at_topic_idx;


--
-- Name: messages_2026_03_30_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_30_pkey;


--
-- Name: purchase_approval_detail purchase_approval_detail_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER purchase_approval_detail_updated_at BEFORE UPDATE ON public.purchase_approval_detail FOR EACH ROW EXECUTE FUNCTION public.update_purchase_approval_detail_updated_at();


--
-- Name: purchase_approval purchase_approval_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER purchase_approval_updated_at BEFORE UPDATE ON public.purchase_approval FOR EACH ROW EXECUTE FUNCTION public.update_purchase_approval_updated_at();


--
-- Name: purchase_approval trg_purchase_approval_budget_year; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_purchase_approval_budget_year BEFORE INSERT OR UPDATE OF doc_date ON public.purchase_approval FOR EACH ROW EXECUTE FUNCTION public.set_purchase_approval_budget_year();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: extensions extensions_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _realtime; Owner: -
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _realtime.tenants(external_id) ON DELETE CASCADE;


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: inventory_adjustment_item InventoryAdjustmentItem_adjustmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_adjustment_item
    ADD CONSTRAINT "InventoryAdjustmentItem_adjustmentId_fkey" FOREIGN KEY (adjustment_id) REFERENCES public.inventory_adjustment(id) ON DELETE CASCADE;


--
-- Name: inventory_adjustment_item InventoryAdjustmentItem_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_adjustment_item
    ADD CONSTRAINT "InventoryAdjustmentItem_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_balance InventoryBalance_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_balance
    ADD CONSTRAINT "InventoryBalance_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE CASCADE;


--
-- Name: inventory_issue_item InventoryIssueItem_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_issue_item
    ADD CONSTRAINT "InventoryIssueItem_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_issue_item InventoryIssueItem_issueId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_issue_item
    ADD CONSTRAINT "InventoryIssueItem_issueId_fkey" FOREIGN KEY (issue_id) REFERENCES public.inventory_issue(id) ON DELETE CASCADE;


--
-- Name: inventory_issue_item InventoryIssueItem_requisitionItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_issue_item
    ADD CONSTRAINT "InventoryIssueItem_requisitionItemId_fkey" FOREIGN KEY (requisition_item_id) REFERENCES public.inventory_requisition_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_issue InventoryIssue_requisitionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_issue
    ADD CONSTRAINT "InventoryIssue_requisitionId_fkey" FOREIGN KEY (requisition_id) REFERENCES public.inventory_requisition(id) ON DELETE RESTRICT;


--
-- Name: inventory_item InventoryItem_locationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT "InventoryItem_locationId_fkey" FOREIGN KEY (location_id) REFERENCES public.inventory_location(id) ON DELETE SET NULL;


--
-- Name: inventory_item InventoryItem_warehouseId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT "InventoryItem_warehouseId_fkey" FOREIGN KEY (warehouse_id) REFERENCES public.inventory_warehouse(id) ON DELETE RESTRICT;


--
-- Name: inventory_location InventoryLocation_warehouseId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_location
    ADD CONSTRAINT "InventoryLocation_warehouseId_fkey" FOREIGN KEY (warehouse_id) REFERENCES public.inventory_warehouse(id) ON DELETE RESTRICT;


--
-- Name: inventory_movement InventoryMovement_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_movement
    ADD CONSTRAINT "InventoryMovement_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_period_balance InventoryPeriodBalance_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_period_balance
    ADD CONSTRAINT "InventoryPeriodBalance_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_period_balance InventoryPeriodBalance_periodId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_period_balance
    ADD CONSTRAINT "InventoryPeriodBalance_periodId_fkey" FOREIGN KEY (period_id) REFERENCES public.inventory_period(id) ON DELETE CASCADE;


--
-- Name: inventory_receipt_item InventoryReceiptItem_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_receipt_item
    ADD CONSTRAINT "InventoryReceiptItem_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_receipt_item InventoryReceiptItem_receiptId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_receipt_item
    ADD CONSTRAINT "InventoryReceiptItem_receiptId_fkey" FOREIGN KEY (receipt_id) REFERENCES public.inventory_receipt(id) ON DELETE CASCADE;


--
-- Name: inventory_requisition_item InventoryRequisitionItem_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_requisition_item
    ADD CONSTRAINT "InventoryRequisitionItem_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_requisition_item InventoryRequisitionItem_requisitionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_requisition_item
    ADD CONSTRAINT "InventoryRequisitionItem_requisitionId_fkey" FOREIGN KEY (requisition_id) REFERENCES public.inventory_requisition(id) ON DELETE CASCADE;


--
-- Name: purchase_approval_detail purchase_approval_detail_purchase_approval_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_approval_detail
    ADD CONSTRAINT purchase_approval_detail_purchase_approval_id_fkey FOREIGN KEY (purchase_approval_id) REFERENCES public.purchase_approval(id) ON DELETE CASCADE;


--
-- Name: purchase_approval_inventory_link purchase_approval_inventory_link_last_receipt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_approval_inventory_link
    ADD CONSTRAINT purchase_approval_inventory_link_last_receipt_id_fkey FOREIGN KEY (last_receipt_id) REFERENCES public.inventory_receipt(id) ON DELETE SET NULL;


--
-- Name: purchase_approval_inventory_link purchase_approval_inventory_link_purchase_approval_detail_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_approval_inventory_link
    ADD CONSTRAINT purchase_approval_inventory_link_purchase_approval_detail_id_fk FOREIGN KEY (purchase_approval_detail_id) REFERENCES public.purchase_approval_detail(id) ON DELETE CASCADE;


--
-- Name: purchase_approval purchase_approval_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_approval
    ADD CONSTRAINT purchase_approval_status_fkey FOREIGN KEY (status) REFERENCES public.approval_doc_status(code);


--
-- Name: iceberg_namespaces iceberg_namespaces_catalog_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_catalog_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_namespace_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_namespace_id_fkey FOREIGN KEY (namespace_id) REFERENCES storage.iceberg_namespaces(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_namespaces; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.iceberg_namespaces ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_tables; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.iceberg_tables ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

\unrestrict UKUSySYV0gZXiBl7YMlmeqllmYyrcgchbxA1TAPeCFgJnta0CWGlqsBdsbGDfeY

