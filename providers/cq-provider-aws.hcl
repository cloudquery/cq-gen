service = "aws"
output_directory = "../cq-provider-aws/resources"

resource "aws" "autoscaling" "launch_configurations" {
  path = "github.com/aws/aws-sdk-go-v2/service/autoscaling/types.LaunchConfiguration"

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

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
}

resource "aws" "cloudfront" "cache_policies" {
  path = "github.com/aws/aws-sdk-go-v2/service/cloudfront/types.CachePolicySummary"

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  column "id" {
    type = "string"
    rename = "resource_id"
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

resource "aws" "cloudtrail" "trails" {
  path = "github.com/aws/aws-sdk-go-v2/service/cloudtrail/types.Trail"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  postResourceResolver "postCloudtrailTrailResolver" {
    path = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
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
  userDefinedColumn "cloudwatch_logs_log_group_name" {
    type = "string"
    generate_resolver = true
  }

  userDefinedColumn "is_logging" {
    type = "bool"
  }

  userDefinedColumn "latest_cloudwatch_logs_delivery_error" {
    type = "string"
  }

  userDefinedColumn "latest_cloudwatch_logs_delivery_time" {
    type = "timestamp"
  }

  userDefinedColumn "latest_delivery_attempt_succeeded" {
    type = "string"
  }

  userDefinedColumn "latest_delivery_attempt_time" {
    type = "string"
  }

  userDefinedColumn "latest_delivery_error" {
    type = "string"
  }

  userDefinedColumn "latest_delivery_time" {
    type = "timestamp"
  }

  userDefinedColumn "latest_digest_delivery_error" {
    type = "string"
  }

  userDefinedColumn "latest_digest_delivery_time" {
    type = "timestamp"
  }

  userDefinedColumn "latest_notification_attempt_succeeded" {
    type = "string"
  }

  userDefinedColumn "latest_notification_attempt_time" {
    type = "string"
  }

  userDefinedColumn "latest_notification_error" {
    type = "string"
  }

  userDefinedColumn "latest_notification_time" {
    type = "timestamp"
  }

  userDefinedColumn "start_logging_time" {
    type = "timestamp"
  }

  userDefinedColumn "stop_logging_time" {
    type = "timestamp"
  }

  userDefinedColumn "time_logging_started" {
    type = "string"
  }

  userDefinedColumn "time_logging_stopped" {
    type = "string"
  }

  relation "aws" "cloudtrail" "trail_event_selectors" {
    path = "github.com/aws/aws-sdk-go-v2/service/cloudtrail/types.EventSelector"

    column "data_resources" {
      skip = true
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
  column "dimensions" {
    type = "json"
    generate_resolver = true
  }

  relation "aws" "cloudwatch" "alarm_metrics" {
    path = "github.com/aws/aws-sdk-go-v2/service/cloudwatch/types.MetricDataQuery"

    column "id" {
      rename = "metric_id"
    }
    column "metric_stat_metric_dimensions" {
      rename = "metric_stat_metric_dimensions"
      type = "json"
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
    type = "string"
    rename = "name"
  }
  column "filter_pattern" {
    type = "string"
    rename = "pattern"
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

  column "tags" {
    type = "json"
    generate_resolver = true
  }

  column "product_codes" {
    type = "json"
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
        type = "bool"
        rename = "is_primary"
      }
    }
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
    type = "json"
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
  column "tags" {
    // TypeJson
    type = "json"
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
  column "tags" {
    // TypeJson
    type = "json"
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

  column "tags" {
    // TypeJson
    type = "json"
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

  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver = true
  }

  relation "aws" "ec2" "nat_gateway_address" {
    path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.InternetGatewayAttachment"
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

  column "tags" {
    // TypeJson
    type = "json"
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

  column "route_table_id" {
    // TypeJson
    type = "string"
    rename = "resource_id"
  }

  column "tags" {
    // TypeJson
    type = "json"
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

  column "tags" {
    // TypeJson
    type = "json"
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
  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver = true
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

  column "accepter_vpc_info_cidr_block_set" {
    type = "stringArray"
    rename = "accepter_cidr_block_set"
    generate_resolver = true
  }

  column "accepter_vpc_info_ipv6_cidr_block_set" {
    type = "stringArray"
    rename = "accepter_ipv6_cidr_block_set"
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
    type = "stringArray"
    rename = "requester_cidr_block_set"
    generate_resolver = true
  }

  column "requester_vpc_info_ipv6_cidr_block_set" {
    type = "stringArray"
    rename = "requester_ipv6_cidr_block_set"
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
    type = "json"
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

  column "tags" {
    // TypeJson
    type = "json"
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
  column "tags" {
    // TypeJson
    type = "json"
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
    column "tags" {
      // TypeJson
      type = "json"
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

  column "settings" {
    // TypeJson
    type = "json"
    generate_resolver = true
  }

  column "statistics" {
    // TypeJson
    type = "json"
    generate_resolver = true
  }

  column "tags" {
    // TypeJson
    type = "json"
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
  column "tags" {
    // TypeJson
    type = "json"
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

  //  column "tags" {
  //    // TypeJson
  //    type = "json"
  //    generate_resolver=true
  //  }

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

  column "c_n_a_m_e" {
    type = "string"
    rename = "cname"
  }

  column "resources_load_balancer_domain" {
    type = "string"
    rename = "load_balancer_domain"
  }

  column "resources_load_balancer_load_balancer_name" {
    type = "string"
    rename = "load_balancer_name"
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

  //github.com/aws/aws-sdk-go-v2/service/elasticloadbalancing/types.LoadBalancerAttributes
  //AccessLog
  userDefinedColumn "attributes_access_log_enabled" {
    type = "bool"
    generate_resolver = true
  }
  userDefinedColumn "attributes_access_log_s3_bucket_name" {
    type = "string"
    generate_resolver = true
  }
  userDefinedColumn "attributes_access_log_s3_bucket_prefix" {
    type = "string"
    generate_resolver = true
  }
  userDefinedColumn "attributes_access_log_emit_interval" {
    type = "int"
    generate_resolver = true
  }
  //ConnectionSettings
  userDefinedColumn "attributes_connection_settings_idle_timeout" {
    type = "int"
    generate_resolver = true
  }
  //CrossZoneLoadBalancing
  userDefinedColumn "attributes_cross_zone_load_balancing_enabled" {
    type = "bool"
    generate_resolver = true
  }
  //ConnectionDraining
  userDefinedColumn "attributes_connection_draining_enabled" {
    type = "bool"
    generate_resolver = true
  }
  userDefinedColumn "attributes_connection_draining_timeout" {
    type = "int"
    generate_resolver = true
  }
  //AdditionalAttributes
  userDefinedColumn "attributes_additional_attributes" {
    type = "Json"
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
    type = "stringarray"
    generate_resolver = true
  }

  relation "aws" "elbv1" "load_balancer_policies" {
    path = "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancing/types.PolicyDescription"

    column "policy_attribute_descriptions" {
      type = "json"
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

  column "id" {
    type = "string"
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
  column "file_system" {
    skip = true
  }
  column "tags" {
    // TypeJson
    type = "json"
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

  userDefinedColumn "policies" {
    type = "json"
    generate_resolver = true
  }
}


resource "aws" "iam" "openid_connect_identity_providers" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam.GetOpenIDConnectProviderOutput"
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
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  column "tags" {
    type = "json"
    generate_resolver = true
  }
}


resource "aws" "iam" "saml_identity_providers" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam.GetSAMLProviderOutput"
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
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  column "tags" {
    type = "json"
    generate_resolver = true
  }
}


resource "aws" "iam" "group_policies" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam.GetGroupPolicyOutput"
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
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  column "policy_document" {
    type = "json"
    generate_resolver = true
  }
}


resource "aws" "iam" "role_policies" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam.GetRolePolicyOutput"
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
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  column "policy_document" {
    type = "json"
    generate_resolver = true
  }
}


resource "aws" "iam" "user_policies" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam.GetUserPolicyOutput"
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
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  column "policy_document" {
    type = "json"
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
}

resource "aws" "iam" "policies" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam/types.ManagedPolicyDetail"
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
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  relation "aws" "iam" "policy_versions" {
    path = "github.com/aws/aws-sdk-go-v2/service/iam/types.PolicyVersion"

    column "document" {
      type = "json"
      generate_resolver = true
    }
  }
}

resource "aws" "iam" "roles" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam/types.Role"
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
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  userDefinedColumn "policies" {
    type = "json"
    generate_resolver = true
  }

  column "assume_role_policy_document" {
    type = "json"
    generate_resolver = true
  }

  column "tags" {
    // TypeJson
    type = "json"
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
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
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

  column "tags" {
    type = "json"
    generate_resolver = true
  }
  column "user_tags" {
    type = "json"
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
    path = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
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

  userDefinedColumn "rotation_enabled" {
    type = "bool"
  }
  userDefinedColumn "cloud_hsm_cluster_id" {
    type = "string"
  }
  userDefinedColumn "creation_date" {
    type = "timestamp"
  }
  userDefinedColumn "custom_key_store_id" {
    type = "string"
  }
  userDefinedColumn "customer_master_key_spec" {
    type = "string"
  }
  userDefinedColumn "deletion_date" {
    type = "timestamp"
  }
  userDefinedColumn "description" {
    type = "string"
  }
  userDefinedColumn "enabled" {
    type = "bool"
  }
  userDefinedColumn "encryption_algorithms" {
    type = "stringarray"
  }
  userDefinedColumn "expiration_model" {
    type = "string"
  }
  userDefinedColumn "manager" {
    type = "string"
  }
  userDefinedColumn "key_state" {
    type = "string"
  }
  userDefinedColumn "key_usage" {
    type = "string"
  }
  userDefinedColumn "origin" {
    type = "string"
  }
  userDefinedColumn "signing_algorithms" {
    type = "stringarray"
  }
  userDefinedColumn "valid_to" {
    type = "timestamp"
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
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  column "id" {
    type = "string"
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

  column "pending_modified_values_pending_cloudwatch_logs_exports_log_types_to_disable" {
    rename = "pending_cloudwatch_logs_types_to_disable"
  }

  column "pending_modified_values_pending_cloudwatch_logs_exports_log_types_to_enable" {
    rename = "pending_cloudwatch_logs_types_to_enable"
  }

  column "tag_list" {
    // TypeJson
    rename = "tags"
    type = "json"
    generate_resolver = true
  }

  column "aws_rds_instance_pending_modified_values_processor_features" {
    // TypeJson
    type = "json"
    generate_resolver = true
  }

  column "aws_rds_instance_processor_features" {
    // TypeJson
    type = "json"
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
    type = "string"
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

  column "tag_list" {
    // TypeJson
    rename = "tags"
    type = "json"
    generate_resolver = true
  }

  column "pending_modified_values_pending_cloudwatch_logs_exports_log_types_to_enable" {
    rename = "pending_cloudwatch_logs_types_to_enable"
  }

  column "pending_modified_values_pending_cloudwatch_logs_exports_log_types_to_disable" {
    rename = "pending_cloudwatch_logs_types_to_disable"
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
    type = "string"
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
    type = "json"
  }

  userDefinedColumn "delegation_set_id" {
    type = "string"
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
      type = "stringarray"
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


resource "aws" "route53" "reusable_delegation_sets" {
  path = "github.com/aws/aws-sdk-go-v2/service/route53/types.DelegationSet"

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
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
}

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
    type = "string"
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

  userDefinedColumn "cloud_watch_alarm_configuration_dimensions" {
    type = "json"
    generate_resolver = true
  }

  userDefinedColumn "tags" {
    type = "json"
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
    type = "string"
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
      type = "Json"
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
    path = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
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

  // Topic attributes are returned as a string we define this to handle type conversion
  userDefinedColumn "owner" {
    type = "string"
  }
  userDefinedColumn "policy" {
    type = "Json"
  }
  userDefinedColumn "delivery_policy" {
    type = "Json"
  }
  userDefinedColumn "display_name" {
    type = "string"
  }
  userDefinedColumn "subscriptions_confirmed" {
    type = "int"
  }
  userDefinedColumn "subscriptions_deleted" {
    type = "int"
  }
  userDefinedColumn "subscriptions_pending" {
    type = "int"
  }
  userDefinedColumn "effective_delivery_policy" {
    type = "Json"
  }
  userDefinedColumn "fifo_topic" {
    type = "bool"
  }

  userDefinedColumn "content_based_deduplication" {
    type = "bool"
  }
}

resource "aws" "s3" "buckets" {
  path = "github.com/aws/aws-sdk-go-v2/service/s3/types.Bucket"

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
    path = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "ResolveAwsAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type = "string"
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
    path = "github.com/aws/aws-sdk-go-v2/service/s3/types.PublicAccessBlockConfiguration"
    embed = true
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
    path = "github.com/aws/aws-sdk-go-v2/service/s3/types.ReplicationConfiguration"
    embed = true
    column "role" {
      generate_resolver = false
    }
    relation "aws" "s3" "replication_rules" {
      path = "github.com/aws/aws-sdk-go-v2/service/s3/types.ReplicationRule"

      column "filter" {
        type = "json"
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
      type = "json"
      generate_resolver = true
    }
    column "id" {
      rename = "resource_id"
    }
    column "transitions" {
      type = "json"
      generate_resolver = true
    }
    column "noncurrent_version_expiration_noncurrent_days" {
      rename = "noncurrent_version_expiration_days"
    }
    column "noncurrent_version_transitions" {
      type = "json"
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
    path = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
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

  // Topic attributes are returned as a string we define this to handle type conversion
  userDefinedColumn "owner" {
    type = "string"
  }
  userDefinedColumn "policy" {
    type = "Json"
  }
  userDefinedColumn "delivery_policy" {
    type = "Json"
  }
  userDefinedColumn "display_name" {
    type = "string"
  }
  userDefinedColumn "subscription_confirmed" {
    type = "bigint"
  }
  userDefinedColumn "subscription_deleted" {
    type = "bigint"
  }
  userDefinedColumn "subscription_pending" {
    type = "bigint"
  }
  userDefinedColumn "effective_delivery_policy" {
    type = "Json"
  }
  userDefinedColumn "fifo_topic" {
    type = "bool"
  }

  userDefinedColumn "content_based_deduplication" {
    type = "bool"
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

  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver = true
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

  relation "aws" "redshift" "Subnet" {
    path = "github.com/aws/aws-sdk-go-v2/service/redshift/types.Subnet"
    column "subnet_availability_zone_supported_platforms" {
      // TypeStringArray
      type = "stringArray"
      generate_resolver = true
    }
  }

  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver = true
  }
}


resource "aws" "access_analyzer" "analyzer" {
  path = "github.com/aws/aws-sdk-go-v2/service/accessanalyzer/types.AnalyzerSummary"
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
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
  column "tags" {
    // TypeJson
    type = "json"
  }

  relation "aws" "access_analyzer" "finding" {
    path = "github.com/aws/aws-sdk-go-v2/service/accessanalyzer/types.FindingSummary"

    column "id" {
      type = "string"
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
  column "conformance_pack_input_parameters" {
    type = "json"
    generate_resolver = true
  }
}


resource "aws" "lambda" "functions" {
  path = "github.com/aws/aws-sdk-go-v2/service/lambda.GetFunctionOutput"
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
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  postResourceResolver "resolvePolicyCodeSigningConfig" {
    path = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
  }

  userDefinedColumn "policy_document" {
    type = "json"
  }
  userDefinedColumn "policy_revision_id" {
    type = "string"
  }

  userDefinedColumn "code_signing_allowed_publishers_version_arns" {
    type = "stringarray"
  }
  userDefinedColumn "code_signing_config_arn" {
    type = "string"
  }
  userDefinedColumn "code_signing_config_id" {
    type = "string"
  }
  userDefinedColumn "code_signing_policies_untrusted_artifact_on_deployment" {
    type = "string"
  }
  userDefinedColumn "code_signing_description" {
    type = "string"
  }
  userDefinedColumn "code_signing_last_modified" {
    type = "timestamp"
  }
  column "configuration" {
    skip_prefix = true
  }

  column "image_config_response" {
    skip_prefix = true
  }
//  column "tags" {
//    type = "json"
//  }

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


  relation "aws" "lambda" "layer_versions" {
    path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.LayerVersionsListItem"
    relation "aws" "lambda" "layer_version_policies" {
      path = "github.com/aws/aws-sdk-go-v2/service/lambda.GetLayerVersionPolicyOutput"
    }
  }


  column "tags" {
    type = "json"
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


  relation "aws" "lambda" "layer_versions" {
    path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.LayerVersionsListItem"
    relation "aws" "lambda" "layer_version_policies" {
      path = "github.com/aws/aws-sdk-go-v2/service/lambda.GetLayerVersionPolicyOutput"
    }
  }

  column "tags" {
    type = "json"
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

  relation "aws" "apigatewayv2" "rest_api_authorizers" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Authorizer"
  }

  relation "aws" "apigatewayv2" "rest_api_deployments" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Deployment"
  }

  relation "aws" "apigatewayv2" "rest_api_integrations" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Integration"

    relation "aws" "apigatewayv2" "rest_api_integration_responses" {
      path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.IntegrationResponse"
    }
  }

  relation "aws" "apigatewayv2" "rest_api_models" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Model"
    userDefinedColumn "model_template" {
      type = "string"
      generate_resolver = true
    }
  }

  relation "aws" "apigatewayv2" "rest_api_routes" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Route"
    relation "aws" "apigatewayv2" "rest_api_route_responses" {
      path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.RouteResponse"
    }
  }

  relation "aws" "apigatewayv2" "rest_api_stages" {
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
    type = "string"
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
    type = "string"
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
      type = "string"
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

  column "id" {
    rename = "resource_id"
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
  relation "aws" "waf" "rules" {
    path = "github.com/aws/aws-sdk-go-v2/service/waf/types.ActivatedRule"
    column "excluded_rules" {
      // TypeStringArray
      type = "stringArray"
      generate_resolver = true
    }
  }
}

resource "aws" "waf" "rulegroups" {
  path = "github.com/aws/aws-sdk-go-v2/service/waf/types.RuleGroupSummary"
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
}

resource "aws" "waf" "subscribed_rulegroups" {
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
}

resource "aws" "waf" "rules" {
  path = "github.com/aws/aws-sdk-go-v2/service/waf/types.RuleSummary"
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
}


resource "aws" "lambda" "functions" {
  path = "github.com/aws/aws-sdk-go-v2/service/lambda.GetFunctionOutput"
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
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSRegion"
    }
  }

  postResourceResolver "resolvePolicyCodeSigningConfig" {
    path = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
  }

  userDefinedColumn "policy_document" {
    type = "json"
  }
  userDefinedColumn "policy_revision_id" {
    type = "string"
  }

  userDefinedColumn "code_signing_allowed_publishers_version_arns" {
    type = "stringarray"
  }
  userDefinedColumn "code_signing_config_arn" {
    type = "string"
  }
  userDefinedColumn "code_signing_config_id" {
    type = "string"
  }
  userDefinedColumn "code_signing_policies_untrusted_artifact_on_deployment" {
    type = "string"
  }
  userDefinedColumn "code_signing_description" {
    type = "string"
  }
  userDefinedColumn "code_signing_last_modified" {
    type = "timestamp"
  }
  column "configuration" {
    skip_prefix = true
  }

  column "image_config_response" {
    skip_prefix = true
  }
//  column "tags" {
//    type = "json"
//  }

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


  relation "aws" "lambda" "layer_versions" {
    path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.LayerVersionsListItem"
    relation "aws" "lambda" "layer_version_policies" {
      path = "github.com/aws/aws-sdk-go-v2/service/lambda.GetLayerVersionPolicyOutput"
    }
  }


  column "tags" {
    type = "json"
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


  relation "aws" "lambda" "layer_versions" {
    path = "github.com/aws/aws-sdk-go-v2/service/lambda/types.LayerVersionsListItem"
    relation "aws" "lambda" "layer_version_policies" {
      path = "github.com/aws/aws-sdk-go-v2/service/lambda.GetLayerVersionPolicyOutput"
    }
  }

  column "tags" {
    type = "json"
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

  relation "aws" "apigatewayv2" "rest_api_authorizers" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Authorizer"
  }

  relation "aws" "apigatewayv2" "rest_api_deployments" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Deployment"
  }

  relation "aws" "apigatewayv2" "rest_api_integrations" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Integration"

    relation "aws" "apigatewayv2" "rest_api_integration_responses" {
      path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.IntegrationResponse"
    }
  }

  relation "aws" "apigatewayv2" "rest_api_models" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Model"
    userDefinedColumn "model_template" {
      type = "string"
      generate_resolver = true
    }
  }

  relation "aws" "apigatewayv2" "rest_api_routes" {
    path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.Route"
    relation "aws" "apigatewayv2" "rest_api_route_responses" {
      path = "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types.RouteResponse"
    }
  }

  relation "aws" "apigatewayv2" "rest_api_stages" {
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
    type = "string"
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
    type = "string"
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
      type = "string"
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

  column "id" {
    rename = "resource_id"
  }


}