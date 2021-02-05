package service

import (
	"fmt"
	commonCfg "github.com/amplify-cms/sys-share/sys-core/service/config/common"
	"github.com/amplify-cms/sys-share/sys-core/service/fileutils"
	"gopkg.in/yaml.v2"
)

const (
	errParsingConfig           = "error parsing %s config: %v\n"
	errNoUnauthenticatedRoutes = "error: no unauthenticated routes defined"
	errNoBusClientRoutes       = "error: no bus client routes defined"
)

type ModDiscoConfig struct {
	SysCoreConfig         commonCfg.Config `json:"sysCoreConfig" yaml:"sysCoreConfig" mapstructure:"sysCoreConfig"`
	SysFileConfig         commonCfg.Config `json:"sysFileConfig" yaml:"sysFileConfig" mapstructure:"sysFileConfig"`
	UnauthenticatedRoutes []string         `json:"unauthenticatedRoutes" yaml:"unauthenticatedRoutes"`
	JWTConfig             JWTConfig        `json:"jwt" yaml:"jwt"`
	BusClientRoutes       []string         `json:"busClientRoutes" yaml:"busClientRoutes"`
}

func (c ModDiscoConfig) Validate() error {
	if len(c.UnauthenticatedRoutes) == 0 {
		return fmt.Errorf(errNoUnauthenticatedRoutes)
	}
	if len(c.BusClientRoutes) == 0 {
		return fmt.Errorf(errNoBusClientRoutes)
	}
	if err := c.SysCoreConfig.Validate(); err != nil {
		return err
	}
	if err := c.SysFileConfig.Validate(); err != nil {
		return err
	}
	return c.JWTConfig.Validate()
}

type JWTConfig struct {
	Access  commonCfg.TokenConfig `json:"access" yaml:"access" mapstructure:"access"`
	Refresh commonCfg.TokenConfig `json:"refresh" yaml:"refresh" mapstructure:"refresh"`
}

func (j JWTConfig) Validate() error {
	if err := j.Access.Validate(); err != nil {
		return err
	}
	if err := j.Refresh.Validate(); err != nil {
		return err
	}
	return nil
}

func NewConfig(filepath string) (*ModDiscoConfig, error) {
	cfg := &ModDiscoConfig{}
	f, err := fileutils.LoadFile(filepath)
	if err != nil {
		return nil, err
	}
	if err := yaml.UnmarshalStrict(f, &cfg); err != nil {
		return nil, fmt.Errorf(errParsingConfig, filepath, err)
	}
	if err := cfg.Validate(); err != nil {
		return nil, err
	}
	return cfg, nil
}
