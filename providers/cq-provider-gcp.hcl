service = "gcp"
output_directory = "../cq-provider-gcp/resources"
description_parser = "gcp"


resource "gcp" "kms" "keyrings" {
  path = "google.golang.org/api/cloudkms/v1.KeyRing"
  description = "A KeyRing is a toplevel logical grouping of CryptoKeys."
  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  deleteFilter "ProjectDeleteFilter" {
    path = "github.com/cloudquery/cq-provider-gcp/client.DeleteProjectFilter"
  }
  ignoreError "IgnoreError" {
    path = "github.com/cloudquery/cq-provider-gcp/client.IgnoreErrorHandler"
  }

  postResourceResolver "AddGcpMetadata" {
    path = "github.com/cloudquery/cq-provider-gcp/client.AddGcpMetadata"
  }
  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "labels" {
    description = "Labels for this resource"
  }
  column "primary_algorithm" {
    description = "The CryptoKeyVersionAlgorithm that this CryptoKeyVersion supports"
  }
  column "primary_attestation_format" {
    description = "The format of the attestation data"
  }
  column "create_time" {
    type = "timestamp"
    resolver "ISODateResolver" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
      path_resolver = true
    }
  }

  userDefinedColumn "location" {
    type = "string"
    description = "Location of the resource"
  }

  relation "gcp" "kms" "cryptoKey" {
    path = "google.golang.org/api/cloudkms/v1.CryptoKey"
    description = "A CryptoKey represents a logical key that can be used for cryptographic operations."

    postResourceResolver "PostResourceResolver" {
      path = "github.com/cloudquery/cq-provider-gcp/client.AddGcpMetadata"
    }
    ignoreError "IgnoreError" {
      path = "github.com/cloudquery/cq-provider-gcp/client.IgnoreErrorHandler"
    }

    column "create_time" {
      type = "timestamp"
      resolver "ISODateResolver" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
        path_resolver = true
      }
    }
    column "next_rotation_time" {
      type = "timestamp"
      resolver "ISODateResolver" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
        path_resolver = true
      }
    }
    column "primary_create_time" {
      type = "timestamp"
      resolver "ISODateResolver" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
        path_resolver = true
      }
    }
    column "primary_destroy_event_time" {
      type = "timestamp"
      resolver "ISODateResolver" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
        path_resolver = true
      }
    }
    column "primary_destroy_time" {
      type = "timestamp"
      resolver "ISODateResolver" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
        path_resolver = true
      }
    }
    column "primary_generate_time" {
      type = "timestamp"
      resolver "ISODateResolver" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
        path_resolver = true
      }
    }
    column "primary_import_time" {
      type = "timestamp"
      resolver "ISODateResolver" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
        path_resolver = true
      }
    }
    column "primary_protection_level" {
      description = "The ProtectionLevel describing how crypto operations are performed with this CryptoKeyVersion"
    }
    column "primary_state" {
      description = "The current state of the CryptoKeyVersion"
    }
    column "purpose" {
      description = "Immutable The immutable purpose of this CryptoKey"
    }
    column "version_template_algorithm" {
      description = "Algorithm to use when creating a CryptoKeyVersion based on this template"
    }
    column "version_template_protection_level" {
      description = "ProtectionLevel to use when creating a CryptoKeyVersion based on this template Immutable Defaults to SOFTWARE"
    }

    userDefinedColumn "project_id" {
      type = "string"
      description = "GCP Project Id of the resource"
      resolver "resolveResourceProject" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
      }
    }

    userDefinedColumn "location" {
      type = "string"
      description = "Location of the resource"
    }

    userDefinedColumn "policy" {
      type = "json"
      description = "Access control policy for a resource"
      generate_resolver = true
    }
  }
}

