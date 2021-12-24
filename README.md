<p align="center">
<a href="https://cloudquery.io">
<img alt="cloudquery logo" width=75% src="https://github.com/cloudquery/cloudquery/raw/main/docs/images/logo.png" />
</a>
</p>


CloudQuery Provider Generator
=======================

*CQ-Gen* allows creating providers resources fast by generating all the boring bits and allow you to focus on the logic!

The main goal of cq-gen is to easily generate tables from an existing source including reading their descriptions and relations, 
by defining our generation once in a configuration we can re-generate when new fields are added and our resolver functions can stay the same.

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

Two important values are the service name this configuration is part of and the output directory
```hcl
service = "aws"
output_directory = "providers/cq-client-aws/resources"
```

### Resource
Resources are the most top level definition, they are defined by service/domain/name label.
A resource may define relation resources, [columns](#column), [userDefinedColumns](#userdefinedcolumn) and [resolvers](#resolvers).

Relations are the same as a resource, yet the table generated is part of the parent resource, and an ID column is automatically added based on the relation's parent name.

```hcl
resource "aws" "redshift" "subnet_groups" {
  path = "github.com/aws/aws-sdk-go-v2/service/redshift/types.ClusterSubnetGroup"

  ignoreError "IgnoreAccessDenied" {
    path = "github.com/cloudquery/cq-client-aws/client.IgnoreAccessDeniedServiceDisabled"
  }
  multiplex "AwsAccountRegion" {
    path = "github.com/cloudquery/cq-client-aws/client.AccountRegionMultiplex"
  }
  deleteFilter "AccountRegionFilter" {
    path = "github.com/cloudquery/cq-client-aws/client.DeleteAccountRegionFilter"
  }
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-client-aws/client.ResolveAWSAccount"
    }
  }
  userDefinedColumn "region" {
    type = "string"
    resolver "resolveAWSRegion" {
      path = "github.com/cloudquery/cq-client-aws/client.ResolveAWSRegion"
    }
  }

  relation "aws" "redshift" "Subnet" {
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

#### All ResourceConfig Options:

```go

type ResourceConfig struct {
    // Name of service i.e AWS,Azure etc'
    Service     string `hcl:"service,label"`
    // Domain this resource belongs too, i.e Storage, Users etc'
    Domain      string `hcl:"domain,label"`
    // Name of the resource table
    Name        string `hcl:"name,label"`
    // Description of the table
    Description string `hcl:"description,optional"`
    // Path to the struct we are generating from
    Path        string `hcl:"path,optional"`
    
    // Column configurations we want to modify
    Columns           []ColumnConfig   `hcl:"column,block"`
    // Relations configurations we want to modify / add
    Relations         []ResourceConfig `hcl:"relation,block"`
    // UserDefinedColumns are a list of columns we add that aren't part of the original struct
    UserDefinedColumn []ColumnConfig   `hcl:"userDefinedColumn,block"`
    
    // Function configurations will be omitted if not givien
    IgnoreError          *FunctionConfig `hcl:"ignoreError,block"`
    Multiplex            *FunctionConfig `hcl:"multiplex,block"`
    DeleteFilter         *FunctionConfig `hcl:"deleteFilter,block"`
    PostResourceResolver *FunctionConfig `hcl:"postResourceResolver,block"`
    
    // LimitDepth limits the depth cq-gen enters the structs, this is to avoid recursive structs
    LimitDepth int `hcl:"limit_depth,optional"`
    
    // EmbedRelation embeds all of the relations columns into the parent struct
    EmbedRelation   bool `hcl:"embed,optional"`
    // EmbedSkipPrefix skips the embedded relation name prefix for all it's embedded columns
    EmbedSkipPrefix bool `hcl:"embed_skip_prefix,optional"`
    // Disables reading the struct for description comments for each column
    DisableReadDescriptions bool `hcl:"disable_auto_descriptions,optional"`
}
```

The resource config allows us to control how a resource is generated in cq-gen. 
There are a few important flags to take note:

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

#### All ColumnConfigs Options:
```go
type ColumnConfig struct {
    // Name of column as defined by resource, in snake_case, be careful with abbreviations
    Name string `hcl:"name,label"`
    // Description of column to display to user, this overrides if the column has a description in the struct
    Description string `hcl:"description,optional"`
    // SkipPrefix Whether we want to skip adding the embedded prefix to a column
    SkipPrefix bool `hcl:"skip_prefix,optional" defaults:"false"`
    // Skip
    Skip bool `hcl:"skip,optional" defaults:"false"`
    // GenerateResolver whether to force a resolver creation
    GenerateResolver bool `hcl:"generate_resolver,optional"`
    // Resolver unique resolver function to use
    Resolver *FunctionConfig `hcl:"resolver,block"`
    // Type Overrides column type, use carefully, validation will fail if interface{} of value isn't the same as expected ValueType
    Type string `hcl:"type,optional"`
    // Rename column name, if no resolver is passed schema.PathResolver will be used
    Rename string `hcl:"rename,optional"`
}

```

### UserDefinedColumn
User defined columns are identical to [columns](#column), and rather than changing and existing column 
they add more columns to your resource. UserDefinedColumns are usually used to add global columns such as account_id

The only difference between a UserDefinedColumn and a [column](#column) is tha Type is required. (How can we guess new field's type?)
```hcl
  userDefinedColumn "account_id" {
    type = "string"
    resolver "resolveAWSAccount" {
      path = "github.com/cloudquery/cq-client-aws/client.ResolveAWSAccount"
    }
  }
```

**Note**: note the resolver here i.e. [resolver](#resolvers) is a user defined function giving the path inside the provider,
if this isn't given a generator will be created instead.

### Resolvers
Resolvers are very important part of cq-gen, by default cq-gen knows to add mandatory resolvers by default if not created.
Some resolvers can be added to override existing behavior or point to existing resolvers to reduce bloat.

Resolvers used in many places in the cq-gen configuration: 
- Columns can define a resolver (ColumnResolver)
- Resources define multiple resolvers (Multiplexer, IgnoreError, RowResolver, DeleteFilter)

**Note**: the resolver functions expect a certain signature, giving a bad function path will result in an error.
#### All FunctionConfig Options:
```go
type FunctionConfig struct {
	// Name of function, usually auto generated by cq-gen
	Name     string `hcl:"name,label"`
	// Body to insert when function is generated, use with care, auto importing isn't supported in user defined bodies
	Body     string `hcl:"body,optional"`
	// Path to a function to use.
	Path     string `hcl:"path"`
	// Generate tells cq-gen to create the function code in template, usually set automatically.
	// Setting to true will force function generation in template.
	Generate bool   `hcl:"generate,optional"`
}
```
