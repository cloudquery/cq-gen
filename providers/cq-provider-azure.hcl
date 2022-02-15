service          = "azure"
output_directory = "../cq-provider-azure/resources/services/datalake"


description_modifier "remove_read_only" {
  words = ["READ-ONLY; "]
}

description_modifier "remove_field_name" {
  regex = ".+- "
}

resource "azure" "compute" "disks" {
  path        = "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2020-06-01/compute.Disk"
  description = "Azure compute disk"

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }

  column "id" {
    rename = "resource_id"
  }

  column "time_created_time" {
    rename                                = "time_created"
    extract_description_from_parent_field = true
  }
  column "hyper_v_generation" {
    rename = "hyperv_generation"
  }

  column "disk_properties" {
    skip_prefix = true
  }
  column "disk_mb_ps_read_only" {
    rename = "disk_mbps_read_only"
  }
  column "disk_mb_ps_read_write" {
    rename = "disk_mbps_read_write"
  }

  column "share_info" {
    type              = "StringArray"
    generate_resolver = true
  }

  relation "azure" "compute" "disk_encryption_settings" {
    description = "Azure compute disk encryption setting"
    path        = "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2020-06-01/compute.EncryptionSettingsElement"
  }
}

resource "azure" "storage" "containers" {
  path        = "github.com/Azure/azure-sdk-for-go/services/storage/mgmt/2019-06-01/storage.ListContainerItem"
  description = "Azure storage container"

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  userDefinedColumn "account_id" {
    type        = "uuid"
    description = "Azure storage account id"
    resolver "parentIdResolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.ParentIdResolver"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }
  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }

  column "container_properties" {
    skip_prefix = true
  }

  column "immutability_policy_immutability_policy_property_immutability_period_since_creation_in_days" {
    rename = "immutability_policy_period_since_creation_in_days"
  }

  column "immutability_policy_immutability_policy_property_state" {
    rename = "immutability_policy_state"
  }

  column "immutability_policy_immutability_policy_property_allow_protected_append_writes" {
    rename = "immutability_policy_allow_protected_append_writes"
  }

  column "legal_hold" {
    type              = "json"
    generate_resolver = true
  }

  column "immutability_policy" {
    type              = "json"
    generate_resolver = true
  }

  column "deleted_time" {
    extract_description_from_parent_field = true
  }

  column "last_modified_time" {
    extract_description_from_parent_field = true
  }

  column "azure_storage_container_immutability_policy_update_histories_timestamp_time" {
    extract_description_from_parent_field = true
  }
  column "azure_storage_container_legal_hold_tags_timestamp_time" {
    extract_description_from_parent_field = true
  }

  column "id" {
    rename = "resource_id"
  }

}

