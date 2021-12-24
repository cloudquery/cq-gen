service          = "k8s"
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
    type              = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }

  column "spec_finalizers" {
    rename = "finalizers"
  }
  column "status_phase" {
    rename = "phase"
  }
  column "status_conditions" {
    type              = "json"
    rename            = "conditions"
    generate_resolver = true
  }

  relation "k8s" "" "owner_references" {
    options {
      primary_keys = ["resource_uid", "uid"]
    }
    path = "k8s.io/apimachinery/pkg/apis/meta/v1.OwnerReference"

    resolver "OwnerReferenceResolver" {
      path = "github.com/cloudquery/cq-provider-k8s/client.OwnerReferenceResolver"
    }
    userDefinedColumn "resource_uid" {
      type        = "string"
      description = "resources this owner object references"
    }
    column "uid" {
      rename = "owner_uid"
    }
  }

}


resource "k8s" "core" "limit_ranges" {
  path = "k8s.io/api/core/v1.LimitRange"

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

  column "spec" {
    skip_prefix = true
  }

  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }
}


resource "k8s" "core" "resource_quotas" {
  path = "k8s.io/api/core/v1.ResourceQuota"

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

  column "spec" {
    skip_prefix = true
  }

  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }
}


resource "k8s" "core" "endpoints" {
  path = "k8s.io/api/core/v1.Endpoints"

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

  column "subsets" {
    skip_prefix = true
  }

  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }
}


resource "k8s" "core" "service_accounts" {
  path = "k8s.io/api/core/v1.ServiceAccount"

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

  column "secrets" {
    skip_prefix = true
  }

  column "image_pull_secrets" {
    skip_prefix = true
  }

  column "automount_service_account_token" {
    skip_prefix = true
  }

  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type              = "json"
    generate_resolver = true
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

  column "object_meta" {
    skip_prefix = true
  }
  column "type_meta" {
    skip_prefix = true
  }
  column "spec" {
    skip_prefix = true
  }
  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }
  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }
  column "template" {
    type              = "json"
    generate_resolver = true
  }
}


resource "k8s" "batch" "cron_jobs" {
  path = "k8s.io/api/batch/v1.CronJob"

  multiplex "ContextMultiplex" {
    path = "github.com/cloudquery/cq-provider-k8s/client.ContextMultiplex"
  }
  deleteFilter "DeleteContextFilter" {
    path = "github.com/cloudquery/cq-provider-k8s/client.DeleteContextFilter"
  }

  options {
    primary_keys = ["uid"]
  }

  column "object_meta" {
    skip_prefix = true
  }

  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }

  column "spec" {
    skip_prefix = true
  }

  column "type_meta" {
    skip = true
  }

  column "job_template" {
    type              = "json"
    generate_resolver = true
  }


  column "status" {
    type              = "json"
    generate_resolver = true
  }
}


resource "k8s" "batch" "jobs" {
  path = "k8s.io/api/batch/v1.Job"

  multiplex "ContextMultiplex" {
    path = "github.com/cloudquery/cq-provider-k8s/client.ContextMultiplex"
  }
  deleteFilter "DeleteContextFilter" {
    path = "github.com/cloudquery/cq-provider-k8s/client.DeleteContextFilter"
  }

  options {
    primary_keys = ["uid"]
  }

  column "object_meta" {
    skip_prefix = true
  }

  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }

  column "spec" {
    skip_prefix = true
  }

  column "type_meta" {
    skip = true
  }

  column "template" {
    type              = "json"
    generate_resolver = true
  }
}


resource "k8s" "apps" "daemon_sets" {
  path = "k8s.io/api/apps/v1.DaemonSet"

  multiplex "ContextMultiplex" {
    path = "github.com/cloudquery/cq-provider-k8s/client.ContextMultiplex"
  }
  deleteFilter "DeleteContextFilter" {
    path = "github.com/cloudquery/cq-provider-k8s/client.DeleteContextFilter"
  }

  options {
    primary_keys = ["uid"]
  }

  column "object_meta" {
    skip_prefix = true
  }

  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }


  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }


  column "spec" {
    skip_prefix = true
  }

  column "type_meta" {
    skip = true
  }

  column "template" {
    type              = "json"
    generate_resolver = true
  }
}


resource "k8s" "apps" "replica_sets" {
  path = "k8s.io/api/apps/v1.ReplicaSet"

  multiplex "ContextMultiplex" {
    path = "github.com/cloudquery/cq-provider-k8s/client.ContextMultiplex"
  }
  deleteFilter "DeleteContextFilter" {
    path = "github.com/cloudquery/cq-provider-k8s/client.DeleteContextFilter"
  }

  // Changing column to user defined: table=k8s_apps_replica_sets column=Template valueType=TypeInvalid userDefinedType=json

  options {
    primary_keys = ["uid"]
  }

  column "object_meta" {
    skip_prefix = true
  }

  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }

  column "spec" {
    skip_prefix = true
  }

  column "type_meta" {
    skip = true
  }

  column "template" {
    type              = "json"
    generate_resolver = true
  }
  column "template" {
    type              = "json"
    generate_resolver = true
  }
}


