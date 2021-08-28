package codegen

import (
	"fmt"
	"go/types"
	"path"
	"strings"
)

func GetFunctionParams(sig *types.Signature) string {

	params := make([]string, sig.Params().Len())
	for i := 0; i < sig.Params().Len(); i++ {
		v := sig.Params().At(i)
		params[i] = fmt.Sprintf("%s %s", v.Name(), typeIdentifier(v.Type()))
	}
	if sig.Results().Len() == 0 {
		return fmt.Sprintf("(%s)", strings.Join(params, ","))
	}
	results := make([]string, sig.Results().Len())
	for i := 0; i < sig.Results().Len(); i++ {
		v := sig.Results().At(i)
		results[i] = fmt.Sprintf("%s", typeIdentifier(v.Type()))
	}
	if len(results) == 1 {
		return fmt.Sprintf("(%s) %s", strings.Join(params, ","), results[0])
	}
	return fmt.Sprintf("(%s) (%s)", strings.Join(params, ","), strings.Join(results, ","))
}

func typeIdentifier(t types.Type) string {

	typeStr := t.String()
	// get only the base path, removing package path
	current := path.Base(typeStr)
	if strings.HasPrefix(typeStr, "*") {
		return "*" + current
	}
	return current
}