resource "gcp" "storage" "buckets" {
  path = "google.golang.org/api/storage/v1.Bucket"
  description = "The Buckets resource represents a bucket in Cloud Storage"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }
  deleteFilter "ProjectDeleteFilter" {
    path = "github.com/cloudquery/cq-provider-gcp/client.DeleteProjectFilter"
  }
  ignoreError "IgnoreError" {
    path = "github.com/cloudquery/cq-provider-gcp/client.IgnoreErrorHandler"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "default_event_based_hold" {
    description = "The default value for event-based hold on newly created objects in this bucket Event-based hold is a way to retain objects indefinitely until an event occurs, signified by the hold's release After being released, such objects will be subject to bucket-level retention"
  }

  column "storage_class" {
    description = "The bucket's default storage class, used whenever no storageClass is specified for a newly-created object This defines how objects in the bucket are stored and determines the SLA and the cost of storage Values include MULTI_REGIONAL, REGIONAL, STANDARD, NEARLINE, COLDLINE, ARCHIVE, and DURABLE_REDUCED_AVAILABILITY"
  }

  column "satisfies_p_z_s" {
    rename = "satisfies_pzs"
  }
  column "id" {
    type = "string"
    rename = "resource_id"
    description = "Original Id of the resource"
    resolver "ResolveResourceId" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveResourceId"
    }
  }

  relation "gcp" "storage" "acls" {
    path = "google.golang.org/api/storage/v1.BucketAccessControl"
    description = "Access controls on the bucket."
    column "id" {
      type = "string"
      rename = "resource_id"
      resolver "ResolveResourceId" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ResolveResourceId"
      }
    }
  }
  relation "gcp" "storage" "lifecycle_rules" {
    path = "google.golang.org/api/storage/v1.BucketLifecycleRule"
    description = "A lifecycle management rule, which is made of an action to take and the condition(s) under which the action will be taken."
  }
  relation "gcp" "storage" "cors" {
    path = "google.golang.org/api/storage/v1.BucketCors"
    description = "The bucket's Cross-Origin Resource Sharing (CORS) configuration."
  }

  relation "gcp" "storage" "bucket_policy" {
    path = "google.golang.org/api/storage/v1.Policy"
    column "id" {
      type = "string"
      description = "Original Id of the resource"
      rename = "resource_id"
    }
  }

  relation "gcp" "storage" "default_object_acls" {
    path = "google.golang.org/api/storage/v1.ObjectAccessControl"
    description = "Default access controls to apply to new objects when no ACL is provided."
    column "id" {
      type = "string"
      rename = "resource_id"
      resolver "ResolveResourceId" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ResolveResourceId"
      }
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
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "replica_configuration" {
    skip_prefix = true
  }

  column "replica_configuration_kind" {
    //    rename = "replica_configuration_kind"
    skip = true
  }

  column "settings_database_flags" {
    type = "json"
    generate_resolver = true
  }
  column "current_disk_size" {
    description = "The current disk usage of the instance in bytes This property has been deprecated by google API and might be null"
  }
  column "settings_replication_type" {
    description = "The type of replication this instance uses This can be either *ASYNCHRONOUS* or *SYNCHRONOUS*"
  }
  column "settings_backup_configuration_backup_retention_settings_retention_unit" {
    rename = "settings_backup_retention_settings_retention_unit"
  }

  column "settings_backup_configuration_backup_retention_settings_retained_backups" {
    rename = "settings_backup_retention_settings_retained_backups"
  }
  column "id" {
    description = "Original Id of the resource"
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
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "source_repository_url" {
    description = "The URL pointing to the hosted repository where the function is defined"
  }
  column "network" {
    description = "The VPC Network that this cloud function can connect to It can be either the fully-qualified URI, or the short name of the network resource"
  }
  column "max_instances" {
    description = "The limit on the maximum number of function instances that may coexist at a given time"
  }
  column "event_trigger_resource" {
    description = "The resource(s) from which to observe events"
  }
  column "event_trigger_event_type" {
    description = "The type of event to observe"
  }
  column "build_worker_pool" {
    description = "Name of the Cloud Build Custom Worker Pool that should be used to build the function"
  }
  column "id" {
    type = "string"
    rename = "resource_id"
  }
}

resource "gcp" "crm" "projects" {
  path = "google.golang.org/api/cloudresourcemanager/v3.Project"
  description = "A project is a high-level Google Cloud entity"

  column "id" {
    type = "string"
    rename = "resource_id"
  }

  column "labels" {
    description = "The labels associated with this project"
  }
}

resource "gcp" "iam" "service_accounts" {
  path = "google.golang.org/api/iam/v1.ServiceAccount"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }
  // deprecated
  column "etag" {
    skip = true
  }

  column "name" {
    description = "The resource name of the service account In one of the following formats: * `projects/{PROJECT_ID}/serviceAccounts/{EMAIL_ADDRESS}` OR `projects/{PROJECT_ID}/serviceAccounts/{UNIQUE_ID}` OR `projects/-/serviceAccounts/{UNIQUE_ID}"
  }

  relation "gcp" "iam" "service_account_keys" {
    path = "google.golang.org/api/iam/v1.ServiceAccountKey"

    column "private_key_data" {
      skip = true
    }

    column "public_key_data" {
      skip = true
    }

    column "private_key_type" {
      skip = true
    }

    column "valid_after_time" {
      type = "timestamp"
      resolver "ISODateResolver" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
        path_resolver = true
      }
    }

    column "valid_before_time" {
      type = "timestamp"
      resolver "ISODateResolver" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
        path_resolver = true
      }
    }
  }
}


