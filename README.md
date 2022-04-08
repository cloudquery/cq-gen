<p align="center">
<a href="https://cloudquery.io">
<img alt="cloudquery logo" width=75% src="https://github.com/cloudquery/cloudquery/raw/main/docs/images/logo.png" />
</a>
</p>


CloudQuery Provider Generator
=======================

*CQ-Gen* allows creating provider resources fast by generating all the boring bits and allow you to focus on the logic!

The main goal of cq-gen is to easily generate tables from an existing source including reading their descriptions and relations, 
by defining our generation once in a configuration. *cq-gen* allows to quickly re-generate when new fields are added keeping our resolver functions logic from previous iterations.

## Key features
- We generate most of the boring table bits and all fields including descriptions, so you can focus on defining the resolver logic and add more resources faster!
- Configurable, cq-gen allows you to define your own columns, relations and even transform existing columns
- Read from one or more sources, openAPI? Golang? some other source? we got you covered we can support reading from any source as long as it supports the interface.

Usage 
=====

### introduction
To use cq-gen you first must add it as a tool to your provider module [see](https://marcofranssen.nl/manage-go-tools-via-go-modules) for how to set it up.
After we set up our cq-gen tool we can start configuring our resources and create them.

### Execution
To execute cq-gen all you need to do is execute which has four main flags:
  - **config**: where the hcl configuration file to generate exists
  - **domain**: what domain we want to generate from.
  - **resource**: what specific resource in given domain we want to generate.
  - **output**: which directory to output resources go files.

#### Example
`./cq-gen --config=providers/cq-provider-aws.hcl --domain=ecs --resource=clusters`

## Configuration

This section goes over the configuration options available in cq-gen and how to use them correctly.

The cq-gen has a few high level concepts we will go over before deep diving into an example.


### Global Flags
 - `service`: the name of service, this is usually the top level provider
 - `add_generate`: defines if to add a `go:generate` one liner on top of the generated resource
 - `output_directory`: output directory where to generate the resources files

### Resource
Resources are the most top level definition, they are defined by service/domain/name label.
A resource may define relation resources, [columns](#column), [userDefinedColumns](#userdefinedcolumn) and [resolvers](#resolvers).

Relations are the same as a resource, yet the table generated is part of the parent resource, and an ID column is automatically added based on the relation's parent name.

#### Resource Example:
```hcl
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

  postResourceResolver "postResolveSubnetGroups" {
    path     = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
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

  user_relation "aws" "redshift" "Subnet" {
    path = "github.com/aws/aws-sdk-go-v2/service/redshift/types.Subnet"
    column "subnet_availability_zone_supported_platforms" {
      // TypeStringArray
      type = "stringArray"
      generate_resolver = true # will force cq-gen to generate a resolver for this column
    }
  }

  column "tags" {
    // TypeJson
    type = "json"
    generate_resolver = true # will force cq-gen to generate a resolver for this column i.e resolveSubnetGroupsTags
  }
}
```

#### Important Fields:
The resource config allows us to control how a resource is generated in cq-gen, these are the following attributes you can set:
* **path**:  the path defines for [data-source]() where to search for the structure either in the go package or openapi spec for example.
* **allow_unexported**: if the structure we are generating from has any private members this tells cq-gen to add them as-well, by default cq-gen skips private columns.
* **options**: the table options allow to define the [options](https://docs.cloudquery.io/docs/developers/sdk/table/primary-key) field in `schema.Table`.
* **limit_depth**: limits the depth cq-gen enters the structs, this is to avoid recursive structs.
* **disable_auto_descriptions**: Disables reading the struct for description comments for each column.
* **disable_pluralize**: Disable pluralize of the name of the resource.

**Full ResourceConfig options see structure [here](https://github.com/cloudquery/cq-gen/blob/main/codegen/config/config.go#L52).**

### Column
Every resource has a set of columns, by default column configs are auto generated based on the resource type. 
However, if you wish to control the name of the column, or it's type or perhaps force a resolver generation.

There are a few caveats when it comes to column generation, the name has to be a snake case version of the column
and has to include full path if it's embedded. (**Tip**: generate the resource first and then redefine columns based on name cq-gen defined)

The following config changes the column FilterPattern into a type string and renames it to pattern
```hcl
  column "filter_pattern" {
    type = "string"
    rename = "pattern"
  }
```
The column block allows us to change the original type, define an existing resolver or even request cq-gen to generate for
us a resolver function to implement.

#### Important Fields:
* **description**: Description of column, this will override the original description if it exists.
* **skip_prefix**: Whether we want to skip adding the embedded prefix to a column.
* **skip**: skips makes cq-gen skip the column.
* **generate_resolver**: forces cq-gen to generate a resolver function to implement.
* **resolver**: resolver definition for column, usually omitted, but if you want to use a generic/custom [resolver](https://docs.cloudquery.io/docs/developers/sdk/table/column-resolvers) for the resolver, this is an option.
* **type**: the value type, all available values types can be found [here](https://docs.cloudquery.io/docs/developers/sdk/table/column-types).
* **rename**: rename the column, if no resolver is passed schema.PathResolver will be used.


**Full Column options see structure [here](https://github.com/cloudquery/cq-gen/blob/main/codegen/config/config.go#L151).**

### UserDefinedColumn
User defined columns are identical to [columns](#column), but rather than changing and existing column 
they add more columns to your resource. UserDefinedColumns are usually used to add global columns such as `account_id`

The only difference between a [UserDefinedColumn][#UserDefinedColumn] and a [column](#column) is that Type is required.
```hcl
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-provider-aws/client.ResolveAWSAccount"
    }
  }
```

**Note**: note the resolver here i.e. [resolver](#resolvers) is a user defined function giving the path inside the provider,
if this isn't given a generator will be created instead.

### Common Resource functions
cq-gen resource creates a [schema.Table](https://docs.cloudquery.io/docs/developers/sdk/table/overview) structure, as such,
we allow to pre-set and generate its common functions such as the [TableResolver](#Resolvers), [Multiplexer & DeleteFilter](https://docs.cloudquery.io/docs/developers/sdk/table/multiplexer-and-deletefilter),
IgnoreError and postResourceResolver.

To set any of these functions to cq-gen can generate them you have to add a [FunctionConfig]((https://github.com/cloudquery/cq-gen/blob/main/codegen/config/config.go#L106)) Block. 

#### Example:
The following example shows how we can tell cq-gen what resolver function to set, in the case of `postResourceResolver` 
we ask cq-gen to generate the function with the signature of `schema.RowResolver`
```hcl
  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-provider-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-provider-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-provider-aws/client.DeleteAccountRegionFilter"
  }

  postResourceResolver "postResolveSubnetGroups" {
    path     = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
  }
```

#### Important Fields:
* **body**: function body insert when function is generated, use with care, auto importing isn't supported in user defined bodies.
* **path**: golang package path of function to use.
* **generate**: creates the function code in template, usually set automatically. Setting to true will force function generation in template.
* **path_resolver**: defines this function to be called the FieldPath traversed, this is used by generic functions such as PathResolver.
* **params**: defines params that pass the function.

### Resolvers
Resolvers are very important part of cq-gen, by default cq-gen knows to add mandatory resolvers by default if not created.
Some resolvers can be added to override existing behavior or point to existing resolvers to reduce bloat.

Resolvers used in many places in the cq-gen configuration: 
- Columns can define a resolver (ColumnResolver)
- Resources define multiple functions (Multiplexer, IgnoreError, RowResolver, DeleteFilter)

**Note**: the resolver functions expect a certain signature, giving a bad function path will result in an error.


## Examples

Check the [providers directory](https://github.com/cloudquery/cq-gen/tree/main/providers) and the [testing directory](https://github.com/cloudquery/cq-gen/tree/main/codegen/tests) for examples using cq-gen. Moreover, if the provider
you want to contribute resources to already uses cq-gen check existing generations to get a general idea how to use it for this provider
(usually all the default functions are duplicated)
