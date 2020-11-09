package main

import (
	"fmt"
	"io/ioutil"
	"log"

	"github.com/brianvoe/gofakeit/v5"

	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
)

type bootstrapSurveyProject struct {
	NewSurveyProject []discoRpc.NewSurveyProjectRequest `fakesize:"2" json:"new_survey_projects"`
}

type bootstrapSurveyUser struct {
	NewSurveyUser []discoRpc.NewSurveyUserRequest `fakesize:"2" json:"new_survey_users"`
}

type bootstrapDiscoProject struct {
	NewDiscoProject []discoRpc.NewDiscoProjectRequest `fakesize:"2" json:"new_disco_projects"`
}

type BootstrapModDisco struct {
	BSP bootstrapSurveyProject `json:"bootstrap_survey_project" yaml:"bootstrap_survey_project"`
	BSU bootstrapSurveyUser    `json:"bootstrap_survey_user" yaml:"bootstrap_survey_user"`
	BDP bootstrapDiscoProject  `json:"bootstrap_disco_project" yaml:"bootstrap_disco_project"`
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
	bmd := BootstrapModDisco{
		BSP: bsp,
		BSU: bsu,
		BDP: bsdp,
	}
	return sysCoreSvc.MarshalPretty(&bmd)
}

func main() {
	b, err := BootstrapFakeData()
	if err != nil {
		log.Fatal(err)
	}
	if err = ioutil.WriteFile("bs-mod-disco.json", b, 0644); err != nil {
		log.Fatal(err)
	}
}
