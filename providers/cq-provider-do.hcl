service = "aws"
output_directory = "../cq-provider-digitalocean/resources"


resource "digitalocean" "" "droplets" {
  path = "github.com/digitalocean/godo.Droplet"

  relation "digitalocean" "" "neighbors" {
    path = ""
    userDefinedColumn "droplet_id" {
      type = "bigint"
      generate_resolver = true
    }
    userDefinedColumn "neighbor_id" {
      type = "bigint"
    }
  }
}

resource "digitalocean" "" "images" {
  path = "github.com/digitalocean/godo.Image"
}

resource "digitalocean" "" "actions" {
  path = "github.com/digitalocean/godo.Action"
}

resource "digitalocean" "" "account" {
  path = "github.com/digitalocean/godo.Account"
}

resource "digitalocean" "" "projects" {
  path = "github.com/digitalocean/godo.Project"

  relation "digitalocean" "" "resources" {
    path = "github.com/digitalocean/godo.ProjectResource"
  }
}

//resource "digitalocean" "" "apps" {
//  path = "github.com/digitalocean/godo.App"
//
//  relation "digitalocean" "" "tiers" {
//    path = "github.com/digitalocean/godo.AppTier"
//  }
//  relation "digitalocean" "" "regions" {
//    path = "github.com/digitalocean/godo.AppRegion"
//  }
//
//  relation "digitalocean" "" "instance_sizes" {
//    path = "github.com/digitalocean/godo.AppInstanceSize"
//  }
//}

resource "digitalocean" "" "balance" {
  path = "github.com/digitalocean/godo.Balance"
}

resource "digitalocean" "" "billing_history" {
  path = "github.com/digitalocean/godo.Balance"
}

resource "digitalocean" "" "invoices" {
  path = "github.com/digitalocean/godo.Invoice"
}

resource "digitalocean" "" "volumes" {
  path = "github.com/digitalocean/godo.Volume"
}

resource "digitalocean" "" "snapshots" {
  path = "github.com/digitalocean/godo.Snapshot"
}

resource "digitalocean" "" "regions" {
  path = "github.com/digitalocean/godo.Region"
}

resource "digitalocean" "" "vpc" {
  path = "github.com/digitalocean/godo.VPC"

  options {
    primary_keys = ["id"]
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-digitalocean/client.DeleteFilter"
  }

  relation "digitalocean" "" "member" {
    path = "github.com/digitalocean/godo.VPCMember"

    options {
      primary_keys = ["id"]
    }

    userDefinedColumn "type" {
      type = "string"
      resolver "ResolveResourceTypeFromUrn" {
        path = "github.com/cloudquery/cq-provider-digitalocean/client.ResolveResourceTypeFromUrn"
      }
    }
    userDefinedColumn "id" {
      type = "string"
      resolver "ResolveResourceIdFromUrn" {
        path = "github.com/cloudquery/cq-provider-digitalocean/client.ResolveResourceIdFromUrn"
      }
    }
  }
}


resource "digitalocean" "" "keys" {
  path = "github.com/digitalocean/godo.Key"
}

resource "digitalocean" "" "domains" {
  path = "github.com/digitalocean/godo.Domain"

  relation "digitalocean" "domain" "records" {
    path = "github.com/digitalocean/godo.DomainRecord"
  }
}


resource "digitalocean" "" "size" {
  path = "github.com/digitalocean/godo.Size"
}