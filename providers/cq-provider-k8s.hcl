service = "k8s"
output_directory = "../cq-provider-k8s/resources"

#description_source "openapi" {
#  #  https://github.com/digitalocean/openapi/blob/main/specification/DigitalOcean-public.v2.yaml
#  path = "C:\\Users\\Ron-Work\\Downloads\\k8s_openapi.yml"
#}

resource "k8s" "core" "namespaces" {
  path = "k8s.io/api/core/v1.Namespace"

  options {
    primary_keys = ["uid"]
  }

  multiplex "ContextMultiplex" {
    path = "github.com/cloudquery/cq-provider-k8s/client.ContextMultiplex"
  }
  deleteFilter "DeleteContextFilter" {
    path = "github.com/cloudquery/cq-provider-k8s/client.DeleteContextFilter"
  }

  column "type_meta" {
    skip_prefix = true
  }

  column "object_meta" {
    skip_prefix = true
  }

  column "owner_references" {
    type = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type = "json"
    generate_resolver = true
  }

  column "spec_finalizers" {
    rename = "finalizers"
  }
  column "status_phase" {
    rename = "phase"
  }
  column "status_conditions" {
    type = "json"
    rename = "conditions"
    generate_resolver = true
  }

  relation "k8s" "" "owner_references" {
    options {
      primary_keys = ["resource_uid", "uid"]
    }
    path = "k8s.io/apimachinery/pkg/apis/meta/v1.OwnerReference"

    resolver "OwnerReferenceResolver"{
      path = "github.com/cloudquery/cq-provider-k8s/client.OwnerReferenceResolver"
    }
    userDefinedColumn "resource_uid" {
      type = "string"
      description = "resources this owner object references"
    }
    column "uid" {
      rename = "owner_uid"
    }
  }

}


resource "k8s" "apps" "deployments" {
  path = "k8s.io/api/apps/v1.Deployment"

  multiplex "ContextMultiplex" {
    path = "github.com/cloudquery/cq-provider-k8s/client.ContextMultiplex"
  }
  deleteFilter "DeleteContextFilter" {
    path = "github.com/cloudquery/cq-provider-k8s/client.DeleteContextFilter"
  }

  options {
    primary_keys = ["uid"]
  }


  column "type_meta" {
    skip_prefix = true
  }

  column "object_meta" {
    skip_prefix = true
  }
  // Skip owner references
  column "owner_references" {
    skip = true
  }
  column "managed_fields" {
    type = "json"
    generate_resolver = true
  }

  relation "k8s" "" "owner_references" {
    path = "k8s.io/apimachinery/pkg/apis/meta/v1.OwnerReference"

    userDefinedColumn "resource_uid" {
      type = "string"
    }
    column "uid" {
      rename = "owner_uid"
    }
  }

  // Skip owner references
  column "object_meta_owner_references" {
    skip = true
  }

  column "spec" {
    skip = true
  }

  column "status" {
    type = "json"
    generate_resolver = true
  }
}