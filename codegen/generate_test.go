package codegen

import (
	"fmt"
	"io/ioutil"
	"os"
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/stretchr/testify/assert"
)

func TestMain(m *testing.M) {
	// remove output from previous test runs
	err := os.RemoveAll("./tests/output")
	if err != nil {
		panic("failed to remove output directory before tests:" + err.Error())
	}

	code := m.Run()

	os.Exit(code)
}

func Test_Generate(t *testing.T) {
	type test struct {
		Name         string
		Config       string
		Domain       string
		ResourceName string
		ExpectError  error
	}

	generatorTests := []test{
		{Name: "simple", Config: "./tests/base.hcl", Domain: "base", ResourceName: "simple"},
		{Name: "complex", Config: "./tests/base.hcl", Domain: "base", ResourceName: "complex"},
		{Name: "relations", Config: "./tests/base.hcl", Domain: "base", ResourceName: "relations"},
		{Name: "columns", Config: "./tests/columns.hcl", Domain: "columns", ResourceName: "columns"},
		{Name: "embedded_prefix_skip", Config: "./tests/columns.hcl", Domain: "columns", ResourceName: "embedded_prefix_skip"},
		{Name: "embedded_rename", Config: "./tests/columns.hcl", Domain: "columns", ResourceName: "embedded_rename"},
		{Name: "embedded_field_rename", Config: "./tests/columns.hcl", Domain: "columns", ResourceName: "embedded_field_rename"},
		{Name: "columns", Config: "./tests/columns.hcl", Domain: "columns", ResourceName: "columns"},
		{Name: "change_type_default_resolver", Config: "./tests/columns.hcl", Domain: "columns", ResourceName: "change_type_default_resolver"},
		{Name: "resolvers_user_defined", Config: "./tests/resolvers.hcl", Domain: "resolvers", ResourceName: "user_defined"},
		{Name: "resolvers_rename", Config: "./tests/resolvers.hcl", Domain: "resolvers", ResourceName: "rename_with_resolver"},
		{Name: "with_params", Config: "./tests/resolvers.hcl", Domain: "resolvers", ResourceName: "with_params"},
		{Name: "user_defined_simple", Config: "./tests/user_defined.hcl", Domain: "user_defined", ResourceName: "simple"},
		{Name: "user_defined_resolvers", Config: "./tests/user_defined.hcl", Domain: "user_defined", ResourceName: "resolvers"},
		{Name: "relations_rename", Config: "./tests/relations.hcl", Domain: "relations", ResourceName: "rename"},
		{Name: "relations_user_relations", Config: "./tests/relations.hcl", Domain: "relations", ResourceName: "user_relation"},
		// Bad configurations
		{Name: "bad_duplicate_resource", Config: "./tests/bad_config.hcl", Domain: "bad", ResourceName: "duplicate", ExpectError: fmt.Errorf("failed to build resources: duplicate resource found. Domain: bad Resource: duplicate")},
	}
	t.Parallel()
	for _, tc := range generatorTests {
		t.Run(tc.Name, func(t *testing.T) {
			err := Generate(tc.Config, tc.Domain, tc.ResourceName, fmt.Sprintf("./tests/output/%s", tc.Domain))
			if tc.ExpectError == nil {
				assert.NoError(t, err)
			} else {
				assert.EqualError(t, err, tc.ExpectError.Error())
				return
			}
			filename := fmt.Sprintf("./tests/output/%s.go", tc.ResourceName)
			if tc.Domain != "" {
				filename = fmt.Sprintf("./tests/output/%s/%s.go", tc.Domain, tc.ResourceName)
			}

			expectedFilename := fmt.Sprintf("./tests/expected/%s.go", tc.ResourceName)
			if tc.Domain != "" {
				expectedFilename = fmt.Sprintf("./tests/expected/%s/%s.go", tc.Domain, tc.ResourceName)
			}

			result, err := ioutil.ReadFile(filename)
			assert.NoError(t, err)
			expected, err := ioutil.ReadFile(expectedFilename)

			assert.NoError(t, err, "expected output file missing", expectedFilename)
			if diff := cmp.Diff(expected, result); diff != "" {
				t.Error(diff)
			}
		})
	}
}
