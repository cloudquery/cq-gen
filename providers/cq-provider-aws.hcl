service = "aws"
output_directory = "providers/cq-provider-aws/resources"

resource "aws" "autoscaling" "launch_configurations" {
  path = "github.com/aws/aws-sdk-go-v2/service/autoscaling/types.LaunchConfiguration"

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
}

resource "aws" "cloudtrail" "trails" {
  path = "github.com/aws/aws-sdk-go-v2/service/cloudtrail/types.Trail"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  postResourceResolver "postCloudtrailTrailResolver" {
    path = "github.com/cloudquery/cq-provider-sdk/plugin/schema.RowResolver"
    generate = true
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
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
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  relation "aws" "cloudwatch" "metrics" {
    path = "github.com/aws/aws-sdk-go-v2/service/cloudwatch/types.MetricDataQuery"
  }
}

resource "aws" "cloudwatchlogs" "filters" {
  path = "github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs/types.MetricFilter"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
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
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
}

resource "aws" "directconnect" "gateways" {
  path = "github.com/aws/aws-sdk-go-v2/service/directconnect/types.DirectConnectGateway"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
}

resource "aws" "ec2" "images" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.Image"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }

}


resource "aws" "ec2" "instances" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.Instance"

  column "tags" {
    type = "json"
  }
}


resource "aws" "ec2" "byoip_cidrs" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.ByoipCidr"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
}



resource "aws" "ec2" "instances" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.Instance"

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }


  column "tags" {
    // TypeJson
    type = "json"
  }
  relation "aws" "ec2" "InstanceNetworkInterface" {
    relation "aws" "ec2" "InstancePrivateIpAddress" {
      column "primary" {
        type = "bool"
        rename = "is_primary"
      }
    }
  }

}




resource "aws" "ec2" "customer_gateways" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.CustomerGateway"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }
}

resource "aws" "ec2" "flow_logs" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.FlowLog"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }
}

resource "aws" "ec2" "internet_gateways" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.InternetGateway"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }

  relation "aws" "ec2" "internet_gateway_attachments" {
    path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.InternetGatewayAttachment"
  }
}

resource "aws" "ec2" "nat_gateways" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.NatGateway"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }

  relation "aws" "ec2" "nat_gateway_address" {
    path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.InternetGatewayAttachment"
  }
}

resource "aws" "ec2" "network_acls" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.NetworkAcl"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
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
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }

}

resource "aws" "ec2" "security_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.SecurityGroup"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }
}

resource "aws" "ec2" "subnets" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.Subnet"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }
}

resource "aws" "ec2" "vpc_peering_connections" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.VpcPeeringConnection"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }
}

resource "aws" "ec2" "vpcs" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.Vpc"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }
}

resource "aws" "ecr" "repositories" {
  path = "github.com/aws/aws-sdk-go-v2/service/ecr/types.Repository"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
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
        path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
      }
    }
    userDefinedColumn "region" {
      type = "string"
      resolver "resolveAWSRegion" {
        path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
      }
    }
    column "tags" {
      // TypeJson
      type = "json"
      generate_resolver=true
    }
  }
}

resource "aws" "ecs" "clusters" {
  path = "github.com/aws/aws-sdk-go-v2/service/ecs/types.Cluster"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  column "settings" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }

  column "statistics" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }

  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }

}

resource "aws" "efs" "filesystems" {
  path = "github.com/aws/aws-sdk-go-v2/service/efs/types.FileSystemDescription"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }
}

resource "aws" "eks" "clusters" {
  path = "github.com/aws/aws-sdk-go-v2/service/eks/types.Cluster"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }

}


resource "aws" "elasticbeanstalk" "environments" {
  path = "github.com/aws/aws-sdk-go-v2/service/elasticbeanstalk/types.EnvironmentDescription"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
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
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
}

resource "aws" "elbv2" "load_balancers" {
  path = "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2/types.LoadBalancer"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
}

resource "aws" "emr" "clusters" {
  path = "github.com/aws/aws-sdk-go-v2/service/emr/types.ClusterSummary"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
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
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
  column "file_system" {
    skip = true
  }
  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }
}

resource "aws" "iam" "groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam/types.Group"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  userDefinedColumn "policies" {
    type = "json"
    generate_resolver=true
  }
}

resource "aws" "iam" "password_policies" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam/types.PasswordPolicy"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
}

resource "aws" "iam" "policies" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam/types.ManagedPolicyDetail"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  relation "aws" "iam" "policy_versions" {
    path = "github.com/aws/aws-sdk-go-v2/service/iam/types.PolicyVersion"

    column "document" {
      type = "json"
      generate_resolver=true
    }
  }
}

resource "aws" "iam" "roles" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam/types.Role"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  userDefinedColumn "policies" {
    type = "json"
    generate_resolver=true
  }

  column "assume_role_policy_document" {
    type = "json"
    generate_resolver=true
  }

  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }
}

resource "aws" "iam" "virtual_mfa_devices" {
  path = "github.com/aws/aws-sdk-go-v2/service/iam/types.VirtualMFADevice"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }

  column "tags" {
    type = "json"
    generate_resolver=true
  }
  column "user_tags" {
    type = "json"
    generate_resolver=true
  }
}

resource "aws" "kms" "keys" {
  path = "github.com/aws/aws-sdk-go-v2/service/kms/types.KeyListEntry"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  postResourceResolver "resolveKmsKey" {
    path = "github.com/cloudquery/cq-provider-sdk/plugin/schema.RowResolver"
    generate = true
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
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
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
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
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
}

resource "aws" "rds" "certificates" {
  path = "github.com/aws/aws-sdk-go-v2/service/rds/types.Certificate"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
}

resource "aws" "rds" "subnet_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/rds/types.DBSubnetGroup"
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
}


resource "aws" "sns" "topics" {
  path = "github.com/aws/aws-sdk-go-v2/service/sns/types.Topic"

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  postResourceResolver "resolveTopicAttributes" {
    path = "github.com/cloudquery/cq-provider-sdk/plugin/schema.RowResolver"
    generate = true
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
    type = "int"
  }
  userDefinedColumn "subscription_deleted" {
    type = "int"
  }
  userDefinedColumn "subscription_pending" {
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
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountFilter"
  }

  postResourceResolver "resolveS3BucketsAttributes" {
    path = "github.com/cloudquery/cq-provider-sdk/plugin/schema.RowResolver"
    generate = true
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "ResolveAwsAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
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
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }

  postResourceResolver "resolveTopicAttributes" {
    path = "github.com/cloudquery/cq-provider-sdk/plugin/schema.RowResolver"
    generate = true
  }

  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
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
    type = "int"
  }
  userDefinedColumn "subscription_deleted" {
    type = "int"
  }
  userDefinedColumn "subscription_pending" {
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

resource "aws" "sns" "subscriptions" {
  path = "github.com/aws/aws-sdk-go-v2/service/sns/types.Subscription"

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
}


resource "aws" "redshift" "cluster" {
  path = "github.com/aws/aws-sdk-go-v2/service/redshift/types.Cluster"

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/provider.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/provider.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/provider.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
  
  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver=true
  }
}