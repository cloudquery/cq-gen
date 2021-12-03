service          = "aws"

output_directory = "../cq-provider-aws/resources"

resource "aws" "dynamodb" "tables" {
  path        = "github.com/aws/aws-sdk-go-v2/service/dynamodb/types.TableDescription"
  description = "Information about a DynamoDB table."

  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
    description       = "The tags associated with the table."
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  options {
    primary_keys = [
      "arn"
    ]
  }

  column "sse_description" {
    skip_prefix = true
  }
  column "status" {
    rename = "sse_status"
  }

  column "attribute_definitions" {
    type              = "json"
    generate_resolver = true
  }

  column "key_schema" {
    type              = "json"
    generate_resolver = true
  }

  column "billing_mode_summary" {
    type              = "json"
    generate_resolver = true
  }
  column "archival_summary" {
    type              = "json"
    generate_resolver = true
  }
  column "restore_summary" {
    type              = "json"
    generate_resolver = true
  }
  column "stream_specification" {
    type              = "json"
    generate_resolver = true
  }

  column "table_arn" {
    rename = "arn"
  }
  column "table_name" {
    rename = "name"
  }
  column "table_id" {
    rename = "id"
  }

  relation "aws" "dynamodb" "replica_auto_scaling" {
    path = "github.com/aws/aws-sdk-go-v2/service/dynamodb/types.ReplicaAutoScalingDescription"

    column "replica_provisioned_read_capacity_auto_scaling_settings" {
      rename            = "read_capacity"
      type              = "json"
      generate_resolver = true
    }

    column "replica_provisioned_write_capacity_auto_scaling_settings" {
      rename            = "write_capacity"
      type              = "json"
      generate_resolver = true
    }

    column "global_secondary_indexes" {
      type              = "json"
      generate_resolver = true
    }

  }

  relation "aws" "dynamodb" "global_secondary_indexes" {
    path = "github.com/aws/aws-sdk-go-v2/service/dynamodb/types.GlobalSecondaryIndexDescription"

    column "key_schema" {
      type              = "json"
      generate_resolver = true
    }

    column "index_arn" {
      rename = "arn"
    }
    column "index_name" {
      rename = "name"
    }
    column "index_status" {
      rename = "status"
    }
  }

  relation "aws" "dynamodb" "local_secondary_indexes" {
    path = "github.com/aws/aws-sdk-go-v2/service/dynamodb/types.LocalSecondaryIndexDescription"

    column "key_schema" {
      type              = "json"
      generate_resolver = true
    }

    column "index_arn" {
      rename = "arn"
    }
    column "index_name" {
      rename = "name"
    }
    column "index_status" {
      rename = "status"
    }
  }

  relation "aws" "dynamodb" "table_replicas" {
    path = "github.com/aws/aws-sdk-go-v2/service/dynamodb/types.ReplicaDescription"

    column "global_secondary_indexes" {
      type              = "json"
      generate_resolver = true
    }

    column "replica_table_class_summary_last_update_date_time" {
      rename = "summary_last_update_date_time"
    }

    column "replica_table_class_summary_table_class" {
      rename = "summary_table_class"
    }
  }

  relation "aws" "dynamodb" "continuous_backups" {
    path = "github.com/aws/aws-sdk-go-v2/service/dynamodb/types.ContinuousBackupsDescription"

    column "point_in_time_recovery_description" {
      skip_prefix = true
    }
  }
}

