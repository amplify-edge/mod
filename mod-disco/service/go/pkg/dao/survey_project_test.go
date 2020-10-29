package dao_test

import (
	"github.com/getcouragenow/mod/mod-disco/service/go/pkg/dao"
	coresvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	"github.com/segmentio/encoding/json"
	"io/ioutil"
	"testing"

	"github.com/stretchr/testify/assert"

	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
)

var (
	newSurveyProjects = []*discoRpc.NewSurveyProjectRequest{
		{
			SysAccountProjectRefId: project1ID,
			SurveySchemaTypes:      []byte{},
			SurveyFilterTypes:      []byte{},
		},
		{
			SysAccountProjectRefId: project2ID,
			SurveySchemaTypes:      []byte{},
			SurveyFilterTypes:      []byte{},
		},
		{
			SysAccountProjectRefId: coresvc.NewID(),
			SurveySchemaTypes:      []byte{},
			SurveyFilterTypes:      []byte{},
		},
	}

	surveyProjects []*discoRpc.SurveyProject
	surveyUsers    []*discoRpc.SurveyUser
)

func testInsertSurveyProjects(t *testing.T) {
	t.Log("on inserting survey projects")
	for _, newSurveyProject := range newSurveyProjects {
		_, err = mdb.InsertSurveyProject(newSurveyProject)
		assert.NoError(t, err)
	}
}

func testListtSurveyProjects(t *testing.T) {
	t.Log("on listing survey projects")
	sps, _, err := mdb.ListSurveyProject(map[string]interface{}{}, dao.DefaultCursor, 10, 0)
	assert.NoError(t, err)
	for _, sp := range sps {
		surveyProject, err := sp.ToPkgSurveyProject()
		assert.NoError(t, err)
		surveyProjects = append(surveyProjects, surveyProject)
	}
	assert.Equal(t, 3, len(surveyProjects))
	t.Logf("\n Survey Projects: %v\n", surveyProjects)
}

func testGetSurveyProject(t *testing.T) {
	t.Log("on getting survey projects")
	sp, err := mdb.GetSurveyProject(map[string]interface{}{"sys_account_project_ref_id": project2ID})
	assert.NoError(t, err)
	assert.Equal(t, newSurveyProjects[1].SysAccountProjectRefId, sp.SysAccountProjectRefId)
}

func testUpdateSurveyProject(t *testing.T) {
	f, err := ioutil.ReadFile("testdata/test_update_survey_proj.json")
	assert.NoError(t, err)
	var sfilter dao.SurveyFilter
	assert.NoError(t, json.Unmarshal(f, &sfilter))
	condBytes, err := json.Marshal(&sfilter)
	assert.NoError(t, err)
	t.Logf(string(condBytes))
	updateSurveyProjects := []*discoRpc.UpdateSurveyProjectRequest{
		{
			SurveyProjectId:   surveyProjects[0].SurveyProjectId,
			SurveySchemaTypes: nil,
			SurveyFilterTypes: condBytes,
		},
	}
	for _, usp := range updateSurveyProjects {
		err = mdb.UpdateSurveyProject(usp)
		assert.NoError(t, err)
	}
	sp, err := mdb.GetSurveyProject(map[string]interface{}{"survey_project_id": surveyProjects[0].SurveyProjectId})
	assert.NoError(t, err)
	t.Logf("Survey Project: %v", sp)
	// assert.Equal(t, sp.SurveyFilterTypes, cond)
}

func testDeleteSurveyProject(t *testing.T) {
	err = mdb.DeleteSurveyProject(surveyProjects[0].SurveyProjectId)
	assert.NoError(t, err)
	_, err = mdb.GetSurveyProject(map[string]interface{}{"survey_project_id": surveyProjects[0].SurveyProjectId})
	assert.Error(t, err)
	assert.Equal(t, "document not found", err.Error())
}

func testInsertSurveyUser(t *testing.T) {
	newSurveyUsers := []*discoRpc.NewSurveyUserRequest{
		{
			SurveyProjectRefId:  surveyProjects[0].SurveyProjectId,
			SysAccountUserRefId: account1ID,
			SurveySchemaTypes:   []byte{},
			SurveyFilterTypes:   []byte{},
		},
		{
			SurveyProjectRefId:  surveyProjects[1].SurveyProjectId,
			SysAccountUserRefId: account2ID,
			SurveySchemaTypes:   nil,
			SurveyFilterTypes:   nil,
		},
	}
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
		surveyUser, err := sp.ToPkgSurveyUser()
		assert.NoError(t, err)
		surveyUsers = append(surveyUsers, surveyUser)
	}
	assert.Equal(t, 2, len(surveyUsers))
	t.Logf("\n Survey Users: %v\n", surveyUsers)
}

func testGetSurveyUser(t *testing.T) {
	t.Log("on getting survey users")
	sp, err := mdb.GetSurveyUser(map[string]interface{}{"sys_account_account_ref_id": account1ID})
	assert.NoError(t, err)
	assert.Equal(t, account1ID, sp.SysAccountAccountRefId)
}

func testUpdateSurveyUser(t *testing.T) {
	f, err := ioutil.ReadFile("testdata/test_update_survey_user.json")
	assert.NoError(t, err)
	var sfilter dao.SurveyFilter
	assert.NoError(t, json.Unmarshal(f, &sfilter))
	condBytes, err := json.Marshal(&sfilter)
	assert.NoError(t, err)
	t.Logf(string(condBytes))
	updateSurveyUsers := []*discoRpc.UpdateSurveyUserRequest{
		{
			SurveyUserId:       surveyUsers[0].SurveyUserId,
			SurveySchemaValues: condBytes,
			SurveyFilterValues: condBytes,
		},
	}
	for _, usp := range updateSurveyUsers {
		err = mdb.UpdateSurveyUser(usp)
		assert.NoError(t, err)
	}
	sp, err := mdb.GetSurveyUser(map[string]interface{}{"survey_user_id": surveyUsers[0].SurveyUserId})
	assert.NoError(t, err)
	t.Logf("Survey User: %v", *sp)
	pkgSurveyUser, err := sp.ToPkgSurveyUser()
	assert.NoError(t, err)
	assert.Equal(t, condBytes, pkgSurveyUser.SurveySchemaFilters)
}
