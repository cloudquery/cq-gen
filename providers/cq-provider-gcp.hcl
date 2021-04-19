service = "gcp"
output_directory = "providers/cq-provider-gcp/resources"


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

  userDefinedColumn "location" {
    type = "string"
    resolver "resolveResourceLocation" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
    }
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

  relation "gcp" "storage" "object_acls" {
    path = "google.golang.org/api/storage/v1.ObjectAccessControl"
    column "id" {
      type = "string"
      rename = "resource_id"
    }
  }

  relation "gcp" "storage" "default_object_acls" {
    path = "google.golang.org/api/storage/v1.ObjectAccessControl"
    column "id" {
      type = "string"
      rename = "resource_id"
    }
  }
}

resource "gcp" "sql" "instances" {
  path = "google.golang.org/api/sql/v1beta4.DatabaseInstance"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }
  userDefinedColumn "location" {
    type = "string"
    resolver "resolveResourceLocation" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveLocation"
    }
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
    type="json"
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
  path = "google.golang.org/api/cloudresourcemanager/v1.Project"

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
      type="stringarray"
      generate_resolver = true
    }
    column "shielded_instance_initial_state_dbxs" {
      type="json"
      generate_resolver = true
    }
    column "shielded_instance_initial_state_dbs" {
      type="json"
      generate_resolver = true
    }
    column "shielded_instance_initial_state_keks" {
      type="json"
      generate_resolver = true
    }
  }


  column "metadata_items" {
    type="json"
    generate_resolver = true
  }
  column "guest_accelerators" {
    type="json"
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
    type="stringarray"
    generate_resolver = true
  }
  column "shielded_instance_initial_state_dbxs" {
    type="json"
    generate_resolver = true
  }
  column "shielded_instance_initial_state_dbs" {
    type="json"
    generate_resolver = true
  }
  column "shielded_instance_initial_state_keks" {
    type="json"
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
    type="stringarray"
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