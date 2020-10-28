package dao

import (
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	log "github.com/sirupsen/logrus"
	"strings"
)

type ModDiscoDB struct {
	db  *sysCoreSvc.CoreDB
	log *log.Entry
}

func NewModDiscoDB(db *sysCoreSvc.CoreDB, l *log.Entry) (*ModDiscoDB, error) {
	err := db.RegisterModels(map[string]sysCoreSvc.DbModel{
		SurveyProjectTableName: SurveyProject{},
		SurveyUsersTableName:   SurveyUser{},
	})
	if err != nil {
		return nil, err
	}
	if err = db.MakeSchema(); err != nil {
		return nil, err
	}
	return &ModDiscoDB{
		db:  db,
		log: l,
	}, nil
}

func (m *ModDiscoDB) BuildSearchQuery(qs string) string {
	var sb strings.Builder
	sb.WriteString("%s")
	sb.WriteString(qs)
	sb.WriteString("%s")
	return sb.String()
}