resource "aws" "dax" "clusters" {
  path = "github.com/aws/aws-sdk-go-v2/service/dax/types.Cluster"
  description = "Information about a DAX cluster."

  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
    description = "The tags associated with the cluster."
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  options {
    primary_keys = [
      "arn"
    ]
  }

  column "parameter_group" {
    skip_prefix = true
  }

  column "cluster_arn" {
    rename = "arn"
  }
  column "cluster_name" {
    rename = "name"
  }

  column "security_groups" {
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "autoscaling" "launch_configurations" {
  path = "github.com/aws/aws-sdk-go-v2/service/autoscaling/types.LaunchConfiguration"

  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  column "metadata_options_http_tokens" {
    description = "The state of token usage for your instance metadata requests."
  }
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  relation "aws" "autoscaling" "block_device_mappings" {
    path = "github.com/aws/aws-sdk-go-v2/service/autoscaling/types.BlockDeviceMapping"
    column "ebs_encrypted" {
      description = "Specifies whether the volume should be encrypted."
    }

    column "ebs_iops" {
      description = "The number of I/O operations per second (IOPS) to provision for the volume."
    }

    column "ebs_volume_size" {
      description = "The volume size, in Gibibytes (GiB)."
    }
    column "no_device" {
      description = "Setting this value to true suppresses the specified device included in the block device mapping of the AMI."
    }
  }
}

resource "aws" "cloudfront" "cache_policies" {
  path = "github.com/aws/aws-sdk-go-v2/service/cloudfront/types.CachePolicySummary"

  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  column "id" {
    type   = "string"
    rename = "resource_id"
  }
  column "cookies_behavior" {

  }
  column "cache_policy" {
    skip_prefix = true
  }

  column "cache_policy_config" {
    skip_prefix = true
  }

  column "parameters_in_cache_key_and_forwarded_to_origin" {
    //    rename = "parameters"
    skip_prefix = true
  }
}

resource "aws" "cloudfront" "distributions" {
  path        = "github.com/aws/aws-sdk-go-v2/service/cloudfront/types.DistributionSummary"
  description = "A summary of the information about a CloudFront distribution."

  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  options {
    primary_keys = [
      "arn"
    ]
  }

  column "is_ipv6_enabled" {
    rename = "ip_v6_enabled"
  }

  column "restrictions_geo_restriction_restriction_type" {
    rename = "restrictions_geo_restriction_type"
  }

  column "aliases_quantity" {
    skip = true
  }

  column "cache_behaviors_quantity" {
    skip = true
  }
  column "custom_error_responses_quantity" {
    skip = true
  }

  column "origins_quantity" {
    skip = true
  }
  column "restrictions_geo_restriction_quantity" {
    skip = true
  }
  column "origin_groups_quantity" {
    skip = true
  }


  column "distribution_config" {
    skip_prefix = true
  }

  column "default_cache_behavior_lambda_function_associations_items" {
    rename = "default_cache_behavior_lambda_functions"
  }

  relation "aws" "cloudfront" "distribution_origins" {
    path = "github.com/aws/aws-sdk-go-v2/service/cloudfront/types.Origin"
    column "custom_headers_items" {
      rename = "custom_headers"
    }

    column "custom_origin_config_origin_ssl_protocols_quantity" {
      skip = true
    }

    column "custom_headers_quantity" {
      skip = true
    }

    column "custom_origin_config_origin_ssl_protocols_items" {
      rename = "custom_origin_config_origin_ssl_protocols"
    }

    column "custom_headers" {
      type              = "json"
      generate_resolver = true
    }

    column "custom_origin_config_origin_protocol_policy" {
      rename = "custom_origin_config_protocol_policy"
    }

    column "custom_origin_config_origin_keepalive_timeout" {
      rename = "custom_origin_config_keepalive_timeout"
    }

    column "custom_origin_config_origin_read_timeout" {
      rename = "custom_origin_config_read_timeout"
    }

    column "custom_origin_config_origin_ssl_protocols" {
      rename = "custom_origin_config_ssl_protocols"
    }

    column "custom_origin_config_origin_keepalive_timeout" {
      rename = "custom_origin_config_keepalive_timeout"
    }

    column "custom_origin_config_origin_ssl_protocols" {
      rename = "custom_origin_config_ssl_protocols"
    }
  }

  relation "aws" "cloudfront" "distribution_cache_behaviours" {
    path = "github.com/aws/aws-sdk-go-v2/service/cloudfront/types.CacheBehavior"
    column "lambda_function_associations_items" {
      rename = "lambda_functions"
    }

    column "allowed_methods_quantity" {
      skip = true
    }
    column "allowed_methods_cached_methods_quantity" {
      skip = true
    }

    column "forwarded_values_cookies_whitelisted_names_quantity" {
      skip = true
    }
    column "forwarded_values_headers_quantity" {
      skip = true
    }
    column "forwarded_values_query_string_cache_keys_quantity" {
      skip = true
    }
    column "lambda_function_associations_quantity" {
      skip = true
    }
    column "trusted_key_groups_quantity" {
      skip = true
    }
    column "trusted_signers_quantity" {
      skip = true
    }

    column "allowed_methods_items" {
      rename = "allowed_methods"
    }

    column "allowed_methods_cached_methods_items" {
      rename = "cached_methods"
    }

    column "forwarded_values_cookies_whitelisted_names_items" {
      rename = "forwarded_values_cookies_whitelisted_names"
    }

    column "forwarded_values_headers_items" {
      rename = "forwarded_values_headers"
    }

    column "trusted_key_groups_items" {
      rename = "trusted_key_groups"
    }

    column "trusted_signers_items" {
      rename = "trusted_signers"
    }

    column "forwarded_values_query_string_cache_keys_items" {
      rename = "forwarded_values_query_string_cache_keys"
    }

  }

  relation "aws" "cloudfront" "distribution_origin_groups" {
    path = "github.com/aws/aws-sdk-go-v2/service/cloudfront/types.OriginGroup"


    column "failover_criteria_status_codes_items" {
      rename            = "failover_criteria_status_codes"
      generate_resolver = true
    }

    column "failover_criteria_status_codes_quantity" {
      skip = true
    }

    column "members_quantity" {
      skip = true
    }

    column "members_items" {
      rename            = "members_origin_ids"
      type              = "StringArray"
      generate_resolver = true
    }
  }

  relation "aws" "cloudfront" "distribution_default_behaviour_lambda_functions" {
    path = "github.com/aws/aws-sdk-go-v2/service/cloudfront/types.LambdaFunctionAssociation"
  }

  relation "aws" "cloudfront" "distribution_alias_icp_recordals" {
    path = "github.com/aws/aws-sdk-go-v2/service/cloudfront/types.AliasICPRecordal"
    column "c_n_a_m_e" {
      rename = "cname"
    }

    column "i_c_p_recordal_status" {
      rename = "icp_recordal_status"
    }
  }


  column "aliases_items" {
    rename = "aliases"
  }

  column "custom_error_responses_items" {
    rename = "custom_error_responses"
  }


  column "active_trusted_key_groups_items" {
    rename = "active_trusted_key_groups"
  }

  column "active_trusted_signers_items" {
    rename = "active_trusted_signers"
  }

  column "default_cache_behavior_cache_policy_id" {
    rename = "cache_behaviour_cache_policy_id"
  }

  column "default_cache_behavior_target_origin_id" {
    rename = "cache_behaviour_target_origin_id"
  }

  column "default_cache_behavior_viewer_protocol_policy" {
    rename = "cache_behaviour_viewer_protocol_policy"
  }

  column "default_cache_behavior_allowed_methods_items" {
    rename = "cache_behaviour_allowed_methods"
  }


  column "default_cache_behavior_allowed_methods_quantity" {
    skip = true
    #    rename = "cache_behaviour_allowed_methods_quantity"
  }

  column "default_cache_behavior_allowed_methods_cached_methods_items" {
    rename = "cache_behaviour_allowed_methods_cached_methods"
  }

  column "default_cache_behavior_allowed_methods_cached_methods_quantity" {
    skip = true
    #    rename = "cache_behaviour_allowed_methods_cached_methods_quantity"
  }

  column "default_cache_behavior_allowed_methods_cached_methods_quantity" {
    rename = "cache_behaviour_allowed_methods_cached_methods_quantity"
  }

  column "default_cache_behavior_compress" {
    rename = "cache_behaviour_compress"
  }

  column "default_cache_behavior_default_ttl" {
    rename = "cache_behaviour_default_ttl"
  }

  column "default_cache_behavior_field_level_encryption_id" {
    rename = "cache_behaviour_field_level_encryption_id"
  }

  column "default_cache_behavior_forwarded_values_cookies_forward" {
    rename = "cache_behaviour_forwarded_values_cookies_forward"
  }

  column "default_cache_behavior_forwarded_values_cookies_whitelisted_names_quantity" {
    skip = true
    #    rename = "cache_behaviour_forwarded_values_cookies_whitelisted_names_quantity"
  }

  column "default_cache_behavior_forwarded_values_cookies_whitelisted_names_items" {
    rename = "cache_behaviour_forwarded_values_cookies_whitelisted_names"
  }

  column "default_cache_behavior_forwarded_values_query_string" {
    rename = "cache_behaviour_forwarded_values_query_string"
  }

  column "default_cache_behavior_forwarded_values_headers_quantity" {
    skip = true
    #    rename = "cache_behaviour_forwarded_values_headers_quantity"
  }

  column "default_cache_behavior_forwarded_values_headers_items" {
    rename = "cache_behaviour_forwarded_values_headers"
  }

  column "default_cache_behavior_forwarded_values_query_string_cache_keys_quantity" {
    skip = true
    #    rename = "cache_behaviour_forwarded_values_query_string_cache_keys_quantity"
  }

  column "default_cache_behavior_forwarded_values_query_string_cache_keys_items" {
    rename = "cache_behaviour_forwarded_values_query_string_cache_keys"
  }

  column "default_cache_behavior_lambda_function_associations_quantity" {
    skip = true
    #    rename = "cache_behaviour_lambda_function_associations_quantity"
  }

  column "default_cache_behavior_max_ttl" {
    rename = "cache_behaviour_max_ttl"
  }

  column "default_cache_behavior_min_ttl" {
    rename = "cache_behaviour_min_ttl"
  }

  column "default_cache_behavior_origin_request_policy_id" {
    rename = "cache_behaviour_origin_request_policy_id"
  }

  column "default_cache_behavior_realtime_log_config_arn" {
    rename = "cache_behaviour_realtime_log_config_arn"
  }

  column "default_cache_behavior_smooth_streaming" {
    rename = "cache_behaviour_smooth_streaming"
  }

  column "default_cache_behavior_trusted_key_groups_enabled" {
    rename = "cache_behaviour_trusted_key_groups_enabled"
  }

  column "default_cache_behavior_trusted_key_groups_quantity" {
    skip = true
    #    rename = "cache_behaviour_trusted_key_groups_quantity"
  }

  column "default_cache_behavior_trusted_key_groups_items" {
    rename = "cache_behaviour_trusted_key_groups"
  }

  column "default_cache_behavior_trusted_signers_enabled" {
    rename = "cache_behaviour_trusted_signers_enabled"
  }

  column "default_cache_behavior_trusted_signers_quantity" {
    skip = true
    #    rename = "cache_behaviour_trusted_signers_quantity"
  }

  column "default_cache_behavior_trusted_signers_items" {
    rename = "cache_behaviour_trusted_signers"
  }

  column "restrictions_geo_restriction_items" {
    rename = "restrictions_geo_restrictions"
  }

  column "viewer_certificate_a_c_m_certificate_arn" {
    rename = "viewer_certificate_acm_certificate_arn"
  }

  column "viewer_certificate_certificate_source" {
    rename = "viewer_certificate_source"
  }

  column "viewer_certificate_cloud_front_default_certificate" {
    rename = "viewer_certificate_cloudfront_default_certificate"
  }

  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }
}


resource "aws" "cloudtrail" "trails" {
  path = "github.com/aws/aws-sdk-go-v2/service/cloudtrail/types.Trail"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }
  postResourceResolver "postCloudtrailTrailResolver" {
    path     = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  column "home_region" {
    rename = "region"
  }

  column "trail_arn" {
    rename = "arn"
  }


  options {
    primary_keys = [
      "account_id",
      "arn"
    ]
  }

  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }


  userDefinedColumn "cloudwatch_logs_log_group_name" {
    type              = "string"
    generate_resolver = true
  }

  userDefinedColumn "is_logging" {
    description = " Whether the CloudTrail is currently logging AWS API calls."
    type        = "bool"
  }

  userDefinedColumn "latest_cloud_watch_logs_delivery_error" {
    description = "Displays any CloudWatch Logs error that CloudTrail encountered when attempting to deliver logs to CloudWatch Logs."
    type        = "string"
  }

  userDefinedColumn "latest_cloud_watch_logs_delivery_time" {
    description = "Displays the most recent date and time when CloudTrail delivered logs to CloudWatch Logs."
    type        = "timestamp"
  }


  userDefinedColumn "latest_delivery_error" {
    description = "Displays any Amazon S3 error that CloudTrail encountered when attempting to deliver log files to the designated bucket."
    type        = "string"
  }

  userDefinedColumn "latest_delivery_time" {
    description = "Specifies the date and time that CloudTrail last delivered log files to an account's Amazon S3 bucket."
    type        = "timestamp"
  }

  userDefinedColumn "latest_digest_delivery_error" {
    description = "Displays any Amazon S3 error that CloudTrail encountered when attempting to deliver a digest file to the designated bucket."
    type        = "string"
  }

  userDefinedColumn "latest_digest_delivery_time" {
    description = "Specifies the date and time that CloudTrail last delivered a digest file to an account's Amazon S3 bucket."
    type        = "timestamp"
  }

  userDefinedColumn "latest_notification_error" {
    description = " Displays any Amazon SNS error that CloudTrail encountered when attempting to send a notification."
    type        = "string"
  }

  userDefinedColumn "latest_notification_time" {
    description = "Specifies the date and time of the most recent Amazon SNS notification that CloudTrail has written a new log file to an account's Amazon S3 bucket."
    type        = "timestamp"
  }

  userDefinedColumn "start_logging_time" {
    description = "Specifies the most recent date and time when CloudTrail started recording API calls for an AWS account."
    type        = "timestamp"
  }

  userDefinedColumn "stop_logging_time" {
    description = "Specifies the most recent date and time when CloudTrail stopped recording API calls for an AWS account."
    type        = "timestamp"
  }

  relation "aws" "cloudtrail" "trail_event_selectors" {
    path = "github.com/aws/aws-sdk-go-v2/service/cloudtrail/types.EventSelector"

    column "data_resources" {
      skip = true
    }

    userDefinedColumn "trail_arn" {
      type        = "string"
      description = "Specifies the ARN of the trail"
      resolver "ParentPathResolver" {
        //argument is ("TrailARN")
        path          = "github.com/cloudquery/cq-provider-sdk/provider/schema.ParentPathResolver"
        generate      = true
        path_resolver = true
      }
    }
  }
}

resource "aws" "cloudwatch" "alarms" {
  path = "github.com/aws/aws-sdk-go-v2/service/cloudwatch/types.MetricAlarm"

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "o_k_actions" {
    rename = "ok_actions"
  }
  column "dimensions" {
    type              = "json"
    generate_resolver = true
  }

  relation "aws" "cloudwatch" "alarm_metrics" {
    path = "github.com/aws/aws-sdk-go-v2/service/cloudwatch/types.MetricDataQuery"

    column "id" {
      rename = "metric_id"
    }
    column "metric_stat_metric_dimensions" {
      rename            = "metric_stat_metric_dimensions"
      type              = "json"
      generate_resolver = true
    }

    column "metric_stat_metric_metric_name" {
      rename = "metric_stat_metric_name"
    }
  }

}

resource "aws" "cloudwatchlogs" "filters" {
  path = "github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs/types.MetricFilter"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  column "filter_name" {
    type   = "string"
    rename = "name"
  }
  column "filter_pattern" {
    type   = "string"
    rename = "pattern"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
}

resource "aws" "directconnect" "gateways" {
  path = "github.com/aws/aws-sdk-go-v2/service/directconnect/types.DirectConnectGateway"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
}

resource "aws" "directconnect" "virtual_interfaces" {
  path        = "github.com/aws/aws-sdk-go-v2/service/directconnect/types.VirtualInterface"
  description = "Information about a virtual interface. A virtual interface (VLAN) transmits the traffic between the AWS Direct Connect location and the customer network"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "tags" {
    type              = "json"
    generate_resolver = true
  }

  column "route_filter_prefixes" {
    type              = "StringArray"
    generate_resolver = true
  }
}

resource "aws" "directconnect" "virtual_gateways" {
  path = "github.com/aws/aws-sdk-go-v2/service/directconnect/types.VirtualGateway"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
}

resource "aws" "dms" "replication_instances" {
  path = "github.com/aws/aws-sdk-go-v2/service/databasemigrationservice/types.ReplicationInstance"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "pending_modified_values_replication_instance_class" {
    rename = "pending_modified_values_class"
  }

  column "replication_instance_arn" {
    rename = "arn"
  }

  column "replication_instance_class" {
    rename = "class"
  }

  column "replication_instance_identifier" {
    rename = "identifier"
  }

  column "replication_instance_private_ip_address" {
    type = "inet"
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.IPAddressResolver"
      path_resolver = true
    }
  }

  column "replication_instance_private_ip_addresses" {
    type = "inetrarray"
    generate_resolver = true
  }

  column "replication_instance_public_ip_address" {
    type = "inet"
    resolver "Resolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.IPAddressResolver"
      path_resolver = true
    }
  }

  column "replication_instance_public_ip_addresses" {
    type = "inetrarray"
    generate_resolver = true
  }

  column "replication_instance_status" {
    rename = "status"
  }
}

