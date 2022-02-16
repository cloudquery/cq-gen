package naming

import (
	"sync"

	"github.com/iancoleman/strcase"
)

var initAcronyms sync.Once

// CamelToSnake converts a given string to snake case
func CamelToSnake(s string) string {
	initAcronyms.Do(func() {
		for k, _ := range commonInitialisms {
			strcase.ConfigureAcronym(k, k)
		}
	})
	return strcase.ToSnake(s)
}

// commonInitialisms, taken from
// https://github.com/golang/lint/blob/206c0f020eba0f7fbcfbc467a5eb808037df2ed6/lint.go#L731
var commonInitialisms = map[string]bool{
	"ACL":       true,
	"API":       true,
	"ASCII":     true,
	"CPU":       true,
	"CSS":       true,
	"DNS":       true,
	"EOF":       true,
	"ETA":       true,
	"GPU":       true,
	"GUID":      true,
	"HTML":      true,
	"HTTP":      true,
	"HTTPS":     true,
	"ID":        true,
	"IP":        true,
	"JSON":      true,
	"LHS":       true,
	"OS":        true,
	"QPS":       true,
	"RAM":       true,
	"RHS":       true,
	"RPC":       true,
	"SLA":       true,
	"SMTP":      true,
	"Query":     true,
	"SSH":       true,
	"TCP":       true,
	"TLS":       true,
	"TTL":       true,
	"UDP":       true,
	"UI":        true,
	"UID":       true,
	"UUID":      true,
	"URI":       true,
	"URL":       true,
	"UTF8":      true,
	"VM":        true,
	"XML":       true,
	"XMPP":      true,
	"XSRF":      true,
	"XSS":       true,
	"OAuth":     true,
	"VPC":       true,
	"DB":        true,
	"ARN":       true,
	"IPV":       true,
	"IAM":       true,
	"QR":        true,
	"PNG":       true,
	"AZ":        true,
	"CA":        true,
	"KMS":       true,
	"FQDN":      true,
	"IOPS":      true,
	"GB":        true,
	"MB":        true,
	"KB":        true,
	"MBPS":      true,
	"SSL":       true,
	"SAML":      true,
	"IPV6":      true,
	"IPV4":      true,
	"IDs":       true,
	"URN":       true,
	"CORS":      true,
	"CNAME":     true,
	"TTY":       true,
	"CSI":       true,
	"RBD":       true,
	"AWS":       true,
	"NFS":       true,
	"ISCSI":     true,
	"GigaBytes": true,
	"SSE":       true,
}