resource "k8s" "apps" "stateful_sets" {
  path = "k8s.io/api/apps/v1.StatefulSet"

  multiplex "ContextMultiplex" {
    path = "github.com/cloudquery/cq-provider-k8s/client.ContextMultiplex"
  }
  deleteFilter "DeleteContextFilter" {
    path = "github.com/cloudquery/cq-provider-k8s/client.DeleteContextFilter"
  }

  options {
    primary_keys = ["uid"]
  }

  column "object_meta" {
    skip_prefix = true
  }

  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }

  column "spec" {
    skip_prefix = true
  }

  column "type_meta" {
    skip = true
  }

  column "template" {
    type              = "json"
    generate_resolver = true
  }

  column "volume_claim_templates" {
    type              = "json"
    generate_resolver = true
  }
}

resource "k8s" "rbac" "roles" {
  path = "k8s.io/api/rbac/v1.Role"

  column "type_meta" {
    skip_prefix = true
  }

  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }

  multiplex "ContextMultiplex" {
    path = "github.com/cloudquery/cq-provider-k8s/client.ContextMultiplex"
  }
  deleteFilter "DeleteContextFilter" {
    path = "github.com/cloudquery/cq-provider-k8s/client.DeleteContextFilter"
  }

  options {
    primary_keys = ["uid"]
  }

  column "object_meta" {
    skip_prefix = true
  }

  relation "k8s" "rbac" "role_rules" {
    path = "k8s.io/api/rbac/v1.PolicyRule"

    column "non_resource_url_s" {
      rename = "non_resource_urls"
    }
  }

}


resource "k8s" "rbac" "role_bindings" {
  path = "k8s.io/api/rbac/v1.RoleBinding"


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
  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }
}


resource "k8s" "networking" "network_policies" {
  path = "k8s.io/api/networking/v1.NetworkPolicy"

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
  column "spec" {
    skip_prefix = true
  }
  column "owner_references" {
    type              = "json"
    generate_resolver = true
  }

  column "managed_fields" {
    type              = "json"
    generate_resolver = true
  }
  relation "k8s" "networking" "ingress" {
    path = "k8s.io/api/networking/v1.NetworkPolicyIngressRule"

    userDefinedColumn "network_policy_uid" {
      type        = "string"
      //argument ("uid")
      description = "The name of the Availability Zone.."
      resolver "parentPathResolver" {
        path          = "github.com/cloudquery/cq-provider-sdk/provider/schema.ParentResourceFieldResolver"
        generate      = true
        path_resolver = true
      }
    }

    relation "k8s" "networking" "from" {
      path = "k8s.io/api/networking/v1.NetworkPolicyPeer"

      column "pod_selector_match_expressions" {
        type              = "json"
        generate_resolver = true
      }
      column "ip_block_c_id_r" {
        rename = "ip_block_cidr"
      }


      column "namespace_selector_match_expressions" {
        type              = "json"
        generate_resolver = true
      }
    }
  }

  relation "k8s" "networking" "egress" {
    path = "k8s.io/api/networking/v1.NetworkPolicyEgressRule"

    userDefinedColumn "network_policy_uid" {
      type        = "string"
      //argument ("uid")
      description = "The name of the Availability Zone.."
      resolver "parentPathResolver" {
        path          = "github.com/cloudquery/cq-provider-sdk/provider/schema.ParentResourceFieldResolver"
        generate      = true
        path_resolver = true
      }
    }

    relation "k8s" "networking" "to" {
      path = "k8s.io/api/networking/v1.NetworkPolicyPeer"

      column "ip_block_c_id_r" {
        rename = "ip_block_cidr"
      }

      column "pod_selector_match_expressions" {
        type              = "json"
        generate_resolver = true
      }

      column "namespace_selector_match_expressions" {
        type              = "json"
        generate_resolver = true
      }
    }
  }
}


resource "k8s" "meta" "owner_references" {
  path = "k8s.io/apimachinery/pkg/apis/meta/v1.OwnerReference"
  userDefinedColumn "resource_cq_id" {
    description = "cq_id of parent resource"
    type        = "uuid"
  }
  options {
    primary_keys = ["resource_cq_id", "uid"]
  }
}

resource "k8s" "meta" "managed_fields" {
  path = "k8s.io/apimachinery/pkg/apis/meta/v1.ManagedFieldsEntry"
  userDefinedColumn "resource_cq_id" {
    description = "cq_id of parent resource"
    type        = "uuid"
  }
  options {
    primary_keys = ["resource_cq_id", "cq_id"]
  }
}