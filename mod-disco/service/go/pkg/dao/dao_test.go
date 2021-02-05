package dao_test

import (
	"go.amplifyedge.org/mod-v2/mod-disco/service/go/pkg/fakedata"
	sharedConfig "go.amplifyedge.org/sys-share-v2/sys-core/service/config"
	"go.amplifyedge.org/sys-share-v2/sys-core/service/logging/zaplog"

	"github.com/stretchr/testify/assert"
	"testing"

	"go.amplifyedge.org/mod-v2/mod-disco/service/go/pkg/dao"
	corecfg "go.amplifyedge.org/sys-v2/sys-core/service/go"
	coresvc "go.amplifyedge.org/sys-v2/sys-core/service/go/pkg/coredb"
)

var (
	testDb *coresvc.CoreDB
	mdb    *dao.ModDiscoDB
	err    error

	project1ID    = sharedConfig.NewID()
	project2ID    = sharedConfig.NewID()
	org1ID        = sharedConfig.NewID()
	org2ID        = sharedConfig.NewID()
	sysProjectIds []string
	sysAccountIds []string
)

func init() {
	logger := zaplog.NewZapLogger(zaplog.DEBUG, "mod-disco-dao-test", true, "./testdata/gcn.log")
	logger.InitLogger(nil)

	var csc *corecfg.SysCoreConfig
	csc, err = corecfg.NewConfig("./testdata/syscore.yml")
	if err != nil {
		logger.Fatalf("error initializing db: %v", err)
	}

	testDb, err = coresvc.NewCoreDB(logger, &csc.SysCoreConfig, nil)
	if err != nil {
		logger.Fatalf("error creating CoreDB: %v", err)
	}
	logger.Debug("MakeSchema testing .....")
	mdb, err = dao.NewModDiscoDB(testDb, logger)
	if err != nil {
		logger.Fatal(err)
	}
	logger.Infof("successfully initialize mod-disco-db:  %v", mdb)
	bmd, err := fakedata.BootstrapFromFilepath("./testdata/bs-mod-disco.json")
	if err != nil {
		logger.Fatalf("unable to unmarshal bs-mod-disco.json => %v", err)
	}
	newSurveyProjects = bmd.GetSurveyProjects()
	for _, nsp := range newSurveyProjects {
		pid := sharedConfig.NewID()
		sysProjectIds = append(sysProjectIds, pid)
		nsp.SysAccountProjectRefId = pid
	}
	newSurveyUsers = bmd.GetSurveyUsers()
	for _, nsu := range newSurveyUsers {
		uid := sharedConfig.NewID()
		sysAccountIds = append(sysAccountIds, uid)
		nsu.SysAccountUserRefId = uid
	}
}

func TestAll(t *testing.T) {
	t.Run("Test Survey Project Insert", testInsertSurveyProjects)
	t.Run("Test Survey Project List", testListSurveyProjects)
	t.Run("Test Survey Project Get", testGetSurveyProject)
	t.Run("Test Survey Project Update", testUpdateSurveyProject)
	t.Run("Test Survey User Insert", testInsertSurveyUser)
	t.Run("Test Survey User List", testListSurveyUsers)
	t.Run("Test Survey User Get", testGetSurveyUser)
	t.Run("Test Disco Project Insert", testInsertDiscoProject)
	t.Run("Test Disco Project Get", testGetDiscoProject)
	t.Run("Test Disco Project List", testListDiscoProject)
	t.Run("Test Disco Project Update", testUpdateDiscoProject)
	t.Run("Test Disco Project Delete", testDeleteDiscoProject)
	t.Run("Test Survey User Update", testUpdateSurveyUser)
	t.Run("Test Counting Lawyers", testCountLawyers)
	t.Run("Test Survey Project Delete", testDeleteSurveyProject)
}

func testCountLawyers(t *testing.T) {
	lawyers, err := mdb.CountRecords()
	assert.NoError(t, err)
	t.Logf("Lawyers: %v", lawyers)
}
