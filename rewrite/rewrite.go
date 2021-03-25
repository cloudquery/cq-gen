package rewrite

import (
	"fmt"
	"github.com/cloudquery/cq-gen/code"
	"go/ast"
	"go/token"
	"golang.org/x/tools/go/packages"
	"io/ioutil"
	"path/filepath"
	"strconv"
)

type Rewriter struct {
	pkg    *packages.Package
	files  map[string]string
	copied map[ast.Decl]bool
}

func New(dir string) (*Rewriter, error) {
	importPath := code.ImportPathForDir(dir)
	if importPath == "" {
		return nil, fmt.Errorf("import path not found for directory: %q", dir)
	}
	pkgs, err := packages.Load(&packages.Config{
		Mode: packages.NeedSyntax | packages.NeedTypes,
	}, importPath)
	if err != nil {
		return nil, err
	}
	if len(pkgs) == 0 {
		return nil, fmt.Errorf("package not found for importPath: %s", importPath)
	}

	return &Rewriter{
		pkg:    pkgs[0],
		files:  map[string]string{},
		copied: map[ast.Decl]bool{},
	}, nil
}

func (r *Rewriter) getSource(start, end token.Pos) string {
	startPos := r.pkg.Fset.Position(start)
	endPos := r.pkg.Fset.Position(end)

	if startPos.Filename != endPos.Filename {
		panic("cant get source spanning multiple files")
	}

	file := r.getFile(startPos.Filename)
	return file[startPos.Offset:endPos.Offset]
}

func (r *Rewriter) getFile(filename string) string {
	if _, ok := r.files[filename]; !ok {
		b, err := ioutil.ReadFile(filename)
		if err != nil {
			panic(fmt.Errorf("unable to load file, already exists: %s", err.Error()))
		}

		r.files[filename] = string(b)

	}

	return r.files[filename]
}

func (r *Rewriter) GetFunction(funcName string) string {
	for _, f := range r.pkg.Syntax {
		for _, d := range f.Decls {
			d, isFunc := d.(*ast.FuncDecl)
			if !isFunc {
				continue
			}
			if d.Name.Name != funcName {
				continue
			}
			r.copied[d] = true

			return r.getSource(d.Body.Pos()+1, d.Body.End()-1)
		}
	}

	return ""
}

func (r *Rewriter) ExistingImports(filename string) []Import {
	filename, err := filepath.Abs(filename)
	if err != nil {
		panic(err)
	}
	for _, f := range r.pkg.Syntax {
		pos := r.pkg.Fset.Position(f.Pos())

		if filename != pos.Filename {
			continue
		}

		var imps []Import
		for _, i := range f.Imports {
			name := ""
			if i.Name != nil {
				name = i.Name.Name
			}
			path, err := strconv.Unquote(i.Path.Value)
			if err != nil {
				panic(err)
			}
			imps = append(imps, Import{name, path})
		}
		return imps
	}
	return nil
}

type Import struct {
	Alias      string
	ImportPath string
}