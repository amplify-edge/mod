package fakedata

import (
	"fmt"
	"github.com/brianvoe/gofakeit/v5"
	"math/rand"

	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sharedConfig "github.com/getcouragenow/sys-share/sys-core/service/config"
	"github.com/getcouragenow/sys-share/sys-core/service/fakehelper"
)

type bootstrapSurveyProject struct {
	NewSurveyProject []*discoRpc.NewSurveyProjectRequest `fakesize:"200" json:"new_survey_projects" yaml:"new_survey_projects"`
}

func genFakeSurveyProject(sysAccProjRc *fakehelper.RefCount) (*fakehelper.RefCount, bootstrapSurveyProject) {
	projRc := sysAccProjRc.ResetLastReference()
	spRc, srtRc, untRc := fakehelper.NewRefCount(), fakehelper.NewRefCount(), fakehelper.NewRefCount()
	gofakeit.Seed(sharedConfig.CurrentTimestamp())
	gofakeit.AddFuncLookup(fakehelper.FakeNameSequence(
		func(prefix, referral string, isRef, isUniqueRef, reset bool) (interface{}, error) {
			var rc, referralRc *fakehelper.RefCount
			switch prefix {
			case "survey_project":
				rc = spRc
			case "support_role_type":
				rc = srtRc
			case "user_needs_type":
				rc = untRc
			default:
				rc = fakehelper.NewRefCount()
			}
			if isRef {
				switch referral {
				case "sys_account_project":
					referralRc = projRc
				case "survey_project":
					referralRc = spRc
				default:
					referralRc = fakehelper.NewRefCount()
				}
				if isUniqueRef {
					if referralRc.LastReference > referralRc.Sequence {
						return nil, fmt.Errorf("reference amounted more than available referral")
					}
					seq := referralRc.LastReference
					referralRc.LastReference += 1
					return fmt.Sprintf("%s_%d", prefix, seq), nil
				} else {
					return fmt.Sprintf("%s_%d", prefix, rand.Intn(referralRc.Sequence)), nil
				}
			}
			rc.Previous = rc.Sequence
			rc.Sequence += 1
			return fmt.Sprintf("%s_%d", prefix, rc.Previous), nil
		},
	))
	var bsp bootstrapSurveyProject
	gofakeit.Struct(&bsp)
	return spRc, bsp
}

type bootstrapSurveyUser struct {
	NewSurveyUser []*discoRpc.NewSurveyUserRequest `fakesize:"4" json:"new_survey_users" yaml:"new_survey_users"`
}

func genFakeSurveyUser(domain string, sysAccRc, sysAccProjRc, surveyProjectRc *fakehelper.RefCount) bootstrapSurveyUser {
	projRc := sysAccProjRc.ResetLastReference()
	accRc := sysAccRc.ResetLastReference()
	spRc := surveyProjectRc.ResetLastReference()
	suRc, srvRc, unvRc := fakehelper.NewRefCount(), fakehelper.NewRefCount(), fakehelper.NewRefCount()
	gofakeit.Seed(sharedConfig.CurrentTimestamp())
	gofakeit.AddFuncLookup(fakehelper.FakeNameSequence(
		func(prefix, referral string, isRef, isUniqueRef, reset bool) (interface{}, error) {
			var rc, referralRc *fakehelper.RefCount
			switch prefix {
			case "survey_user":
				rc = suRc
			case "survey_project":
				rc = surveyProjectRc
			case "support_role_value":
				rc = srvRc
			case "user_needs_value":
				rc = unvRc
			default:
				rc = fakehelper.NewRefCount()
			}
			if isRef {
				switch referral {
				case "sys_account_project":
					referralRc = projRc
				case "survey_project":
					referralRc = spRc
				default:
					referralRc = fakehelper.NewRefCount()
				}
				if isUniqueRef {
					if referralRc.LastReference > referralRc.Sequence {
						return nil, fmt.Errorf("reference amounted more than available referral")
					}
					seq := referralRc.LastReference
					referralRc.LastReference += 1
					return fmt.Sprintf("%s_%d", prefix, seq), nil
				} else {
					return fmt.Sprintf("%s_%d", prefix, rand.Intn(referralRc.Sequence)), nil
				}
			}
			rc.Previous = rc.Sequence
			rc.Sequence += 1
			return fmt.Sprintf("%s_%d", prefix, rc.Previous), nil
		},
	))
	gofakeit.AddFuncLookup(fakehelper.FakeMailSequence(
		func(prefix, referral string, isRef, isUniqueRef bool) (interface{}, error) {
			var rc, referralRc *fakehelper.RefCount
			rc = accRc
			if isRef {
				switch referral {
				case "sys_account_email":
					referralRc = accRc
				default:
					referralRc = fakehelper.NewRefCount()
				}
				if isUniqueRef {
					if referralRc.LastReference > referralRc.Sequence {
						return nil, fmt.Errorf("reference amounted more than available referral")
					}
					seq := referralRc.LastReference
					referralRc.LastReference += 1
					return fmt.Sprintf("%s_%d@%s", prefix, seq, domain), nil
				} else {
					return fmt.Sprintf("%s_%d@%s", prefix, rand.Intn(referralRc.Sequence), domain), nil
				}
			}
			rc.Previous = rc.Sequence
			rc.Sequence += 1
			return fmt.Sprintf("%s_%d@%s", prefix, rc.Previous, domain), nil
		},
	))
	var bsu bootstrapSurveyUser
	gofakeit.Struct(&bsu)
	return bsu
}

