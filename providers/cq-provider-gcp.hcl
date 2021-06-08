service = "gcp"
output_directory = "../forks/cq-provider-gcp/resources"


resource "gcp" "kms" "keyring" {
  path = "google.golang.org/api/cloudkms/v1.KeyRing"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  userDefinedColumn "location" {
    type = "string"
    resolver "resolveResourceLocation" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
    }
  }

  relation "gcp" "kms" "cryptoKey" {
    path = "google.golang.org/api/cloudkms/v1.CryptoKey"

    userDefinedColumn "project_id" {
      type = "string"
      resolver "resolveResourceProject" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
      }
    }
    userDefinedColumn "location" {
      type = "string"
      resolver "resolveResourceLocation" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
      }
    }
  }
}

resource "gcp" "storage" "bucket" {
  path = "google.golang.org/api/storage/v1.Bucket"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-gcp/client.DeleteProjectFilter"
  }
  ignoreError "IgnoreError" {
    path = "github.com/cloudquery/cq-provider-gcp/client.IgnoreErrorHandler"
  }


  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "satisfies_p_z_s" {
    rename = "satisfies_pzs"
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }

  //  relation "gcp" "storage" "object_acls" {
  //    path = "google.golang.org/api/storage/v1.ObjectAccessControl"
  //    column "id" {
  //      type = "string"
  //      rename = "resource_id"
  //    }
  //  }

  relation "gcp" "storage" "default_object_acls" {
    path = "google.golang.org/api/storage/v1.ObjectAccessControl"
    column "id" {
      type = "string"
      rename = "resource_id"
    }
  }

  relation "gcp" "storage" "bucket_policy" {
    path = "google.golang.org/api/storage/v1.Policy"
    column "id" {
      type = "string"
      rename = "resource_id"
    }
  }

  relation "gcp" "storage" "bucket_acl" {
    path = "google.golang.org/api/storage/v1.BucketAccessControl"
    column "id" {
      type = "string"
      rename = "resource_id"
    }
  }
}

resource "gcp" "sql" "instances" {
  path = "google.golang.org/api/sqladmin/v1beta4.DatabaseInstance"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "replica_configuration" {
    skip_prefix = true
  }
  column "settings_database_flags" {
    type = "json"
    generate_resolver = true
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }
}

resource "gcp" "cloudfunctions" "function" {
  path = "google.golang.org/api/cloudfunctions/v1.CloudFunction"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }
}

resource "gcp" "crm" "projects" {
  path = "google.golang.org/api/cloudresourcemanager/v3.Project"

  column "id" {
    type = "string"
    rename = "resource_id"
  }
}

resource "gcp" "iam" "service_accounts" {
  path = "google.golang.org/api/iam/v1.ServiceAccount"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

}


resource "gcp" "iam" "roles" {
  path = "google.golang.org/api/iam/v1.Role"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
}

resource "gcp" "domains" "registration" {
  path = "google.golang.org/api/domains/v1beta1.Registration"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "contact_settings" {
    skip_prefix = true
  }
  column "pending_contact_settings" {
    skip = true
  }

  column "dns_settings" {
    skip_prefix = true
  }

  column "custom_dns_ds_records" {
    type = "json"
    generate_resolver = true
  }
  column "google_domains_dns_ds_records" {
    type = "json"
    generate_resolver = true
  }
}


resource "gcp" "compute" "instances" {
  path = "google.golang.org/api/compute/v1.Instance"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  userDefinedColumn "location" {
    type = "string"
    resolver "resolveResourceLocation" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
    }
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }
  relation "gcp" "compute" "disks" {
    path = "google.golang.org/api/compute/v1.AttachedDisk"
    column "initialize_params" {
      skip_prefix = true
    }
    column "guest_os_features" {
      type = "stringarray"
      generate_resolver = true
    }
    column "shielded_instance_initial_state_dbxs" {
      type = "json"
      generate_resolver = true
    }
    column "shielded_instance_initial_state_dbs" {
      type = "json"
      generate_resolver = true
    }
    column "shielded_instance_initial_state_keks" {
      type = "json"
      generate_resolver = true
    }
  }


  column "metadata_items" {
    type = "json"
    generate_resolver = true
  }
  column "guest_accelerators" {
    type = "json"
    generate_resolver = true
  }
}


resource "gcp" "compute" "images" {
  path = "google.golang.org/api/compute/v1.Image"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  userDefinedColumn "location" {
    type = "string"
    resolver "resolveResourceLocation" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
    }
  }

  column "license_codes" {
    skip = true
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }
  column "guest_os_features" {
    type = "stringarray"
    generate_resolver = true
  }
  column "shielded_instance_initial_state_dbxs" {
    type = "json"
    generate_resolver = true
  }
  column "shielded_instance_initial_state_dbs" {
    type = "json"
    generate_resolver = true
  }
  column "shielded_instance_initial_state_keks" {
    type = "json"
    generate_resolver = true
  }

}

