service          = "azure"
output_directory = "../cq-provider-azure/resources"

description_source "openapi" {
  path = "./providers/msgraph-v1.0.json"
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