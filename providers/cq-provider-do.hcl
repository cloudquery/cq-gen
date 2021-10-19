service = "aws"
output_directory = "../cq-provider-digitalocean/resources"

description_source "openapi" {
#  https://github.com/digitalocean/openapi/blob/main/specification/DigitalOcean-public.v2.yaml
  path = "../../DigitalOcean-public.v2.yaml"
}


resource "digitalocean" "" "droplets" {

  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }

  options {
    primary_keys = [
      "id"]
  }
  path = "github.com/digitalocean/godo.Droplet"

  column "next_backup_window_start_time" {
    description = "A time value given in ISO8601 combined date and time format specifying the start of the Droplet's backup window."
  }
  column "next_backup_window_end_time" {
    description = "A time value given in ISO8601 combined date and time format specifying the end of the Droplet's backup window."

  }
  relation "digitalocean" "" "neighbors" {
    description = "Droplets that are co-located on the same physical hardware"
    path = ""
    userDefinedColumn "droplet_id" {
      description = "Unique identifier of the droplet associated with the neighbor droplet."
      type = "bigint"
    }
    userDefinedColumn "neighbor_id" {
      description = "Droplet neighbor identifier that exists on same the same physical hardware as the droplet."
      type = "bigint"
    }
  }

  relation "digitalocean" "" "networks_v6" {
    column "ip_address" {
      type = "cidr"
      resolver "Resolver" {
        path = "github.com/cloudquery/cq-provider-sdk/provider/schema.IPNetResolver"
        path_resolver = true
      }
    }
    column "netmask" {
      type = "cidr"
      resolver "Resolver" {
        path = "github.com/cloudquery/cq-provider-sdk/provider/schema.IPNetResolver"
        path_resolver = true
      }
    }
    column "gateway" {
      type = "cidr"
      resolver "Resolver" {
        path = "github.com/cloudquery/cq-provider-sdk/provider/schema.IPNetResolver"
        path_resolver = true
      }
    }
  }

  relation "digitalocean" "" "networks_v4" {
    column "ip_address" {
      type = "cidr"
      resolver "Resolver" {
        path = "github.com/cloudquery/cq-provider-sdk/provider/schema.IPNetResolver"
        path_resolver = true
      }
    }
    column "netmask" {
      type = "cidr"
      resolver "Resolver" {
        path = "github.com/cloudquery/cq-provider-sdk/provider/schema.IPNetResolver"
        path_resolver = true
      }
    }
    column "gateway" {
      type = "cidr"
      resolver "Resolver" {
        path = "github.com/cloudquery/cq-provider-sdk/provider/schema.IPNetResolver"
        path_resolver = true
      }
    }
  }
}


resource "digitalocean" "" "vpc" {
  path = "github.com/digitalocean/godo.VPC"

  options {
    primary_keys = [
      "id"]
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }

  column "region_slug" {
    description = "The slug identifier for the region where the VPC will be created."
  }

  column "ip_range" {
    type = "inet"
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.IPAddressResolver"
      path_resolver = true
    }
  }

  relation "digitalocean" "" "member" {
    path = "github.com/digitalocean/godo.VPCMember"
    description = "Resources that are members of a VPC."
    options {
      primary_keys = [
        "id"]
    }

    userDefinedColumn "type" {
      type = "string"
      description = "The resource type of the URN associated with the VPC.."
      resolver "ResolveResourceTypeFromUrn" {
        path = "github.com/cloudquery/cq-provider-digitalocean/client.ResolveResourceTypeFromUrn"
      }
    }
    userDefinedColumn "id" {
      type = "string"
      description = "A unique ID that can be used to identify the resource that is a member of the VPC."
      resolver "ResolveResourceIdFromUrn" {
        path = "github.com/cloudquery/cq-provider-digitalocean/client.ResolveResourceIdFromUrn"
      }
    }
  }
}

