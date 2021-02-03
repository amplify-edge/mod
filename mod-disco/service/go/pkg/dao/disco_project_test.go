package dao_test

import (
	"github.com/amplify-cms/mod/mod-disco/service/go/pkg/dao"
	sharedConfig "github.com/amplify-cms/sys-share/sys-core/service/config"

	"github.com/stretchr/testify/assert"
	"testing"

	discoRpc "github.com/amplify-cms/mod/mod-disco/service/go/rpc/v2"
)

var (
	newDiscoProjects = []*discoRpc.NewDiscoProjectRequest{
		{
			SysAccountProjectRefId: project1ID,
			SysAccountOrgRefId:     org1ID,
			Goal:                   "Distribute food to third world country",
			AlreadyPledged:         10,
			ActionTimeNano:         sharedConfig.CurrentTimestamp(),
			ActionLocation:         "Boston, MA",
			MinPioneers:            3000,
			MinRebelsMedia:         1000,
			MinRebelsToWin:         800,
			ActionLength:           "1",
			ActionType:             "NVDA",
			Category:               "Food",
			Contact:                "contact@example.com",
			HistPrecedents:         "",
			Strategy:               "Force government to lift ban on helping third-world country",
			VideoUrl:               []string{"https://some.domain.here.com"},
			UnitOfMeasures:         "days",
		},
		{
			SysAccountProjectRefId: project2ID,
			SysAccountOrgRefId:     org2ID,
			Goal:                   "Lift senate immunity law",
			AlreadyPledged:         10,
			ActionTimeNano:         sharedConfig.CurrentTimestamp(),
			ActionLocation:         "Jakarta, ID",
			MinPioneers:            3000,
			MinRebelsMedia:         1000,
			MinRebelsToWin:         800,
			ActionLength:           "1",
			ActionType:             "NVDA",
			Category:               "Legal",
			Contact:                "contact@example.com",
			HistPrecedents:         "",
			Strategy:               "Nobody is above the law, so we'll force senate to lift their own immunity",
			VideoUrl:               []string{"https://some.domain.here.com"},
			UnitOfMeasures:         "weeks",
		},
	}

	discoProjects []*discoRpc.DiscoProject
)

func testInsertDiscoProject(t *testing.T) {
	t.Log("on inserting new disco projects")
	for _, dp := range newDiscoProjects {
		discoProject, err := mdb.InsertDiscoProject(dp, nil)
		assert.NoError(t, err)
		discoProjects = append(discoProjects, discoProject)
	}
}

func testGetDiscoProject(t *testing.T) {
	t.Log("on getting disco project")
	dp, err := mdb.GetDiscoProject(map[string]interface{}{
		"project_id": discoProjects[0].ProjectId,
	})
	assert.NoError(t, err)
	assert.Equal(t, discoProjects[0].SysAccountOrgRefId, dp.SysAccountOrgRefId)
	assert.Equal(t, discoProjects[0].SysAccountProjectRefId, dp.SysAccountProjectRefId)
	assert.Equal(t, discoProjects[0].ProjectId, dp.ProjectId)
}

func testListDiscoProject(t *testing.T) {
	t.Log("on listing disco project")
	listDiscoProjects, _, err := mdb.ListDiscoProject(map[string]interface{}{}, dao.DefaultCursor, dao.DefaultLimit, 0)
	assert.NoError(t, err)
	assert.Equal(t, len(discoProjects), len(listDiscoProjects))
}

func testUpdateDiscoProject(t *testing.T) {
	t.Log("on updating disco project")
	updReq := &discoRpc.UpdateDiscoProjectRequest{
		ProjectId:      discoProjects[0].ProjectId,
		Goal:           "Yay",
		AlreadyPledged: 0,
		ActionTime:     nil,
		ActionLocation: "",
		MinPioneers:    0,
		MinRebelsMedia: 0,
		MinRebelsToWin: 0,
		ActionLength:   "",
		ActionType:     "",
		Category:       "",
		Contact:        "",
		HistPrecedents: "",
		Strategy:       "",
		VideoUrl:       "",
		UnitOfMeasures: "",
	}
	err = mdb.UpdateDiscoProject(updReq)
	assert.NoError(t, err)
	dp, err := mdb.GetDiscoProject(map[string]interface{}{"project_id": updReq.ProjectId})
	assert.NoError(t, err)
	assert.Equal(t, updReq.Goal, dp.Goal)
	assert.NotEqual(t, "", dp.ActionLocation)
}

func testDeleteDiscoProject(t *testing.T) {
	err = mdb.DeleteDiscoProject(discoProjects[0].ProjectId, "", "")
	assert.NoError(t, err)
	_, err = mdb.GetDiscoProject(map[string]interface{}{"project_id": discoProjects[0].ProjectId})
	assert.Error(t, err)
	assert.Equal(t, "document not found", err.Error())
}
