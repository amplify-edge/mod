package dao

import (
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	log "github.com/sirupsen/logrus"
	"strings"
)

type ModDiscoDB struct {
	db                      *sysCoreSvc.CoreDB
	log                     *log.Entry
	surveyProjectColumns    string
	surveyUserColumns       string
	discoProjectColumns     string
	supportRoleTypeColumns  string
	supportRoleValueColumns string
	userNeedTypeColumns     string
	userNeedValueColumns    string
}

func NewModDiscoDB(db *sysCoreSvc.CoreDB, l *log.Entry) (*ModDiscoDB, error) {
	spColumns := sysCoreSvc.GetStructColumns(SurveyProject{})
	suColumns := sysCoreSvc.GetStructColumns(SurveyUser{})
	dpColumns := sysCoreSvc.GetStructColumns(DiscoProject{})
	srtColumns := sysCoreSvc.GetStructColumns(SupportRoleType{})
	untCols := sysCoreSvc.GetStructColumns(UserNeedsType{})
	srvCols := sysCoreSvc.GetStructColumns(SupportRoleValue{})
	unvCols := sysCoreSvc.GetStructColumns(UserNeedsValue{})
	err := db.RegisterModels(map[string]sysCoreSvc.DbModel{
		SurveyProjectTableName: SurveyProject{},
		SurveyUsersTableName:   SurveyUser{},
		DiscoProjectTableName:  DiscoProject{},
		SupportRoleTypesTable:  SupportRoleType{},
		UserNeedTypesTable:     UserNeedsType{},
		SupportRoleValuesTable: SupportRoleValue{},
		UserNeedValuesTable:    UserNeedsValue{},
	})
	l.Debug("Registered models")
	if err != nil {
		return nil, err
	}
	l.Debug("Making mod-disco schema")
	if err = db.MakeSchema(); err != nil {
		return nil, err
	}
	return &ModDiscoDB{
		db:                      db,
		log:                     l,
		surveyProjectColumns:    spColumns,
		discoProjectColumns:     dpColumns,
		surveyUserColumns:       suColumns,
		supportRoleTypeColumns:  srtColumns,
		userNeedTypeColumns:     untCols,
		supportRoleValueColumns: srvCols,
		userNeedValueColumns:    unvCols,
	}, nil
}

func (m *ModDiscoDB) BuildSearchQuery(qs string) string {
	var sb strings.Builder
	sb.WriteString("%")
	sb.WriteString(qs)
	sb.WriteString("%")
	return sb.String()
}
