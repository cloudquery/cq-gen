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

resource "k8s" "core" "nodes" {
  path = "k8s.io/api/core/v1.Node"

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

  # Spec fields
  column "spec" {
    skip_prefix = true
  }

  column "pod_c_id_r" {
    rename = "pod_cidr"
  }

  column "pod_c_id_rs" {
    rename = "pod_cidrs"
  }

  column "taints" {
    type = "json"
    generate_resolver = true
  }

  # Status fields
  column "status" {
    skip_prefix = true
  }

  column "node_info" {
    skip_prefix = true
  }

  column "conditions" {
    type = "json"
    generate_resolver = true
  }

  column "volumes_attached" {
    type = "json"
    generate_resolver = true
  }

  column "images" {
    type = "json"
    generate_resolver = true
  }

  column "config" {
    type = "json"
    generate_resolver = true
  }
}