resource "gcp" "compute" "interconnects" {
  path = "google.golang.org/api/compute/v1.Interconnect"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  userDefinedColumn "location" {
    type = "string"
    resolver "resolveResourceLocation" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
    }
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }


}

resource "gcp" "compute" "networks" {
  path = "google.golang.org/api/compute/v1.Network"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  userDefinedColumn "location" {
    type = "string"
    resolver "resolveResourceLocation" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
    }
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }
}

resource "gcp" "compute" "ssl_certificates" {
  path = "google.golang.org/api/compute/v1.SslCertificate"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  userDefinedColumn "location" {
    type = "string"
    resolver "resolveResourceLocation" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
    }
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }
}

resource "gcp" "compute" "subnetworks" {
  path = "google.golang.org/api/compute/v1.Subnetwork"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  userDefinedColumn "location" {
    type = "string"
    resolver "resolveResourceLocation" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
    }
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }
}

resource "gcp" "compute" "vpn_gateways" {
  path = "google.golang.org/api/compute/v1.VpnGateway"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  userDefinedColumn "location" {
    type = "string"
    resolver "resolveResourceLocation" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
    }
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }

  relation "gcp" "compute" "vpn_interfaces" {
    path = "google.golang.org/api/compute/v1.VpnGatewayVpnGatewayInterface"

    column "id" {
      type = "string"
      rename = "resource_id"
    }
  }

}

resource "gcp" "compute" "forwarding_rules" {
  path = "google.golang.org/api/compute/v1.ForwardingRule"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  userDefinedColumn "location" {
    type = "string"
    resolver "resolveResourceLocation" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
    }
  }

  column "metadata_filters" {
    type = "json"
    generate_resolver = true
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }
}

resource "gcp" "compute" "firewalls" {
  path = "google.golang.org/api/compute/v1.Firewall"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  userDefinedColumn "location" {
    type = "string"
    resolver "resolveResourceLocation" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
    }
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }
}

resource "gcp" "compute" "disk_types" {
  path = "google.golang.org/api/compute/v1.DiskType"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }

}

resource "gcp" "compute" "disks" {
  path = "google.golang.org/api/compute/v1.Disk"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }

  column "license_codes" {
    skip = true
  }
  column "guest_os_features" {
    type = "stringarray"
    generate_resolver = true
  }

}


resource "gcp" "compute" "backend_services" {
  path = "google.golang.org/api/compute/v1.BackendService"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "enable_c_d_n" {
    rename = "enable_cdn"
  }

  column "cdn_policy_bypass_cache_on_request_headers" {
    type = "stringarray"
    generate_resolver = true
  }

  column "cdn_policy_negative_caching_policies" {
    type = "json"
    generate_resolver = true
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }
}

resource "gcp" "compute" "autoscalers" {
  path = "google.golang.org/api/compute/v1.Autoscaler"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "autoscaling_policy" {
    skip_prefix = true
  }

  column "status_details" {
    type = "json"
    generate_resolver = true
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }
}

resource "gcp" "compute" "addresses" {
  path = "google.golang.org/api/compute/v1.Address"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }
}


resource "gcp" "compute" "addresses" {
  path = "google.golang.org/api/compute/v1.Address"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }
}


resource "gcp" "bigquery" "datasets" {
  path = "google.golang.org/api/bigquery/v2.Dataset"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }

  column "dataset_reference_dataset_id" {
    rename = "reference_dataset_id"
    skip = true
  }

  column "dataset_reference_project_id" {
    rename = "reference_project_id"
    skip = true
  }

  column "satisfies_p_z_s" {
    rename = "satisfies_pzs"
  }

  column "access" {
    skip = true
  }
}

resource "gcp" "bigquery" "dataset_accesses" {
  path = "google.golang.org/api/bigquery/v2.DatasetAccess"

  column "dataset_dataset_dataset_id" {
    rename = "dataset_id"
    skip = true
  }

  userDefinedColumn "dataset_id" {
    type = "uuid"
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.ParentIdResolver"
    }
  }

  column "dataset_dataset_project_id" {
    rename = "project_id"
    skip = true
  }

  column "dataset_target_types" {
    type = "stringarray"
    rename = "target_types"
    generate_resolver = true
  }
}