resource "gcp" "iam" "roles" {
  path = "google.golang.org/api/iam/v1.Role"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "name" {
    description = "The name of the role"
  }
}

resource "gcp" "domains" "registration" {
  path = "google.golang.org/api/domains/v1beta1.Registration"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
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

  column "admin_contact_postal_address_address_lines" {
    description = "Unstructured address lines describing the lower levels of an address"
  }
  column "admin_contact_postal_address_postal_code" {
    description = "Postal code of the address Not all countries use or require postal codes to be present"
  }

  column "admin_contact_postal_address_administrative_area" {
    description = "Optional Highest administrative subdivision which is used for postal addresses of a country or region"
  }
  column "admin_contact_postal_address_language_code" {
    description = "Optional BCP-47 language code of the contents of this address (if known)"
  }
  column "admin_contact_postal_address_locality" {
    description = "Optional Generally refers to the city/town portion of the address"
  }
  column "admin_contact_postal_address_sorting_code" {
    description = "Optional Additional, country-specific, sorting code"
  }

  column "technical_contact_postal_address_address_lines" {
    description = "Unstructured address lines describing the lower levels of an address"
  }
  column "technical_contact_postal_address_administrative_area" {
    description = "Optional Highest administrative subdivision which is used for postal addresses of a country or region"
  }

  column "technical_contact_postal_address_language_code" {
    description = "Optional BCP-47 language code of the contents of this address (if known)"
  }
  column "technical_contact_postal_address_sorting_code" {
    description = "Optional Additional, country-specific, sorting code"
  }
  column "technical_contact_postal_address_postal_code" {
    description = "Postal code of the address Not all countries use or require postal codes to be present"
  }
  column "registrant_contact_postal_address_address_lines" {
    description = "Unstructured address lines describing the lower levels of an address"
  }
  column "registrant_contact_postal_address_administrative_area" {
    description = "Optional Highest administrative subdivision which is used for postal addresses of a country or region"

  }
  column "registrant_contact_postal_address_language_code" {
    description = "Optional BCP-47 language code of the contents of this address (if known)"
  }
  column "registrant_contact_postal_address_locality" {
    description = "Optional Generally refers to the city/town portion of the address"
  }
  column "registrant_contact_postal_address_sorting_code" {
    description = "Optional Additional, country-specific, sorting code"
  }
  column "registrant_contact_postal_address_postal_code" {
    description = "Postal code of the address Not all countries use or require postal codes to be present"
  }
}


resource "gcp" "compute" "instances" {
  path = "google.golang.org/api/compute/v1.Instance"
  description = "Represents an Instance resource  An instance is a virtual machine that is hosted on Google Cloud Platform For more information, read Virtual Machine Instances"
  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }
  column "name" {
    description = "Name of the resource provided by the client when the resource is created"
  }
  column "labels" {
    description = "Labels for this resource"
  }
  column "fingerprint" {
    description = "Specifies a fingerprint for this resource"
  }
  column "label_fingerprint" {
    description = "A fingerprint for the labels being applied to this image"
  }

  column "machine_type" {
    description = "Full or partial URL of the machine type resource to use for this instance, in the format: zones/zone/machineTypes/machine-type"
  }
  column "metadata_fingerprint" {
    description = "Specifies a fingerprint for this request"
  }
  column "tags_fingerprint" {
    description = "Specifies a fingerprint for this request, which is essentially a hash of the tags' contents and used for optimistic locking The fingerprint is initially generated by Compute Engine and changes after every request"
  }

  column "reservation_affinity_consume_reservation_type" {
    description = "Specifies the type of reservation from which this instance can consume resources: ANY_RESERVATION (default), SPECIFIC_RESERVATION, or NO_RESERVATION"
  }
  column "dxs" {
    type = "json"
    skip = true
  }
  column "dbs" {
    type = "json"
    skip = true
  }
  column "keks" {
    skip = true
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
    column "source_image" {
      description = "The source image to create this disk"
    }
    column "source_snapshot" {
      description = "The source snapshot to create this disk"
    }
    column "source" {
      description = "The source snapshot to create this disk"
    }
    column "disk_type" {
      description = "Specifies the disk type to use to create the instance"
    }
    column "source_storage_object" {
      description = "The full Google Cloud Storage URI where the disk image is stored"
    }

    column "creation_timestamp" {
      type = "timestamp"
      resolver "ISODateResolver" {
        path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
        path_resolver = true
      }
    }

    column "shielded_instance_initial_state_dbxs" {
      type = "json"
      skip = true
    }
    column "shielded_instance_initial_state_dbs" {
      type = "json"
      skip = true
    }
    column "shielded_instance_initial_state_keks" {
      type = "json"
      skip = true
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
  description = "Represents an Image resource  You can use images to create boot disks for your VM instances"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }
  column "name" {
    description = "Name of the resource"
  }

  column "label_fingerprint" {
    description = "A fingerprint for the labels being applied to this image"
  }
  column "labels" {
    description = "Labels for this resource"
  }
  column "raw_disk_sha1_checksum" {
    skip = true
  }
  column "license_codes" {
    skip = true
  }

  column "guest_os_features" {
    type = "stringarray"
    generate_resolver = true
  }
  column "shielded_instance_initial_state_dbxs" {
    skip = true
  }
  column "shielded_instance_initial_state_dbs" {
    skip = true
  }
  column "shielded_instance_initial_state_keks" {
    skip = true
  }

}

