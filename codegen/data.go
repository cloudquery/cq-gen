package codegen

import (
	"github.com/cloudquery/cq-provider-sdk/logging"
	"github.com/cloudquery/cq-gen/code"
	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/rewrite"
	"github.com/hashicorp/go-hclog"
)

type ResourceDefinition struct {
	Config config.ResourceConfig
	Table  *TableDefinition
}

func buildResources(cfg *config.Config) ([]*ResourceDefinition, error) {
	rw, err := rewrite.New(cfg.OutputDirectory)
	if err != nil {
		return nil, err
	}
	b := builder{code.NewFinder(), rw, logging.New(&hclog.LoggerOptions{
		Name:  "builder",
		Level: hclog.Debug,
	})}
	return b.build(cfg)
}

func buildResource(cfg *config.Config, resource string) (*ResourceDefinition, error) {
	rw, err := rewrite.New(cfg.OutputDirectory)
	if err != nil {
		return nil, err
	}
	b := builder{code.NewFinder(), rw, logging.New(&hclog.LoggerOptions{
		Name:  "builder",
		Level: hclog.Debug,
	})}

	resourceCfg, err := cfg.GetResource(resource)
	if err != nil {
		return nil, err
	}

	t, err := b.buildTable(resourceCfg)
	if err != nil {
		return nil, err
	}

	return &ResourceDefinition{
		Config: resourceCfg,
		Table:  t,
	}, nil
}

// builder generates all models code based from the configuration
type builder struct {
	finder   *code.Finder
	rewriter *rewrite.Rewriter
	logger   hclog.Logger
}

func (b builder) build(cfg *config.Config) ([]*ResourceDefinition, error) {
	resources := make([]*ResourceDefinition, len(cfg.Resources))
	for i, resource := range cfg.Resources {
		t, err := b.buildTable(resource)
		if err != nil {
			return nil, err
		}
		resources[i] = &ResourceDefinition{
			Config: resource,
			Table:  t,
		}
	}
	return resources, nil
}
