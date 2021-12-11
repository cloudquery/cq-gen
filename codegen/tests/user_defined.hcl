// This configuration file creates all mutations possible user defined columns


service = "test"
output_directory = "./tests/output"

// Simple use case of defining user columns that aren't part of the original structure
// user defined columns are added first before any structure
resource "test" "user_defined" "simple" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"

  userDefinedColumn "test_column" {
    type = "json"
    description = "user defined column test"
    generate_resolver = true
  }
}


// Sometimes we want to define user defined columns to point to already defined resolvers.
// We can do this by setting a resolver block in our column
resource "test" "user_defined" "resolvers" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"

  userDefinedColumn "test_column_with_resolver" {
    type = "json"
    description = "user defined column resolver test"
    // point to and existing resolver "TestResolver" function that implements the ColumnResolver interface
    resolver "testResolver" {
      path = "github.com/cloudquery/cq-gen/codegen/tests.TestResolver"
    }
  }

  // Sometimes we want to get the data with a PathResolver, we also want to get the full path to access
  // the value in the structure, this is usually done with generic resolvers and funk.Get function
  // Its important when the Path and column pathing isn't the same.
  userDefinedColumn "test_column_path_resolver" {
    type = "int"
    description = "user defined column path resolver test"

    resolver "testResolver" {
      path = "github.com/cloudquery/cq-gen/codegen/tests.PathTestResolver"
      path_resolver = true
    }
  }

  // Some use cases we want to define an on the fly resolver, the body should usually hold simple functions, as any
  // imported packages won't be read from the body
  userDefinedColumn "test_column_templated" {
    type = "json"
    description = "user defined column test"

    resolver "testResolver" {
      // Define the column resolver as our default base ColumnResolver
      path = "github.com/cloudquery/cq-provider-sdk/provider/schema.ColumnResolver"
      body = "panic(\"test body\")"
    }
  }
}