resource "gcp" "compute" "interconnects" {
  path = "google.golang.org/api/compute/v1.Interconnect"
  description = "Represents an Interconnect resource  An Interconnect resource is a dedicated connection between the GCP network and your on-premises network"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }
  column "name" {
    description = "Name of the resource Provided by the client when the resource is created"
  }


}

resource "gcp" "compute" "networks" {
  path = "google.golang.org/api/compute/v1.Network"
  description = "Represents a VPC Network resource  Networks connect resources to each other and to the internet"
  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }
  column "name" {
    description = "Name of the resource provided by the client when the resource is created"
  }
}

resource "gcp" "compute" "ssl_certificates" {
  path = "google.golang.org/api/compute/v1.SslCertificate"
  description = "Represents an SSL Certificate resource."
  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }
  column "name" {
    description = "Name of the resource provided by the client when the resource is created"
  }
}

resource "gcp" "compute" "subnetworks" {
  path = "google.golang.org/api/compute/v1.Subnetwork"
  description = "Represents a Subnetwork resource  A subnetwork (also known as a subnet) is a logical partition of a Virtual Private Cloud network with one primary IP range and zero or more secondary IP ranges"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }
  column "name" {
    description = "Name of the resource Provided by the client when the resource is created"
  }
  column "purpose" {
    description = "The purpose of the resource. This field can be either PRIVATE_RFC_1918 or INTERNAL_HTTPS_LOAD_BALANCER A subnetwork with purpose set to INTERNAL_HTTPS_LOAD_BALANCER is a user-created subnetwork that is reserved for Internal HTTP(S) Load Balancing If unspecified, the purpose defaults to PRIVATE_RFC_1918 The enableFlowLogs field isn't supported with the purpose field set to INTERNAL_HTTPS_LOAD_BALANCE"
  }
}

resource "gcp" "compute" "vpn_gateways" {
  path = "google.golang.org/api/compute/v1.VpnGateway"
  description = "Represents a HA VPN gateway  HA VPN is a high-availability (HA) Cloud VPN solution that lets you securely connect your on-premises network to your Google Cloud Virtual Private Cloud network through an IPsec VPN connection in a single region."

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "name" {
    description = "Name of the resource Provided by the client when the resource is created"
  }
  column "labels" {
    description = "Labels for this resource"
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
  description = "Represents a Forwarding Rule resource  Forwarding rule resources in GCP can be either regional or global."

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }


  column "metadata_filters" {
    type = "json"
    skip = true
  }

  column "service_directory_registrations" {
    skip = true
  }

  column "ip_address" {
    description = "IP address that this forwarding rule serves When a client sends traffic to this IP address, the forwarding rule directs the traffic to the target that you specify in the forwarding rule"
  }
  column "service_label" {
    description = "An optional prefix to the service name for this Forwarding Rule"
  }
  column "subnetwork" {
    description = "This field is only used for internal load balancing"
  }
  column "region" {
    description = "URL of the region where the regional forwarding rule resides"
  }
  column "label_fingerprint" {
    description = "A fingerprint for the labels being applied to this resource"
  }
  column "fingerprint" {
    description = "Fingerprint of this resource A hash of the contents stored in this object"
  }
  column "labels" {
    description = "Labels for this resource"
  }
  column "name" {
    description = "Name of the resource"
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
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }

  column "name" {
    description = "Name of the resource"
  }

  relation "gcp" "compute" "denied" {
    path = "google.golang.org/api/compute/v1.FirewallDenied"
    disable_pluralize = true
  }
  relation "gcp" "compute" "allowed" {
    path = "google.golang.org/api/compute/v1.FirewallAllowed"
    disable_pluralize = true
  }
}

