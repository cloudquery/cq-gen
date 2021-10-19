service          = "azure"
output_directory = "../cq-provider-azure/resources"

description_source "openapi" {
#  https://github.com/microsoftgraph/microsoft-graph-openapi/blob/master/v1.0.json
  path = "../../providers/msgraph-v1.0.json"
}


resource "azure" "ad" "groups" {
  path                      = "github.com/yaegashi/msgraph.go/v1.0.Group"
  description_path_parts    = ["microsoft.graph.group"]
  disable_auto_descriptions = true

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

  column "conversations" {
    skip = true
  }
  column "threads" {
    skip = true
  }

  column "calendar_view" {
    skip = true
  }
  column "events" {
    skip = true
  }
  column "calendar" {
    skip = true
  }

  column "drive" {
    skip = true
  }

  column "drives" {
    skip = true
  }

  column "sites" {
    skip = true
  }

  column "extensions" {
    skip = true
  }

  column "planner" {
    skip = true
  }

  column "onenote" {
    skip = true
  }

  column "directory_object" {
    skip_prefix = true
  }

  column "entity_id" {
    rename = "id"
  }

  column "photo_entity_id" {
    rename = "photo_id"
  }

  column "created_on_behalf_of_entity_id" {
    rename = "created_on_behalf_of_id"
  }

  column "team_entity_id" {
    rename = "team_id"
  }

  relation "azure" "ad" "members" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"

    column "entity_id" {
      rename = "id"
    }
  }


  relation "azure" "ad" "member_of" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "assigned_licenses" {
    path                   = "github.com/yaegashi/msgraph.go/v1.0.AssignedLicense"
    description_path_parts = ["assignedLicenses"]
    column "s_k_uid" {
      rename = "sku_id"
    }
  }

  relation "azure" "ad" "members_with_license_errors" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "transitive_members" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "transitive_member_of" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "owners" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }


  relation "azure" "ad" "settings" {
    path = "github.com/yaegashi/msgraph.go/v1.0.GroupSetting"
    column "entity_id" {
      rename = "id"
    }

    column "values" {
      type              = "json"
      generate_resolver = true
    }
  }

  relation "azure" "ad" "photos" {
    path = "github.com/yaegashi/msgraph.go/v1.0.ProfilePhoto"
    column "entity_id" {
      rename = "id"
    }
  }


  relation "azure" "ad" "accepted_senders" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "rejected_senders" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }


  relation "azure" "ad" "group_lifecycle_policies" {
    path = "github.com/yaegashi/msgraph.go/v1.0.GroupLifecyclePolicy"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "team_channels" {
    path = "github.com/yaegashi/msgraph.go/v1.0.Channel"
    column "entity_id" {
      rename = "id"
    }

    relation "azure" "ad" "tabs" {
      path = "github.com/yaegashi/msgraph.go/v1.0.TeamsTab"

      column "entity_id" {
        rename = "id"
      }

      column "configuration_entity_id" {
        rename = "configuration_id"
      }

      column "teams_app_entity_id" {
        rename = "teams_app_id"
      }

      relation "azure" "ad" "teams_app_app_definitions" {
        path = "github.com/yaegashi/msgraph.go/v1.0.TeamsAppDefinition"
        column "entity_id" {
          rename = "id"
        }
      }
    }
  }


  relation "azure" "ad" "team_installed_apps" {
    path = "github.com/yaegashi/msgraph.go/v1.0.TeamsAppInstallation"
    column "entity_id" {
      rename = "id"
    }
    column "teams_app_entity_id" {
      rename = "teams_app_id"
    }

    column "teams_app_definition_entity_id" {
      rename = "teams_app_definition_id"
    }


    relation "azure" "ad" "teams_app_app_definitions" {
      path = "github.com/yaegashi/msgraph.go/v1.0.TeamsAppDefinition"
      column "entity_id" {
        rename = "id"
      }
    }
  }


  relation "azure" "ad" "team_operations" {
    path = "github.com/yaegashi/msgraph.go/v1.0.TeamsAsyncOperation"
    column "entity_id" {
      rename = "id"
    }
  }
}


