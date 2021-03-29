service = "aws"
output_directory = "providers/cq-provider-aws/resources"

//resource "aws" "s3" "buckets" {
//  path = "github.com/aws/aws-sdk-go-v2/service/s3/types.Bucket"
//
//  userDefinedColumn "account_id" {
//    type = 5
//    resolver = "github.com/cloudquery/cq-gen/resources/resolvers.ResolveAwsAccount"
//  }
//
//  relation "aws" "s3" "grants" {
//    path = "github.com/aws/aws-sdk-go-v2/service/s3/types.Grant"
//
//    column "grantee" {
//      skip_prefix = true
//    }
//  }
//}


resource "aws" "ec2" "instances" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.Instance"

  userDefinedColumn "account_id" {
    type = 5
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
    type = 10
  }
  relation "aws" "ec2" "InstanceNetworkInterface" {
    relation "aws" "ec2" "InstancePrivateIpAddress" {
      column "primary" {
        type = 1
        rename = "is_primary"
      }
    }
  }

}
resource "aws" "ec2" "byoip_cidr" {
  path = "github.com/aws/aws-sdk-go-v2/service/ec2/types.ByoipCidr"
  //  multiplex = "provider.AccountRegionMultiplex"
  //  deleteFilter = "provider.DeleteAccountRegionFilter"

  userDefinedColumn "account_id" {
    type = 5
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSAccount"
    }
  }

  userDefinedColumn "region" {
    type = 5
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-provider-aws/provider.ResolveAWSRegion"
    }
  }
}