resource "gcp" "compute" "disk_types" {
  path = "google.golang.org/api/compute/v1.DiskType"
  description = "Represents a Disk Type resource."

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
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
  description = "Represents a Persistent Disk resource."

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "id" {
    rename = "disk_id"
    resolver "resolveResourceId" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveResourceId"
    }
  }


  column "name" {
    description = "Name of the resource Provided by the client when the resource is created"
  }
  column "source_image" {
    description = "The source image used to create this disk"
  }
  column "size_gb" {
    description = "Size, in GB"
  }
  column "source_disk" {
    description = "The source disk used to create this disk"
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
  description = "Represents a Backend Service resource  A backend service defines how Google Cloud load balancers distribute traffic The backend service configuration contains a set of values, such as the protocol used to connect to backends, various distribution and session settings, health checks, and timeouts These settings provide fine-grained control over how your load balancer behaves."

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "enable_c_d_n" {
    rename = "enable_cdn"
  }
  column "cdn_policy_cache_mode" {
    description = "Specifies the cache setting for all responses from this backend"
  }
  column "cdn_policy_client_ttl" {
    description = "Specifies a separate client (eg browser client) maximum TTL"
  }
  column "cdn_policy_default_ttl" {
    description = "Specifies the default TTL for cached content served by this origin for responses that do not have an existing valid TTL"
  }
  column "cdn_negative_caching_policies" {
    type = "json"
    generate_resolver = true
  }
  column "cdn_policy_bypass_cache_on_request_headers" {
    type = "stringarray"
    generate_resolver = true
  }

  column "cdn_policy_negative_caching_policy" {
    type = "json"
    generate_resolver = true
  }

  column "id" {
    type = "string"
    rename = "resource_id"
  }

  relation "gcp" "compute" "backends" {
    path = "google.golang.org/api/compute/v1.Backend"
    column "group" {
      description = "The fully-qualified URL of an instance group or network endpoint group (NEG) resource The type of backend that a backend service supports depends on"
    }
  }
}

resource "gcp" "compute" "autoscalers" {
  path = "google.golang.org/api/compute/v1.Autoscaler"
  description = "Represents an Autoscaler resource."

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
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
  column "scale_in_control_max_scaled_in_replicas_calculated" {
    description = "Absolute value of VM instances calculated based on the specific mode "
  }

  relation "gcp" "compute" "custom_metric_utilizations" {
    path = "google.golang.org/api/compute/v1.AutoscalingPolicyCustomMetricUtilization"

    column "filter" {
      description = "A filter string, compatible with a Stackdriver Monitoring filter string"
    }
    column "single_instance_assignment" {
      description = "per-group metric value that represents the total amount of work to be done or resource usage"
    }
  }
}

resource "gcp" "compute" "addresses" {
  path = "google.golang.org/api/compute/v1.Address"
  description = "Addresses for GFE-based external HTTP(S) load balancers."

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "name" {
    description = "Name of the resource Provided by the client when the resource is created"
  }
  column "network_tier" {
    description = "This signifies the networking tier used for configuring this address"
  }
  column "id" {
    rename = "address_id"
    type = "string"
    resolver "resolveResourceId" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveResourceId"
    }
  }
}


resource "gcp" "bigquery" "datasets" {
  path = "google.golang.org/api/bigquery/v2.Dataset"
  description = "dataset resources in the project"
  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }

  userDefinedColumn "project_id" {
    type = "string"
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    type = "string"
    rename = "dataset_id"
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
    description = "Which resources in the dataset this entry applies to."
    generate_resolver = true
  }
}

