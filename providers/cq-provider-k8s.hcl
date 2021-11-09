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


resource "k8s" "apps" "deployments" {
  path = "k8s.io/api/apps/v1.Deployment"
  ====== = column "spec" {
    skip_prefix = true
  }

  column "type_meta" {
    skip = true
  }

  column "template_object_meta_owner_references" {
    rename = "template_owner_references"
  }

  column "template_object_meta_managed_fields" {
    rename = "template_managed_fields"
  }


  column "template_object_meta_name" {
    rename = "template_name"
  }

  column "template_object_meta_generate_name" {
    rename = "template_generate_name"
  }

  column "template_object_meta_namespace" {
    rename = "template_namespace"
  }

  column "template_object_meta_self_link" {
    rename = "template_self_link"
  }
  column "template_object_meta_uid" {
    rename = "template_uid"
  }
  column "template_object_meta_resource_version" {
    rename = "template_resource_version"
  }
  column "template_object_meta_generation" {
    rename = "template_generation"
  }
  column "template_object_meta_deletion_grace_period_seconds" {
    rename = "template_deletion_grace_period_seconds"
  }
  column "template_object_meta_labels" {
    rename = "template_labels"
  }
  column "template_object_meta_annotations" {
    rename = "template_annotations"
  }
  column "template_object_meta_finalizers" {
    rename = "template_finalizers"
  }
  column "template_object_meta_cluster_name" {
    rename = "template_cluster_name"
  }

  column "template_spec_affinity" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_dns_config" {
    type              = "json"
    generate_resolver = true
  }
  column "template_spec_overhead" {
    generate_resolver = true
  }


  column "template_spec_readiness_gates" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_security_context" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_host_p_id" {
    rename = "template_spec_host_pid"
  }


  column "template_spec_host_ip_c" {
    rename = "template_spec_host_ipc"
  }

  column "template_spec_topology_spread_constraints" {
    type              = "json"
    generate_resolver = true
  }

  relation "k8s" "batch" "job_template_spec_volumes" {
    path = "k8s.io/api/batch/v1.Volume"

    column "volume_source" {
      skip_prefix = true
    }

    column "secret_items" {
      type              = "json"
      generate_resolver = true
    }

    column "downward_api_items" {
      type              = "json"
      generate_resolver = true
    }

    column "config_map_items" {
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_object_meta_owner_references" {
      rename            = "ephemeral_volume_claim_template_owner_references"
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_object_meta_managed_fields" {
      rename            = "ephemeral_volume_claim_template_managed_fields"
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_spec_selector_match_expressions" {
      type              = "json"
      generate_resolver = true
    }

    column "projected_sources" {
      type              = "json"
      generate_resolver = true
    }

    column "g_c_e_persistent_disk" {
      rename = "gce_persistent_disk"
      type   = "json"
    }


    column "aws_elastic_block_store" {
      type              = "json"
      generate_resolver = true
    }


    column "secret" {
      type = "json"
    }

    column "glusterfs" {
      type = "json"
    }

    column "persistent_volume_claim" {
      type = "json"
    }


    column "ceph_f_s" {
      rename = "ceph_fs"
      type   = "json"
    }
    column "nfs" {
      type              = "json"
      generate_resolver = true
    }
    column "git_repo" {
      type = "json"
    }

    column "f_c" {
      rename = "fc"
      type   = "json"
    }

    column "scale_i_o" {
      rename = "scale_io"
      type   = "json"
    }

    column "flex_volume" {
      type = "json"
    }
    column "iscsi" {
      type              = "json"
      generate_resolver = true
    }
    column "rbd" {
      type              = "json"
      generate_resolver = true
    }
    column "flocker" {
      type = "json"
    }
    column "downward_api" {
      type              = "json"
      generate_resolver = true
    }
    column "fc" {
      type = "json"
    }
    column "azure_file" {
      type = "json"
    }
    column "config_map" {
      type = "json"
    }
    column "vsphere_volume" {
      type = "json"
    }
    column "quobyte" {
      type = "json"
    }
    column "azure_disk" {
      type = "json"
    }
    column "photon_persistent_disk" {
      type = "json"
    }
    column "projected" {
      type = "json"
    }
    column "portworx_volume" {
      type = "json"
    }
    column "scale_io" {
      type = "json"
    }
    column "storage_os" {
      type              = "json"
      generate_resolver = true
    }
    column "csi" {
      type              = "json"
      generate_resolver = true
    }
    column "ephemeral" {
      type = "json"
    }
    column "cinder" {
      type = "json"
    }
    column "vsphere_volume" {
      type = "json"
    }

  }

  relation "k8s" "batch" "job_template_spec_ephemeral_containers" {
    path = "k8s.io/api/core/v1.EphemeralContainer"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_container_common" {
      skip_prefix = true
    }

    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }

    column "env_from" {
      type              = "json"
      generate_resolver = true
    }


  }

  relation "k8s" "batch" "job_template_spec_containers" {
    path = "k8s.io/api/core/v1.Container"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }
    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }
    column "env_from" {
      type              = "json"
      generate_resolver = true
    }
  }

  relation "k8s" "batch" "template_spec_init_containers" {
    path = "k8s.io/api/core/v1.Container"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }

    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }

    column "env_from" {
      type              = "json"
      generate_resolver = true
    }
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


  column "spec" {
    skip_prefix = true
  }

  column "type_meta" {
    skip = true
  }

  column "template_object_meta_owner_references" {
    rename = "template_owner_references"
  }

  column "template_object_meta_managed_fields" {
    rename = "template_managed_fields"
  }


  column "template_object_meta_name" {
    rename = "template_name"
  }

  column "template_object_meta_generate_name" {
    rename = "template_generate_name"
  }

  column "template_object_meta_namespace" {
    rename = "template_namespace"
  }

  column "template_object_meta_self_link" {
    rename = "template_self_link"
  }
  column "template_object_meta_uid" {
    rename = "template_uid"
  }
  column "template_object_meta_resource_version" {
    rename = "template_resource_version"
  }
  column "template_object_meta_generation" {
    rename = "template_generation"
  }
  column "template_object_meta_deletion_grace_period_seconds" {
    rename = "template_deletion_grace_period_seconds"
  }
  column "template_object_meta_labels" {
    rename = "template_labels"
  }
  column "template_object_meta_annotations" {
    rename = "template_annotations"
  }
  column "template_object_meta_finalizers" {
    rename = "template_finalizers"
  }
  column "template_object_meta_cluster_name" {
    rename = "template_cluster_name"
  }

  column "template_spec_affinity" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_dns_config" {
    type              = "json"
    generate_resolver = true
  }
  column "template_spec_overhead" {
    generate_resolver = true
  }


  column "template_spec_readiness_gates" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_security_context" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_host_p_id" {
    rename = "template_spec_host_pid"
  }


  column "template_spec_host_ip_c" {
    rename = "template_spec_host_ipc"
  }

  column "template_spec_topology_spread_constraints" {
    type              = "json"
    generate_resolver = true
  }

  relation "k8s" "batch" "job_template_spec_volumes" {
    path = "k8s.io/api/batch/v1.Volume"

    column "volume_source" {
      skip_prefix = true
    }

    column "secret_items" {
      type              = "json"
      generate_resolver = true
    }

    column "downward_api_items" {
      type              = "json"
      generate_resolver = true
    }

    column "config_map_items" {
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_object_meta_owner_references" {
      rename            = "ephemeral_volume_claim_template_owner_references"
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_object_meta_managed_fields" {
      rename            = "ephemeral_volume_claim_template_managed_fields"
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_spec_selector_match_expressions" {
      type              = "json"
      generate_resolver = true
    }

    column "projected_sources" {
      type              = "json"
      generate_resolver = true
    }

    column "g_c_e_persistent_disk" {
      rename = "gce_persistent_disk"
      type   = "json"
    }


    column "aws_elastic_block_store" {
      type              = "json"
      generate_resolver = true
    }


    column "secret" {
      type = "json"
    }

    column "glusterfs" {
      type = "json"
    }

    column "persistent_volume_claim" {
      type = "json"
    }


    column "ceph_f_s" {
      rename = "ceph_fs"
      type   = "json"
    }
    column "nfs" {
      type              = "json"
      generate_resolver = true
    }
    column "git_repo" {
      type = "json"
    }

    column "f_c" {
      rename = "fc"
      type   = "json"
    }

    column "scale_i_o" {
      rename = "scale_io"
      type   = "json"
    }

    column "flex_volume" {
      type = "json"
    }
    column "iscsi" {
      type              = "json"
      generate_resolver = true
    }
    column "rbd" {
      type              = "json"
      generate_resolver = true
    }
    column "flocker" {
      type = "json"
    }
    column "downward_api" {
      type              = "json"
      generate_resolver = true
    }
    column "fc" {
      type = "json"
    }
    column "azure_file" {
      type = "json"
    }
    column "config_map" {
      type = "json"
    }
    column "vsphere_volume" {
      type = "json"
    }
    column "quobyte" {
      type = "json"
    }
    column "azure_disk" {
      type = "json"
    }
    column "photon_persistent_disk" {
      type = "json"
    }
    column "projected" {
      type = "json"
    }
    column "portworx_volume" {
      type = "json"
    }
    column "scale_io" {
      type = "json"
    }
    column "storage_os" {
      type              = "json"
      generate_resolver = true
    }
    column "csi" {
      type              = "json"
      generate_resolver = true
    }
    column "ephemeral" {
      type = "json"
    }
    column "cinder" {
      type = "json"
    }
    column "vsphere_volume" {
      type = "json"
    }

  }

  relation "k8s" "batch" "job_template_spec_ephemeral_containers" {
    path = "k8s.io/api/core/v1.EphemeralContainer"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_container_common" {
      skip_prefix = true
    }

    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }

    column "env_from" {
      type              = "json"
      generate_resolver = true
    }


  }

  relation "k8s" "batch" "job_template_spec_containers" {
    path = "k8s.io/api/core/v1.Container"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }
    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }
    column "env_from" {
      type              = "json"
      generate_resolver = true
    }
  }

  relation "k8s" "batch" "template_spec_init_containers" {
    path = "k8s.io/api/core/v1.Container"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }

    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }

    column "env_from" {
      type              = "json"
      generate_resolver = true
    }
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

  userDefinedColumn "owner_references" {
    type              = "json"
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


  column "template_object_meta_owner_references" {
    rename = "template_owner_references"
  }

  column "template_object_meta_managed_fields" {
    rename = "template_managed_fields"
  }


  column "template_object_meta_name" {
    rename = "template_name"
  }

  column "template_object_meta_generate_name" {
    rename = "template_generate_name"
  }

  column "template_object_meta_namespace" {
    rename = "template_namespace"
  }

  column "template_object_meta_self_link" {
    rename = "template_self_link"
  }
  column "template_object_meta_uid" {
    rename = "template_uid"
  }
  column "template_object_meta_resource_version" {
    rename = "template_resource_version"
  }
  column "template_object_meta_generation" {
    rename = "template_generation"
  }
  column "template_object_meta_deletion_grace_period_seconds" {
    rename = "template_deletion_grace_period_seconds"
  }
  column "template_object_meta_labels" {
    rename = "template_labels"
  }
  column "template_object_meta_annotations" {
    rename = "template_annotations"
  }
  column "template_object_meta_finalizers" {
    rename = "template_finalizers"
  }
  column "template_object_meta_cluster_name" {
    rename = "template_cluster_name"
  }

  column "template_spec_affinity" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_dns_config" {
    type              = "json"
    generate_resolver = true
  }
  column "template_spec_overhead" {
    generate_resolver = true
  }


  column "template_spec_readiness_gates" {
    type              = "json"
    generate_resolver = true
  }
  column "template_spec_security_context" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_host_p_id" {
    rename = "template_spec_host_pid"
  }
  column "template_spec_host_ip_c" {
    rename = "template_spec_host_ipc"
  }

  column "template_spec_topology_spread_constraints" {
    type              = "json"
    generate_resolver = true
  }

  relation "k8s" "apps" "daemon_set_template_spec_volumes" {
    path = "k8s.io/api/batch/v1.Volume"

    column "volume_source" {
      skip_prefix = true
    }

    column "secret_items" {
      type              = "json"
      generate_resolver = true
    }

    column "downward_api_items" {
      type              = "json"
      generate_resolver = true
    }

    column "config_map_items" {
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_object_meta_owner_references" {
      rename            = "ephemeral_volume_claim_template_owner_references"
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_object_meta_managed_fields" {
      rename            = "ephemeral_volume_claim_template_managed_fields"
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_spec_selector_match_expressions" {
      type              = "json"
      generate_resolver = true
    }

    column "projected_sources" {
      type              = "json"
      generate_resolver = true
    }

    column "g_c_e_persistent_disk" {
      rename = "gce_persistent_disk"
      type   = "json"
    }


    column "aws_elastic_block_store" {
      type              = "json"
      generate_resolver = true
    }


    column "secret" {
      type = "json"
    }

    column "glusterfs" {
      type = "json"
    }

    column "persistent_volume_claim" {
      type = "json"
    }


    column "ceph_f_s" {
      rename = "ceph_fs"
      type   = "json"
    }
    column "nfs" {
      type              = "json"
      generate_resolver = true
    }
    column "git_repo" {
      type = "json"
    }

    column "f_c" {
      rename = "fc"
      type   = "json"
    }

    column "scale_i_o" {
      rename = "scale_io"
      type   = "json"
    }

    column "flex_volume" {
      type = "json"
    }
    column "iscsi" {
      type              = "json"
      generate_resolver = true
    }
    column "rbd" {
      type              = "json"
      generate_resolver = true
    }
    column "flocker" {
      type = "json"
    }
    column "downward_api" {
      type              = "json"
      generate_resolver = true
    }
    column "fc" {
      type = "json"
    }
    column "azure_file" {
      type = "json"
    }
    column "config_map" {
      type = "json"
    }
    column "vsphere_volume" {
      type = "json"
    }
    column "quobyte" {
      type = "json"
    }
    column "azure_disk" {
      type = "json"
    }
    column "photon_persistent_disk" {
      type = "json"
    }
    column "projected" {
      type = "json"
    }
    column "portworx_volume" {
      type = "json"
    }
    column "scale_io" {
      type = "json"
    }
    column "storage_os" {
      type              = "json"
      generate_resolver = true
    }
    column "csi" {
      type              = "json"
      generate_resolver = true
    }
    column "ephemeral" {
      type = "json"
    }
    column "cinder" {
      type = "json"
    }
    column "vsphere_volume" {
      type = "json"
    }

  }


  relation "k8s" "apps" "daemon_set_template_spec_ephemeral_containers" {
    path = "k8s.io/api/core/v1.EphemeralContainer"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_container_common" {
      skip_prefix = true
    }

    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }

    column "env_from" {
      type              = "json"
      generate_resolver = true
    }


  }

  relation "k8s" "apps" "daemon_set_template_spec_containers" {
    path = "k8s.io/api/core/v1.Container"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }
    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }
    column "env_from" {
      type              = "json"
      generate_resolver = true
    }
  }

  relation "k8s" "apps" "daemon_set_template_spec_init_containers" {
    path = "k8s.io/api/core/v1.Container"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }

    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }

    column "env_from" {
      type              = "json"
      generate_resolver = true
    }
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


  column "template_object_meta_owner_references" {
    rename = "template_owner_references"
  }

  column "template_object_meta_managed_fields" {
    rename = "template_managed_fields"
  }


  column "template_object_meta_name" {
    rename = "template_name"
  }

  column "template_object_meta_generate_name" {
    rename = "template_generate_name"
  }

  column "template_object_meta_namespace" {
    rename = "template_namespace"
  }

  column "template_object_meta_self_link" {
    rename = "template_self_link"
  }
  column "template_object_meta_uid" {
    rename = "template_uid"
  }
  column "template_object_meta_resource_version" {
    rename = "template_resource_version"
  }
  column "template_object_meta_generation" {
    rename = "template_generation"
  }
  column "template_object_meta_deletion_grace_period_seconds" {
    rename = "template_deletion_grace_period_seconds"
  }
  column "template_object_meta_labels" {
    rename = "template_labels"
  }
  column "template_object_meta_annotations" {
    rename = "template_annotations"
  }
  column "template_object_meta_finalizers" {
    rename = "template_finalizers"
  }
  column "template_object_meta_cluster_name" {
    rename = "template_cluster_name"
  }

  column "template_spec_affinity" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_dns_config" {
    type              = "json"
    generate_resolver = true
  }
  column "template_spec_overhead" {
    generate_resolver = true
  }

  column "template_spec_readiness_gates" {
    type              = "json"
    generate_resolver = true
  }
  column "template_spec_security_context" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_host_p_id" {
    rename = "template_spec_host_pid"
  }
  column "template_spec_host_ip_c" {
    rename = "template_spec_host_ipc"
  }

  column "template_spec_topology_spread_constraints" {
    type              = "json"
    generate_resolver = true
  }

  relation "k8s" "apps" "replica_set_template_spec_volumes" {
    path = "k8s.io/api/batch/v1.Volume"

    column "volume_source" {
      skip_prefix = true
    }

    column "secret_items" {
      type              = "json"
      generate_resolver = true
    }

    column "downward_api_items" {
      type              = "json"
      generate_resolver = true
    }

    column "config_map_items" {
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_object_meta_owner_references" {
      rename            = "ephemeral_volume_claim_template_owner_references"
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_object_meta_managed_fields" {
      rename            = "ephemeral_volume_claim_template_managed_fields"
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_spec_selector_match_expressions" {
      type              = "json"
      generate_resolver = true
    }

    column "projected_sources" {
      type              = "json"
      generate_resolver = true
    }

    column "g_c_e_persistent_disk" {
      rename = "gce_persistent_disk"
      type   = "json"
    }


    column "aws_elastic_block_store" {
      type              = "json"
      generate_resolver = true
    }


    column "secret" {
      type = "json"
    }

    column "glusterfs" {
      type = "json"
    }

    column "persistent_volume_claim" {
      type = "json"
    }


    column "ceph_f_s" {
      rename = "ceph_fs"
      type   = "json"
    }
    column "nfs" {
      type              = "json"
      generate_resolver = true
    }
    column "git_repo" {
      type = "json"
    }

    column "f_c" {
      rename = "fc"
      type   = "json"
    }

    column "scale_i_o" {
      rename = "scale_io"
      type   = "json"
    }

    column "flex_volume" {
      type = "json"
    }
    column "iscsi" {
      type              = "json"
      generate_resolver = true
    }
    column "rbd" {
      type              = "json"
      generate_resolver = true
    }
    column "flocker" {
      type = "json"
    }
    column "downward_api" {
      type              = "json"
      generate_resolver = true
    }
    column "fc" {
      type = "json"
    }
    column "azure_file" {
      type = "json"
    }
    column "config_map" {
      type = "json"
    }
    column "vsphere_volume" {
      type = "json"
    }
    column "quobyte" {
      type = "json"
    }
    column "azure_disk" {
      type = "json"
    }
    column "photon_persistent_disk" {
      type = "json"
    }
    column "projected" {
      type = "json"
    }
    column "portworx_volume" {
      type = "json"
    }
    column "scale_io" {
      type = "json"
    }
    column "storage_os" {
      type              = "json"
      generate_resolver = true
    }
    column "csi" {
      type              = "json"
      generate_resolver = true
    }
    column "ephemeral" {
      type = "json"
    }
    column "cinder" {
      type = "json"
    }
    column "vsphere_volume" {
      type = "json"
    }

  }


  relation "k8s" "apps" "replica_set_template_spec_ephemeral_containers" {
    path = "k8s.io/api/core/v1.EphemeralContainer"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_container_common" {
      skip_prefix = true
    }

    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }

    column "env_from" {
      type              = "json"
      generate_resolver = true
    }


  }

  relation "k8s" "apps" "replica_set_template_spec_containers" {
    path = "k8s.io/api/core/v1.Container"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }
    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }
    column "env_from" {
      type              = "json"
      generate_resolver = true
    }
  }

  relation "k8s" "apps" "replica_set_template_spec_init_containers" {
    path = "k8s.io/api/core/v1.Container"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }

    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }

    column "env_from" {
      type              = "json"
      generate_resolver = true
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


  column "template_object_meta_owner_references" {
    rename = "template_owner_references"
  }

  column "template_object_meta_managed_fields" {
    rename = "template_managed_fields"
  }


  column "template_object_meta_name" {
    rename = "template_name"
  }

  column "template_object_meta_generate_name" {
    rename = "template_generate_name"
  }

  column "template_object_meta_namespace" {
    rename = "template_namespace"
  }

  column "template_object_meta_self_link" {
    rename = "template_self_link"
  }
  column "template_object_meta_uid" {
    rename = "template_uid"
  }
  column "template_object_meta_resource_version" {
    rename = "template_resource_version"
  }
  column "template_object_meta_generation" {
    rename = "template_generation"
  }
  column "template_object_meta_deletion_grace_period_seconds" {
    rename = "template_deletion_grace_period_seconds"
  }
  column "template_object_meta_labels" {
    rename = "template_labels"
  }
  column "template_object_meta_annotations" {
    rename = "template_annotations"
  }
  column "template_object_meta_finalizers" {
    rename = "template_finalizers"
  }
  column "template_object_meta_cluster_name" {
    rename = "template_cluster_name"
  }

  column "template_spec_affinity" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_dns_config" {
    type              = "json"
    generate_resolver = true
  }
  column "template_spec_overhead" {
    generate_resolver = true
  }


  column "template_spec_readiness_gates" {
    type              = "json"
    generate_resolver = true
  }
  column "template_spec_security_context" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_host_p_id" {
    rename = "template_spec_host_pid"
  }
  column "template_spec_host_ip_c" {
    rename = "template_spec_host_ipc"
  }

  column "template_spec_topology_spread_constraints" {
    type              = "json"
    generate_resolver = true
  }

  relation "k8s" "apps" "deployment_template_spec_volumes" {
    path = "k8s.io/api/batch/v1.Volume"

    column "volume_source" {
      skip_prefix = true
    }

    column "secret_items" {
      type              = "json"
      generate_resolver = true
    }

    column "downward_api_items" {
      type              = "json"
      generate_resolver = true
    }

    column "config_map_items" {
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_object_meta_owner_references" {
      rename            = "ephemeral_volume_claim_template_owner_references"
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_object_meta_managed_fields" {
      rename            = "ephemeral_volume_claim_template_managed_fields"
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_spec_selector_match_expressions" {
      type              = "json"
      generate_resolver = true
    }

    column "projected_sources" {
      type              = "json"
      generate_resolver = true
    }

    column "g_c_e_persistent_disk" {
      rename = "gce_persistent_disk"
      type   = "json"
    }


    column "aws_elastic_block_store" {
      type              = "json"
      generate_resolver = true
    }


    column "secret" {
      type = "json"
    }

    column "glusterfs" {
      type = "json"
    }

    column "persistent_volume_claim" {
      type = "json"
    }


    column "ceph_f_s" {
      rename = "ceph_fs"
      type   = "json"
    }
    column "nfs" {
      type              = "json"
      generate_resolver = true
    }
    column "git_repo" {
      type = "json"
    }

    column "f_c" {
      rename = "fc"
      type   = "json"
    }

    column "scale_i_o" {
      rename = "scale_io"
      type   = "json"
    }

    column "flex_volume" {
      type = "json"
    }
    column "iscsi" {
      type              = "json"
      generate_resolver = true
    }
    column "rbd" {
      type              = "json"
      generate_resolver = true
    }
    column "flocker" {
      type = "json"
    }
    column "downward_api" {
      type              = "json"
      generate_resolver = true
    }
    column "fc" {
      type = "json"
    }
    column "azure_file" {
      type = "json"
    }
    column "config_map" {
      type = "json"
    }
    column "vsphere_volume" {
      type = "json"
    }
    column "quobyte" {
      type = "json"
    }
    column "azure_disk" {
      type = "json"
    }
    column "photon_persistent_disk" {
      type = "json"
    }
    column "projected" {
      type = "json"
    }
    column "portworx_volume" {
      type = "json"
    }
    column "scale_io" {
      type = "json"
    }
    column "storage_os" {
      type              = "json"
      generate_resolver = true
    }
    column "csi" {
      type              = "json"
      generate_resolver = true
    }
    column "ephemeral" {
      type = "json"
    }
    column "cinder" {
      type = "json"
    }
    column "vsphere_volume" {
      type = "json"
    }

  }


  relation "k8s" "apps" "deployment_template_spec_ephemeral_containers" {
    path = "k8s.io/api/core/v1.EphemeralContainer"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_container_common" {
      skip_prefix = true
    }

    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }

    column "env_from" {
      type              = "json"
      generate_resolver = true
    }


  }

  relation "k8s" "apps" "deployment_template_spec_containers" {
    path = "k8s.io/api/core/v1.Container"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }
    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }
    column "env_from" {
      type              = "json"
      generate_resolver = true
    }
  }

  relation "k8s" "apps" "deployment_template_spec_init_containers" {
    path = "k8s.io/api/core/v1.Container"

    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }

    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }

    column "env_from" {
      type              = "json"
      generate_resolver = true
    }
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


  column "spec" {
    skip_prefix = true
  }

  column "type_meta" {
    skip = true
  }


  column "template_object_meta_owner_references" {
    rename = "template_owner_references"
  }

  column "template_object_meta_managed_fields" {
    rename = "template_managed_fields"
  }


  column "template_object_meta_name" {
    rename = "template_name"
  }

  column "template_object_meta_generate_name" {
    rename = "template_generate_name"
  }

  column "template_object_meta_namespace" {
    rename = "template_namespace"
  }

  column "template_object_meta_self_link" {
    rename = "template_self_link"
  }
  column "template_object_meta_uid" {
    rename = "template_uid"
  }
  column "template_object_meta_resource_version" {
    rename = "template_resource_version"
  }
  column "template_object_meta_generation" {
    rename = "template_generation"
  }
  column "template_object_meta_deletion_grace_period_seconds" {
    rename = "template_deletion_grace_period_seconds"
  }
  column "template_object_meta_labels" {
    rename = "template_labels"
  }
  column "template_object_meta_annotations" {
    rename = "template_annotations"
  }
  column "template_object_meta_finalizers" {
    rename = "template_finalizers"
  }
  column "template_object_meta_cluster_name" {
    rename = "template_cluster_name"
  }

  column "template_spec_affinity" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_dns_config" {
    type              = "json"
    generate_resolver = true
  }
  column "template_spec_overhead" {
    generate_resolver = true
  }


  column "template_spec_readiness_gates" {
    type              = "json"
    generate_resolver = true
  }
  column "template_spec_security_context" {
    type              = "json"
    generate_resolver = true
  }

  column "template_spec_host_p_id" {
    rename = "template_spec_host_pid"
  }
  column "template_spec_host_ip_c" {
    rename = "template_spec_host_ipc"
  }

  column "template_spec_topology_spread_constraints" {
    type              = "json"
    generate_resolver = true
  }

  relation "k8s" "apps" "stateful_set_volume_claim_templates" {
    path = "k8s.io/api/core/v1.PersistentVolumeClaim"

    column "object_meta" {
      skip_prefix = true
    }

    column "spec" {
      skip_prefix = true
    }

    column "selector_match_expressions" {
      type              = "json"
      generate_resolver = true
    }
  }


  relation "k8s" "apps" "stateful_set_template_spec_volumes" {
    path = "k8s.io/api/batch/v1.Volume"

    column "volume_source" {
      skip_prefix = true
    }

    column "secret_items" {
      type              = "json"
      generate_resolver = true
    }

    column "downward_api_items" {
      type              = "json"
      generate_resolver = true
    }

    column "config_map_items" {
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_object_meta_owner_references" {
      rename            = "ephemeral_volume_claim_template_owner_references"
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_object_meta_managed_fields" {
      rename            = "ephemeral_volume_claim_template_managed_fields"
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_volume_claim_template_spec_selector_match_expressions" {
      type              = "json"
      generate_resolver = true
    }

    column "projected_sources" {
      type              = "json"
      generate_resolver = true
    }

    column "g_c_e_persistent_disk" {
      rename = "gce_persistent_disk"
      type   = "json"
    }


    column "aws_elastic_block_store" {
      type              = "json"
      generate_resolver = true
    }


    column "secret" {
      type = "json"
    }

    column "glusterfs" {
      type = "json"
    }

    column "persistent_volume_claim" {
      type = "json"
    }


    column "ceph_f_s" {
      rename = "ceph_fs"
      type   = "json"
    }
    column "nfs" {
      type              = "json"
      generate_resolver = true
    }
    column "git_repo" {
      type = "json"
    }

    column "f_c" {
      rename = "fc"
      type   = "json"
    }

    column "scale_i_o" {
      rename = "scale_io"
      type   = "json"
    }

    column "flex_volume" {
      type = "json"
    }
    column "iscsi" {
      type              = "json"
      generate_resolver = true
    }
    column "rbd" {
      type              = "json"
      generate_resolver = true
    }
    column "flocker" {
      type = "json"
    }
    column "downward_api" {
      type              = "json"
      generate_resolver = true
    }
    column "fc" {
      type = "json"
    }
    column "azure_file" {
      type = "json"
    }
    column "config_map" {
      type = "json"
    }
    column "vsphere_volume" {
      type = "json"
    }
    column "quobyte" {
      type = "json"
    }
    column "azure_disk" {
      type = "json"
    }
    column "photon_persistent_disk" {
      type = "json"
    }
    column "projected" {
      type = "json"
    }
    column "portworx_volume" {
      type = "json"
    }
    column "scale_io" {
      type = "json"
    }
    column "storage_os" {
      type              = "json"
      generate_resolver = true
    }
    column "csi" {
      type              = "json"
      generate_resolver = true
    }
    column "ephemeral" {
      type = "json"
    }
    column "cinder" {
      type = "json"
    }
    column "vsphere_volume" {
      type = "json"
    }

  }


  relation "k8s" "apps" "stateful_set_template_spec_ephemeral_containers" {
    path = "k8s.io/api/core/v1.EphemeralContainer"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }

    column "ephemeral_container_common" {
      skip_prefix = true
    }

    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }

    column "env_from" {
      type              = "json"
      generate_resolver = true
    }


  }

  relation "k8s" "apps" "stateful_set_template_spec_containers" {
    path = "k8s.io/api/core/v1.Container"


    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }
    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }
    column "env_from" {
      type              = "json"
      generate_resolver = true
    }
  }

  relation "k8s" "apps" "stateful_set_template_spec_init_containers" {
    path = "k8s.io/api/core/v1.Container"

    column "volume_devices" {
      type              = "json"
      generate_resolver = true
    }

    column "volume_mounts" {
      type              = "json"
      generate_resolver = true
    }

    column "liveness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "readiness_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "startup_probe" {
      type              = "json"
      generate_resolver = true
    }

    column "lifecycle" {
      type              = "json"
      generate_resolver = true
    }

    column "security_context" {
      type              = "json"
      generate_resolver = true
    }

    column "env_from" {
      type              = "json"
      generate_resolver = true
    }
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