resource "gcp" "bigquery" "dataset_tables" {
  path = "google.golang.org/api/bigquery/v2.Table"
  limit_depth = 1
  column "schema" {
    type = "json"
    generate_resolver = true
  }

  userDefinedColumn "dataset_id" {
    type = "uuid"
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.ParentIdResolver"
    }
  }

  column "external_data_configuration_schema" {
    type = "json"
    generate_resolver = true
  }

  column "id" {
    rename = "resource_id"
  }

  column "model_model_options_labels" {
    rename = "model_options_labels"
  }
  column "model_model_options_loss_type" {
    rename = "model_options_loss_type"
  }
  column "model_model_options_model_type" {
    rename = "model_options_model_type"
  }

  column "snapshot_definition_base_table_reference_dataset_id" {
    skip = true
  }
  column "snapshot_definition_base_table_reference_project_id" {
    skip = true
  }
  column "snapshot_definition_base_table_reference_table_id" {
    skip = true
  }
  column "snapshot_definition_snapshot_time" {
    skip = true
  }

  column "table_reference_dataset_id" {
    skip = true
  }
  column "table_reference_project_id" {
    skip = true
  }
  column "table_reference_table_id" {
    skip = true
  }

  //  column "external_data_configuration_autodetect" {
  //    skip = true
  //  }
  //  column "external_data_configuration_compression" {
  //    skip = true
  //  }
  //  column "external_data_configuration_connection_id" {
  //    skip = true
  //  }
  //  column "external_data_configuration_ignore_unknown_values" {
  //    skip = true
  //  }
  //  column "external_data_configuration_max_bad_records" {
  //    skip = true
  //  }
  //  column "external_data_configuration_schema" {
  //    skip = true
  //  }
  //  column "external_data_configuration_source_format" {
  //    skip = true
  //  }
  //  column "external_data_configuration_source_uris" {
  //    skip = true
  //  }
  column "external_data_configuration_bigtable_options_ignore_unspecified_column_families" {
    skip = true
  }
  column "external_data_configuration_bigtable_options_read_rowkey_as_string" {
    skip = true
  }
  column "external_data_configuration_csv_options_allow_jagged_rows" {
    skip = true
  }
  column "external_data_configuration_csv_options_allow_quoted_newlines" {
    skip = true
  }
  column "external_data_configuration_csv_options_encoding" {
    skip = true
  }
  column "external_data_configuration_csv_options_field_delimiter" {
    skip = true
  }
  column "external_data_configuration_csv_options_quote" {
    skip = true
  }
  column "external_data_configuration_csv_options_skip_leading_rows" {
    skip = true
  }
  column "external_data_configuration_google_sheets_options_range" {
    skip = true
  }
  column "external_data_configuration_google_sheets_options_skip_leading_rows" {
    skip = true
  }
  column "external_data_configuration_hive_partitioning_options_mode" {
    skip = true
  }
  column "external_data_configuration_hive_partitioning_options_require_partition_filter" {
    skip = true
  }
  column "external_data_configuration_hive_partitioning_options_source_uri_prefix" {
    skip = true
  }
  column "external_data_configuration_parquet_options_enable_list_inference" {
    skip = true
  }
  column "external_data_configuration_parquet_options_enable_list_inference" {
    skip = true
  }
  column "external_data_configuration_parquet_options_enum_as_string" {
    skip = true
  }

  column "external_data_configuration_bigtable_options_column_families" {
    skip = true
  }


  relation "gcp" "bigquery" "dataset_model_training_runs" {
    path = "google.golang.org/api/bigquery/v2.BqmlTrainingRun"
    column "iteration_results" {
      skip = true
    }
  }

}


resource "gcp" "compute" "projects" {
  path = "google.golang.org/api/compute/v1.Project"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-gcp/client.DeleteProjectFilter"
  }
  ignoreError "IgnoreError" {
    path = "github.com/cloudquery/cq-provider-gcp/client.IgnoreErrorHandler"
  }


  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    rename = "resource_id"
  }

  column "common_instance_metadata_items" {
    type = "json"
    generate_resolver = true
  }
}


resource "gcp" "compute" "target_ssl_proxies" {
  path = "google.golang.org/api/compute/v1.TargetSslProxy"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-gcp/client.DeleteProjectFilter"
  }
  ignoreError "IgnoreError" {
    path = "github.com/cloudquery/cq-provider-gcp/client.IgnoreErrorHandler"
  }


  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    rename = "resource_id"
  }
}
resource "gcp" "compute" "target_https_proxies" {
  path = "google.golang.org/api/compute/v1.TargetHttpsProxy"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-gcp/client.DeleteProjectFilter"
  }
  ignoreError "IgnoreError" {
    path = "github.com/cloudquery/cq-provider-gcp/client.IgnoreErrorHandler"
  }


  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    rename = "resource_id"
  }
}


resource "gcp" "compute" "ssl_policies" {
  path = "google.golang.org/api/compute/v1.SslPolicy"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-gcp/client.DeleteProjectFilter"
  }
  ignoreError "IgnoreError" {
    path = "github.com/cloudquery/cq-provider-gcp/client.IgnoreErrorHandler"
  }


  userDefinedColumn "project_id" {
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    rename = "resource_id"
  }

  relation "gcp" "compute" "ssl_policy_warnings"{
    path = "google.golang.org/api/compute/v1.SslPolicyWarnings"

    column "data"{
      type = "json"
      generate_resolver = true
    }
  }
}


