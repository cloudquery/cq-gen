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

  column "id" {
    rename = "resource_id"
    generate_resolver = true
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

  column "linked_service_service_principal" {
    rename = "linked_service_principal"
  }

  userDefinedColumn "tags" {
    type = "json"
    generate_resolver = true
  }

//  postResourceResolver "resolveTags" {
//    path = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
//    generate = true
//  }

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
}


resource "aws" "route53" "traffic_policies" {
  path = "github.com/aws/aws-sdk-go-v2/service/route53/types.TrafficPolicy"

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

  relation "aws" "s3" "grants" {
    path = "github.com/aws/aws-sdk-go-v2/service/s3/types.Grant"

    column "grantee" {
      skip_prefix = true
    }
  }

  relation "aws" "s3" "cors_rules" {
    path = "github.com/aws/aws-sdk-go-v2/service/s3/types.CORSRule"
    column "id" {
      rename = "resource_id"
    }
  }

  //  relation "aws" "s3" "encryption_rules" {
  //    path = "github.com/aws/aws-sdk-go-v2/service/s3/types.ServerSideEncryptionRule"
  //
  //    column "apply_server_side_encryption_by_default_s_s_e_algorithm" {
  //      rename = "sse_algorithm"
  //
  //    }
  //    column "apply_server_side_encryption_by_default_k_m_s_master_key_id" {
  //      rename = "kms_master_key_id"
  //    }
  //  }

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