resource "azure" "storage" "accounts" {
  path        = "github.com/Azure/azure-sdk-for-go/services/storage/mgmt/2019-06-01/storage.Account"
  description = "Azure storage account"

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }

  column "account_properties" {
    skip_prefix = true
  }

  column "id" {
    rename = "resource_id"
  }

  column "encryption_key_vault_properties_current_versioned_key_identifier" {
    rename = "encryption_key_current_versioned_key_identifier"
  }

  column "azure_files_identity_based_authentication_directory_service_options" {
    rename = "files_identity_auth_directory_service_options"
  }

  column "azure_files_identity_based_authentication_active_directory_properties_domain_name" {
    rename = "files_identity_auth_ad_properties_domain_name"
  }

  column "azure_files_identity_based_authentication_active_directory_properties_net_bios_domain_name" {
    rename = "files_identity_auth_ad_properties_net_bios_domain_name"
  }

  column "azure_files_identity_based_authentication_active_directory_properties_forest_name" {
    rename = "files_identity_auth_ad_properties_forest_name"
  }

  column "azure_files_identity_based_authentication_active_directory_properties_domain_guid" {
    rename = "files_identity_auth_ad_properties_domain_guid"
  }

  column "azure_files_identity_based_authentication_active_directory_properties_domain_sid" {
    rename = "files_identity_auth_ad_properties_net_bios_domain_sid"
  }

  column "azure_files_identity_based_authentication_active_directory_properties_azure_storage_sid" {
    rename = "files_identity_auth_ad_properties_azure_storage_sid"
  }

  column "last_geo_failover_time" {
    extract_description_from_parent_field = true
  }

  column "creation_time" {
    extract_description_from_parent_field = true
  }

  column "encryption_services_blob_last_enabled_time" {
    extract_description_from_parent_field = true
  }

  column "encryption_services_file_last_enabled_time" {
    extract_description_from_parent_field = true
  }

  column "encryption_services_table_last_enabled_time" {
    extract_description_from_parent_field = true
  }

  column "encryption_services_queue_last_enabled_time" {
    extract_description_from_parent_field = true
  }

  column "encryption_key_vault_properties_last_key_rotation_timestamp_time" {
    extract_description_from_parent_field = true
    rename                                = "encryption_key_last_key_rotation_timestamp_time"
  }

  column "blob_restore_status_parameters_time_to_restore_time" {
    extract_description_from_parent_field = true
  }

  column "geo_replication_stats_last_sync_time" {
    extract_description_from_parent_field = true
  }

  column "blob_restore_status_parameters_blob_ranges" {
    type              = "json"
    generate_resolver = true
  }

  relation "azure" "storage" "private_endpoint_connections" {
    path        = "github.com/Azure/azure-sdk-for-go/services/storage/mgmt/2019-06-01/storage.PrivateEndpointConnection"
    description = "Azure storage account private endpoint connection"
    column "id" {
      rename = "resource_id"
    }
    column "private_endpoint_connection_properties" {
      skip_prefix = true
    }
  }
}

resource "azure" "sql" "servers" {
  description = "Azure sql server"
  path        = "github.com/Azure/azure-sdk-for-go/services/sql/mgmt/2014-04-01/sql.Server"

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }
  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }
  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  column "server_properties" {
    skip_prefix = true
  }

  column "id" {
    rename = "resource_id"
  }
}


resource "azure" "sql" "managed_instances" {
  #  description = "SQL Managed Instance"
  path = "github.com/Azure/azure-sdk-for-go/services/preview/sql/mgmt/v4.0/sql.ManagedInstance"

  options {
    primary_keys = [
      "subscription_id",
      "id"
    ]
  }

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }
  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }
  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  column "managed_instance_properties" {
    skip_prefix = true
  }

  column "managed_instance_create_mode" {
    description = "Specifies the mode of database creation"
  }

  column "private_link_service_connection_state_status" {
    rename = "connection_status"
  }
  column "private_link_service_connection_state_description" {
    rename = "connection_description"
  }
  column "private_link_service_connection_state_actions_required" {
    rename = "connection_actions_required"
  }

  relation "azure" "sql" "private_endpoint_connections" {
    column "properties" {
      skip_prefix = true
    }
  }

  user_relation "azure" "sql" "vulnerability_assessments" {
    path = "github.com/Azure/azure-sdk-for-go/services/preview/sql/mgmt/v4.0/sql.ManagedInstanceVulnerabilityAssessment"
    column "managed_instance_vulnerability_assessment_properties" {
      skip_prefix = true
    }
  }

  user_relation "azure" "sql" "encryption_protectors" {
    path = "github.com/Azure/azure-sdk-for-go/services/preview/sql/mgmt/v4.0/sql.ManagedInstanceEncryptionProtector"
    column "managed_instance_encryption_protector_properties" {
      skip_prefix = true
    }
  }
}