resource "aws" "ec2" "images" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.Image"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "tags" {
    type              = "json"
    generate_resolver = true
  }

  column "product_codes" {
    type              = "json"
    generate_resolver = true
  }

}

resource "aws" "ec2" "byoip_cidrs" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.ByoipCidr"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
}

resource "aws" "ec2" "instances" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.Instance"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  relation "aws" "ec2" "InstanceNetworkInterface" {
    path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.InstanceNetworkInterface"

    relation "aws" "ec2" "InstancePrivateIpAddress" {
      path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.InstancePrivateIpAddress"
      column "primary" {
        type   = "bool"
        rename = "is_primary"
      }
    }
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "capacity_reservation_specification_capacity_reservation_preference" {
    rename = "cap_reservation_preference"
  }

  column "capacity_reservation_specification_capacity_reservation_target_capacity_reservation_id" {
    rename = "cap_reservation_target_capacity_reservation_id"
  }

  column "capacity_reservation_specification_capacity_reservation_target_capacity_reservation_resource_group_arn" {
    rename = "cap_reservation_target_capacity_reservation_rg_arn"
  }

  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }

}

resource "aws" "ec2" "customer_gateways" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.CustomerGateway"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "ec2" "flow_logs" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.FlowLog"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "ec2" "internet_gateways" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.InternetGateway"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }

  relation "aws" "ec2" "internet_gateway_attachments" {
    path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.InternetGatewayAttachment"
  }
}

resource "aws" "ec2" "nat_gateways" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.NatGateway"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }

}

resource "aws" "ec2" "network_acls" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.NetworkAcl"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }

  relation "aws" "ec2" "network_acl_associations" {
    path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.NetworkAclAssociation"

    column "network_acl_id" {
      skip = true
    }
  }
}

resource "aws" "ec2" "route_tables" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.RouteTable"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "route_table_id" {
    // TypeJson
    type   = "string"
    rename = "resource_id"
  }

  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }

  relation "aws" "ec2" "associations" {
    path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.RouteTableAssociation"
    column "route_table_id" {
      skip = true
    }
  }

}

resource "aws" "ec2" "security_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.SecurityGroup"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "ec2" "subnets" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.Subnet"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "ec2" "transit_gateways" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.TransitGateway"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
}

resource "aws" "ec2" "vpc_peering_connections" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.VpcPeeringConnection"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "accepter_vpc_info_cidr_block_set" {
    type              = "stringArray"
    rename            = "accepter_cidr_block_set"
    generate_resolver = true
  }

  column "accepter_vpc_info_ipv6_cidr_block_set" {
    type              = "stringArray"
    rename            = "accepter_ipv6_cidr_block_set"
    generate_resolver = true
  }

  column "accepter_vpc_info_cidr_block" {
    rename = "accepter_cidr_block"
  }

  column "accepter_vpc_info_cidr_block_set" {
    rename = "accepter_cidr_block_set"
  }
  column "accepter_vpc_info_ipv6_cidr_block_set" {
    rename = "accepter_ipv6_cidr_block_set"
  }
  column "accepter_vpc_info_owner_id" {
    rename = "accepter_owner_id"
  }

  column "accepter_vpc_info_peering_options_allow_egress_from_local_vpc_to_remote_classic_link" {
    rename = "accepter_allow_egress_local_vpc_to_remote_classic_link"
  }

  column "accepter_vpc_info_peering_options_allow_egress_from_local_classic_link_to_remote_vpc" {
    rename = "accepter_allow_egress_local_classic_link_to_remote_vpc"
  }

  column "accepter_vpc_info_peering_options_allow_dns_resolution_from_remote_vpc" {
    rename = "accepter_allow_dns_resolution_from_remote_vpc"
  }

  column "accepter_vpc_info_vpc_id" {
    rename = "accepter_vpc_id"
  }

  column "accepter_vpc_info_region" {
    rename = "accepter_vpc_region"
  }

  column "requester_vpc_info_cidr_block_set" {
    type              = "stringArray"
    rename            = "requester_cidr_block_set"
    generate_resolver = true
  }

  column "requester_vpc_info_ipv6_cidr_block_set" {
    type              = "stringArray"
    rename            = "requester_ipv6_cidr_block_set"
    generate_resolver = true
  }

  column "requester_vpc_info_cidr_block" {
    rename = "requester_cidr_block"
  }
  column "requester_vpc_info_cidr_block_set" {
    rename = "requester_cidr_block_set"
  }
  column "requester_vpc_info_ipv6_cidr_block_set" {
    rename = "requester_ipv6_cidr_block_set"
  }
  column "requester_vpc_info_owner_id" {
    rename = "requester_owner_id"
  }

  column "requester_vpc_info_peering_options_allow_egress_from_local_vpc_to_remote_classic_link" {
    rename = "requester_allow_egress_local_vpc_to_remote_classic_link"
  }

  column "requester_vpc_info_peering_options_allow_egress_from_local_classic_link_to_remote_vpc" {
    rename = "requester_allow_egress_local_classic_link_to_remote_vpc"
  }

  column "requester_vpc_info_peering_options_allow_dns_resolution_from_remote_vpc" {
    rename = "requester_allow_dns_resolution_from_remote_vpc"
  }

  column "requester_vpc_info_vpc_id" {
    rename = "requester_vpc_id"
  }

  column "requester_vpc_info_region" {
    rename = "requester_vpc_region"
  }

  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}


resource "aws" "ec2" "vpc_endpoints" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.VpcEndpoint"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}


resource "aws" "ec2" "vpcs" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.Vpc"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "ecr" "repositories" {
  path = "github.com/aws/aws-sdk-go-v2/service/ecr/types.Repository"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "repository_name" {
    rename = "name"
  }

  column "repository_arn" {
    rename = "arn"
  }

  column "repository_uri" {
    rename = "uri"
  }

  relation "aws" "ecr" "repository_images" {
    path = "github.com/aws/aws-sdk-go-v2/service/ecr/types.ImageDetail"
    userDefinedColumn "account_id" {
      type        = "string"
      description = "The AWS Account ID of the resource."
      resolver "resolveAWSAccount" {
        path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
      }
    }
    userDefinedColumn "region" {
      type = "string"
      resolver "resolveAWSRegion" {
        path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
      }
    }
    column "tags" {
      // TypeJson
      type              = "json"
      generate_resolver = true
    }
  }
}

resource "aws" "ecs" "clusters" {
  path = "github.com/aws/aws-sdk-go-v2/service/ecs/types.Cluster"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "settings" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }

  column "statistics" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }

  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }

}

resource "aws" "efs" "filesystems" {
  path = "github.com/aws/aws-sdk-go-v2/service/efs/types.FileSystemDescription"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "eks" "clusters" {
  path = "github.com/aws/aws-sdk-go-v2/service/eks/types.Cluster"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  relation "aws" "eks" "logging" {
    path = "github.com/aws/aws-sdk-go-v2/service/eks/types.LogSetup"
    column "types" {
      generate_resolver = true
    }
  }

}

resource "aws" "elasticbeanstalk" "environments" {
  path = "github.com/aws/aws-sdk-go-v2/service/elasticbeanstalk/types.EnvironmentDescription"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  options {
    primary_keys = [
      "account_id",
      "id"
    ]
  }

  column "environment_arn" {
    rename = "arn"
  }

  column "environment_id" {
    rename = "id"
  }

  column "environment_name" {
    rename = "name"
  }

  column "c_n_a_m_e" {
    type   = "string"
    rename = "cname"
  }

  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }

  column "resources_load_balancer_domain" {
    type   = "string"
    rename = "load_balancer_domain"
  }

  column "resources_load_balancer_load_balancer_name" {
    type   = "string"
    rename = "load_balancer_name"
  }

  column "resources_load_balancer_listeners" {
    type              = "json"
    rename            = "listeners"
    generate_resolver = true
  }
}


resource "aws" "elbv2" "listeners" {
  path = "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2/types.Listener"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  relation "aws" "elbv2" "certificates" {
    path = "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2/types.Certificate"
  }

  options {
    primary_keys = [
      "arn"
    ]
  }

  relation "aws" "elbv2" "default_actions" {
    path = "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2/types.Action"
    column "authenticate_cognito_config" {
      rename = "cognito"
      skip_prefix = true
    }

  }

  column "listener_arn" {
    rename = "arn"
  }

  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }
}



resource "aws" "elbv2" "target_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2/types.TargetGroup"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "target_group_arn" {
    rename = "arn"
  }

  column "target_group_name" {
    rename = "name"
  }

  options {
    primary_keys = [
      "arn"
    ]
  }

  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "elbv2" "load_balancers" {
  path = "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2/types.LoadBalancer"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  relation "aws" "elbv2" "availability_zones" {
    path = "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2/types.AvailabilityZone"

    userDefinedColumn "load_balance_name" {
      type        = "string"
      //argument ("name")
      description = "The name of the load balancer"
      resolver "parentPathResolver" {
        path          = "github.com/cloudquery/cq-provider-sdk/provider/schema.ParentResourceFieldResolver"
        generate      = true
        path_resolver = true
      }
    }

    relation "aws" "elbv2" "addresses" {
      path = "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2/types.LoadBalancerAddress"

      column "ip_v6_address" {
        rename = "ipv6_address"
      }
      column "private_ip_v4_address" {
        rename = "private_ipv4_address"
      }

      userDefinedColumn "zone_name" {
        type        = "string"
        //argument ("zone_name")
        description = "The name of the Availability Zone.."
        resolver "parentPathResolver" {
          path          = "github.com/cloudquery/cq-provider-sdk/provider/schema.ParentResourceFieldResolver"
          generate      = true
          path_resolver = true
        }
      }
    }
  }

  column "load_balancer_arn" {
    rename = "arn"
  }

  column "load_balancer_name" {
    rename = "name"
  }

  options {
    primary_keys = [
      "arn"
    ]
  }

  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }


}


