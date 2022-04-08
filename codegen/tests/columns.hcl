service          = "test"
output_directory = "./tests/output/columns/"


resource "test" "columns" "columns" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"

  // Here we rename the column "IntValue" to "rename_int_value" we override the description, and change type to string
  // We also generate a resolver so we can do the casting and set it ourselves.
  // if we had a generic cast resolver we could have used the resolver block, see commented out
  column "int_value" {
    description = "change description to whatever you want"
    rename = "rename_int_value"
    type = "string"
    generate_resolver = true
#    // we don't need to force generate_resolver if we define this block
#    resolver "castToString" {
#      path =  "github.com/cloudquery/cq-gen/codegen/tests.CastToString"
#    }
  }

  column "bool_value" {
    skip = true
  }

  column "embedded_field_a" {
    description = "change description to whatever you want"
  }

}

resource "test" "columns" "embedded_prefix_skip" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"

  // skip prefix on the embedded column, all sub columns won't have the prefix added on therr name
  column "embedded" {
    skip_prefix = true
  }
  // we want to rename the "embedded_field_a" column because we skipped prefix, we use the unprefixed name
  column "field_a" {
    rename = "rename_field"
  }
}
resource "test" "columns" "embedded_rename" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"

  // we want to rename a prefix, don't use this with skip-prefix as the rename won't be used if skipped.
  column "embedded" {
    rename = "rename_prefix"
  }
}



resource "test" "columns" "embedded_field_rename" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"

  // we want to rename the "embedded_field_a" column because we didn't skip prefix, we use the full path name
  column "embedded_field_a" {
    rename = "rename_field"
  }
}