resource "azure" "sql" "managed_databases" {
  #  description = "SQL Managed Instance"
  path = "github.com/Azure/azure-sdk-for-go/services/preview/sql/mgmt/v4.0/sql.ManagedDatabase"


  column "managed_database_properties" {
    skip_prefix = true
  }


  relation "azure" "sql" "private_endpoint_connections" {
    column "properties" {
      skip_prefix = true
    }
  }

  user_relation "azure" "sql" "vulnerability_assessments" {
    path = "github.com/Azure/azure-sdk-for-go/services/preview/sql/mgmt/v4.0/sql.DatabaseVulnerabilityAssessment"
    column "database_vulnerability_assessment_properties" {
      skip_prefix = true
    }
  }


  user_relation "azure" "sql" "vulnerability_assessment_scans" {
    path = "github.com/Azure/azure-sdk-for-go/services/preview/sql/mgmt/v4.0/sql.VulnerabilityAssessmentScanRecord"
    column "vulnerability_assessment_scan_record_properties" {
      skip_prefix = true
    }

    column "errors" {
      type = "json"
    }
  }
}

resource "azure" "sql" "databases" {
  description = "Azure sql database"
  path        = "github.com/Azure/azure-sdk-for-go/services/preview/sql/mgmt/v4.0/sql.Database"

  userDefinedColumn "server_cq_id" {
    description = "Azure sql server cloudquery id"
    type        = "uuid"
    resolver "parentIdResolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.ParentIdResolver"
    }
  }


  options {
    primary_keys = [
      "server_cq_id", "id"
    ]
  }
  column "database_properties" {
    skip_prefix = true
  }

  #  column "id" {
  #    rename = "resource_id"
  #  }

  column "creation_date_time" {
    extract_description_from_parent_field = true
  }
  column "earliest_restore_date_time" {
    extract_description_from_parent_field = true
  }
  column "source_database_deletion_date_time" {
    extract_description_from_parent_field = true
  }
  column "restore_point_in_time" {
    extract_description_from_parent_field = true
  }

  column "recommended_index" {
    skip = true
  }
  column "service_tier_advisors" {
    skip = true
  }
  column "recommended_index_recommended_index_properties_estimated_impacts" {
    skip = true
  }

  userDefinedColumn "transparent_data_encryption" {
    description       = "TransparentDataEncryption represents a database transparent data encryption configuration"
    type              = "json"
    generate_resolver = true
  }

  column "source_database_deletion_date_time" {
    description = "Specifies the time that the database was deleted"
  }

  column "restore_point_in_time" {
    description = "Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database."
  }


  user_relation "azure" "sql" "db_blob_auditing_policies" {
    path = "github.com/Azure/azure-sdk-for-go/services/preview/sql/mgmt/v4.0/sql.DatabaseBlobAuditingPolicy"
    column "database_blob_auditing_policy_properties" {
      skip_prefix = true
    }

    column "is_azure_monitor_target_enabled" {
      description = "Specifies whether audit events are sent to Azure Monitor."
    }

  }

  user_relation "azure" "sql" "db_vulnerability_assessments" {
    path = "github.com/Azure/azure-sdk-for-go/services/preview/sql/mgmt/v4.0/sql.DatabaseVulnerabilityAssessment"
    column "database_vulnerability_assessment_properties" {
      skip_prefix = true
    }
  }

  user_relation "azure" "sql" "db_vulnerability_assessment_scans" {
    path = "github.com/Azure/azure-sdk-for-go/services/preview/sql/mgmt/v4.0/sql.VulnerabilityAssessmentScanRecord"
    column "vulnerability_assessment_scan_record_properties" {
      skip_prefix = true
    }
    column "errors" {
      type              = "json"
      generate_resolver = true
    }
  }

  user_relation "azure" "sql" "db_threat_detection_policies" {
    path = "github.com/Azure/azure-sdk-for-go/services/preview/sql/mgmt/v4.0/sql.DatabaseSecurityAlertPolicy"
    column "database_security_alert_policy_properties" {
      skip_prefix = true
    }
  }
}