resource "aws" "elbv1" "load_balancers" {
  path = "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancing/types.LoadBalancerDescription"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  //github.com/aws/aws-sdk-go-v2/service/elasticloadbalancing/types.LoadBalancerAttributes
  //AccessLog
  userDefinedColumn "attributes_access_log_enabled" {
    description       = "Specifies whether access logs are enabled for the load balancer."
    type              = "bool"
    generate_resolver = true
  }
  userDefinedColumn "attributes_access_log_s3_bucket_name" {
    description       = "The name of the Amazon S3 bucket where the access logs are stored."
    type              = "string"
    generate_resolver = true
  }
  userDefinedColumn "attributes_access_log_s3_bucket_prefix" {
    type              = "string"
    description       = "The logical hierarchy you created for your Amazon S3 bucket, for example my-bucket-prefix/prod. If the prefix is not provided, the log is placed at the root level of the bucket."
    generate_resolver = true
  }
  userDefinedColumn "attributes_access_log_emit_interval" {
    description       = "The interval for publishing the access logs."
    type              = "int"
    generate_resolver = true
  }
  //ConnectionSettings
  userDefinedColumn "attributes_connection_settings_idle_timeout" {
    description       = "The time, in seconds, that the connection is allowed to be idle (no data has been sent over the connection) before it is closed by the load balancer."
    type              = "int"
    generate_resolver = true
  }
  //CrossZoneLoadBalancing
  userDefinedColumn "attributes_cross_zone_load_balancing_enabled" {
    description       = "Specifies whether cross-zone load balancing is enabled for the load balancer."
    type              = "bool"
    generate_resolver = true
  }
  //ConnectionDraining
  userDefinedColumn "attributes_connection_draining_enabled" {
    description       = "Specifies whether connection draining is enabled for the load balancer."
    type              = "bool"
    generate_resolver = true
  }
  userDefinedColumn "attributes_connection_draining_timeout" {
    description       = "The maximum time, in seconds, to keep the existing connections open before de-registering the instances."
    type              = "int"
    generate_resolver = true
  }
  //AdditionalAttributes
  userDefinedColumn "attributes_additional_attributes" {
    type              = "Json"
    description       = "Information about additional load balancer attributes"
    generate_resolver = true
  }

  userDefinedColumn "tags" {
    // TypeJson
    type = "json"
  }

  column "listener_descriptions" {
    rename = "listeners"
  }

  column "source_security_group_group_name" {
    rename = "source_security_group_name"
  }

  column "policies_other_policies" {
    rename = "other_policies"
  }

  column "policies_l_b_cookie_stickiness_policies" {
    rename = "policies_lb_cookie_stickiness_policies"
  }

  column "instances" {
    type              = "stringarray"
    generate_resolver = true
  }

  relation "aws" "elbv1" "load_balancer_policies" {
    path = "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancing/types.PolicyDescription"

    column "policy_attribute_descriptions" {
      type              = "json"
      generate_resolver = true
    }
  }
}

resource "aws" "emr" "clusters" {
  path = "github.com/aws/aws-sdk-go-v2/service/emr/types.ClusterSummary"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "id" {
    type   = "string"
    rename = "resource_id"
  }
}

resource "aws" "fsx" "backups" {
  path = "github.com/aws/aws-sdk-go-v2/service/fsx/types.Backup"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  column "file_system" {
    skip = true
  }
  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "iam" "groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam/types.Group"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  userDefinedColumn "attached_policies" {
    type              = "json"
    generate_resolver = true
    description       = "List of policies attached to group."
  }

  //relation "inline_policies"
}


resource "aws" "iam" "openid_connect_identity_providers" {
  path        = "github.com/aws/aws-sdk-go-v2/service/iam.GetOpenIDConnectProviderOutput"
  description = "IAM OIDC identity providers are entities in IAM that describe an external identity provider (IdP) service that supports the OpenID Connect (OIDC) standard, such as Google or Salesforce."
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  column "tags" {
    type              = "json"
    generate_resolver = true
  }
}


resource "aws" "iam" "saml_identity_providers" {
  path        = "github.com/aws/aws-sdk-go-v2/service/iam.GetSAMLProviderOutput"
  description = "SAML provider resource objects defined in IAM for the AWS account."
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  column "tags" {
    type              = "json"
    generate_resolver = true
  }
}


resource "aws" "iam" "group_policies" {
  path        = "github.com/aws/aws-sdk-go-v2/service/iam.GetGroupPolicyOutput"
  description = "Inline policies that are embedded in the specified IAM group"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  column "policy_document" {
    type              = "json"
    generate_resolver = true
  }
}


resource "aws" "iam" "role_policies" {
  path        = "github.com/aws/aws-sdk-go-v2/service/iam.GetRolePolicyOutput"
  description = "Inline policies that are embedded in the specified IAM role"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }
  userDefinedColumn "role_id" {
    type        = "uuid"
    description = "Role ID the policy belongs too."
    resolver "parentIdResolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.ParentIdResolver"
    }
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  column "policy_document" {
    type              = "json"
    generate_resolver = true
  }
}


resource "aws" "iam" "user_policies" {
  path        = "github.com/aws/aws-sdk-go-v2/service/iam.GetUserPolicyOutput"
  description = "Inline policies that are embedded in the specified IAM user"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }
  userDefinedColumn "user_id" {
    type        = "uuid"
    description = "User ID the policy belongs too."
    resolver "parentIdResolver" {
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.ParentIdResolver"
    }
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  column "policy_document" {
    type              = "json"
    generate_resolver = true
  }
}


resource "aws" "iam" "password_policies" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam/types.PasswordPolicy"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
}

resource "aws" "iam" "policies" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam/types.ManagedPolicyDetail"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountDeleteFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  relation "aws" "iam" "policy_versions" {
    path = "github.com/aws/aws-sdk-go-v2/service/iam/types.PolicyVersion"

    column "document" {
      type              = "json"
      generate_resolver = true
    }
  }
}

resource "aws" "iam" "roles" {
  path        = "github.com/aws/aws-sdk-go-v2/service/iam/types.Role"
  description = "An IAM role is an IAM identity that you can create in your account that has specific permissions."
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountDeleteFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "policies" {
    type              = "json"
    generate_resolver = true
    description       = "List of policies attached to group."
  }

  column "assume_role_policy_document" {
    type              = "json"
    generate_resolver = true
  }

  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "iam" "server_certificates" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam/types.ServerCertificateMetadata"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
}


resource "aws" "iam" "virtual_mfa_devices" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam/types.VirtualMFADevice"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  column "tags" {
    type              = "json"
    generate_resolver = true
  }
  column "user_tags" {
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "kms" "keys" {
  path = "github.com/aws/aws-sdk-go-v2/service/kms/types.KeyListEntry"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  postResourceResolver "resolveKmsKey" {
    path     = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  options {
    primary_keys = [
      "arn"
    ]
  }

  column "key_arn" {
    rename = "arn"
  }

  column "key_id" {
    rename = "id"
  }

  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  userDefinedColumn "rotation_enabled" {
    description = "specifies whether key rotation is enabled."
    type        = "bool"
  }
  userDefinedColumn "cloud_hsm_cluster_id" {
    description = "The cluster ID of the AWS CloudHSM cluster that contains the key material for the CMK"
    type        = "string"
  }
  userDefinedColumn "creation_date" {
    description = "The date and time when the CMK was created."
    type        = "timestamp"
  }
  userDefinedColumn "custom_key_store_id" {
    description = "A unique identifier for the custom key store."
    type        = "string"
  }
  userDefinedColumn "customer_master_key_spec" {
    description = "Describes the type of key material in the CMK."
    type        = "string"
  }
  userDefinedColumn "deletion_date" {
    description = "he date and time after which AWS KMS deletes the CMK. This value is present only when KeyState is PendingDeletion."
    type        = "timestamp"
  }
  userDefinedColumn "description" {
    description = "The description of the CMK."
    type        = "string"
  }
  userDefinedColumn "enabled" {
    description = "Specifies whether the CMK is enabled."
    type        = "bool"
  }
  userDefinedColumn "encryption_algorithms" {
    description = "The encryption algorithms that the CMK supports."
    type        = "stringarray"
  }
  userDefinedColumn "expiration_model" {
    description = "Specifies whether the CMK's key material expires."
    type        = "string"
  }
  userDefinedColumn "manager" {
    description = "The manager of the CMK."
    type        = "string"
  }
  userDefinedColumn "key_state" {
    description = "The current status of the CMK."
    type        = "string"
  }
  userDefinedColumn "key_usage" {
    description = "The cryptographic operations for which you can use the CMK."
    type        = "string"
  }
  userDefinedColumn "origin" {
    description = "The source of the CMK's key material."
    type        = "string"
  }
  userDefinedColumn "signing_algorithms" {
    description = "The signing algorithms that the CMK supports."
    type        = "stringarray"
  }
  userDefinedColumn "valid_to" {
    description = "The time at which the imported key material expires."
    type        = "timestamp"
  }
}

resource "aws" "organizations" "accounts" {
  path = "github.com/aws/aws-sdk-go-v2/service/organizations/types.Account"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "id" {
    type   = "string"
    rename = "resource_id"
  }
}

resource "aws" "rds" "clusters" {
  path = "github.com/aws/aws-sdk-go-v2/service/rds/types.DBCluster"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "pending_modified_values_pending_cloudwatch_logs_exports_log_types_to_disable" {
    rename = "pending_cloudwatch_logs_types_to_disable"
  }

  column "pending_modified_values_pending_cloudwatch_logs_exports_log_types_to_enable" {
    rename = "pending_cloudwatch_logs_types_to_enable"
  }

  column "tag_list" {
    // TypeJson
    rename            = "tags"
    type              = "json"
    generate_resolver = true
  }

  column "aws_rds_instance_pending_modified_values_processor_features" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }

  column "aws_rds_instance_processor_features" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "rds" "certificates" {
  path = "github.com/aws/aws-sdk-go-v2/service/rds/types.Certificate"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
}

resource "aws" "rds" "db_subnet_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/rds/types.DBSubnetGroup"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
}

resource "aws" "rds" "instances" {
  path = "github.com/aws/aws-sdk-go-v2/service/rds/types.DBInstance"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "tag_list" {
    // TypeJson
    rename            = "tags"
    type              = "json"
    generate_resolver = true
  }

  column "pending_modified_values_pending_cloudwatch_logs_exports_log_types_to_enable" {
    rename = "pending_cloudwatch_logs_types_to_enable"
  }

  column "pending_modified_values_pending_cloudwatch_logs_exports_log_types_to_disable" {
    rename = "pending_cloudwatch_logs_types_to_disable"
  }

  column "pending_modified_values_processor_features" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }

  column "processor_features" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}


