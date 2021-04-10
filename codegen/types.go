package codegen

import (
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
	"go/types"
	"path"
	"strings"
)

const TypeRelation schema.ValueType = -1
const TypeEmbedded schema.ValueType = -2
const TypeUserDefined schema.ValueType = -3

func getValueType(typ types.Type) schema.ValueType {
	if vt := getUniqueStructs(typ); vt != schema.TypeInvalid {
		return vt
	}
	switch t := typ.(type) {
	case *types.Map:
		return schema.TypeJSON
	case *types.Basic:
		return getBasicType(t)
	case *types.Named:
		return getValueType(t.Underlying())
	case *types.Struct:
		return TypeEmbedded
	case *types.Slice:
		valueType := getValueType(t.Elem())
		switch valueType {
		case schema.TypeInt:
			return schema.TypeIntArray
		case schema.TypeString:
			return schema.TypeStringArray
		case TypeEmbedded:
			return TypeRelation
		case schema.TypeSmallInt:
			return schema.TypeByteArray
		default:
			return schema.TypeInvalid
		}
	case *types.Pointer:
		return getValueType(t.Elem())
	}
	return schema.TypeInvalid
}

func getBasicType(typ *types.Basic) schema.ValueType {
	switch typ.Kind() {
	case types.Bool:
		return schema.TypeBool
	case types.Int8, types.Uint8, types.Int16:
		return schema.TypeSmallInt
	case types.Uint16, types.Int32:
		return schema.TypeInt
	case types.Uint32, types.Int64, types.Int:
		return schema.TypeBigInt
	case types.Float32, types.Float64:
		return schema.TypeFloat
	case types.String:
		return schema.TypeString
	}
	return schema.TypeInvalid
}

func getUniqueStructs(typ types.Type) schema.ValueType {
	switch typ.String() {
	case "time.Time":
		return schema.TypeTimestamp
	case "uuid.UUID":
		return schema.TypeUUID
	default:
		return schema.TypeInvalid
	}
}

func getNamedType(typ types.Type) *types.Named {
	switch t := typ.(type) {
	case *types.Pointer:
		return getNamedType(t.Elem())
	case *types.Named:
		return t
	case *types.Slice:
		return getNamedType(t.Elem())
	}
	panic("type ")
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