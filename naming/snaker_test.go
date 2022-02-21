package naming

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func Test_CamelToSnake(t *testing.T) {
	type test struct {
		Camel string
		Snake string
	}

	generatorTests := []test{
		{Camel: "TestCamelCase", Snake: "test_camel_case"},
		{Camel: "TestCamelCase", Snake: "test_camel_case"},
		{Camel: "AccountID", Snake: "account_id"},
		{Camel: "PostgreSSL", Snake: "postgre_ssl"},
		{Camel: "CNAME", Snake: "cname"},
		{Camel: "CNAMEBuilder", Snake: "cname_builder"},
		{Camel: "TestCNAMEBuilder", Snake: "test_cname_builder"},
		{Camel: "QueryStoreRetention", Snake: "query_store_retention"},
		{Camel: "TestCamelCaseLongString", Snake: "test_camel_case_long_string"},
		{Camel: "testCamelCaseLongString", Snake: "test_camel_case_long_string"},
	}
	t.Parallel()
	for _, tc := range generatorTests {
		t.Run(tc.Camel, func(t *testing.T) {
			assert.Equal(t, tc.Snake, CamelToSnake(tc.Camel))
		})
	}
}