resource "aws" "route53" "hosted_zones" {
  path = "github.com/aws/aws-sdk-go-v2/service/route53/types.HostedZone"

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }


  column "id" {
    rename = "resource_id"
  }

  column "linked_service_service_principal" {
    rename = "linked_service_principal"
  }

  userDefinedColumn "tags" {
    type        = "json"
    description = "The tags associated with the hosted zone."
  }

  userDefinedColumn "delegation_set_id" {
    type        = "string"
    description = "A complex type that lists the Amazon Route 53 name servers for the specified hosted zone."
  }


  relation "aws" "route53" "query_logging_configs" {
    path = "github.com/aws/aws-sdk-go-v2/service/route53/types.QueryLoggingConfig"
    column "id" {
      rename = "query_logging_config_id"
    }

    column "hosted_zone_id" {
      skip = true
    }
  }

  relation "aws" "route53" "resource_record_sets" {
    path = "github.com/aws/aws-sdk-go-v2/service/route53/types.ResourceRecordSet"

    column "alias_target" {
      skip_prefix = true
    }

    column "hosted_zone_id" {
      skip = true
    }

    column "resource_records" {
      skip = true
    }

    userDefinedColumn "resource_records" {
      type              = "stringarray"
      generate_resolver = true
    }
  }

  relation "aws" "route53" "traffic_policy_instances" {
    path = "github.com/aws/aws-sdk-go-v2/service/route53/types.TrafficPolicyInstance"

    column "hosted_zone_id" {
      skip = true
    }

    column "id" {
      rename = "policy_id"
    }
  }

  relation "aws" "route53" "vpc_association_authorizations" {
    path = "github.com/aws/aws-sdk-go-v2/service/route53/types.VPC"

    column "hosted_zone_id" {
      skip = true
    }
  }
}


//resource "aws" "route53" "reusable_delegation_sets" {
//  path = "github.com/aws/aws-sdk-go-v2/service/route53/types.DelegationSet"
//
//  column "id" {
//    rename = "resource_id"
//  }
//
//  ignoreError "IgnoreAccessDenied" {
//    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
//  }
//  multiplex "AwsAccountRegion" {
//    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
//  }
//  deleteFilter "AccountRegionFilter" {
//    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
//  }
//
//  userDefinedColumn "account_id" {
//    type = "string"
//    description = "The AWS Account ID of the resource."
//    resolver "resolveAWSAccount" {
//      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
//    }
//  }
//}

resource "aws" "route53" "health_checks" {
  path = "github.com/aws/aws-sdk-go-v2/service/route53/types.HealthCheck"

  column "id" {
    rename = "resource_id"
  }

  column "cloud_watch_alarm_configuration_comparison_operator" {
    rename = "cloud_watch_alarm_config_comparison_operator"
  }

  column "cloud_watch_alarm_configuration_evaluation_periods" {
    rename = "cloud_watch_alarm_config_evaluation_periods"
  }

  column "cloud_watch_alarm_configuration_metric_name" {
    rename = "cloud_watch_alarm_config_metric_name"
  }

  column "cloud_watch_alarm_configuration_namespace" {
    rename = "cloud_watch_alarm_config_namespace"
  }

  column "cloud_watch_alarm_configuration_period" {
    rename = "cloud_watch_alarm_config_period"
  }

  column "cloud_watch_alarm_configuration_statistic" {
    rename = "cloud_watch_alarm_config_statistic"
  }

  column "cloud_watch_alarm_configuration_threshold" {
    rename = "cloud_watch_alarm_config_threshold"
  }

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  column health_check_config {
    skip_prefix = true
  }

  column "enable_s_n_i" {
    rename = "enable_sni"
  }

  column "cloud_watch_alarm_configuration_dimensions" {
    skip = true
  }

  column "insufficient_data_health_status" {
    description = "When CloudWatch has insufficient data about the metric to determine the alarm state, the status that you want Amazon Route 53 to assign to the health check."
  }

  userDefinedColumn "cloud_watch_alarm_configuration_dimensions" {
    type              = "json"
    description       = "the metric that the CloudWatch alarm is associated with, a complex type that contains information about the dimensions for the metric."
    generate_resolver = true
  }

  userDefinedColumn "tags" {
    type        = "json"
    description = "The tags associated with the health check."
  }

}


resource "aws" "route53" "traffic_policies" {
  path = "github.com/aws/aws-sdk-go-v2/service/route53/types.TrafficPolicySummary"

  column "id" {
    rename = "resource_id"
  }

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }


  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  relation "aws" "route53" "versions" {
    path = "github.com/aws/aws-sdk-go-v2/service/route53/types.TrafficPolicy"

    column "id" {
      rename = "version_id"
    }

    column "document" {
      type              = "Json"
      generate_resolver = true
    }
  }
}

resource "aws" "sns" "topics" {
  path = "github.com/aws/aws-sdk-go-v2/service/sns/types.Topic"

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  postResourceResolver "resolveTopicAttributes" {
    path     = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }


  // Topic attributes are returned as a string we define this to handle type conversion
  userDefinedColumn "owner" {
    type        = "string"
    description = "The AWS account ID of the topic's owner."
  }
  userDefinedColumn "policy" {
    type        = "Json"
    description = "The JSON serialization of the topic's access control policy."
  }
  userDefinedColumn "delivery_policy" {
    type        = "Json"
    description = "The JSON serialization of the topic's delivery policy."
  }
  userDefinedColumn "display_name" {
    type        = "string"
    description = "The human-readable name used in the From field for notifications to email and email-json endpoints."
  }
  userDefinedColumn "subscription_confirmed" {
    type        = "int"
    description = "The number of confirmed subscriptions for the topic."
  }
  userDefinedColumn "subscription_deleted" {
    type        = "int"
    description = "The number of deleted subscriptions for the topic."
  }
  userDefinedColumn "subscription_pending" {
    type        = "int"
    description = "The number of subscriptions pending confirmation for the topic."
  }
  userDefinedColumn "effective_delivery_policy" {
    type        = "Json"
    description = "The JSON serialization of the effective delivery policy, taking system defaults into account."
  }
  userDefinedColumn "fifo_topic" {
    type        = "bool"
    description = "When this is set to true, a FIFO topic is created."
  }

  userDefinedColumn "content_based_deduplication" {
    type        = "bool"
    description = "Enables content-based deduplication for FIFO topics."
  }
}

resource "aws" "s3" "buckets" {
  path        = "github.com/aws/aws-sdk-go-v2/service/s3/types.Bucket"
  description = "An Amazon S3 bucket is a public cloud storage resource available in Amazon Web Services' (AWS) Simple Storage Service (S3)"

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountFilter"
  }

  postResourceResolver "resolveS3BucketsAttributes" {
    path     = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
  }

  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "ResolveAwsAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
  }

  userDefinedColumn "logging_target_prefix" {
    type = "string"
  }

  userDefinedColumn "logging_target_bucket" {
    type = "string"
  }

  userDefinedColumn "versioning_status" {
    type = "string"
  }

  userDefinedColumn "versioning_mfa_delete" {
    type = "string"
  }

  userDefinedColumn "policy" {
    type = "json"
  }

  userDefinedColumn "tags" {
    type = "json"
  }

  relation "aws" "s3" "grants" {
    path = "github.com/aws/aws-sdk-go-v2/service/s3/types.Grant"

    column "grantee" {
      skip_prefix = true
    }
    column "id" {
      rename = "resource_id"
    }
  }

  relation "aws" "s3" "cors_rules" {
    path = "github.com/aws/aws-sdk-go-v2/service/s3/types.CORSRule"
    column "id" {
      rename = "resource_id"
    }
  }
  relation "aws" "s3" "public_access_block" {
    path              = "github.com/aws/aws-sdk-go-v2/service/s3/types.PublicAccessBlockConfiguration"
    embed             = true
    embed_skip_prefix = true
  }

  relation "aws" "s3" "encryption_rules" {
    path = "github.com/aws/aws-sdk-go-v2/service/s3/types.ServerSideEncryptionRule"

    column "apply_server_side_encryption_by_default_s_s_e_algorithm" {
      rename = "sse_algorithm"

    }
    column "apply_server_side_encryption_by_default_kms_master_key_id" {
      rename = "kms_master_key_id"
    }
  }

  relation "aws" "s3" "replication" {
    path  = "github.com/aws/aws-sdk-go-v2/service/s3/types.ReplicationConfiguration"
    embed = true
    column "role" {
      generate_resolver = false
    }
    relation "aws" "s3" "replication_rules" {
      path = "github.com/aws/aws-sdk-go-v2/service/s3/types.ReplicationRule"

      column "filter" {
        type              = "json"
        generate_resolver = true
      }
      column "destination_replication_time_time_minutes" {
        rename = "destination_replication_time_minutes"
      }

      column "id" {
        rename = "resource_id"
      }

      column "source_selection_criteria_replica_modifications_status" {
        rename = "source_replica_modifications_status"
      }
      column "source_selection_criteria_sse_kms_encrypted_objects_status" {
        rename = "source_sse_kms_encrypted_objects_status"
      }
    }
  }


  relation "aws" "s3" "lifecycle" {
    path = "github.com/aws/aws-sdk-go-v2/service/s3/types.LifecycleRule"
    column "filter" {
      type              = "json"
      generate_resolver = true
    }
    column "id" {
      rename = "resource_id"
    }
    column "transitions" {
      type              = "json"
      generate_resolver = true
    }
    column "noncurrent_version_expiration_noncurrent_days" {
      rename = "noncurrent_version_expiration_days"
    }
    column "noncurrent_version_transitions" {
      type              = "json"
      generate_resolver = true
    }
  }
}


resource "aws" "sns" "subscriptions" {
  path = "github.com/aws/aws-sdk-go-v2/service/sns/types.Subscription"

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
}

resource "aws" "redshift" "clusters" {
  path = "github.com/aws/aws-sdk-go-v2/service/redshift/types.Cluster"

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "tags" {
    type              = "json"
    generate_resolver = true
  }

  relation "aws" "redshift" "parameter_groups" {
    path = "github.com/aws/aws-sdk-go-v2/service/redshift/types.ClusterParameterGroupStatus"

    relation "aws" "redshift" "status_lists" {
      path = "github.com/aws/aws-sdk-go-v2/service/redshift/types.ClusterParameterStatus"

    }
  }
}

