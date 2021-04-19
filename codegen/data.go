package codegen

import (
	"github.com/cloudquery/cq-gen/code"
	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/rewrite"
	"github.com/cloudquery/cq-provider-sdk/logging"
	"github.com/hashicorp/go-hclog"
)

type ResourceDefinition struct {
	Config config.ResourceConfig
	Table  *TableDefinition
}

func buildResources(cfg *config.Config, domain string, resource string) ([]*ResourceDefinition, error) {
	rw, err := rewrite.New(cfg.OutputDirectory)
	if err != nil {
		return nil, err
	}
	b := builder{code.NewFinder(), rw, logging.New(&hclog.LoggerOptions{
		Name:  "builder",
		Level: hclog.Debug,
	}), 0}
	return b.build(cfg, domain, resource)
}

// builder generates all models code based from the configuration
type builder struct {
	finder   *code.Finder
	rewriter *rewrite.Rewriter
	logger   hclog.Logger
	depth    int
}

func (b builder) build(cfg *config.Config, domain string, resourceName string) ([]*ResourceDefinition, error) {
	resources := make([]*ResourceDefinition, 0)
	for _, resource := range cfg.Resources {
		if domain != "" && resource.Domain != domain {
			continue
		}
		if resourceName != "" && resource.Name != resourceName {
			continue
		}
		t, err := b.buildTable(nil, resource)
		if err != nil {
			return nil, err
		}
		resources = append(resources, &ResourceDefinition{
			Config: resource,
			Table:  t,
		})
	}
	return resources, nil
}
