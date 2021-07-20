service = "azure"
output_directory = "../cq-provider-azure/resources"
description_parser = "azure"

resource "azure" "compute" "disks" {
  path = "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2020-06-01/compute.Disk"
  description = "Azure compute disk"

  userDefinedColumn "subscription_id" {
    type = "string"
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
    rename = "time_created"
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
    type = "StringArray"
    generate_resolver = true
  }

  relation "azure" "compute" "disk_encryption_settings" {
    description = "Azure compute disk encryption setting"
    path = "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2020-06-01/compute.EncryptionSettingsElement"
  }
}

resource "azure" "storage" "containers" {
  path = "github.com/Azure/azure-sdk-for-go/services/storage/mgmt/2019-06-01/storage.ListContainerItem"
  description = "Azure storage container"

  userDefinedColumn "subscription_id" {
    type = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  userDefinedColumn "account_id" {
    type = "uuid"
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
    type = "json"
    generate_resolver = true
  }

  column "immutability_policy" {
    type = "json"
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
  path = "github.com/Azure/azure-sdk-for-go/services/storage/mgmt/2019-06-01/storage.Account"
  description = "Azure storage account"

  userDefinedColumn "subscription_id" {
    type = "string"
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
    rename = "encryption_key_last_key_rotation_timestamp_time"
  }

  column "blob_restore_status_parameters_time_to_restore_time" {
    extract_description_from_parent_field = true
  }

  column "geo_replication_stats_last_sync_time" {
    extract_description_from_parent_field = true
  }

  column "blob_restore_status_parameters_blob_ranges" {
    type = "json"
    generate_resolver = true
  }

  relation "azure" "storage" "private_endpoint_connections" {
    path = "github.com/Azure/azure-sdk-for-go/services/storage/mgmt/2019-06-01/storage.PrivateEndpointConnection"
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
  path = "github.com/Azure/azure-sdk-for-go/services/sql/mgmt/2014-04-01/sql.Server"

  userDefinedColumn "subscription_id" {
    type = "string"
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

resource "azure" "sql" "databases" {
  description = "Azure sql database"
  path = "github.com/Azure/azure-sdk-for-go/services/sql/mgmt/2014-04-01/sql.Database"

  userDefinedColumn "subscription_id" {
    description = "Azure subscription id"
    type = "string"
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
  column "database_properties" {
    skip_prefix = true
  }

  column "id" {
    rename = "resource_id"
  }

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

  relation "azure" "sql" "transparent_data_encryptions" {
    description = "Azure sql database encryption"
    path = "github.com/Azure/azure-sdk-for-go/services/sql/mgmt/2014-04-01/sql.TransparentDataEncryption"
    column "transparent_data_encryption_properties" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }
}

resource "azure" "resources" "groups" {
  path = "github.com/Azure/azure-sdk-for-go/services/resources/mgmt/2020-06-01/resources.Group"
  description = "Azure resource group"

  userDefinedColumn "subscription_id" {
    type = "string"
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
  path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-08-01/network.VirtualNetwork"
  limit_depth = 1

  userDefinedColumn "subscription_id" {
    type = "string"
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

  column "id" {
    rename = "resource_id"
  }

  relation "azure" "networks" "subnets" {
    path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-08-01/network.Subnet"
    description = "Azure virtual network subnet"
    column "subnet_properties_format" {
      skip_prefix = true
    }
    column "route_table_properties_format" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }

    column "network_security_group_security_group_properties_format_resource_guid" {
      rename = "security_group_properties_format_resource_guid"
    }

    column "network_security_group_security_group_properties_format_provisioning_state" {
      rename = "security_group_properties_format_provisioning_state"
    }
  }

  relation "azure" "networks" "peerings" {
    path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-08-01/network.VirtualNetworkPeering"
    description = "Azure virtual network peering"
    column "virtual_network_peering_properties_format" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }

  relation "azure" "networks" "ip_allocations" {
    path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-08-01/network.SubResource"
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
  path = "github.com/Azure/azure-sdk-for-go/services/keyvault/mgmt/2019-09-01/keyvault.Vault"
  description = "Azure ketvault vault"

  userDefinedColumn "subscription_id" {
    type = "string"
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

  column "properties" {
    skip_prefix = true
  }
  column "id" {
    rename = "resource_id"
  }
  column "network_acls_ip_rules" {
    type = "stringArray"
    generate_resolver = true
  }
  relation "azure" "keyvault" "keys" {
    description = "Azure ketvault vault key"
    path = "github.com/Azure/azure-sdk-for-go/services/keyvault/mgmt/2019-09-01/keyvault.Key"

    column "key_properties" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }

    column "key_ops" {
      description = "Enumerates the values for json web key operation"
    }
  }

  relation "azure" "keyvault" "private_endpoint_connections" {
    path = "github.com/Azure/azure-sdk-for-go/services/keyvault/mgmt/2019-09-01/keyvault.PrivateEndpointConnectionItem"
    description = "Azure ketvault vault endpoint connection"
    column "private_endpoint_connection_properties" {
      skip_prefix = true
    }
  }

  column "network_acls_virtual_network_rules" {
    type = "stringArray"
    generate_resolver = true
  }
}

resource "azure" "postgresql" "servers" {
  path = "github.com/Azure/azure-sdk-for-go/services/postgresql/mgmt/2020-01-01/postgresql.Server"
  description = "Azure postgresql server"

  userDefinedColumn "subscription_id" {
    type = "string"
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
    path = "github.com/Azure/azure-sdk-for-go/services/postgresql/mgmt/2020-01-01/postgresql.ServerPrivateEndpointConnection"
    description = "Azure postgresql server private endpoint connection"
    column "properties" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }

  }

  relation "azure" "postgresql" "configurations" {
    path = "github.com/Azure/azure-sdk-for-go/services/postgresql/mgmt/2020-01-01/postgresql.Configuration"
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
  path = "github.com/Azure/azure-sdk-for-go/services/mysql/mgmt/2020-01-01/mysql.Server"
  description = "Azure mysql server"

  userDefinedColumn "subscription_id" {
    type = "string"
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
    path = "github.com/Azure/azure-sdk-for-go/services/mysql/mgmt/2020-01-01/mysql.ServerPrivateEndpointConnection"
    description = "Azure mysql server private endpoint connection"
    column "properties" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }

  relation "azure" "mySQL" "configurations" {
    path = "github.com/Azure/azure-sdk-for-go/services/mysql/mgmt/2020-01-01/mysql.Configuration"
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
  path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-11-01/network.Watcher"
  description = "Azure network watcher"


  userDefinedColumn "subscription_id" {
    type = "string"
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

  relation "azure" "network_watcher" "flow_log" {
    path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-11-01/network.FlowLogProperties"
    embed = true
  }
}


resource "azure" "monitor" "diagnostic_settings" {
  path = "github.com/Azure/azure-sdk-for-go/services/preview/monitor/mgmt/2019-11-01-preview/insights.DiagnosticSettingsResource"

  userDefinedColumn "subscription_id" {
    type = "string"
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


resource "azure" "compute" "virtual_machines" {
  path = "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2021-03-01/compute.VirtualMachine"

  deleteFilter "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.DeleteSubscriptionFilter"
  }

  options {
    primary_keys = [
      "subscription_id",
      "id"]
  }

  userDefinedColumn "subscription_id" {
    type = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
  }
  limit_depth = 0

  column "virtual_machine_properties" {
    skip_prefix = true
  }

  column "additional_capabilities_ultra_s_s_d_enabled" {
    rename = "additional_capabilities_ultra_ssd_enabled"
  }

  column "virtual_machine_properties_instance_view_patch_status" {
    type = "json"
  }

  column "platform_fault_domain" {
    description = "Specifies the scale set logical fault domain into which the Virtual Machine will be created."
  }

  column "storage_profile" {
    type = "json"
    generate_resolver = true
  }

  column "os_profile" {
    skip_prefix = true
    generate_resolver = true
  }

  column "instance_view" {
    type = "json"
    generate_resolver = true
  }

  column "maintenance_redeploy_status" {
    skip_prefix = true
  }

  column "patch_status" {
    skip_prefix = true
  }

  column "windows_configuration_additional_unattend_content" {
    type = "json"
    generate_resolver = true
  }

  column "network_profile_network_interfaces" {
    type = "json"
    generate_resolver = true
  }

  column "windows_configuration_win_r_m_listeners" {
    rename = "win_config_rm_listeners"
  }


  column "linux_configuration_ssh_public_keys" {
    type = "json"
    generate_resolver = true
  }


  column "last_patch_installation_summary_error_details" {
    type = "json"
    generate_resolver = true
  }

  column "available_patch_summary_error_details" {
    type = "json"
    generate_resolver = true
  }


  relation "azure" "compute" "virtual_machine_network_interfaces" {
    path = "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2021-03-01/compute.NetworkInterfaceReference"
  }


  relation "azure" "compute" "virtual_machine_resources" {
    path = "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2021-03-01/compute.VirtualMachineExtension"

    column "virtual_machine_extension_properties" {
      type = "json"
      generate_resolver = true
    }
    column "settings" {
      type = "json"
      generate_resolver = true
    }

    column "instance_view_substatuses" {
      rename = "substatuses"
    }

    column "instance_view_statuses" {
      rename = "statuses"
    }

    column "protected_settings" {
      type = "json"
      generate_resolver = true
    }

  }
}



resource "azure" "monitor" "activity_log_alerts" {
  path = "github.com/Azure/azure-sdk-for-go/services/preview/monitor/mgmt/2019-11-01-preview/insights.ActivityLogAlertResource"
  //  description = "Azure network security group"
  limit_depth = 1


  userDefinedColumn "subscription_id" {
    type = "string"
    description = "Azure subscription id"
    resolver "resolveAzureSubscription" {
      path = "github.com/cloudquery/cq-provider-azure/client.ResolveAzureSubscription"
    }
  }

  multiplex "AzureSubscription" {
    path = "github.com/cloudquery/cq-provider-azure/client.SubscriptionMultiplex"
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
  path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-11-01/network.SecurityGroup"
  description = "Azure network security group"
  limit_depth = 1

  userDefinedColumn "subscription_id" {
    type = "string"
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
      "id"]
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
      rename = "flow_analytics_configuration_enabled"
    }

    column "flow_analytics_configuration_network_watcher_flow_analytics_configuration_workspace_id" {
      description = "The resource guid of the attached workspace for network watcher"
      rename = "flow_analytics_configuration_workspace_id"
    }

    column "flow_analytics_configuration_network_watcher_flow_analytics_configuration_workspace_region" {
      description = "The location of the attached workspace for network watcher"
      rename = "flow_analytics_configuration_workspace_region"
    }
    column "flow_analytics_configuration_network_watcher_flow_analytics_configuration_workspace_resource_id" {
      description = "Resource Id of the attached workspace for network watcher"
      rename = "flow_analytics_configuration_workspace_resource_id"
    }
    column "flow_analytics_configuration_network_watcher_flow_analytics_configuration_traffic_analytics_interval" {
      description = "The interval in minutes which would decide how frequently TA service should do flow analytics for network watcher"
      rename = "flow_analytics_configuration_traffic_analytics_interval"
    }
  }
}


resource "azure" "network" "public_ip_addresses" {
  path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-11-01/network.PublicIPAddress"
  limit_depth = 1

  options {
    primary_keys = [
      "subscription_id",
      "id"]
  }

  userDefinedColumn "subscription_id" {
    type = "string"
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

  column "ip_configuration" {
    skip_prefix = true
  }

  column "ip_configuration_properties_format" {
    skip_prefix = true
  }

  column "public_ip_address" {
    type = "json"
    generate_resolver = true
  }

  column "subnet" {
    type = "json"
    generate_resolver = true
  }
}


resource "azure" "monitor" "diagnostic_settings" {
  path = "github.com/Azure/azure-sdk-for-go/services/preview/monitor/mgmt/2019-11-01-preview/insights.DiagnosticSettingsResource"

  userDefinedColumn "subscription_id" {
    type = "string"
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