resource "aws" "redshift" "subnet_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/redshift/types.ClusterSubnetGroup"

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  relation "aws" "redshift" "Subnet" {
    path = "github.com/aws/aws-sdk-go-v2/service/redshift/types.Subnet"
    column "subnet_availability_zone_supported_platforms" {
      // TypeStringArray
      type              = "stringArray"
      generate_resolver = true
      description       = "A list of supported platforms for orderable clusters."
    }
  }


  column "tags" {
    // TypeJson
    type              = "json"
    generate_resolver = true
  }
}


resource "aws" "access_analyzer" "analyzer" {
  path = "github.com/aws/aws-sdk-go-v2/service/accessanalyzer/types.AnalyzerSummary"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "tags" {
    // TypeJson
    type = "json"
  }

  relation "aws" "access_analyzer" "finding" {
    path = "github.com/aws/aws-sdk-go-v2/service/accessanalyzer/types.FindingSummary"

    column "id" {
      type   = "string"
      rename = "finding_id"
    }
  }
}

resource "aws" "config" "configuration_recorders" {
  path = "github.com/aws/aws-sdk-go-v2/service/configservice/types.ConfigurationRecorder"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
}

resource "aws" "config" "conformance_pack" {
  path = "github.com/aws/aws-sdk-go-v2/service/configservice/types.ConformancePackDetail"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  column "conformance_pack_input_parameters" {
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "waf" "webacls" {
  path = "github.com/aws/aws-sdk-go-v2/service/waf/types.WebACL"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }

  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  relation "aws" "waf" "rules" {
    path = "github.com/aws/aws-sdk-go-v2/service/waf/types.ActivatedRule"
    column "excluded_rules" {
      // TypeStringArray
      type              = "stringArray"
      generate_resolver = true
    }
  }
}

resource "aws" "waf" "rule_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/waf/types.RuleGroup"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  userDefinedColumn "arn" {
    type              = "string"
    generate_resolver = true
  }
  userDefinedColumn "rule_ids" {
    type              = "stringArray"
    generate_resolver = true
  }
  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "waf" "subscribed_rule_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/waf/types.SubscribedRuleGroupSummary"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
}

resource "aws" "waf" "rules" {
  path = "github.com/aws/aws-sdk-go-v2/service/waf/types.Rule"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  userDefinedColumn "arn" {
    type              = "string"
    generate_resolver = true
  }
  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }

  relation "aws" "waf" "predicates" {
    path = "github.com/aws/aws-sdk-go-v2/service/waf/types.Predicate"
  }
}

resource "aws" "wafv2" "web_acls" {
  path        = "github.com/aws/aws-sdk-go-v2/service/wafv2/types.WebACL"
  limit_depth = 1
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  userDefinedColumn "resources_for_web_acl" {
    type              = "stringArray"
    generate_resolver = true
  }
  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }

  column "id" {
    type   = "string"
    rename = "resource_id"
  }
  column "default_action" {
    type              = "json"
    generate_resolver = true
  }
  column "pre_process_firewall_manager_rule_groups" {
    skip = true
  }
  column "post_process_firewall_manager_rule_groups" {
    skip = true
  }
  relation "aws" "wafv2" "rules" {
    path = "github.com/aws/aws-sdk-go-v2/service/wafv2/types.Rule"
    column "statement" {
      type              = "json"
      generate_resolver = true
    }
    column "action" {
      type              = "json"
      generate_resolver = true
    }
    column "override_action" {
      type              = "json"
      generate_resolver = true
    }
    column "rule_labels" {
      type              = "stringArray"
      generate_resolver = true
      rename            = "labels"
    }
  }
  relation "aws" "wafv2" "post_process_firewall_manager_rule_groups" {
    path = "github.com/aws/aws-sdk-go-v2/service/wafv2/types.FirewallManagerRuleGroup"
    column "firewall_manager_statement" {
      type              = "json"
      generate_resolver = true
      rename            = "statement"
    }
    column "override_action" {
      type              = "json"
      generate_resolver = true
    }
  }
  relation "aws" "wafv2" "pre_process_firewall_manager_rule_groups" {
    path = "github.com/aws/aws-sdk-go-v2/service/wafv2/types.FirewallManagerRuleGroup"
    column "firewall_manager_statement" {
      type              = "json"
      generate_resolver = true
      rename            = "statement"
    }
    column "override_action" {
      type              = "json"
      generate_resolver = true
    }
  }
}

resource "aws" "wafv2" "rule_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/wafv2/types.RuleGroup"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }
  userDefinedColumn "policy" {
    type              = "json"
    generate_resolver = true
  }

  column "id" {
    type   = "string"
    rename = "resource_id"
  }
  column "rules" {
    type              = "json"
    generate_resolver = true
  }
}

resource "aws" "wafv2" "managed_rule_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/wafv2/types.ManagedRuleGroupSummary"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccount" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  postResourceResolver "resolveDescribeManagedRuleGroup" {
    path     = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
  }
  userDefinedColumn "available_labels" {
    type = "stringArray"
  }
  userDefinedColumn "consumed_labels" {
    type = "stringArray"
  }
  userDefinedColumn "capacity" {
    type = "bigint"
  }
  userDefinedColumn "label_namespace" {
    type = "string"
  }
  userDefinedColumn "rules" {
    type = "json"
  }
  userDefinedColumn "arn" {
    type              = "string"
    generate_resolver = true
  }
  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }

  relation "aws" "waf" "predicates" {
    path = "github.com/aws/aws-sdk-go-v2/service/waf/types.Predicate"
  }
}

resource "aws" "lambda" "functions" {
  path        = "github.com/aws/aws-sdk-go-v2/service/lambda.GetFunctionOutput"
  description = "AWS Lambda is a serverless compute service that lets you run code without provisioning or managing servers, creating workload-aware cluster scaling logic, maintaining event integrations, or managing runtimes"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  postResourceResolver "resolvePolicyCodeSigningConfig" {
    path     = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
  }

  userDefinedColumn "policy_document" {
    type        = "json"
    description = "The resource-based policy."
  }
  userDefinedColumn "policy_revision_id" {
    type        = "string"
    description = "A unique identifier for the current revision of the policy."
  }

  userDefinedColumn "code_signing_allowed_publishers_version_arns" {
    type        = "stringarray"
    description = "The Amazon Resource Name (ARN) for each of the signing profiles. A signing profile defines a trusted user who can sign a code package."
  }
  userDefinedColumn "code_signing_config_arn" {
    description = "The Amazon Resource Name (ARN) of the Code signing configuration."
    type        = "string"
  }
  userDefinedColumn "code_signing_config_id" {
    description = "Unique identifier for the Code signing configuration."
    type        = "string"
  }
  userDefinedColumn "code_signing_policies_untrusted_artifact_on_deployment" {
    description = "Code signing configuration policy for deployment validation failure."
    type        = "string"
  }
  userDefinedColumn "code_signing_description" {
    description = "Code signing configuration description."
    type        = "string"
  }
  userDefinedColumn "code_signing_last_modified" {
    description = "The date and time that the Code signing configuration was last modified, in ISO-8601 format (YYYY-MM-DDThh:mm:ss.sTZD)."

    type = "timestamp"
  }
  column "configuration" {
    skip_prefix = true
  }

  column "image_config_response" {
    skip_prefix = true
  }

  column "environment_error_error_code" {
    rename = "environment_error_code"
  }


  relation "aws" "lambda" "function_aliases" {
    path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.AliasConfiguration"
  }

  relation "aws" "lambda" "function_event_invoke_configs" {
    path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.FunctionEventInvokeConfig"

    column "destination_config" {
      skip_prefix = true
    }
  }

  relation "aws" "lambda" "function_versions" {
    path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.FunctionConfiguration"
    column "image_config_response" {
      skip_prefix = true
    }
  }

  relation "aws" "lambda" "function_concurrency_configs" {
    path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.ProvisionedConcurrencyConfigListItem"
    column "image_config_response" {
      skip_prefix = true
    }
  }

  relation "aws" "lambda" "function_event_source_mappings" {
    path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.EventSourceMappingConfiguration"
    column "image_config_response" {
      skip_prefix = true
    }

    column "source_access_configurations" {
      rename = "access_configurations"
    }

    column "destination_config" {
      skip_prefix = true
    }
  }

}


resource "aws" "lambda" "layers" {
  path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.LayersListItem"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type        = "string"
    description = "The AWS Account ID of the resource."
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }


  relation "aws" "lambda" "layer_versions" {
    path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.LayerVersionsListItem"
    relation "aws" "lambda" "layer_version_policies" {
      path = "github.com/aws/aws-sdk-go-v2/service/lambda.GetLayerVersionPolicyOutput"
    }
  }


  column "tags" {
    type              = "json"
    generate_resolver = true
  }
}


resource "aws" "lambda" "layers" {
  path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.LayersListItem"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }


  relation "aws" "lambda" "layer_versions" {
    path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.LayerVersionsListItem"
    relation "aws" "lambda" "layer_version_policies" {
      path = "github.com/aws/aws-sdk-go-v2/service/lambda.GetLayerVersionPolicyOutput"
    }
  }

  column "tags" {
    type              = "json"
    generate_resolver = true
  }
}


resource "aws" "apigatewayv2" "apis" {
  path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Api"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  relation "aws" "apigatewayv2" "authorizers" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Authorizer"
  }

  relation "aws" "apigatewayv2" "deployments" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Deployment"
  }

  relation "aws" "apigatewayv2" "integrations" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Integration"

    relation "aws" "apigatewayv2" "responses" {
      path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.IntegrationResponse"
    }
  }

  relation "aws" "apigatewayv2" "models" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Model"
    userDefinedColumn "model_template" {
      type              = "string"
      generate_resolver = true
    }
  }

  relation "aws" "apigatewayv2" "routes" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Route"
    relation "aws" "apigatewayv2" "responses" {
      path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.RouteResponse"
    }
  }

  relation "aws" "apigatewayv2" "stages" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Stage"
    column "default_route_settings_data_trace_enabled" {
      rename = "route_settings_data_trace_enabled"
    }
    column "default_route_settings_detailed_metrics_enabled" {
      rename = "route_settings_detailed_metrics_enabled"
    }
    column "default_route_settings_logging_level" {
      rename = "route_settings_logging_level"
    }
    column "default_route_settings_throttling_burst_limit" {
      rename = "route_settings_throttling_burst_limit"
    }
    column "default_route_settings_throttling_rate_limit" {
      rename = "route_settings_throttling_rate_limit"
    }

  }
}


