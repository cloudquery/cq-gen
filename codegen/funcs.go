package codegen

import (
	"go/types"
	"strings"
	"unicode"
)

func UcFirst(s string) string {
	if s == "" {
		return ""
	}
	r := []rune(s)
	r[0] = unicode.ToUpper(r[0])
	return string(r)
}

func LcFirst(s string) string {
	if s == "" {
		return ""
	}

	r := []rune(s)
	r[0] = unicode.ToLower(r[0])
	return string(r)
}

func isDelimiter(c rune) bool {
	return c == '-' || c == '_' || unicode.IsSpace(c)
}

func ref(p types.Type) string {
	return CurrentImports.LookupType(p)
}

func Call(p *FunctionDefinition) string {
	if p == nil {
		return ""
	}
	if p.Type == nil {
		return p.Signature
	}
	path := p.Type.Pkg().Path()
	pkg := CurrentImports.Lookup(path)

	if pkg != "" {
		pkg += "."
	}
	if p.Signature != "" {
		return p.Signature
	}
	return pkg + p.Type.Name()
}

func ToGoPrivate(name string) string {
	if name == "_" {
		return "_"
	}
	runes := make([]rune, 0, len(name))

	first := true
	wordWalker(name, func(info *wordInfo) {
		word := info.Word
		switch {
		case first:
			if strings.ToUpper(word) == word || strings.ToLower(word) == word {
				// ID → id, CAMEL → camel
				word = strings.ToLower(info.Word)
			} else {
				// ITicket → iTicket
				word = LcFirst(info.Word)
			}
			first = false
		case info.MatchCommonInitial:
			word = strings.ToUpper(word)
		case !info.HasCommonInitial:
			word = UcFirst(strings.ToLower(word))
		}
		runes = append(runes, []rune(word)...)
	})

	return sanitizeKeywords(string(runes))
}

func ToGo(name string) string {
	if name == "_" {
		return "_"
	}
	runes := make([]rune, 0, len(name))

	wordWalker(name, func(info *wordInfo) {
		word := info.Word
		if info.MatchCommonInitial {
			word = strings.ToUpper(word)
		} else if !info.HasCommonInitial {
			if strings.ToUpper(word) == word || strings.ToLower(word) == word {
				// FOO or foo → Foo
				// FOo → FOo
				word = UcFirst(strings.ToLower(word))
			}
		}
		runes = append(runes, []rune(word)...)
	})

	return string(runes)
}

func ToSnake(name string) string {
	runes := make([]rune, 0)
	wordWalker(name, func(info *wordInfo) {
		if len(runes) > 1 {
			runes = append(runes, '_')
		}
		runes = append(runes, []rune(strings.ToLower(info.Word))...)
	})
	return string(runes)
}

type wordInfo struct {
	Word               string
	MatchCommonInitial bool
	HasCommonInitial   bool
}

// This function is based on the following code.
// https://github.com/golang/lint/blob/06c8688daad7faa9da5a0c2f163a3d14aac986ca/lint.go#L679
func wordWalker(str string, f func(*wordInfo)) {
	runes := []rune(strings.TrimFunc(str, isDelimiter))
	w, i := 0, 0 // index of start of word, scan
	hasCommonInitial := false
	for i+1 <= len(runes) {
		eow := false // whether we hit the end of a word
		switch {
		case i+1 == len(runes):
			eow = true
		case isDelimiter(runes[i+1]):
			// underscore; shift the remainder forward over any run of underscores
			eow = true
			n := 1
			for i+n+1 < len(runes) && isDelimiter(runes[i+n+1]) {
				n++
			}

			// Leave at most one underscore if the underscore is between two digits
			if i+n+1 < len(runes) && unicode.IsDigit(runes[i]) && unicode.IsDigit(runes[i+n+1]) {
				n--
			}

			copy(runes[i+1:], runes[i+n+1:])
			runes = runes[:len(runes)-n]
		case unicode.IsLower(runes[i]) && !unicode.IsLower(runes[i+1]):
			// lower->non-lower
			eow = true
		}
		i++

		// [w,i) is a word.
		word := string(runes[w:i])
		if !eow && commonInitialisms[word] && !unicode.IsLower(runes[i]) {
			// through
			// split IDFoo → ID, Foo
			// but URLs → URLs
		} else if !eow {
			if commonInitialisms[word] {
				hasCommonInitial = true
			}
			continue
		}

		matchCommonInitial := false
		if commonInitialisms[strings.ToUpper(word)] {
			hasCommonInitial = true
			matchCommonInitial = true
		}

		f(&wordInfo{
			Word:               word,
			MatchCommonInitial: matchCommonInitial,
			HasCommonInitial:   hasCommonInitial,
		})
		hasCommonInitial = false
		w = i
	}
}

var keywords = []string{
	"break",
	"default",
	"func",
	"interface",
	"select",
	"case",
	"defer",
	"go",
	"map",
	"struct",
	"chan",
	"else",
	"goto",
	"package",
	"switch",
	"const",
	"fallthrough",
	"if",
	"range",
	"type",
	"continue",
	"for",
	"import",
	"return",
	"var",
	"_",
}

// sanitizeKeywords prevents collisions with go keywords for arguments to resolver functions
func sanitizeKeywords(name string) string {
	for _, k := range keywords {
		if name == k {
			return name + "Arg"
		}
	}
	return name
}

// commonInitialisms is a set of common initialisms.
// Only add entries that are highly unlikely to be non-initialisms.
// For instance, "ID" is fine (Freudian code is rare), but "AND" is not.
var commonInitialisms = map[string]bool{
	"ACL":   true,
	"API":   true,
	"ASCII": true,
	"CPU":   true,
	"CSS":   true,
	"DNS":   true,
	"EOF":   true,
	"GUID":  true,
	"HTML":  true,
	"HTTP":  true,
	"HTTPS": true,
	"ID":    true,
	"IP":    true,
	"JSON":  true,
	"LHS":   true,
	"PGP":   true,
	"QPS":   true,
	"RAM":   true,
	"RHS":   true,
	"RPC":   true,
	"SLA":   true,
	"SMTP":  true,
	"SQL":   true,
	"SSH":   true,
	"TCP":   true,
	"TLS":   true,
	"TTL":   true,
	"UDP":   true,
	"UI":    true,
	"UID":   true,
	"UUID":  true,
	"URI":   true,
	"URL":   true,
	"UTF8":  true,
	"VM":    true,
	"XML":   true,
	"XMPP":  true,
	"XSRF":  true,
	"XSS":   true,
	"AWS":   true,
	"S3":    true,
	"IPV6":  true,
}