resource "azure" "resources" "groups" {
  path        = "github.com/Azure/azure-sdk-for-go/services/resources/mgmt/2020-06-01/resources.Group"
  description = "Azure resource group"

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }
  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  column "group_properties" {
    skip_prefix = true
  }

  column "id" {
    rename = "resource_id"
  }
}

resource "azure" "network" "virtual_networks" {
  description = "Azure virtual network"
  path        = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-08-01/network.VirtualNetwork"
  limit_depth = 1

  options {
    primary_keys = [
      "subscription_id",
      "id"
    ]
  }
  column "dhcp_options_dns_servers" {
    type              = "inetArray"
    generate_resolver = true
  }

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }
  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }
  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  column "virtual_network_properties_format" {
    skip_prefix = true
  }

  column "ip_allocations" {
    type              = "stringArray"
    generate_resolver = true
  }

  relation "azure" "networks" "subnets" {
    path        = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-08-01/network.Subnet"
    description = "Azure virtual network subnet"
    options {
      primary_keys = [
        "virtual_network_cq_id",
        "id"
      ]
    }
    column "subnet_properties_format" {
      skip_prefix = true
    }
    column "route_table_properties_format" {
      skip_prefix = true
    }
    column "network_security_group_security_group_properties_format_resource_guid" {
      rename = "security_group_properties_format_resource_guid"
    }
    column "network_security_group_security_group_properties_format_provisioning_state" {
      rename = "security_group_properties_format_provisioning_state"
    }
  }

  relation "azure" "networks" "peerings" {
    path        = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-08-01/network.VirtualNetworkPeering"
    description = "Azure virtual network peering"
    options {
      primary_keys = [
        "virtual_network_cq_id",
        "id"
      ]
    }
    column "virtual_network_peering_properties_format" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }

  relation "azure" "networks" "ip_allocations" {
    path        = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-08-01/network.SubResource"
    description = "Azure virtual network ip allocation"
    column "virtual_network_ip_allocations_properties_format" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }
}

resource "azure" "graphrbac" "users" {
  path = "github.com/Azure/azure-sdk-for-go/services/graphrbac/1.6/graphrbac.User"
}

resource "azure" "keyvault" "vaults" {
  path        = "github.com/Azure/azure-sdk-for-go/services/keyvault/mgmt/2019-09-01/keyvault.Vault"
  description = "Azure ketvault vault"

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }


  options {
    primary_keys = [
      "subscription_id",
      "id"
    ]
  }

  column "properties" {
    skip_prefix = true
  }

  column "network_acls_ip_rules" {
    type              = "stringArray"
    generate_resolver = true
  }

  relation "azure" "keyvault" "keys" {
    path = "github.com/Azure/azure-sdk-for-go/services/keyvault/v7.1/keyvault.KeyItem"

    column "attributes" {
      skip_prefix = true
    }

    column "expires" {
      type              = "timestamp"
      generate_resolver = true
    }

    column "not_before" {
      type              = "timestamp"
      generate_resolver = true
    }

    column "created" {
      type              = "timestamp"
      generate_resolver = true
    }

    column "updated" {
      type              = "timestamp"
      generate_resolver = true
    }
  }

  relation "azure" "keyvault" "secrets" {
    path = "github.com/Azure/azure-sdk-for-go/services/keyvault/v7.1/keyvault.SecretItem"

    column "attributes" {
      skip_prefix = true
    }

    column "expires" {
      type              = "timestamp"
      generate_resolver = true
    }

    column "not_before" {
      type              = "timestamp"
      generate_resolver = true
    }

    column "created" {
      type              = "timestamp"
      generate_resolver = true
    }

    column "updated" {
      type              = "timestamp"
      generate_resolver = true
    }
  }

  relation "azure" "keyvault" "private_endpoint_connections" {
    path        = "github.com/Azure/azure-sdk-for-go/services/keyvault/mgmt/2019-09-01/keyvault.PrivateEndpointConnectionItem"
    description = "Azure ketvault vault endpoint connection"
    column "private_endpoint_connection_properties" {
      skip_prefix = true
    }
  }

  column "network_acls_virtual_network_rules" {
    type              = "stringArray"
    generate_resolver = true
  }
}