resource "aws" "apigatewayv2" "domain_names" {
  path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.DomainName"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  relation "aws" "apigatewayv2" "rest_api_mappings" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.ApiMapping"

    //    column "rest_api_id" {
    //      skip = true
    //    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
}

resource "aws" "apigatewayv2" "vpc_links" {
  path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.VpcLink"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  options {
    primary_keys = [
      "account_id",
      "id"
    ]
  }

  column "vpc_link_id" {
    rename = "id"
  }

  column "tags" {
    generate_resolver = true
  }
}


resource "aws" "apigateway" "rest_apis" {
  path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.RestApi"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "id" {
    rename = "resource_id"
  }

  relation "aws" "apigateway" "rest_api_authorizers" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.Authorizer"

    column "id" {
      rename = "resource_id"
    }

    column "provider_arn_s" {
      rename = "provider_arns"
    }
  }

  relation "aws" "apigateway" "rest_api_deployments" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.Deployment"
    column "id" {
      rename = "resource_id"
    }
  }

  relation "aws" "apigateway" "rest_api_documentation_parts" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.DocumentationPart"
    column "id" {
      rename = "documentation_part_id"
    }
  }

  relation "aws" "apigateway" "rest_api_documentation_versions" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.DocumentationVersion"
  }

  relation "aws" "apigateway" "rest_api_gateway_responses" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.GatewayResponse"
  }

  relation "aws" "apigateway" "rest_api_models" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.Model"

    column "id" {
      rename = "resource_id"
    }

    userDefinedColumn "model_template" {
      type              = "string"
      generate_resolver = true
    }
  }
  relation "aws" "apigateway" "rest_api_request_validators" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.RequestValidator"
    column "id" {
      rename = "resource_id"
    }
  }

  relation "aws" "apigateway" "rest_api_resources" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.Resource"
    column "id" {
      rename = "resource_id"
    }
  }

  relation "aws" "apigateway" "rest_api_stages" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.Stage"
  }
}

resource "aws" "apigateway" "usage_plans" {
  path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.UsagePlan"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "id" {
    rename = "resource_id"
  }

  relation "aws" "apigateway" "usage_plan_keys" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.UsagePlanKey"

    column "id" {
      rename = "resource_id"
    }
  }
}

resource "aws" "apigateway" "domain_names" {
  path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.DomainName"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  relation "aws" "apigateway" "domain_name_base_path_mappings" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.BasePathMapping"
  }
}


resource "aws" "apigateway" "client_certificates" {
  path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.ClientCertificate"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
}


resource "aws" "apigateway" "api_keys" {
  path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.ApiKey"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }
  column "id" {
    rename = "resource_id"
  }
}

resource "aws" "apigateway" "vpc_links" {
  path = "github.com/aws/aws-sdk-go-v2/service/apigateway/types.VpcLink"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type        = "string"
    description = "The AWS Region of the resource."
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "id" {
    rename = "resource_id"
  }
}

resource "aws" "mq" "brokers" {
  path = "github.com/aws/aws-sdk-go-v2/service/mq.DescribeBrokerOutput"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    description = "The AWS Region of the resource."
    type        = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "auto_minor_version_upgrade" {
    description = "Enables automatic upgrades to new minor versions for brokers, as Apache releases the versions."
  }

  column "broker_instances" {
    type              = "json"
    generate_resolver = true
  }

  column "configurations" {
    skip = true
  }

  column "deployment_mode" {
    description = "The deployment mode of the broker."
  }

  column "encryption_options_use_aws_owned_key" {
    description = "Enables the use of an AWS owned CMK using AWS Key Management Service (KMS)."
  }

  column "encryption_options_kms_key_id" {
    description = "The symmetric customer master key (CMK) to use for the AWS Key Management Service (KMS)."
  }

  column "engine_type" {
    description = "The type of broker engine."
  }

  column "ldap_server_metadata" {
    type              = "json"
    generate_resolver = true
  }

  column "logs" {
    type              = "json"
    generate_resolver = true
  }

  column "maintenance_window_start_time" {
    type              = "json"
    generate_resolver = true
  }

  column "pending_ldap_server_metadata" {
    type              = "json"
    generate_resolver = true
  }

  column "publicly_accessible" {
    description = "Enables connections from applications outside of the VPC that hosts the broker's subnets."
  }

  column "users" {
    skip = true
  }

  relation "aws" "mq" "configurations" {
    path = "github.com/aws/aws-sdk-go-v2/service/mq.DescribeConfigurationOutput"
    ignoreError "IgnoreAccessDenied" {
      path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
    }
    multiplex "AwsAccountRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
    }
    deleteFilter "AccountRegionFilter" {
      path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
    }
    userDefinedColumn "account_id" {
      description = "The AWS Account ID of the resource."
      type        = "string"
      resolver "resolveAWSAccount" {
        path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
      }
    }
    userDefinedColumn "region" {
      description = "The AWS Region of the resource."
      type        = "string"
      resolver "resolveAWSRegion" {
        path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
      }
    }

    column "arn" {
      description = "The ARN of the configuration."
    }

    column "created" {
      description = "The date and time of the configuration revision."
    }

    column "description" {
      description = "The description of the configuration."
    }

    column "engine_type" {
      description = "The type of broker engine."
    }

    column "engine_version" {
      description = "The version of the broker engine."
    }

    column "id" {
      description = "The unique ID that Amazon MQ generates for the configuration."
      type        = "string"
      rename      = "resource_id"
    }

    column "latest_revision_created" {
      description = "The date and time of the configuration revision."
    }

    column "latest_revision_description" {
      description = "The description of the configuration revision."
    }

    column "latest_revision" {
      description = "The revision number of the configuration."
    }

    column "name" {
      description = "The name of the configuration."
    }
  }

  relation "aws" "mq" "users" {
    path = "github.com/aws/aws-sdk-go-v2/service/mq.DescribeUserOutput"
    ignoreError "IgnoreAccessDenied" {
      path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
    }
    multiplex "AwsAccountRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
    }
    deleteFilter "AccountRegionFilter" {
      path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
    }
    userDefinedColumn "account_id" {
      description = "The AWS Account ID of the resource."
      type        = "string"
      resolver "resolveAWSAccount" {
        path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
      }
    }
    userDefinedColumn "region" {
      description = "The AWS Region of the resource."
      type        = "string"
      resolver "resolveAWSRegion" {
        path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
      }
    }

    column "broker_id" {
      skip = true
    }

    column "pending" {
      type              = "json"
      generate_resolver = true
    }

    column "username" {
      description = "The username of the ActiveMQ user."
    }
  }
}

resource "aws" "elasticsearch" "domains" {
  path = "github.com/aws/aws-sdk-go-v2/service/elasticsearchservice/types.ElasticsearchDomainStatus"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    description = "The AWS Region of the resource."
    type        = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }


  options {
    primary_keys = [
      "account_id",
      "id"
    ]
  }

  column "domain_id" {
    rename = "id"
  }


  column "domain_name" {
    rename = "name"
  }

  userDefinedColumn "tags" {
    type              = "json"
    generate_resolver = true
  }

  column "advanced_security_options_enabled" {
    rename = "advanced_security_enabled"
  }

  column "advanced_security_options_internal_user_database_enabled" {
    rename = "advanced_security_internal_user_database_enabled"
  }

  column "advanced_security_options_saml_options_enabled" {
    rename = "advanced_security_saml_enabled"
  }

  column "advanced_security_options_saml_options_idp_entity_id" {
    rename      = "advanced_security_saml_idp_entity_id"
    description = "The unique Entity ID of the application in SAML Identity Provider."
  }

  column "advanced_security_options_saml_options_idp_metadata_content" {
    rename      = "advanced_security_saml_roles_key"
    description = "The Metadata of the SAML application in XML format."
  }

  column "advanced_security_options_saml_options_session_timeout_minutes" {
    rename = "advanced_security_saml_session_timeout_minutes"
  }

  column "advanced_security_options_saml_options_subject_key" {
    rename = "advanced_security_saml_subject_key"
  }

  column "auto_tune_options_error_message" {
    rename = "auto_tune_error_message"
  }

  column "cognito_options_enabled" {
    rename = "cognito_enabled"
  }

  column "cognito_options_identity_pool_id" {
    rename = "cognito_identity_pool_id"
  }

  column "cognito_options_role_arn" {
    rename = "cognito_role_arn"
  }

  column "cognito_options_user_pool_id" {
    rename = "cognito_user_pool_id"
  }

  column "domain_endpoint_options_custom_endpoint" {
    rename = "domain_endpoint_custom"
  }

  column "domain_endpoint_options_custom_endpoint_certificate_arn" {
    rename = "domain_endpoint_custom_certificate_arn"
  }

  column "domain_endpoint_options_custom_endpoint_enabled" {
    rename = "domain_endpoint_custom_enabled"
  }

  column "domain_endpoint_options_enforce_https" {
    rename = "domain_endpoint_enforce_https"
  }

  column "domain_endpoint_options_tls_security_policy" {
    rename      = "domain_endpoint_tls_security_policy"
    description = "Specify the TLS security policy that needs to be applied to the HTTPS endpoint of Elasticsearch domain."
  }

  column "elasticsearch_cluster_config_cold_storage_options_enabled" {
    rename      = "cluster_cold_storage_options_enabled"
    description = "True to enable cold storage for an Elasticsearch domain."
  }

  column "elasticsearch_cluster_config_dedicated_master_count" {
    rename = "cluster_dedicated_master_count"
  }

  column "elasticsearch_cluster_config_dedicated_master_enabled" {
    rename = "cluster_dedicated_master_enabled"
  }

  column "elasticsearch_cluster_config_dedicated_master_type" {
    rename = "cluster_dedicated_master_type"
  }

  column "elasticsearch_cluster_config_instance_count" {
    rename = "cluster_instance_count"
  }

  column "elasticsearch_cluster_config_instance_type" {
    rename = "cluster_instance_type"
  }

  column "elasticsearch_cluster_config_warm_count" {
    rename = "cluster_warm_count"
  }

  column "elasticsearch_cluster_config_warm_enabled" {
    rename = "cluster_warm_enabled"
  }

  column "elasticsearch_cluster_config_warm_type" {
    rename = "cluster_warm_type"
  }

  column "elasticsearch_cluster_config_zone_awareness_config_availability_zone_count" {
    rename = "cluster_zone_awareness_config_availability_zone_count"
  }

  column "elasticsearch_cluster_config_zone_awareness_enabled" {
    rename = "cluster_zone_awareness_enabled"
  }

  column "encryption_at_rest_options_enabled" {
    rename = "encryption_at_rest_enabled"
  }

  column "encryption_at_rest_options_kms_key_id" {
    rename = "encryption_at_rest_kms_key_id"
  }

  column "e_b_s_options_e_b_s_enabled" {
    rename = "ebs_enabled"
  }

  column "e_b_s_options_iops" {
    rename = "ebs_iops"
  }

  column "e_b_s_options_volume_size" {
    rename = "ebs_volume_size"
  }

  column "e_b_s_options_volume_type" {
    rename = "ebs_volume_type"
  }

  column "node_to_node_encryption_options_enabled" {
    rename = "node_to_node_encryption_enabled"
  }

  column "service_software_options_automated_update_date" {
    rename = "service_software_automated_update_date"
  }

  column "service_software_options_cancellable" {
    rename = "service_software_cancellable"
  }

  column "service_software_options_current_version" {
    rename = "service_software_current_version"
  }

  column "service_software_options_description" {
    rename = "service_software_description"
  }

  column "service_software_options_new_version" {
    rename = "service_software_new_version"
  }

  column "service_software_options_optional_deployment" {
    rename = "service_software_optional_deployment"
  }

  column "service_software_options_update_available" {
    rename = "service_software_update_available"
  }

  column "service_software_options_update_status" {
    rename = "service_software_update_status"
  }

  column "snapshot_options_automated_snapshot_start_hour" {
    rename = "snapshot_options_automated_snapshot_start_hour"
  }

  column "vpc_options_availability_zones" {
    rename = "vpc_availability_zones"
  }

  column "vpc_options_security_group_ids" {
    rename = "vpc_security_group_ids"
  }

  column "vpc_options_subnet_ids" {
    rename = "vpc_subnet_ids"
  }

  column "vpc_options_vpc_id" {
    rename = "vpc_vpc_id"
  }
}

