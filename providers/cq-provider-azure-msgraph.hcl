service          = "azure"
output_directory = "../cq-provider-azure/resources"


resource "azure" "ad" "groups" {
  path        = "github.com/yaegashi/msgraph.go/v1.0.Group"
  limit_depth = 0

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

  relation "azure" "ad" "group_members" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "group_member_ofs" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "group_members_with_license_errors" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "group_transitive_members" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "group_transitive_member_ofs" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }

  relation "azure" "ad" "group_owners" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }
  }


  relation "azure" "ad" "group_settings" {
    path = "github.com/yaegashi/msgraph.go/v1.0.GroupSetting"
    column "entity_id" {
      rename = "id"
    }

    column "values" {
      type              = "json"
      generate_resolver = true
    }
  }

  relation "azure" "ad" "group_photos" {
    path = "github.com/yaegashi/msgraph.go/v1.0.ProfilePhoto"
    column "entity_id" {
      rename = "id"
    }
  }


  relation "azure" "ad" "group_accepted_senders" {
    path = "github.com/yaegashi/msgraph.go/v1.0.DirectoryObject"
    column "entity_id" {
      rename = "id"
    }


  }

  relation "azure" "ad" "group_rejected_senders" {
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

  relation "azure" "ad" "group_team_channels" {
    path = "github.com/yaegashi/msgraph.go/v1.0.Channel"
    column "entity_id" {
      rename = "id"
    }

    relation "azure" "ad" "group_team_channel_tabs" {
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

      relation "azure" "ad" "group_team_channel_tab_teams_app_app_definitions" {
        path = "github.com/yaegashi/msgraph.go/v1.0.TeamsAppDefinition"
        column "entity_id" {
          rename = "id"
        }
      }
    }
  }


  relation "azure" "ad" "group_team_installed_apps" {
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


    relation "azure" "ad" "group_team_installed_app_teams_app_app_definitions" {
      path = "github.com/yaegashi/msgraph.go/v1.0.TeamsAppDefinition"
      column "entity_id" {
        rename = "id"
      }
    }
  }


  relation "azure" "ad" "group_team_operations" {
    path = "github.com/yaegashi/msgraph.go/v1.0.TeamsAsyncOperation"
    column "entity_id" {
      rename = "id"
    }
  }
}