type bootstrapDiscoProject struct {
	NewDiscoProject []*discoRpc.NewDiscoProjectRequest `fakesize:"200" json:"new_disco_projects" yaml:"new_disco_projects"`
}

func genFakeDiscoProject(sysAccOrgRc, sysAccProjRc *fakehelper.RefCount) bootstrapDiscoProject {
	orgRc := sysAccOrgRc.ResetLastReference()
	projRc := sysAccProjRc.ResetLastReference()
	discoProjRc := fakehelper.NewRefCount()
	gofakeit.Seed(sharedConfig.CurrentTimestamp())
	gofakeit.AddFuncLookup(fakehelper.FakeNameSequence(
		func(prefix, referral string, isRef, isUniqueRef, reset bool) (interface{}, error) {
			var rc, referralRc *fakehelper.RefCount
			switch prefix {
			case "disco_project":
				rc = discoProjRc
			default:
				rc = fakehelper.NewRefCount()
			}
			if isRef {
				switch referral {
				case "sys_account_org":
					referralRc = orgRc
				case "sys_account_project":
					referralRc = projRc
				default:
					referralRc = fakehelper.NewRefCount()
				}
				if isUniqueRef {
					if referralRc.LastReference > referralRc.Sequence {
						return nil, fmt.Errorf("reference amounted more than available referral")
					}
					seq := referralRc.LastReference
					referralRc.LastReference += 1
					return fmt.Sprintf("%s_%d", prefix, seq), nil
				} else {
					return fmt.Sprintf("%s_%d", prefix, rand.Intn(referralRc.Sequence)), nil
				}
			}
			rc.Previous = rc.Sequence
			rc.Sequence += 1
			return fmt.Sprintf("%s_%d", prefix, rc.Previous), nil
		},
	))
	gofakeit.AddFuncLookup(fakehelper.FakeRandomTs())
	gofakeit.AddFuncLookup(fakehelper.FakeYtUrls())
	var bsdp bootstrapDiscoProject
	gofakeit.Struct(&bsdp)
	return bsdp
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
	return sharedConfig.MarshalPretty(b)
}

func (b *BootstrapModDisco) MarshalYAML() ([]byte, error) {
	return sharedConfig.MarshalYAML(b)
}

func BootstrapFakeData(domain string, sysAccRc, sysAccOrgRc, sysAccProjRc *fakehelper.RefCount) (*BootstrapModDisco, error) {
	// internal counter
	spRc := fakehelper.NewRefCount()
	suRc := fakehelper.NewRefCount()
	srtRc, untRc := fakehelper.NewRefCount(), fakehelper.NewRefCount()
	srvRc, unvRc := fakehelper.NewRefCount(), fakehelper.NewRefCount()
	gofakeit.Seed(sharedConfig.CurrentTimestamp())
	gofakeit.AddFuncLookup(fakehelper.FakeNameSequence(
		func(prefix, referral string, isRef, isUniqueRef, reset bool) (interface{}, error) {
			var rc, referralRc *fakehelper.RefCount
			switch prefix {
			case "survey_project":
				rc = spRc
			case "survey_user":
				rc = suRc
			case "support_role_type":
				rc = srtRc
			case "user_needs_type":
				rc = untRc
			case "support_role_value":
				rc = srvRc
			case "user_needs_value":
				rc = unvRc
			default:
				rc = fakehelper.NewRefCount()
			}
			if isRef {
				switch referral {
				case "sys_account_email":
					referralRc = sysAccRc
				case "sys_account_org":
					referralRc = sysAccOrgRc
				case "sys_account_project":
					referralRc = sysAccProjRc
				default:
					referralRc = fakehelper.NewRefCount()
				}
				if isUniqueRef {
					if referralRc.LastReference > referralRc.Sequence {
						return nil, fmt.Errorf("reference amounted more than available referral")
					}
					seq := referralRc.LastReference
					referralRc.LastReference += 1
					return fmt.Sprintf("%s_%d", prefix, seq), nil
				} else {
					return fmt.Sprintf("%s_%d", prefix, rand.Intn(referralRc.Sequence)), nil
				}
			}
			rc.Previous = rc.Sequence
			rc.Sequence += 1
			return fmt.Sprintf("%s_%d", prefix, rc.Previous), nil
		},
	))
	spRc, bsp := genFakeSurveyProject(sysAccProjRc)
	bmd := &BootstrapModDisco{
		BSP: bsp,
		BSU: genFakeSurveyUser(domain, sysAccRc, sysAccProjRc, spRc),
		BDP: genFakeDiscoProject(sysAccOrgRc, sysAccProjRc),
	}
	return bmd, nil
}

func BootstrapFromFilepath(path string) (*BootstrapModDisco, error) {
	var bmd BootstrapModDisco
	if err := fakehelper.UnmarshalFromFilepath(path, &bmd); err != nil {
		return nil, err
	}
	return &bmd, nil
}