resource "azure" "ad" "users" {
  path                      = "github.com/yaegashi/msgraph.go/v1.0.User"
  description_path_parts    = ["microsoft.graph.user"]
  disable_auto_descriptions = true

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


  column "directory_object" {
    skip_prefix = true
  }

  column "entity_id" {
    rename = "id"
  }

  column "manager_entity_id" {
    rename = "manager_id"
  }

  column "inference_classification_entity_id" {
    rename = "inference_classification_id"
  }

  column "photo_entity_id" {
    rename = "photo_id"
  }
  column "settings_entity_id" {
    rename = "settings_id"
  }
  column "insights_entity_id" {
    rename = "insights_id"
  }

  column "mailbox_settings" {
    skip_prefix = true
  }

  options {
    primary_keys = [
      "subscription_id",
      "id"
    ]
  }

  column "drive" {
    skip = true
  }
  column "drives" {
    skip = true
  }
  column "messages" {
    skip = true
  }
  column "mail_folders" {
    skip = true
  }
  column "calendar" {
    skip = true
  }
  column "calendars" {
    skip = true
  }
  column "calendar_groups" {
    skip = true
  }
  column "calendar_view" {
    skip = true
  }
  column "events" {
    skip = true
  }
  column "planner" {
    skip = true
  }
  column "onenote" {
    skip = true
  }
  column "online_meetings" {
    skip = true
  }
  column "contacts" {
    skip = true
  }
  column "contact_folders" {
    skip = true
  }
  column "outlook" {
    skip = true
  }
  column "activities" {
    skip = true
  }

  column "joined_teams" {
    type              = "stringArray"
    generate_resolver = true
  }


  relation "azure" "ad" "owned_devices" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "registered_devices" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "registered_devices" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "direct_reports" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "member_of" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "created_objects" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "owned_objects" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "license_details" {
    path = "github.com/yaegashi/msgraph.go/v1.0.LicenseDetails"

    column "entity_id" {
      rename = "id"
    }
    column "s_k_uid" {
      rename = "sku_id"
    }

    column "s_k_u_part_number" {
      rename = "sku_part_number"
    }
  }

  relation "azure" "ad" "transitive_member_of" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "people" {
    path = "github.com/yaegashi/msgraph.go/v1.0.Person"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "inference_classification_overrides" {
    path = "github.com/yaegashi/msgraph.go/v1.0.InferenceClassificationOverride"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "photos" {
    path = "github.com/yaegashi/msgraph.go/v1.0.ProfilePhoto"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "photos" {
    path = "github.com/yaegashi/msgraph.go/v1.0.ProfilePhoto"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "extensions" {
    path = "github.com/yaegashi/msgraph.go/v1.0.Extension"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "extensions" {
    path = "github.com/yaegashi/msgraph.go/v1.0.Extension"
    column "entity_id" {
      rename = "id"
    }
  }


  relation "azure" "ad" "managed_devices" {
    path = "github.com/yaegashi/msgraph.go/v1.0.ManagedDevice"
    column "entity_id" {
      rename = "id"
    }

    column "device_category_entity_id" {
      rename = "device_category_id"
    }


    column "device_category" {
      skip = true
    }

    relation "azure" "ad" "device_configuration_states" {
      path = "github.com/yaegashi/msgraph.go/v1.0.DeviceConfigurationState"
      column "entity_id" {
        rename = "id"
      }
      column "setting_states" {
        type              = "json"
        generate_resolver = true
      }
    }


    relation "azure" "ad" "device_compliance_policy_states" {
      path = "github.com/yaegashi/msgraph.go/v1.0.DeviceCompliancePolicyState"
      column "entity_id" {
        rename = "id"
      }
      column "setting_states" {
        type              = "json"
        generate_resolver = true
      }
    }
  }

  relation "azure" "ad" "managed_app_registrations" {
    path = "github.com/yaegashi/msgraph.go/v1.0.ManagedAppRegistration"
    column "entity_id" {
      rename = "id"
    }
    relation "azure" "ad" "applied_policies" {
      path = "github.com/yaegashi/msgraph.go/v1.0.ManagedAppPolicy"
      column "entity_id" {
        rename = "id"
      }
    }

    relation "azure" "ad" "intended_policies" {
      path = "github.com/yaegashi/msgraph.go/v1.0.ManagedAppPolicy"
      column "entity_id" {
        rename = "id"
      }
    }

    relation "azure" "ad" "operations" {
      path = "github.com/yaegashi/msgraph.go/v1.0.ManagedAppOperation"
      column "entity_id" {
        rename = "id"
      }
    }
  }

  relation "azure" "ad" "device_management_troubleshooting_events" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DeviceManagementTroubleshootingEvent"
    column "entity_id" {
      rename = "id"
    }
  }
  relation "azure" "ad" "insights_trending" {
    path = "github.com/yaegashi/msgraph.go/v1.0.Trending"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "insights_shared" {
    path = "github.com/yaegashi/msgraph.go/v1.0.SharedInsight"
    column "entity_id" {
      rename = "id"
    }
  }
  relation "azure" "ad" "insights_used" {
    path = "github.com/yaegashi/msgraph.go/v1.0.UsedInsight"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "assigned_licenses" {
    path = "github.com/yaegashi/msgraph.go/v1.0.AssignedLicense"
    column "s_k_uid" {
      rename = "sku_id"
    }
  }

  relation "azure" "ad" "license_assignment_states" {
    path = "github.com/yaegashi/msgraph.go/v1.0.LicenseAssignmentState"
    column "s_k_uid" {
      rename = "sku_id"
    }
  }
}


resource "azure" "ad" "applications" {
  path                      = "github.com/yaegashi/msgraph.go/v1.0.Application"
  description_path_parts    = ["microsoft.graph.application"]
  disable_auto_descriptions = true

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

  column "directory_object" {
    skip_prefix = true
  }

  column "created_on_behalf_of_entity_id" {
    rename = "created_on_behalf_of_id"
  }

  column "entity_id" {
    rename = "id"
  }

  column "logo" {
    skip = true
  }


  relation "azure" "ad" "key_credentials" {
    path = "github.com/yaegashi/msgraph.go/v1.0.KeyCredential"
    column "custom_key_identifier" {
      generate_resolver = true
    }

    column "key" {
      generate_resolver = true
    }
  }

  relation "azure" "ad" "password_credentials" {
    path = "github.com/yaegashi/msgraph.go/v1.0.PasswordCredential"
    column "custom_key_identifier" {
      generate_resolver = true
    }
  }

  relation "azure" "ad" "extension_properties" {
    path = "github.com/yaegashi/msgraph.go/v1.0.ExtensionProperty"
    column "directory_object" {
      skip_prefix = true
    }

    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "owners" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }
}