resource "azure" "postgresql" "servers" {
  path        = "github.com/Azure/azure-sdk-for-go/services/postgresql/mgmt/2020-01-01/postgresql.Server"
  description = "Azure postgresql server"

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  column "server_properties" {
    skip_prefix = true
  }

  column "id" {
    rename = "resource_id"
  }

  column "earliest_restore_date_time" {
    extract_description_from_parent_field = true
  }

  relation "azure" "postgresql" "private_endpoint_connection" {
    path        = "github.com/Azure/azure-sdk-for-go/services/postgresql/mgmt/2020-01-01/postgresql.ServerPrivateEndpointConnection"
    description = "Azure postgresql server private endpoint connection"
    column "properties" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }

  }

  relation "azure" "postgresql" "configurations" {
    path        = "github.com/Azure/azure-sdk-for-go/services/postgresql/mgmt/2020-01-01/postgresql.Configuration"
    description = "Azure postgresql server configuration"
    column "configuration_properties" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }

}

resource "azure" "mySQL" "servers" {
  path        = "github.com/Azure/azure-sdk-for-go/services/mysql/mgmt/2020-01-01/mysql.Server"
  description = "Azure mysql server"

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  column "server_properties" {
    skip_prefix = true
  }

  column "id" {
    rename = "resource_id"
  }

  column "earliest_restore_date_time" {
    extract_description_from_parent_field = true
  }

  relation "azure" "mySQL" "private_endpoint_connections" {
    path        = "github.com/Azure/azure-sdk-for-go/services/mysql/mgmt/2020-01-01/mysql.ServerPrivateEndpointConnection"
    description = "Azure mysql server private endpoint connection"
    column "properties" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }

  relation "azure" "mySQL" "configurations" {
    path        = "github.com/Azure/azure-sdk-for-go/services/mysql/mgmt/2020-01-01/mysql.Configuration"
    description = "Azure mysql server configuration"
    column "configuration_properties" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }
}


resource "azure" "network" "watchers" {
  path        = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-11-01/network.Watcher"
  description = "Azure network watcher"


  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }


  column "watcher_properties_format_provisioning_state" {
    rename = "provisioning_state"
  }
}


resource "azure" "monitor" "diagnostic_settings" {
  path = "github.com/Azure/azure-sdk-for-go/services/preview/monitor/mgmt/2019-11-01-preview/insights.DiagnosticSettingsResource"

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  column "diagnostic_settings" {
    skip_prefix = true
  }
}


resource "azure" "compute" "virtual_machine_scale_sets" {
  path = "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2021-03-01/compute.VirtualMachineScaleSet"

  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }

  options {
    primary_keys = [
      "subscription_id",
      "id"
    ]
  }

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }
  column "virtual_machine_scale_set_properties" {
    skip_prefix = true
  }
  column "upgrade_policy" {
    type = "json"
  }

  column "virtual_machine_profile" {
    skip_prefix = true
  }
  column "os_profile_windows_configuration" {
    type              = "json"
    generate_resolver = true
  }
  column "os_profile_linux_configuration" {
    type              = "json"
    generate_resolver = true
  }
  column "storage_profile" {
    type              = "json"
    generate_resolver = true
  }
  column "network_profile" {
    type              = "json"
    generate_resolver = true
  }
  column "security_profile" {
    type              = "json"
    generate_resolver = true
  }
  column "diagnostics_profile" {
    type              = "json"
    generate_resolver = true
  }
  #  column "extension_profile" {
  #    type = "json"
  #    generate_resolver = true
  #  }

  column "scheduled_events_profile" {
    type              = "json"
    generate_resolver = true
  }

  relation "azure" "compute" "os_profile_secrets" {
    column "vault_certificates" {
      type = "json"
    }
  }


  relation "azure" "compute" "extension_profile_extensions" {
    rename = "extensions"


    column "virtual_machine_scale_set_extension_properties" {
      skip_prefix = true
    }

    column "type" {
      skip = true
    }

    userDefinedColumn "type" {
      type        = "string"
      description = "The type of the resource"
      #      path_resolver = "Type"
    }

    userDefinedColumn "extension_type" {
      type        = "string"
      description = "The type of the extension"
      #      Resolver:    schema.PathResolver("VirtualMachineScaleSetExtensionProperties.Type"),
    }

    column "settings" {
      type              = "json"
      generate_resolver = true
    }

    column "protected_settings" {
      type              = "json"
      generate_resolver = true
    }
  }
}

