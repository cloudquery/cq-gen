package codegen

import (
	"fmt"
	"io/ioutil"
	"regexp"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var re = regexp.MustCompile(`\r?\n`)

func Test_Generate(t *testing.T) {
	type test struct {
		Name           string
		Config         string
		Domain         string
		ResourceName   string
		ExpectedOutput string
		ExpectError    error
	}

	generatorTests := []test{
		{Name: "simple", Config: "./tests/base.hcl", Domain: "base", ResourceName: "simple", ExpectedOutput: "./tests/expected/base_simple.go"},
		{Name: "complex", Config: "./tests/base.hcl", Domain: "base", ResourceName: "complex", ExpectedOutput: "./tests/expected/base_complex.go"},
		{Name: "relations", Config: "./tests/base.hcl", Domain: "base", ResourceName: "relations", ExpectedOutput: "./tests/expected/base_relations.go"},
		{Name: "columns", Config: "./tests/columns.hcl", Domain: "columns", ResourceName: "columns", ExpectedOutput: "./tests/expected/columns_columns.go"},
		{Name: "embedded_prefix_skip", Config: "./tests/columns.hcl", Domain: "columns", ResourceName: "embedded_prefix_skip", ExpectedOutput: "./tests/expected/columns_embedded_prefix_skip.go"},
		{Name: "embedded_rename", Config: "./tests/columns.hcl", Domain: "columns", ResourceName: "embedded_rename", ExpectedOutput: "./tests/expected/columns_embedded_rename.go"},
		{Name: "embedded_field_rename", Config: "./tests/columns.hcl", Domain: "columns", ResourceName: "embedded_field_rename", ExpectedOutput: "./tests/expected/columns_embedded_field_rename.go"},
		{Name: "resolvers", Config: "./tests/resolvers.hcl", Domain: "resolvers", ResourceName: "resolvers", ExpectedOutput: "./tests/expected/resolvers_resolvers.go"},
		{Name: "resolvers_user_defined", Config: "./tests/resolvers.hcl", Domain: "resolvers", ResourceName: "user_defined", ExpectedOutput: "./tests/expected/resolvers_user_defined.go"},
		{Name: "resolvers_rename", Config: "./tests/resolvers.hcl", Domain: "resolvers", ResourceName: "rename_with_resolver", ExpectedOutput: "./tests/expected/resolvers_rename_with_resolver.go"},
		{Name: "user_defined_simple", Config: "./tests/user_defined.hcl", Domain: "user_defined", ResourceName: "simple", ExpectedOutput: "./tests/expected/user_defined_simple.go"},
		{Name: "user_defined_resolvers", Config: "./tests/user_defined.hcl", Domain: "user_defined", ResourceName: "resolvers", ExpectedOutput: "./tests/expected/user_defined_resolvers.go"},
		{Name: "relations_rename", Config: "./tests/relations.hcl", Domain: "relations", ResourceName: "rename", ExpectedOutput: "./tests/expected/relations_rename.go"},
		{Name: "relations_user_relations", Config: "./tests/relations.hcl", Domain: "relations", ResourceName: "user_relation", ExpectedOutput: "./tests/expected/relations_user_relation.go"},
		// Bad configurations
		{Name: "bad_duplicate_resource", Config: "./tests/bad_config.hcl", Domain: "bad", ResourceName: "duplicate", ExpectError: fmt.Errorf("duplicate resource found. Domain: bad Resource: duplicate")},
	}
	t.Parallel()
	for _, tc := range generatorTests {
		t.Run(tc.Name, func(t *testing.T) {
			err := Generate(tc.Config, tc.Domain, tc.ResourceName, "./tests/output")
			if tc.ExpectError == nil {
				assert.NoError(t, err)
			} else {
				assert.EqualError(t, err, tc.ExpectError.Error())
				return
			}
			filename := fmt.Sprintf("./tests/output/%s.go", tc.ResourceName)
			if tc.Domain != "" {
				filename = fmt.Sprintf("./tests/output/%s_%s.go", tc.Domain, tc.ResourceName)
			}
			result, err := ioutil.ReadFile(filename)
			assert.NoError(t, err)
			expected, err := ioutil.ReadFile(tc.ExpectedOutput)

			assert.NoError(t, err, "expected output file missing", tc.ExpectedOutput)
			assert.Equal(t,
				strings.ReplaceAll(re.ReplaceAllString(string(expected), " "), " ", ""),
				strings.ReplaceAll(re.ReplaceAllString(string(result), " "), " ", ""))
		})
	}
}
