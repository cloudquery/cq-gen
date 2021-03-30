
package code

import (
	"fmt"
	"github.com/pkg/errors"
	"go/types"
)

var MapType = types.NewMap(types.Typ[types.String], types.NewInterfaceType(nil, nil).Complete())
var InterfaceType = types.NewInterfaceType(nil, nil)

type Finder struct {
	pkgs Packages
}

func NewFinder() *Finder {
	return &Finder{
		pkgs: Packages{},
	}
}

func (f *Finder) FindTypeFromName(name string) (types.Type, error) {
	pkgName, typeName := PkgAndType(name)
	return f.FindType(pkgName, typeName)
}

func (f *Finder) FindFuncFromName(name string) (*types.Func, error) {
	pkgName, typeName := PkgAndType(name)
	obj, err := f.FindObject(pkgName, typeName)
	if err != nil {
		return nil, err
	}
	if fun, isFunc := obj.(*types.Func); isFunc {
		return fun, nil
	}
	return nil, fmt.Errorf("%s is not function", typeName)
}

func (f *Finder) FindType(pkgName string, typeName string) (types.Type, error) {
	if pkgName == "" {
		if typeName == "map[string]interface{}" {
			return MapType, nil
		}

		if typeName == "interface{}" {
			return InterfaceType, nil
		}
	}

	obj, err := f.FindObject(pkgName, typeName)
	if err != nil {
		return nil, err
	}

	if fun, isFunc := obj.(*types.Func); isFunc {
		if fun.Type().(*types.Signature).Params() != nil {
			return  fun.Type().(*types.Signature).Params().At(0).Type(), nil
		}
		return fun.Type(), nil
	}
	return obj.Type(), nil
}


func (f Finder) FindObjectFromName(name string) (types.Object, error) {
	pkgName, typeName := PkgAndType(name)
	return f.FindObject(pkgName, typeName)
}

func (f Finder) FindObject(pkgName string, typeName string) (types.Object, error) {
	if pkgName == "" {
		return nil, fmt.Errorf("package cannot be nil")
	}
	fullName := typeName
	if pkgName != "" {
		fullName = pkgName + "." + typeName
	}

	pkg := f.pkgs.LoadWithTypes(pkgName)
	if pkg == nil {
		return nil, errors.Errorf("required package was not loaded: %s", fullName)
	}


	// then look for types directly
	for astNode, def := range pkg.TypesInfo.Defs {
		// only look at defs in the top scope
		if def == nil || def.Parent() == nil || def.Parent() != pkg.Types.Scope() {
			continue
		}

		if astNode.Name == typeName {
			return def, nil
		}
	}

	return nil, errors.Errorf("unable to find type %s\n", fullName)
}