resource "gcp" "bigquery" "dataset_tables" {
  path = "google.golang.org/api/bigquery/v2.Table"
  description = "Model options used for the first training run These options are immutable for subsequent training runs Default values are used for any options not specified in the input query"
  limit_depth = 1
  column "schema" {
    type = "json"
    generate_resolver = true
  }

  userDefinedColumn "dataset_id" {
    type = "uuid"
    description = ""
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.ParentIdResolver"
    }
  }

  column "external_data_configuration_schema" {
    type = "json"
    generate_resolver = true
  }

  column "id" {
    rename = "table_id"
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
  column "external_data_configuration_ignore_unknown_values" {
    description = "Indicates if BigQuery should allow extra values that are not represented in the table schema"
  }
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

  relation "gcp" "bigquery" "user_defined_functions" {
    path = "google.golang.org/api/bigquery/v2.UserDefinedFunctionResource"
    description = "This is used for defining User Defined Function (UDF) resources only when using legacy SQL"
  }
  relation "gcp" "bigquery" "training_runs" {
    path = "google.golang.org/api/bigquery/v2.BqmlTrainingRun"
    description = "Training options used by this training run These options are mutable for subsequent training runs"
  }


}


resource "gcp" "compute" "projects" {
  path = "google.golang.org/api/compute/v1.Project"
  description = "Represents a Project resource which is used to organize resources in a Google Cloud Platform environment"

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
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "creation_timestamp" {
    type = "timestamp"
    resolver "ISODateResolver" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
      path_resolver = true
    }
  }

  column "common_instance_metadata_fingerprint" {
    description = "Specifies a fingerprint for this resource"
  }

  column "name" {
    description = "The project ID For example: my-example-project"
  }

  column "usage_export_location_bucket_name" {
    description = "The name of an existing bucket in Cloud Storage where the usage report object is stored"
  }

  column "usage_export_location_report_name_prefix" {
    description = "An optional prefix for the name of the usage report object stored in bucketName"
  }

  column "id" {
    type = "string"
    rename = "compute_project_id"
    resolver "resolveResourceId" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveResourceId"
    }
  }

  column "common_instance_metadata_items" {
    type = "json"
    generate_resolver = true
  }
}


resource "gcp" "compute" "target_ssl_proxies" {
  path = "google.golang.org/api/compute/v1.TargetSslProxy"
  description = "Represents a Target SSL Proxy resource"
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
    description = "GCP Project Id of the resource"
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "creation_timestamp" {
    type = "timestamp"
    resolver "ISODateResolver" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
      path_resolver = true
    }
  }
  column "name" {
    description = "Name of the resource"
  }
  column "description" {
    description = "An optional description of this resource"
  }
  column "id" {
    type = "string"
    rename = "ssl_proxy_id"
    resolver "resolveResourceId" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveResourceId"
    }
  }
}

resource "gcp" "compute" "target_https_proxies" {
  path = "google.golang.org/api/compute/v1.TargetHttpsProxy"
  description = "Represents a Target HTTPS Proxy resource"

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
    description = "GCP Project Id of the resource"
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "description" {
    description = "An optional description of this resource"
  }
  column "fingerprint" {
    description = "Fingerprint of this resource"
  }
  column "creation_timestamp" {
    type = "timestamp"
    resolver "ISODateResolver" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
      path_resolver = true
    }
  }

  column "name" {
    description = "Name of the resource"
  }
  column "id" {
    type = "string"
    rename = "https_proxy_id"
    resolver "resolveResourceId" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveResourceId"
    }
  }

}


resource "gcp" "compute" "ssl_policies" {
  path = "google.golang.org/api/compute/v1.SslPolicy"
  description = "Represents an SSL Policy resource"
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
    description = "GCP Project Id of the resource"
    type = "string"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "kind" {
    description = "Type of the resource Always compute#sslPolicy for SSL policies"
  }
  column "description" {
    description = "An optional description of this resource"
  }
  column "fingerprint" {
    description = "Fingerprint of this resource"
  }
  column "creation_timestamp" {
    type = "timestamp"
    resolver "ISODateResolver" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
      path_resolver = true
    }
    generate_resolver = true
  }

  column "name" {
    description = "Name of the resource"
  }
  column "id" {
    type = "string"
    rename = "ssl_policy_id"
    resolver "resolveResourceId" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveResourceId"
    }
  }

  relation "gcp" "compute" "ssl_policy_warnings" {
    path = "google.golang.org/api/compute/v1.SslPolicyWarnings"

    column "data" {
      type = "json"
      generate_resolver = true
    }
  }
}

resource "gcp" "dns" "managed_zones" {
  path = "google.golang.org/api/dns/v1.ManagedZone"

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
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }
  column "name" {
    description = "User assigned name for this resource"
  }
  column "labels" {
    description = "User assigned labels for this resource"
  }
  column "name_server_set" {
    description = "specifies the NameServerSet for this ManagedZone"
  }

  column "kind" {
    description = "The resource type"
  }
  column "id" {
    type = "string"
    rename = "managed_zone_id"
    resolver "resolveResourceId" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveResourceId"
    }
  }
}


