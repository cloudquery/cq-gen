package naming

import (
	"sync"

	"github.com/iancoleman/strcase"
)

var initAcronyms sync.Once

// CamelToSnake converts a given string to snake case
func CamelToSnake(s string) string {
	initAcronyms.Do(func() {
		for _, k := range commonInitialisms {
			strcase.ConfigureAcronym(k, k)
		}
	})
	return strcase.ToSnake(s)
}

// commonInitialisms, taken from
// https://github.com/golang/lint/blob/206c0f020eba0f7fbcfbc467a5eb808037df2ed6/lint.go#L731
var commonInitialisms = []string{
	"ACL",
	"API",
	"ASCII",
	"CPU",
	"CSS",
	"DNS",
	"EOF",
	"ETA",
	"GPU",
	"GUID",
	"HTML",
	"HTTP",
	"HTTPS",
	"ID",
	"IP",
	"JSON",
	"LHS",
	"OS",
	"QPS",
	"RAM",
	"RHS",
	"RPC",
	"SLA",
	"SMTP",
	"Query",
	"SSH",
	"TCP",
	"TLS",
	"TTL",
	"UDP",
	"UI",
	"UID",
	"UUID",
	"URI",
	"URL",
	"UTF8",
	"VM",
	"XML",
	"XMPP",
	"XSRF",
	"XSS",
	"OAuth",
	"VPC",
	"DB",
	"ARN",
	"IPV",
	"IAM",
	"QR",
	"PNG",
	"AZ",
	"CA",
	"KMS",
	"FQDN",
	"IOPS",
	"GB",
	"MB",
	"KB",
	"MBPS",
	"SSL",
	"SAML",
	"IPV6",
	"IPV4",
	"IDs",
	"URN",
	"CORS",
	"CNAME",
	"TTY",
	"CSI",
	"RBD",
	"AWS",
	"NFS",
	"ISCSI",
	"GigaBytes",
	"SSE",
}
