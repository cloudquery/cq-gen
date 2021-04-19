service = "azure"
output_directory = "providers/cq-provider-azure/resources"


resource "azure" "compute" "disks" {
  path = "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2020-06-01/compute.Disk"

  userDefinedColumn "subscription_id" {
    type = "string"
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
    path = "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2020-06-01/compute.EncryptionSettingsElement"
  }
}


resource "azure" "storage" "containers" {
  path = "github.com/Azure/azure-sdk-for-go/services/storage/mgmt/2019-06-01/storage.ListContainerItem"

  userDefinedColumn "subscription_id" {
    type = "string"
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


  column "id" {
    rename = "resource_id"
  }

}

resource "azure" "storage" "accounts" {
  path = "github.com/Azure/azure-sdk-for-go/services/storage/mgmt/2019-06-01/storage.Account"

  userDefinedColumn "subscription_id" {
    type = "string"
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

  relation "azure" "storage" "private_endpoint_connections" {
    path = "github.com/Azure/azure-sdk-for-go/services/storage/mgmt/2019-06-01/storage.PrivateEndpointConnection"
    column "id" {
      rename = "resource_id"
    }
    column "private_endpoint_connection_properties" {
      skip_prefix = true
    }
  }
}


resource "azure" "sql" "servers" {
  path = "github.com/Azure/azure-sdk-for-go/services/sql/mgmt/2014-04-01/sql.Server"

  userDefinedColumn "subscription_id" {
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


  column "server_properties" {
    skip_prefix = true
  }

  column "id" {
    rename = "resource_id"
  }

}

resource "azure" "sql" "databases" {
  path = "github.com/Azure/azure-sdk-for-go/services/sql/mgmt/2014-04-01/sql.Database"

  userDefinedColumn "subscription_id" {
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

  column "recommended_index" {
    skip = true
  }
  column "service_tier_advisors" {
    skip = true
  }
  column "recommended_index_recommended_index_properties_estimated_impacts" {
    skip =true
  }

  relation "azure" "sql" "transparent_data_encryptions" {
    path="github.com/Azure/azure-sdk-for-go/services/sql/mgmt/2014-04-01/sql.TransparentDataEncryption"
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

  userDefinedColumn "subscription_id" {
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

  column "group_properties" {
    skip_prefix = true
  }

  column "id" {
    rename = "resource_id"
  }
}

resource "azure" "network" "virtual_networks" {
  path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-08-01/network.VirtualNetwork"
  limit_depth = 1

  userDefinedColumn "subscription_id" {
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

  column "virtual_network_properties_format" {
    skip_prefix = true
  }

  column "id" {
    rename = "resource_id"
  }

  relation "azure" "networks" "subnets" {
    path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-08-01/network.Subnet"
    column "subnet_properties_format" {
      skip_prefix = true
    }
    column "route_table_properties_format" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }

  relation "azure" "networks" "peerings" {
    path = "github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-08-01/network.VirtualNetworkPeering"
    column "virtual_network_peering_properties_format" {
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

  userDefinedColumn "subscription_id" {
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
    path = "github.com/Azure/azure-sdk-for-go/services/keyvault/mgmt/2019-09-01/keyvault.Key"

    column "key_properties" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }

  relation "azure" "keyvault" "private_endpoint_connections" {
    path = "github.com/Azure/azure-sdk-for-go/services/keyvault/mgmt/2019-09-01/keyvault.PrivateEndpointConnectionItem"
    column "private_endpoint_connection_properties" {
      skip_prefix = true
    }
  }

  column "network_acls_virtual_network_rules" {
    type="stringArray"
    generate_resolver = true

  }
}

resource "azure" "postgresql" "servers" {
  path = "github.com/Azure/azure-sdk-for-go/services/postgresql/mgmt/2020-01-01/postgresql.Server"

  userDefinedColumn "subscription_id" {
    type = "string"
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

  relation "azure" "postgresql" "private_endpoint_connection" {
    path = "github.com/Azure/azure-sdk-for-go/services/postgresql/mgmt/2020-01-01/postgresql.ServerPrivateEndpointConnection"
    column "properties" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }

  }

  relation "azure" "postgresql" "configurations" {
    path = "github.com/Azure/azure-sdk-for-go/services/postgresql/mgmt/2020-01-01/postgresql.Configuration"
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

  userDefinedColumn "subscription_id" {
    type = "string"
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

  relation "azure" "mySQL" "private_endpoint_connections" {
    path = "github.com/Azure/azure-sdk-for-go/services/mysql/mgmt/2020-01-01/mysql.ServerPrivateEndpointConnection"
    column "properties" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }

  relation "azure" "mySQL" "configurations" {
    path = "github.com/Azure/azure-sdk-for-go/services/mysql/mgmt/2020-01-01/mysql.Configuration"
    column "configuration_properties" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }
}