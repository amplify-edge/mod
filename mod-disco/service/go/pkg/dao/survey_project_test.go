package dao_test

import (
	"github.com/getcouragenow/mod/mod-disco/service/go/pkg/dao"
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
			SysAccountProjectRefId: project1ID,
			SurveySchemaTypes:      []byte{},
			SurveyFilterTypes:      []byte{},
		},
	}

	surveyProjects []*discoRpc.SurveyProject
	// surveyUsers    = []*discoRpc.NewSurveyUserRequest{
	// 	{
	// 		SurveyProjectRefId:  surveyProjects[0].SurveyProjectId,
	// 		SysAccountUserRefId: account1ID,
	// 		SurveySchemaTypes:   []byte{},
	// 		SurveyFilterTypes:   []byte{},
	// 	},
	// 	{
	// 		SurveyProjectRefId:  surveyProjects[1].SurveyProjectId,
	// 		SysAccountUserRefId: account2ID,
	// 		SurveySchemaTypes:   nil,
	// 		SurveyFilterTypes:   nil,
	// 	},
	// }
)

func testInsertSurveyProjects(t *testing.T) {
	t.Log("on inserting survey projects")
	for _, newSurveyProject := range newSurveyProjects {
		err = mdb.InsertSurveyProject(newSurveyProject)
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
}