resource "digitalocean" "" "regions" {
  path = "github.com/digitalocean/godo.Region"
  options {
    primary_keys = [
      "slug"]
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
}

resource "digitalocean" "" "size" {
  path = "github.com/digitalocean/godo.Size"
  options {
    primary_keys = [
      "slug"]
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
}

resource "digitalocean" "" "keys" {
  path = "github.com/digitalocean/godo.Key"
  options {
    primary_keys = [
      "id"]
  }
  column "id" {
    description = "A unique identification number for this key. Can be used to embed specific SSH key into a Droplet."
  }
  column "public_key" {
    description = "The entire public key string that was uploaded. Embedded into the root user's `authorized_keys` file if you include this key during Droplet creation."
  }

  column "fingerprint" {
    description = "A unique identifier that differentiates this key from other keys using a format that SSH recognizes. The fingerprint is created when the key is added to your account."
  }

  column "name" {
    description = "A human-readable display name for this key, used to easily identify the SSH keys when they are displayed."
  }

  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
}

resource "digitalocean" "" "snapshots" {
  path = "github.com/digitalocean/godo.Snapshot"
  options {
    primary_keys = [
      "id"]
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
}

resource "digitalocean" "" "projects" {
  path = "github.com/digitalocean/godo.Project"
  options {
    primary_keys = [
      "id"]
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
  relation "digitalocean" "" "resources" {
    path = "github.com/digitalocean/godo.ProjectResource"
  }
}

resource "digitalocean" "" "account" {
  path = "github.com/digitalocean/godo.Account"
  options {
    primary_keys = [
      "uuid"]
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
}

resource "digitalocean" "" "domains" {
  path = "github.com/digitalocean/godo.Domain"
  options {
    primary_keys = [
      "name"]
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
  relation "digitalocean" "" "domain_records" {
    path = "github.com/digitalocean/godo.DomainRecord"
    options {
      primary_keys = [
        "id"]
    }
  }
}

resource "digitalocean" "" "volumes" {
  path = "github.com/digitalocean/godo.Volume"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
  options {
    primary_keys = [
      "id"]
  }
  description_path_parts = ["volume_full"]

  relation "digitalocean" "" "droplets" {
    description = "Droplets that are co-located on the same physical hardware"
    path = ""
    userDefinedColumn "droplet_id" {
      description = "Unique identifier of Droplet the volume is attached to."
      type = "bigint"
    }
    userDefinedColumn "volume_id" {
      description = "The unique identifier for the block storage volume."
      type = "bigint"
    }
  }

}

resource "digitalocean" "" "balance" {
  path = "github.com/digitalocean/godo.Balance"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
  options {
    primary_keys = [
      "generated_at"]
  }
}

resource "digitalocean" "" "images" {
  path = "github.com/digitalocean/godo.Image"
  options {
    primary_keys = [
      "id"]
  }
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
}

resource "digitalocean" "" "billing_history" {
  path = "github.com/digitalocean/godo.BillingHistoryEntry"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
  description_path_parts = ["billing_history"]
}


resource "digitalocean" "" "databases" {
  path = "github.com/digitalocean/godo.Database"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
  options {
    primary_keys = [
      "id"]
  }
  column "version_slug" {
    description = "A string representing the version of the database engine in use for the cluster."
    rename = "version"
  }
  column "engine_slug" {
    description = "A slug representing the database engine used for the cluster. The possible values are: \"pg\" for PostgreSQL, \"mysql\" for MySQL, \"redis\" for Redis, and \"mongodb\" for MongoDB."
    rename = "engine"
  }

  relation "digitalocean" "" "users" {
    column "password" {
      skip = true
    }
  }

  relation "digitalocean" "" "database_backups" {
    path = "github.com/digitalocean/godo.DatabaseBackup"
    description_path_parts = ["backup"]
  }

  relation "digitalocean" "" "database_replicas" {
    path = "github.com/digitalocean/godo.DatabaseReplica"
    description_path_parts = ["database_replica"]
  }

  relation "digitalocean" "" "firewall_rules" {
    path = "github.com/digitalocean/godo.DatabaseFirewallRule"
    description_path_parts = ["firewall_rule"]
  }
  description_path_parts = ["database_cluster"]
}

resource "digitalocean" "" "cdn" {
  path = "github.com/digitalocean/godo.CDN"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
  options {
    primary_keys = [
      "id"]
  }
  description_path_parts = ["cdn_endpoint"]
}

resource "digitalocean" "" "certificates" {
  path = "github.com/digitalocean/godo.Certificate"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
  options {
    primary_keys = [
      "id"]
  }
}


resource "digitalocean" "" "alert_policies" {
  path = "github.com/digitalocean/godo.AlertPolicy"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }

  column "uuid" {
    rename = "id"
    type = "uuid"
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.UUIDResolver"
      path_resolver = true
    }
  }

  options {
    primary_keys = [
      "id"]
  }
}

resource "digitalocean" "" "registry" {
  path = "github.com/digitalocean/godo.Registry"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }
  options {
    primary_keys = [
      "name"]
  }

  relation "digitalocean" "" "repositories" {
    path = "github.com/digitalocean/godo.Repository"
    deleteFilter "DeleteFilter" {
      path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
    }
    options {
      primary_keys = [
        "id"]
    }
    description_path_parts = ["repository"]
  }

  description_path_parts = ["registry"]
}

resource "digitalocean" "" "floating_ips" {
  path = "github.com/digitalocean/godo.FloatingIP"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }

  column "ip" {
    type = "cidr"
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.IPNetResolver"
      path_resolver = true
    }
  }

  column "droplet" {
    skip = true
  }

  userDefinedColumn "droplet_id" {
    description = "Unique identifier of Droplet assigned the floating ip."
    type = "bigint"
  }

  options {
    primary_keys = [
      "ip"]
  }
  description_path_parts = ["floating_ip"]
}

resource "digitalocean" "" "load_balancers" {
  path = "github.com/digitalocean/godo.LoadBalancer"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }

  column "size_slug" {
    description = "The size of the load balancer. The available sizes are lb-small, lb-medium, or lb-large. You can resize load balancers after creation up to once per hour. You cannot resize a load balancer within the first hour of its creation"
    rename = "size"
  }

  column "ip" {
    type = "cidr"
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.IPNetResolver"
      path_resolver = true
    }
  }

  column "id" {
    type = "uuid"
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.UUIDResolver"
      path_resolver = true
    }
  }


  relation "digitalocean" "" "droplets" {
    description = "Droplets that are co-located on the same physical hardware"
    path = ""
    userDefinedColumn "droplet_id" {
      description = "Unique identifier of Droplet assigned to the load balancer."
      type = "bigint"
    }
    userDefinedColumn "load_balancer_id" {
      description = "The unique identifier for the load balancer."
      type = "uuid"
    }
  }

  options {
    primary_keys = [
      "id"]
  }
  description_path_parts = ["load_balancer"]
}

