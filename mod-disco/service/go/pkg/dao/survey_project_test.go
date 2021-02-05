package dao_test

import (
	"go.amplifyedge.org/mod-v2/mod-disco/service/go/pkg/dao"
	"github.com/segmentio/encoding/json"
	"io/ioutil"
	"testing"

	"github.com/stretchr/testify/assert"

	discoRpc "go.amplifyedge.org/mod-v2/mod-disco/service/go/rpc/v2"
)

var (
	newSurveyProjects []*discoRpc.NewSurveyProjectRequest
	newSurveyUsers    []*discoRpc.NewSurveyUserRequest
	surveyProjects    []*discoRpc.SurveyProject
	surveyUsers       []*discoRpc.SurveyUser
)

func testInsertSurveyProjects(t *testing.T) {
	t.Log("on inserting survey projects")
	for _, newSurveyProject := range newSurveyProjects {
		_, err = mdb.InsertSurveyProject(newSurveyProject)
		assert.NoError(t, err)
	}
}

func testListSurveyProjects(t *testing.T) {
	t.Log("on listing survey projects")
	sps, _, err := mdb.ListSurveyProject(map[string]interface{}{}, dao.DefaultCursor, 10, 0)
	assert.NoError(t, err)
	for _, sp := range sps {
		surveyProject, err := mdb.ToPkgSurveyProject(sp)
		assert.NoError(t, err)
		surveyProjects = append(surveyProjects, surveyProject)
	}
	assert.Equal(t, 3, len(surveyProjects))
	t.Logf("\n Survey Projects: %v\n", surveyProjects)
}

func testGetSurveyProject(t *testing.T) {
	t.Log("on getting survey projects")
	sp, err := mdb.GetSurveyProject(map[string]interface{}{"sys_account_project_ref_id": sysProjectIds[0]})
	assert.NoError(t, err)
	t.Log(sp)
}

func testUpdateSurveyProject(t *testing.T) {
	f, err := ioutil.ReadFile("testdata/test_update_survey_proj.json")
	assert.NoError(t, err)
	var sroletype discoRpc.SupportRoleType
	assert.NoError(t, json.Unmarshal(f, &sroletype))
	sroletype.SurveyProjectRefId = surveyProjects[0].SurveyProjectId
	updateSurveyProjects := []*discoRpc.UpdateSurveyProjectRequest{
		{
			SurveyProjectId:  surveyProjects[0].SurveyProjectId,
			SupportRoleTypes: []*discoRpc.SupportRoleType{&sroletype},
		},
	}
	for _, usp := range updateSurveyProjects {
		err = mdb.UpdateSurveyProject(usp)
		assert.NoError(t, err)
	}
	sp, err := mdb.GetSurveyProject(map[string]interface{}{"survey_project_id": surveyProjects[0].SurveyProjectId})
	assert.NoError(t, err)
	t.Logf("Survey Project: %v", sp)
	surveyProject, err := mdb.ToPkgSurveyProject(sp)
	assert.NoError(t, err)
	t.Logf("Survey Project Becomes: %v", surveyProject)
	// assert.Equal(t, [][]byte{condBytes}, surveyProject.SupportRoleTypes)
}

func testDeleteSurveyProject(t *testing.T) {
	err = mdb.DeleteSurveyProject(surveyProjects[0].SurveyProjectId)
	assert.NoError(t, err)
	_, err = mdb.GetSurveyProject(map[string]interface{}{"survey_project_id": surveyProjects[0].SurveyProjectId})
	assert.Error(t, err)
	assert.Equal(t, "document not found", err.Error())
}

func testInsertSurveyUser(t *testing.T) {
	for _, nsu := range newSurveyUsers {
		_, err = mdb.InsertSurveyUser(nsu)
		assert.NoError(t, err)
	}
}

func testListSurveyUsers(t *testing.T) {
	t.Log("on listing survey users")
	sps, _, err := mdb.ListSurveyUser(map[string]interface{}{}, dao.DefaultCursor, 10, 0)
	assert.NoError(t, err)
	for _, sp := range sps {
		surveyUser, err := mdb.ToPkgSurveyUser(sp)
		assert.NoError(t, err)
		surveyUsers = append(surveyUsers, surveyUser)
	}
	assert.Equal(t, 2, len(surveyUsers))
	t.Logf("\n Survey Users: %v\n", surveyUsers)
}

func testGetSurveyUser(t *testing.T) {
	t.Log("on getting survey users")
	sp, err := mdb.GetSurveyUser(map[string]interface{}{"sys_account_account_ref_id": sysAccountIds[0]})
	assert.NoError(t, err)
	assert.Equal(t, sysAccountIds[0], sp.SysAccountAccountRefId)
}

func testUpdateSurveyUser(t *testing.T) {
	f, err := ioutil.ReadFile("testdata/test_update_survey_user.json")
	assert.NoError(t, err)
	var sfilter discoRpc.SupportRoleValue
	assert.NoError(t, json.Unmarshal(f, &sfilter))
	updateSurveyUsers := []*discoRpc.UpdateSurveyUserRequest{
		{
			SurveyUserId:      surveyUsers[0].SurveyUserId,
			SupportRoleValues: []*discoRpc.SupportRoleValue{&sfilter},
		},
	}
	for _, usp := range updateSurveyUsers {
		err = mdb.UpdateSurveyUser(usp)
		assert.NoError(t, err)
	}
	sp, err := mdb.GetSurveyUser(map[string]interface{}{"survey_user_id": surveyUsers[0].SurveyUserId})
	assert.NoError(t, err)
	t.Logf("Survey User: %v", *sp)
	pkgSurveyUser, err := mdb.ToPkgSurveyUser(sp)
	assert.NoError(t, err)
	t.Logf("Survey User becomes: %v\n", pkgSurveyUser)
	// assert.Equal(t, string(condBytesArray), string(pkgSurveyUser.SupportRoleValues))
}
