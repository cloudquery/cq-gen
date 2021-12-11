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
	}

	generatorTests := []test{
		{Name: "simple", Config: "./tests/base.hcl", Domain: "base", ResourceName: "simple", ExpectedOutput: "./tests/expected/base_simple.go"},
		{Name: "complex", Config: "./tests/base.hcl", Domain: "base", ResourceName: "complex", ExpectedOutput: "./tests/expected/base_complex.go"},
		{Name: "relations", Config: "./tests/base.hcl", Domain: "base", ResourceName: "relations", ExpectedOutput: "./tests/expected/base_relations.go"},
		{Name: "user_defined_simple", Config: "./tests/user_defined.hcl", Domain: "user_defined", ResourceName: "simple", ExpectedOutput: "./tests/expected/user_defined_simple.go"},
		{Name: "user_defined_resolvers", Config: "./tests/user_defined.hcl", Domain: "user_defined", ResourceName: "resolvers", ExpectedOutput: "./tests/expected/user_defined_resolvers.go"},
	}
	for _, tc := range generatorTests {
		t.Run(tc.Name, func(t *testing.T) {
			err := Generate(tc.Config, tc.Domain, tc.ResourceName)
			assert.NoError(t, err)
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
