package golang

import (
	"fmt"
	"go/ast"
	"go/types"
	"strings"

	"github.com/cloudquery/cq-gen/code"
	"github.com/cloudquery/cq-gen/codegen/source"
	"github.com/cloudquery/cq-gen/rewrite"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
	"github.com/hashicorp/go-hclog"
)

// DataSource of golang reads from objects from golang code
type DataSource struct {
	finder *code.Finder
	parser source.DescriptionParser
}

func NewDataSource() *DataSource {
	return &DataSource{finder: code.NewFinder(), parser: &source.DefaultDescriptionParser{}}
}

func (d DataSource) Find(path string) (source.Object, error) {
	ro, err := d.finder.FindTypeFromName(path)
	if err != nil {
		return nil, err
	}
	named := ro.(*types.Named)
	pkg, _ := code.PkgAndType(path)
	rw, err := rewrite.NewFromImportPath(pkg)
	if err != nil {
		return nil, err
	}
	docs := rw.GetStructDocs(named.Obj().Name())
	spec := rw.GetStructSpec(named.Obj().Name())
	return &NamedObject{path, d, named, nil, spec, d.parser.Parse(docs.Text())}, nil
}

type NamedObject struct {
	originalPath string
	source       DataSource
	named        *types.Named
	parent       source.Object
	spec         *ast.TypeSpec
	description  string
}

func (n NamedObject) Name() string {
	return n.named.Obj().Name()
}

func (n NamedObject) Description() string {
	return n.description
}

func (n NamedObject) Exported() bool {
	return true
}

func (n NamedObject) Fields() []source.Object {
	st := n.named.Underlying().(*types.Struct)
	fields := make([]source.Object, 0)
	for i := 0; i < st.NumFields(); i++ {
		field, tag := st.Field(i), st.Tag(i)
		// Skip unexported, if the original field has a "-" tag or the field was requested to be skipped via config.
		if strings.Contains(tag, "-") {
			hclog.L().Debug("skipping column", "column", field.Name())
			continue
		}
		fd := getSpecColumnDescription(n.source.parser, n.spec, field.Name())
		fields = append(fields, &FieldObject{n.originalPath, n.source, field, n, fd})
	}
	return fields
}

func (n NamedObject) Type() schema.ValueType {
	return getValueType(n.named.Underlying())
}

func (n NamedObject) Parent() source.Object {
	return n.parent
}

func (n NamedObject) Path() string {
	return fmt.Sprintf("%s.%s", n.named.Obj().Pkg().Path(), n.named.Obj().Name())
}

type FieldObject struct {
	originalPath string
	source       DataSource
	v            *types.Var
	parent       source.Object
	description  string
}

func (f FieldObject) Name() string {
	return f.v.Name()
}

func (f FieldObject) Exported() bool {
	return f.v.Exported()
}

func (f FieldObject) Description() string {
	return f.description
}

func (f FieldObject) Fields() []source.Object {
	if f.Type() != source.TypeEmbedded {
		return nil
	}
	named := getNamedType(f.v.Type())

	pkg, _ := code.PkgAndType(f.originalPath)
	if pkgObj := named.Obj().Pkg(); pkgObj != nil {
		pkg = pkgObj.Path()
	}
	rw, err := rewrite.NewFromImportPath(pkg)
	if err != nil {
		return nil
	}
	docs := rw.GetStructDocs(named.Obj().Name())
	spec := rw.GetStructSpec(named.Obj().Name())
	return NamedObject{f.originalPath, f.source, named, f.parent, spec, f.source.parser.Parse(docs.Text())}.Fields()
}

func (f FieldObject) Type() schema.ValueType {
	return getValueType(f.v.Type())
}

func (f FieldObject) Parent() source.Object {
	return f.parent
}

func (f FieldObject) Path() string {
	named := getNamedType(f.v.Type())
	if named == nil {
		return f.v.Name()
	}
	return fmt.Sprintf("%s.%s", f.v.Pkg().Path(), named.Obj().Name())
}

func getSpecColumnDescription(parser source.DescriptionParser, spec *ast.TypeSpec, columnName string) string {
	s := spec.Type.(*ast.StructType)
	for _, f := range s.Fields.List {
		if f.Names == nil {
			continue
		}
		if f.Names[0].Name != columnName {
			continue
		}
		if f.Comment != nil {
			return parser.Parse(f.Comment.Text())
		}
		if f.Doc != nil {
			return parser.Parse(f.Doc.Text())
		}
	}
	return ""
}