resource "gcp" "dns" "policies" {
  path = "google.golang.org/api/dns/v1.Policy"

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
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "kind" {
    description = "The resource type"
  }

  column "id" {
    type = "string"
    rename = "policy_id"
    resolver "resolveResourceId" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveResourceId"
    }
  }

  column "alternative_name_server_config_target_name_servers" {
    rename = "alternative_name_server_target_name_servers"
  }
  column "alternative_name_server_config_kind" {
    description = "alternative name server type"
  }

  relation "gcp" "dns" "alternative_name_servers" {
    path = "google.golang.org/api/dns/v1.PolicyAlternativeNameServerConfigTargetNameServer"
    column "kind" {
      description = "The resource type"
    }
  }
  relation "gcp" "dns" "policy_networks" {
    path = "google.golang.org/api/dns/v1.PolicyNetwork"
    column "kind" {
      description = "The resource type"
    }
  }
}


resource "gcp" "logging" "metrics" {
  path = "google.golang.org/api/logging/v2.LogMetric"

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
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  //todo float64 array
  column "bucket_options_explicit_buckets_bounds" {
    skip = true
  }

  column "bucket_options_exponential_buckets_growth_factor" {
    rename = "exponential_buckets_options_growth_factor"
  }

  column "bucket_options_exponential_buckets_num_finite_buckets" {
    rename = "exponential_buckets_options_num_finite_buckets"
  }

  column "bucket_options_exponential_buckets_scale" {
    rename = "exponential_buckets_options_scale"
  }

  column "bucket_options_linear_buckets_num_finite_buckets" {
    rename = "linear_buckets_options_num_finite_buckets"
  }

  column "bucket_options_linear_buckets_offset" {
    rename = "linear_buckets_options_offset"
  }

  column "bucket_options_linear_buckets_width" {
    rename = "linear_buckets_options_width"
  }

  column "metric_descriptor_launch_stage" {
    description = "The launch stage of the metric definition"
  }
  // deprecated
  column "metric_descriptor_metadata_launch_stage" {
    skip = true
  }
  column "id" {
    rename = "metric_id"
    description = "Id of the logging metric"
  }
}


resource "gcp" "monitoring" "alert_policies" {
  path = "google.golang.org/api/monitoring/v3.AlertPolicy"

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
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "name" {
    description = "The resource name for this policy"
  }
  column "id" {
    rename = "alert_policy_id"
  }

  column "mutation_record_mutate_time" {
    rename = "mutate_time"
  }

  column "user_labels" {
    rename = "labels"
    description = "Labels for this resource"
  }
  column "mutation_record_mutated_by" {
    rename = "mutated_by"
  }

  //todo array of []byte, maybe tore it as array of strings(base64)
  column "validity_details" {
    skip = true
  }

  relation "gcp" "monitoring" "alert_policy_conditions" {
    path = "google.golang.org/api/monitoring/v3.Condition"

    column "condition_absent_duration" {
      rename = "absent_duration"
    }

    column "condition_absent_filter" {
      rename = "absent_filter"
    }
    column "condition_absent_trigger_count" {
      rename = "absent_trigger_count"
    }

    column "condition_absent_trigger_percent" {
      rename = "absent_trigger_percent"
    }

    column "condition_monitoring_query_language_duration" {
      rename = "monitoring_query_language_duration"
    }

    column "condition_monitoring_query_language_query" {
      rename = "monitoring_query_language_query"
    }

    column "condition_monitoring_query_language_trigger_count" {
      rename = "monitoring_query_language_trigger_count"
    }

    column "condition_monitoring_query_language_trigger_percent" {
      rename = "monitoring_query_language_trigger_percent"
    }

    column "condition_threshold_comparison" {
      rename = "threshold_comparison"
    }

    column "condition_threshold_denominator_filter" {
      rename = "threshold_denominator_filter"
    }

    column "condition_threshold_duration" {
      rename = "threshold_duration"
    }

    column "condition_threshold_filter" {
      rename = "threshold_filter"
    }

    column "condition_threshold_denominator_filter" {
      rename = "threshold_denominator_filter"
    }


    column "condition_threshold_threshold_value" {
      rename = "threshold_value"
    }

    column "condition_threshold_trigger_count" {
      rename = "threshold_trigger_count"
    }

    column "condition_threshold_trigger_percent" {
      rename = "threshold_trigger_percent"
    }

    column "condition_threshold_aggregations" {
      rename = "threshold_aggregations"
    }

    column "condition_absent_aggregations" {
      rename = "absent_aggregations"
    }

    column "condition_threshold_denominator_aggregations" {
      rename = "denominator_aggregations"
    }
  }
}


