service = "k8s"
output_directory = "../forks/cq-provider-k8s/resources"

resource "k8s" "core" "nodes" {
  path = "k8s.io/api/core/v1.Node"

  column "type_meta" {
    skip_prefix = true
  }

  column "object_meta" {
    skip_prefix = true
  }

  column "managed_fields" {
    skip = true
  }

  column "owner_references" {
    description = "List of objects depended by this object."
    type = "json"
    generate_resolver = true
  }

  column "kind" {
    description = "Kind is a string value representing the REST resource this object represents."
  }

  column "api_version" {
    description = "Defines the versioned schema of this representation of an object."
  }

  column "name" {
    description = "Unique name within a namespace."
  }

  column "generate_name" {
    skip = true
  }

  column "namespace" {
    description = "Namespace defines the space within which each name must be unique."
  }

  column "self_link" {
    skip = true
  }

  column "uid" {
    description = "UID is the unique in time and space value for this object."
  }

  column "resource_version" {
    description = "An opaque value that represents the internal version of this object."
  }

  column "generation" {
    description = "A sequence number representing a specific generation of the desired state."
  }

  column "deletion_grace_period_seconds" {
    description = "Number of seconds allowed for this object to gracefully terminate."
  }

  column "labels" {
    description = "Map of string keys and values that can be used to organize and categorize objects."
  }

  column "annotations" {
    description = "Annotations is an unstructured key value map stored with a resource that may be set by external tools."
  }

  column "finalizers" {
    description = "List of finalizers"
  }

  column "cluster_name" {
    description = "The name of the cluster which the object belongs to."
  }

  # Spec fields
  column "spec" {
    skip_prefix = true
  }

  column "pod_c_id_r" {
    rename = "pod_cidr"
    description = "Represents the pod IP range assigned to the node."
  }

  column "pod_c_id_rs" {
    rename = "pod_cidrs"
    description = "Represents the IP ranges assigned to the node for usage by Pods on that node"
  }

  column "taints" {
    type = "json"
    generate_resolver = true
  }

  column "config_source" {
    skip = true
  }

  column "do_not_use_external_id" {
    skip = true
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


resource "k8s" "core" "pods" {
  path = "k8s.io/api/core/v1.Pod"

  # ======================================== Type meta ========================================
  column "type_meta" {
    skip_prefix = true
  }

  column "kind" {
    description = "Kind is a string value representing the REST resource this object represents."
  }

  column "api_version" {
    description = "Defines the versioned schema of this representation of an object."
  }

  # ======================================== Object meta ========================================
  column "object_meta" {
    skip_prefix = true
  }

  column "name" {
    description = "Unique name within a namespace."
  }

  column "namespace" {
    description = "Namespace defines the space within which each name must be unique."
  }

  column "generate_name" {
    skip = true
  }

  column "self_link" {
    skip = true
  }

  column "uid" {
    description = "UID is the unique in time and space value for this object."
  }

  column "resource_version" {
    description = "An opaque value that represents the internal version of this object."
  }

  column "generation" {
    description = "A sequence number representing a specific generation of the desired state."
  }

  column "deletion_grace_period_seconds" {
    description = "Number of seconds allowed for this object to gracefully terminate."
  }

  column "labels" {
    description = "Map of string keys and values that can be used to organize and categorize objects."
  }

  column "annotations" {
    description = "Annotations is an unstructured key value map stored with a resource that may be set by external tools."
  }

  column "owner_references" {
    description = "List of objects depended by this object."
    type = "json"
    generate_resolver = true
  }

  column "finalizers" {
    description = "List of finalizers"
  }

  column "cluster_name" {
    description = "The name of the cluster which the object belongs to."
  }

  column "managed_fields" {
    skip = true
  }

  # ======================================== Spec ========================================
  column "spec" {
    skip_prefix = true
  }

  column "affinity" {
    type = "json"
    generate_resolver = true
  }

  column "deprecated_service_account" {
    skip = true
  }

  column "dns_config" {
    type = "json"
    generate_resolver = true
  }

  column "host_aliases" {
    type = "json"
    generate_resolver = true
  }

  column "image_pull_secrets" {
    type = "json"
    generate_resolver = true
  }

  column "readiness_gates" {
    type = "json"
    generate_resolver = true
  }

  column "security_context" {
    type = "json"
    generate_resolver = true
  }

  column "tolerations" {
    type = "json"
    generate_resolver = true
  }

  column "topology_spread_constraints" {
    type = "json"
    generate_resolver = true
  }

  # ======================================== Status ========================================
  column "status" {
    skip_prefix = true
  }

  column "q_os_class" {
    rename = "qos_class"
  }

  column "conditions" {
    type = "json"
    generate_resolver = true
  }

  column "pod_ip_s" {
    rename = "pod_ips"
    type = "stringarray"
  }

  column "init_container_statuses" {
    skip = true
  }

  column "container_statuses" {
    skip = true
  }

  column "ephemeral_container_statuses" {
    skip = true
  }

  column "volumes" {
    skip = true
  }

  # ======================================== Spec -> Volumes ========================================

  relation "k8s" "core" "volumes" {
    path = "k8s.io/api/core/v1.Volume"

    column "volume_source" {
      skip_prefix = true
    }

    column "git_repo" {
      skip = true
    }

    column "i_s_c_s_i" {
      rename = "iscsi"
      type = "json"
      generate_resolver = true
    }

    column "ephemeral" {
      type = "json"
      generate_resolver = true
    }

    column "c_s_i" {
      rename = "csi"
      type = "json"
      generate_resolver = true
    }

    column "storage_os" {
      type = "json"
      generate_resolver = true
    }
  }
  # ======================================== Status ========================================
  relation "k8s" "core" "init_container_statuses" {
    path = "k8s.io/api/core/v1.ContainerStatus"

    column "state" {
      type = "json"
      generate_resolver = true
    }

    column "last_termination_state" {
      rename = "last_state"
      type = "json"
      generate_resolver = true
    }
  }

  relation "k8s" "core" "container_statuses" {
    path = "k8s.io/api/core/v1.ContainerStatus"

    column "state" {
      type = "json"
      generate_resolver = true
    }

    column "last_termination_state" {
      rename = "last_state"
      type = "json"
      generate_resolver = true
    }
  }

  relation "k8s" "core" "ephemeral_container_statuses" {
    path = "k8s.io/api/core/v1.ContainerStatus"

    column "state" {
      type = "json"
      generate_resolver = true
    }

    column "last_termination_state" {
      rename = "last_state"
      type = "json"
      generate_resolver = true
    }
  }
}

resource "k8s" "core" "services" {
  path = "k8s.io/api/core/v1.Service"

  # ======================================== Type meta ========================================
  column "type_meta" {
    skip_prefix = true
  }

  column "kind" {
    description = "Kind is a string value representing the REST resource this object represents."
  }

  column "api_version" {
    description = "Defines the versioned schema of this representation of an object."
  }

  # ======================================== Object meta ========================================
  column "object_meta" {
    skip_prefix = true
  }

  column "name" {
    description = "Unique name within a namespace."
  }

  column "namespace" {
    description = "Namespace defines the space within which each name must be unique."
  }

  column "generate_name" {
    skip = true
  }

  column "self_link" {
    skip = true
  }

  column "uid" {
    description = "UID is the unique in time and space value for this object."
  }

  column "resource_version" {
    description = "An opaque value that represents the internal version of this object."
  }

  column "generation" {
    description = "A sequence number representing a specific generation of the desired state."
  }

  column "deletion_grace_period_seconds" {
    description = "Number of seconds allowed for this object to gracefully terminate."
  }

  column "labels" {
    description = "Map of string keys and values that can be used to organize and categorize objects."
  }

  column "annotations" {
    description = "Annotations is an unstructured key value map stored with a resource that may be set by external tools."
  }

  column "owner_references" {
    description = "List of objects depended by this object."
    type = "json"
    generate_resolver = true
  }

  column "finalizers" {
    description = "List of finalizers"
  }

  column "cluster_name" {
    description = "The name of the cluster which the object belongs to."
  }

  column "managed_fields" {
    skip = true
  }

  # ======================================== Spec ========================================
  column "spec" {
    skip_prefix = true
  }

  # ======================================== Status ========================================
  column "status" {
    skip_prefix = true
  }
}
