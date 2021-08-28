service = "aws"
output_directory = "../cq-provider-digitalocean/resources"

description_source "openapi" {
  path = "./providers/DigitalOcean-public.v2.yaml"
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