resource "gcp" "logging" "sinks" {
  path = "google.golang.org/api/logging/v2.LogSink"

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
    description = "GCP Project Id of the resource"
    resolver "resolveResourceProject" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveProject"
    }
  }

  column "id" {
    rename = "sink_id"
    description = "Id of the logging sink"
    type = "string"
    resolver "ResolveResourceId" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ResolveResourceId"
    }
  }
}


resource "gcp" "resource_manager" "projects" {
  path = "google.golang.org/api/cloudresourcemanager/v3.Project"

  multiplex "ProjectMultiplex" {
    path = "github.com/cloudquery/cq-provider-gcp/client.ProjectMultiplex"
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-gcp/client.DeleteProjectFilter"
  }
  ignoreError "IgnoreError" {
    path = "github.com/cloudquery/cq-provider-gcp/client.IgnoreErrorHandler"
  }

  column "create_time" {
    type = "timestamp"
    resolver "ISODateResolver" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
      path_resolver = true
    }
  }

  column "delete_time" {
    type = "timestamp"
    resolver "ISODateResolver" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
      path_resolver = true
    }
  }

  column "update_time" {
    type = "timestamp"
    resolver "ISODateResolver" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
    }
  }
  column "labels" {
    description = "The labels associated with this project"
  }
  userDefinedColumn "policy" {
    type = "json"
    description = "Access control policy for a resource"
    generate_resolver = true
  }
}


resource "gcp" "resource_manager" "folders" {
  path = "google.golang.org/api/cloudresourcemanager/v3.Folder"

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

  column "create_time" {
    type = "timestamp"
    resolver "ISODateResolver" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
      path_resolver = true
    }
  }

  column "delete_time" {
    type = "timestamp"
    resolver "ISODateResolver" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
      path_resolver = true
    }
  }

  column "update_time" {
    type = "timestamp"
    resolver "ISODateResolver" {
      path = "github.com/cloudquery/cq-provider-gcp/client.ISODateResolver"
      path_resolver = true
    }
  }

  userDefinedColumn "policy" {
    type = "json"
    description = "Access control policy for a resource"
    generate_resolver = true
  }
}

resource "gcp" "compute" "url_maps" {
  path = "google.golang.org/api/compute/v1.UrlMap"
  description = "Represents a URL Map resource"

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

  options {
    primary_keys = [
      "project_id",
      "id"]
  }

  column "default_route_action" {
    skip_prefix = true
  }

  column "header_action_request_headers_to_add" {
    type = "json"
    generate_resolver = true
  }

  column "header_action_response_headers_to_add" {
    type = "json"
    generate_resolver = true
  }

  relation "gcp" "compute" "url_map_weighted_backend_services" {
    path = "google.golang.org/api/compute/v1.WeightedBackendService"

    column "header_action" {
      type = "json"
      generate_resolver = true
    }
  }

  column "retry_policy_retry_conditions" {
    description = "Specfies one or more conditions when this retry rule applies"
  }

  column "default_service" {
    description = "The full or partial URL of the defaultService resource to which traffic is directed"
  }

  column "default_url_redirect_https_redirect" {
    description = "If set to true, the URL scheme in the redirected request is set to https If set to false, the URL scheme of the redirected request will remain the same as that of the request"
  }

  column "default_url_redirect_path_redirect" {
    description = "The path that will be used in the redirect response instead of the one that was supplied in the request"
  }

  relation "gcp" "compute" "url_map_path_matchers" {
    path = "google.golang.org/api/compute/v1.PathMatcher"

    column "path_rules" {
      type = "json"
      generate_resolver = true
    }

    column "header_action" {
      type = "json"
      generate_resolver = true
    }

    column "default_route_action" {
      type = "json"
      generate_resolver = true
    }

    column "route_rules" {
      type = "json"
      generate_resolver = true
    }
  }

  relation "gcp" "compute" "url_map_tests" {
    path = "google.golang.org/api/compute/v1.UrlMapTest"

    column "headers" {
      type = "json"
      generate_resolver = true
    }
  }


  limit_depth = 2
}





