service          = "test"
output_directory = "./tests/output"


// CloudQuery tables have some functions, we can control the function to be added in the template like so:
resource "test" "resolvers" "resolvers" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"
  ignoreError "TestIgnoreError" {
    path = "github.com/cloudquery/cq-gen/codegen/tests.IgnoreErrorFunc"
  }
  multiplex "TestMultiplex" {
    path = "github.com/cloudquery/cq-gen/codegen/tests.TestMultiplex"
  }
  deleteFilter "TestDeleteFilter" {
    path = "github.com/cloudquery/cq-gen/codegen/tests.TestDeleteFilter"
  }
  postResourceResolver "GeneratedPostResolver" {
    path     = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
  }
}


// Test defining resolver body by user in the configuration
resource "test" "resolvers" "user_defined" {
  resolver "fetchUserDefined" {
    path = "github.com/cloudquery/cq-provider-sdk/provider/schema.TableResolver"
    body = "panic(\"my fetch implementation\")"
  }
}