resource "azure" "compute" "virtual_machines" {
  path = "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2021-03-01/compute.VirtualMachine"

  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }

  options {
    primary_keys = [
      "subscription_id",
      "id"
    ]
  }

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  column "virtual_machine_properties" {
    skip_prefix = true
  }

  column "additional_capabilities_ultra_s_s_d_enabled" {
    rename = "additional_capabilities_ultra_ssd_enabled"
  }

  column "instance_view_patch_status" {
    type = "json"
  }

  column "platform_fault_domain" {
    description = "Specifies the scale set logical fault domain into which the Virtual Machine will be created."
  }

  column "storage_profile" {
    type              = "json"
    generate_resolver = true
  }

  column "os_profile" {
    skip_prefix       = true
    generate_resolver = true
  }

  column "instance_view" {
    type              = "json"
    generate_resolver = true
  }

  column "maintenance_redeploy_status" {
    skip_prefix = true
  }

  column "patch_status" {
    skip_prefix = true
  }

  column "windows_configuration_additional_unattend_content" {
    type              = "json"
    generate_resolver = true
  }

  column "network_profile_network_interface_configurations" {
    type              = "json"
    generate_resolver = true
  }

  column "network_profile_network_interfaces" {
    type              = "json"
    generate_resolver = true
  }


  column "windows_configuration_win_r_m_listeners" {
    rename = "win_config_rm_listeners"
  }


  column "linux_configuration_ssh_public_keys" {
    type              = "json"
    generate_resolver = true
  }


  column "last_patch_installation_summary_error_details" {
    type              = "json"
    generate_resolver = true
  }

  column "available_patch_summary_error_details" {
    type              = "json"
    generate_resolver = true
  }

  column "scheduled_events_profile" {
    type              = "json"
    generate_resolver = true
  }

  relation "azure" "compute" "secrets" {
    options {
      primary_keys = [
        "virtual_machine_cq_id",
        "source_vault_id"
      ]
    }

    relation "azure" "compute" "vault_certificates" {
      options {
        primary_keys = [
          "virtual_machine_secret_cq_id",
          "certificate_url"
        ]
      }
    }

  }

  relation "azure" "compute" "resources" {
    options {
      primary_keys = [
        "virtual_machine_cq_id",
        "id"
      ]
    }
    column "virtual_machine_extension_properties" {
      skip_prefix = true
    }
    column "settings" {
      type              = "json"
      generate_resolver = true
    }
    column "protected_settings" {
      type              = "json"
      generate_resolver = true
    }
    column "instance_view" {
      type              = "json"
      generate_resolver = true
    }
    userDefinedColumn "extension_type" {
      description = "Type of the extension"
      type        = "string"
      //path resolver "VirtualMachineExtensionProperties.Type"
    }
  }
}


