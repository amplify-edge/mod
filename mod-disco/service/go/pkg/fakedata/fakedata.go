package fakedata

import (
	"fmt"
	"github.com/brianvoe/gofakeit/v5"
	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	"github.com/segmentio/encoding/json"
	"io/ioutil"
)

type bootstrapSurveyProject struct {
	NewSurveyProject []*discoRpc.NewSurveyProjectRequest `fakesize:"2" json:"new_survey_projects"`
}

type bootstrapSurveyUser struct {
	NewSurveyUser []*discoRpc.NewSurveyUserRequest `fakesize:"2" json:"new_survey_users"`
}

type bootstrapDiscoProject struct {
	NewDiscoProject []*discoRpc.NewDiscoProjectRequest `fakesize:"2" json:"new_disco_projects"`
}

type BootstrapModDisco struct {
	BSP bootstrapSurveyProject `json:"bootstrap_survey_project" yaml:"bootstrap_survey_project"`
	BSU bootstrapSurveyUser    `json:"bootstrap_survey_user" yaml:"bootstrap_survey_user"`
	BDP bootstrapDiscoProject  `json:"bootstrap_disco_project" yaml:"bootstrap_disco_project"`
}

func (b *BootstrapModDisco) GetSurveyUsers() []*discoRpc.NewSurveyUserRequest {
	return b.BSU.NewSurveyUser
}

func (b *BootstrapModDisco) GetSurveyProjects() []*discoRpc.NewSurveyProjectRequest {
	return b.BSP.NewSurveyProject
}

func (b *BootstrapModDisco) GetDiscoProjects() []*discoRpc.NewDiscoProjectRequest {
	return b.BDP.NewDiscoProject
}

func (b *BootstrapModDisco) MarshalPretty() ([]byte, error) {
	return sysCoreSvc.MarshalPretty(b)
}

func BootstrapFakeData() ([]byte, error) {
	var bsp bootstrapSurveyProject
	var bsu bootstrapSurveyUser
	var bsdp bootstrapDiscoProject
	fmt.Println("GENERATING FAKE DATA FOR Bootstrap Survey Project")
	gofakeit.Struct(&bsp)
	gofakeit.Struct(&bsu)
	gofakeit.Struct(&bsdp)
	fmt.Println("Generated")
	bmd := &BootstrapModDisco{
		BSP: bsp,
		BSU: bsu,
		BDP: bsdp,
	}
	return bmd.MarshalPretty()
}

func BootstrapModDiscoFromFilepath(path string) (*BootstrapModDisco, error) {
	var bmd BootstrapModDisco
	f, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, err
	}
	if err = json.Unmarshal(f, &bmd); err != nil {
		return nil, err
	}
	return &bmd, nil
}
