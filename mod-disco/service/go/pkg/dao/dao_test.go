package dao_test

import (
	"github.com/getcouragenow/mod/mod-disco/service/go/pkg/dao"
	corecfg "github.com/getcouragenow/sys/sys-core/service/go"
	coresvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	log "github.com/sirupsen/logrus"
	"testing"
)

var (
	testDb *coresvc.CoreDB
	mdb    *dao.ModDiscoDB
	err    error

	project1ID = coresvc.NewID()
	project2ID = coresvc.NewID()
	//org1ID     = coresvc.NewID()
	//org2ID     = coresvc.NewID()
	account1ID = coresvc.NewID()
	account2ID = coresvc.NewID()
)

func init() {
	var csc *corecfg.SysCoreConfig
	csc, err = corecfg.NewConfig("./testdata/syscore.yml")
	if err != nil {
		log.Fatalf("error initializing db: %v", err)
	}
	logger := log.New().WithField("test", "mod-disco")
	logger.Level = log.DebugLevel
	testDb, err = coresvc.NewCoreDB(logger, csc, nil)
	if err != nil {
		log.Fatalf("error creating CoreDB: %v", err)
	}
	log.Debug("MakeSchema testing .....")
	mdb, err = dao.NewModDiscoDB(testDb, logger)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("successfully initialize mod-disco-db:  %v", mdb)
}

func TestAll(t *testing.T) {
	t.Run("Test Survey Project Insert", testInsertSurveyProjects)
	t.Run("Test Survey Project List", testListtSurveyProjects)
	t.Run("Test Survey Project Get", testGetSurveyProject)
	t.Run("Test Survey Project Update", testUpdateSurveyProject)
	t.Run("Test Survey User Insert", testInsertSurveyUser)
	t.Run("Test Survey User List", testListSurveyUsers)
	t.Run("Test Survey User Get", testGetSurveyUser)
	t.Run("Test Survey User Update", testUpdateSurveyUser)
}