resource "azure" "monitor" "activity_log_alerts" {
  path        = "github.com/Azure/azure-sdk-for-go/services/preview/monitor/mgmt/2019-11-01-preview/insights.ActivityLogAlertResource"
  //  description = "Azure network security group"
  limit_depth = 1


  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }


  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }


  column "activity_log_alert" {
    skip_prefix = true
  }

  column "scopes" {
    generate_resolver = true
  }

  relation "azure" "monitor" "activity_log_alert_action_groups" {
    path = "github.com/Azure/azure-sdk-for-go/services/preview/monitor/mgmt/2019-11-01-preview/insights.ActivityLogAlertActionGroup"
    column "action_group_id" {
      generate_resolver = true
    }
  }

  relation "azure" "monitor" "activity_log_alert_conditions" {
    path = "github.com/Azure/azure-sdk-for-go/services/preview/monitor/mgmt/2019-11-01-preview/insights.ActivityLogAlertLeafCondition"
    column "field" {
      generate_resolver = true
    }
  }
}


resource "azure" "network" "security_groups" {
  path        = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-11-01/network.SecurityGroup"
  description = "Azure network security group"
  limit_depth = 1

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }


  options {
    primary_keys = [
      "subscription_id",
      "id"
    ]
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }


  column "security_group_properties_format" {
    skip_prefix = true
  }

  column "network_interfaces" {
    skip = true
  }

  column "subnets" {
    skip = true
  }

  relation "azure" "network" "security_group_security_rules" {
    path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-11-01/network.SecurityRule"

    column "security_rule_properties_format" {
      skip_prefix = true
    }
  }


  relation "azure" "network" "security_group_flow_logs" {
    path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-11-01/network.FlowLog"

    column "flow_log_properties_format" {
      skip_prefix = true
    }

    column "flow_analytics_configuration_network_watcher_flow_analytics_configuration_enabled" {
      description = "Flag to enable/disable traffic analytics for network watcher"
      rename      = "flow_analytics_configuration_enabled"
    }

    column "flow_analytics_configuration_network_watcher_flow_analytics_configuration_workspace_id" {
      description = "The resource guid of the attached workspace for network watcher"
      rename      = "flow_analytics_configuration_workspace_id"
    }

    column "flow_analytics_configuration_network_watcher_flow_analytics_configuration_workspace_region" {
      description = "The location of the attached workspace for network watcher"
      rename      = "flow_analytics_configuration_workspace_region"
    }
    column "flow_analytics_configuration_network_watcher_flow_analytics_configuration_workspace_resource_id" {
      description = "Resource Id of the attached workspace for network watcher"
      rename      = "flow_analytics_configuration_workspace_resource_id"
    }
    column "flow_analytics_configuration_network_watcher_flow_analytics_configuration_traffic_analytics_interval" {
      description = "The interval in minutes which would decide how frequently TA service should do flow analytics for network watcher"
      rename      = "flow_analytics_configuration_traffic_analytics_interval"
    }
  }
}


resource "azure" "network" "public_ip_addresses" {
  path        = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-11-01/network.PublicIPAddress"
  limit_depth = 1

  options {
    primary_keys = [
      "subscription_id",
      "id"
    ]
  }

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }

  column "public_ip_address_properties_format" {
    skip_prefix = true
  }

  column "nat_gateway_nat_gateway_properties_format_idle_timeout_in_minutes" {
    rename = "nat_gateway_idle_timeout_in_minutes"
  }

  column "nat_gateway_nat_gateway_properties_format_idle_timeout_in_minutes" {
    rename = "nat_gateway_idle_timeout_in_minutes"
  }

  column "nat_gateway_nat_gateway_properties_format_resource_guid" {
    rename = "nat_gateway_resource_guid"
  }

  column "nat_gateway_nat_gateway_properties_format_provisioning_state" {
    rename = "nat_gateway_provisioning_state"
  }

  column "service_public_ip_address" {
    type              = "json"
    generate_resolver = true
  }

  column "linked_public_ip_address" {
    type              = "json"
    generate_resolver = true
  }

  column "ip_configuration" {
    type              = "json"
    generate_resolver = true
  }

  column "ip_address" {
    type              = "inet"
    generate_resolver = true
  }

  column "ip_tags" {
    type              = "json"
    generate_resolver = true
  }

  column "subnet" {
    type              = "json"
    generate_resolver = true
  }
}