resource "aws" "cognito" "user_pools" {
  path = "github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider/types.UserPoolType"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    description = "The AWS Region of the resource."
    type        = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "account_recovery_setting" {
    type              = "json"
    generate_resolver = "true"
  }

  column "admin_create_user_config_allow_admin_create_user_only" {
    rename = "admin_create_user_admin_only"
  }

  column "admin_create_user_config_invite_message_template_email_message" {
    rename = "admin_create_user_invite_email_message"
  }

  column "admin_create_user_config_invite_message_template_email_subject" {
    rename = "admin_create_user_invite_email_subject"
  }

  column "admin_create_user_config_invite_message_template_s_m_s_message" {
    rename = "admin_create_user_invite_sms"
  }

  column "device_configuration_challenge_required_on_new_device" {
    rename = "challenge_required_on_new_device"
  }

  column "device_configuration_device_only_remembered_on_user_prompt" {
    rename = "device_only_remembered_on_user_prompt"
  }

  column "email_configuration_configuration_set" {
    rename = "email_configuration_set"
  }

  column "email_configuration_email_sending_account" {
    rename = "email_configuration_sending_account"
  }

  column "email_configuration_reply_to_email_address" {
    rename = "email_configuration_reply_to_address"
  }

  column "id" {
    rename = "resource_id"
  }

  column "lambda_config_custom_s_m_s_sender_lambda_arn" {
    rename = "lambda_config_custom_sms_sender_lambda_arn"
  }

  column "lambda_config_custom_s_m_s_sender_lambda_version" {
    rename = "lambda_config_custom_sms_sender_lambda_version"
  }

  relation "aws" "cognito" "schema_attributes" {
    path = "github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider/types.SchemaAttributeType"
  }

  relation "aws" "cognito" "identity_providers" {
    path = "github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider/types.IdentityProviderType"
    ignoreError "IgnoreAccessDenied" {
      path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
    }
    multiplex "AwsAccountRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
    }
    deleteFilter "AccountRegionFilter" {
      path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
    }
    userDefinedColumn "account_id" {
      description = "The AWS Account ID of the resource."
      type        = "string"
      resolver "resolveAWSAccount" {
        path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
      }
    }
    userDefinedColumn "region" {
      description = "The AWS Region of the resource."
      type        = "string"
      resolver "resolveAWSRegion" {
        path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
      }
    }

    column "user_pool_id" {
      skip = "true"
    }
  }
}

resource "aws" "cognito" "identity_pools" {
  path = "github.com/aws/aws-sdk-go-v2/service/cognitoidentity.DescribeIdentityPoolOutput"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type        = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    description = "The AWS Region of the resource."
    type        = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "open_id_connect_provider_arn_s" {
    rename = "open_id_connect_provider_arns"
  }

  column "saml_provider_arn_s" {
    rename = "saml_provider_arns"
  }
}


resource "aws" "iot" "things" {
  path = "github.com/aws/aws-sdk-go-v2/service/iot/types.ThingAttribute"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    description = "The AWS Region of the resource."
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  options {
    primary_keys = [
      "arn"]
  }

  column "thing_name" {
    rename = "name"
  }
  column "thing_arn" {
    rename = "arn"
  }
  column "thing_type_name" {
    rename = "type_name"
  }

  userDefinedColumn "principals" {
    generate_resolver = true
    type = "stringarray"
  }
}

resource "aws" "iot" "thing_types" {
  path = "github.com/aws/aws-sdk-go-v2/service/iot/types.ThingTypeDefinition"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    description = "The AWS Region of the resource."
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }


  options {
    primary_keys = [
      "arn"]
  }

  column "thing_type_arn" {
    rename = "arn"
  }

  column "thing_type_metadata" {
    skip_prefix = true
  }

  column "thing_type_name" {
    rename = "name"
  }

  column "thing_type_properties" {
    skip_prefix = true
  }

  column "thing_type_description" {
    rename = "description"
  }

  userDefinedColumn "tags" {
    generate_resolver = true
    type = "json"
  }
}


resource "aws" "iot" "thing_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/iot.DescribeThingGroupOutput"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    description = "The AWS Region of the resource."
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  options {
    primary_keys = [
      "arn"]
  }

  userDefinedColumn "things_in_group" {
    type = "stringarray"
    generate_resolver = true
    description = "Lists the things in the specified group"
  }

  column "thing_group_arn" {
    rename = "arn"
  }


  column "thing_group_id" {
    rename = "id"
  }

  column "thing_group_name" {
    rename = "name"
  }

  column "thing_group_properties" {
    skip_prefix = true
  }

  column "root_to_parent_thing_groups" {
    type = "json"
    generate_resolver = true
  }


  column "thing_group_metadata" {
    skip_prefix = true
  }

  userDefinedColumn "policies" {
    type = "stringarray"
    generate_resolver = true
  }

  userDefinedColumn "tags" {
    generate_resolver = true
    type = "json"
  }
}


resource "aws" "iot" "billing_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/iot.DescribeBillingGroupOutput"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    description = "The AWS Region of the resource."
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }


  options {
    primary_keys = [
      "arn"]
  }

  column "billing_group_arn" {
    rename = "arn"
  }


  column "billing_group_id" {
    rename = "id"
  }

  column "thing_group_description" {
    rename = "description"
  }

  column "billing_group_metadata_creation_date" {
    rename = "creation_date"
  }

  column "billing_group_name" {
    rename = "name"
  }

  column "billing_group_properties_billing_group_description" {
    rename = "description"
  }

  userDefinedColumn "things_in_group" {
    type = "stringarray"
    generate_resolver = true
    description = "Lists the things in the specified group"
  }


  userDefinedColumn "tags" {
    generate_resolver = true
    type = "json"
  }


}


resource "aws" "iot" "streams" {
  path = "github.com/aws/aws-sdk-go-v2/service/iot/types.StreamInfo"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    description = "The AWS Region of the resource."
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  options {
    primary_keys = [
      "arn"]
  }

  column "stream_id" {
    rename = "id"
  }
  column "stream_arn" {
    rename = "arn"
  }
  column "stream_version" {
    rename = "version"
  }

}


resource "aws" "iot" "security_profiles" {
  path = "github.com/aws/aws-sdk-go-v2/service/iot.DescribeSecurityProfileOutput"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    description = "The AWS Region of the resource."
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }


  options {
    primary_keys = [
      "arn"]
  }

  //  userDefinedColumn "tags" {
  //    generate_resolver = true
  //    type = "json"
  //  }

  column "security_profile_name" {
    rename = "name"
  }

  column "security_profile_arn" {
    rename = "arn"
  }

  column "security_profile_description" {
    rename = "description"
  }

  userDefinedColumn "targets" {
    type = "stringarray"
    generate_resolver = true
  }

  relation "aws" "iot" "security_profile_behaviors" {
    path = "github.com/aws/aws-sdk-go-v2/service/iot/types.Behavior"

    column "criteria_value" {
      type = "json"
      generate_resolver = true
    }
  }

  relation "aws" "iot" "security_profile_additional_metrics_to_retain_v2" {
    path = "github.com/aws/aws-sdk-go-v2/service/iot/types.MetricToRetain"

    column "metric_dimension_dimension_name" {
      rename = "metric_dimension_name"
    }
  }
}


resource "aws" "iot" "ca_certificates" {
  path = "github.com/aws/aws-sdk-go-v2/service/iot/types.CACertificateDescription"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    description = "The AWS Region of the resource."
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  options {
    primary_keys = [
      "arn"]
  }


  column "certificate_id" {
    rename = "id"
  }
  column "certificate_arn" {
    rename = "arn"
  }
  column "certificate_pem" {
    rename = "pem"
  }


  userDefinedColumn "certificates" {
    type = "stringarray"
    generate_resolver = true
  }
}


resource "aws" "iot" "certificates" {
  path = "github.com/aws/aws-sdk-go-v2/service/iot/types.CertificateDescription"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    description = "The AWS Account ID of the resource."
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    description = "The AWS Region of the resource."
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }


  options {
    primary_keys = [
      "arn"]
  }

  column "certificate_id" {
    rename = "id"
  }
  column "certificate_arn" {
    rename = "arn"
  }
  column "certificate_mode" {
    rename = "mode"
  }
  column "certificate_pem" {
    rename = "pem"
  }

  userDefinedColumn "policies" {
    type = "stringarray"
    generate_resolver = true
  }
}