resource "digitalocean" "" "firewalls" {
  path = "github.com/digitalocean/godo.Firewall"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }

  column "id" {
    type = "uuid"
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.UUIDResolver"
      path_resolver = true
    }
  }

  relation "digitalocean" "" "droplets" {
    description = "IDs of the Droplets assigned to the firewall"
    path = ""
    userDefinedColumn "droplet_id" {
      description = "Unique identifier of Droplet assigned to the firewall."
      type = "bigint"
    }
    userDefinedColumn "firewall_id" {
      description = "The unique identifier for the firewall."
      type = "uuid"
    }
  }

  options {
    primary_keys = [
      "id"]
  }
  description_path_parts = ["firewall"]
}


resource "digitalocean" "" "kubernetes" {
  path = "github.com/digitalocean/godo.KubernetesCluster"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }

  column "id" {
    type = "uuid"
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.UUIDResolver"
      path_resolver = true
    }
  }

  options {
    primary_keys = [
      "id"]
  }
  description_path_parts = ["kubernetes_node_pool"]

  relation "digitalocean" "" "upgrades" {
    path = "github.com/digitalocean/godo.KubernetesVersion"
    deleteFilter "DeleteFilter" {
      path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
    }
    options {
      primary_keys = [
        "id"]
    }
    description_path_parts = ["kubernetes_version"]
  }

  relation "digitalocean" "" "users" {
    path = "github.com/digitalocean/godo.KubernetesClusterUser"
    deleteFilter "DeleteFilter" {
      path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
    }
    options {
      primary_keys = [
        "id"]
    }
    description_path_parts = ["user", "kubernetes_cluster_user"]
  }

  relation "digitalocean" "" "clusterlint" {
    path = "github.com/digitalocean/godo.ClusterlintDiagnostic"
    deleteFilter "DeleteFilter" {
      path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
    }
    options {
      primary_keys = [
        "id"]
    }
    description_path_parts = ["clusterlint_results"]
  }
}

resource "digitalocean" "" "apps" {
  path = "github.com/digitalocean/godo.App"
  deleteFilter "DeleteFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }

  column "id" {
    type = "uuid"
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.UUIDResolver"
      path_resolver = true
    }
  }
  options {
    primary_keys = [
      "id"]
  }

  column "spec" {
    type = "json"
    generate_resolver = true
  }
  column "active_deployment" {
    type = "json"
    generate_resolver = true
  }
  column "in_progress_deployment" {
    type = "json"
    generate_resolver = true
  }

  column "domains" {
    type = "json"
    generate_resolver = true
  }
}