resource "azure" "monitor" "diagnostic_settings" {
  path = "github.com/Azure/azure-sdk-for-go/services/preview/monitor/mgmt/2019-11-01-preview/insights.DiagnosticSettingsResource"

  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  column "diagnostic_settings" {
    skip_prefix = true
  }
}

resource "azure" "monitor" "activity_logs" {
  path        = "github.com/Azure/azure-sdk-for-go/services/preview/monitor/mgmt/2019-11-01-preview/insights.EventData"
  description = "Azure network watcher"


  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }
}

resource "azure" "security" "jit_network_access_policies" {
  path = "github.com/Azure/azure-sdk-for-go/services/preview/security/mgmt/v3.0/security.JitNetworkAccessPolicy"
  #  description = "Azure security jit network access policy"

  options {
    primary_keys = [
      "subscription_id",
      "id"
    ]
  }

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }
  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }

  column "jit_network_access_policy_properties" {
    skip_prefix = true
  }

  relation "azure" "security" "virtual_machines" {
    column "ports" {
      type = "json"
    }

    column "public_ip_address" {
      type              = "inet"
      generate_resolver = true
    }
  }

  relation "azure" "security" "requests" {
    column "virtual_machines" {
      type              = "stringArray"
      generate_resolver = true
    }

    column "start_time_utc_time" {
      rename = "start_time_utc"
    }
  }
}


resource "azure" "datalake" "storage_accounts" {
  description = "Data Lake Store account"
  path        = "github.com/Azure/azure-sdk-for-go/services/datalake/store/mgmt/2016-11-01/account.DataLakeStoreAccount"

  options {
    primary_keys = [
      "subscription_id",
      "id"
    ]
  }

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }
  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }

  column "data_lake_store_account_properties" {
    skip_prefix = true
  }


  relation "azure" "datalake" "virtual_network_rules" {
    column "virtual_network_rule_properties" {
      skip_prefix = true
    }
  }

  relation "azure" "datalake" "trusted_id_providers" {
    column "trusted_id_provider_properties" {
      skip_prefix = true
    }
  }

  relation "azure" "datalake" "firewall_rules" {
    column "firewall_rule_properties" {
      skip_prefix = true
    }
    column "start_ip_address" {
      type              = "inet"
      generate_resolver = true
    }
    column "end_ip_address" {
      type              = "inet"
      generate_resolver = true
    }
  }
}


resource "azure" "datalake" "analytics_accounts" {
  description = "Data Lake Analytics account"
  path        = "github.com/Azure/azure-sdk-for-go/services/datalake/analytics/mgmt/2016-11-01/account.DataLakeAnalyticsAccount"

  options {
    primary_keys = [
      "subscription_id",
      "id"
    ]
  }

  userDefinedColumn "subscription_id" {
    type        = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }
  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }

  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }


  column "data_lake_analytics_account_properties" {
    skip_prefix = true
  }

  column "id" {
    description = "The resource identifier"
  }


  relation "azure" "datalake" "data_lake_store_accounts" {
    column "data_lake_store_account_information_properties" {
      skip_prefix = true
    }
  }

  relation "azure" "datalake" "storage_accounts" {
    column "storage_account_information_properties" {
      skip_prefix = true
    }
  }

  relation "azure" "datalake" "compute_policies" {
    column "compute_policy_properties" {
      skip_prefix = true
    }
  }

  relation "azure" "datalake" "firewall_rules" {
    column "firewall_rule_properties" {
      skip_prefix = true
    }

    column "start_ip_address" {
      type              = "inet"
      generate_resolver = true
    }
    column "end_ip_address" {
      type              = "inet"
      generate_resolver = true
    }
  }


}
