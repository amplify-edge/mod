package dao

import (
	"fmt"
	sq "github.com/Masterminds/squirrel"
	"github.com/genjidb/genji/document"
	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sharedConfig "github.com/getcouragenow/sys-share/sys-core/service/config"
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	log "github.com/sirupsen/logrus"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type SurveyUser struct {
	SurveyUserId           string                 `json:"surveyUserId" genji:"survey_user_id"`
	SurveyProjectRefId     string                 `json:"surveyProjectRefId" genji:"survey_project_ref_id"`
	SysAccountAccountRefId string                 `json:"sysAccountAccountRefId" genji:"sys_account_account_ref_id"`
	SurveySchemaValues     map[string]interface{} `json:"surveySchemaValues" genji:"survey_schema_values"`
	SurveySchemaFilters    map[string]interface{} `json:"surveySchemaFilters" genji:"survey_schema_filters"`
	CreatedAt              int64                  `json:"createdAt" genji:"created_at"`
	UpdatedAt              int64                  `json:"updatedAt" genji:"updated_at"`
}

func (m *ModDiscoDB) FromPkgSurveyUser(sp *discoRpc.SurveyUser) (*SurveyUser, error) {
	var err error
	schemaValues := map[string]interface{}{}
	if sp.SurveySchemaValues != nil && len(sp.SurveySchemaValues) != 0 {
		schemaValues, err = sysCoreSvc.UnmarshalToMap(sp.SurveySchemaValues)
		if err != nil {
			return nil, err
		}
	}
	sfilter := map[string]interface{}{}
	if sp.SurveySchemaFilters != nil && len(sp.SurveySchemaFilters) != 0 {
		sfilter, err = sysCoreSvc.UnmarshalToMap(sp.SurveySchemaFilters)
		if err != nil {
			return nil, err
		}
	}
	surveyUserId := sp.SurveyUserId
	if surveyUserId == "" {
		surveyUserId = sysCoreSvc.NewID()
	}
	return &SurveyUser{
		SurveyUserId:           surveyUserId,
		SurveyProjectRefId:     sp.SurveyProjectRefId,
		SysAccountAccountRefId: sp.SysAccountAccountRefId,
		SurveySchemaValues:     schemaValues,
		SurveySchemaFilters:    sfilter,
		CreatedAt:              sp.CreatedAt.Seconds,
		UpdatedAt:              sp.UpdatedAt.Seconds,
	}, nil
}

func (sp *SurveyUser) ToPkgSurveyUser() (*discoRpc.SurveyUser, error) {
	var surveyFilterBytes, schemaValuesBytes []byte
	var err error
	if sp.SurveySchemaFilters != nil && len(sp.SurveySchemaFilters) != 0 {
		surveyFilterBytes, err = sysCoreSvc.MarshalToBytes(sp.SurveySchemaFilters)
		if err != nil {
			return nil, err
		}
		fmt.Printf("SURVEY FILTER BYTES: %s", string(surveyFilterBytes))
	}
	if sp.SurveySchemaValues != nil && len(sp.SurveySchemaValues) != 0 {
		schemaValuesBytes, err = sysCoreSvc.MarshalToBytes(sp.SurveySchemaValues)
		if err != nil {
			return nil, err
		}
		fmt.Printf("SURVEY SCHEMA VALUE BYTES: %s", string(surveyFilterBytes))
	}
	return &discoRpc.SurveyUser{
		SurveyUserId:           sp.SurveyUserId,
		SurveyProjectRefId:     sp.SurveyProjectRefId,
		SysAccountAccountRefId: sp.SysAccountAccountRefId,
		SurveySchemaValues:     schemaValuesBytes,
		SurveySchemaFilters:    surveyFilterBytes,
		CreatedAt:              sharedConfig.UnixToUtcTS(sp.CreatedAt),
		UpdatedAt:              sharedConfig.UnixToUtcTS(sp.UpdatedAt),
	}, nil
}

func (sp SurveyUser) CreateSQL() []string {
	fields := initFields(SurveyUsersColumns, SurveyUsersColumnsType)
	tbl := sysCoreSvc.NewTable(SurveyUsersTableName, fields, []string{})
	return tbl.CreateTable()
}

func (m *ModDiscoDB) SurveyUserQueryFilter(filter map[string]interface{}) sq.SelectBuilder {
	baseStmt := sq.Select(SurveyUsersColumns).From(SurveyUsersTableName)
	if filter != nil {
		for k, v := range filter {
			baseStmt = baseStmt.Where(sq.Eq{k: v})
		}
	}
	return baseStmt
}

func (m *ModDiscoDB) GetSurveyUser(filters map[string]interface{}) (*SurveyUser, error) {
	var sp SurveyUser
	selectStmt, args, err := m.SurveyUserQueryFilter(filters).ToSql()
	if err != nil {
		return nil, err
	}
	doc, err := m.db.QueryOne(selectStmt, args...)
	if err != nil {
		return nil, err
	}
	m.log.WithFields(log.Fields{
		"queryStatement": selectStmt,
		"arguments":      args,
	}).Debugf("GetSurveyUser %s", SurveyUsersTableName)
	err = doc.StructScan(&sp)
	if err != nil {
		return nil, err
	}
	return &sp, nil
}

func (m *ModDiscoDB) ListSurveyUser(filters map[string]interface{}, orderBy string, limit, cursor int64) ([]*SurveyUser, *int64, error) {
	var surveyUsers []*SurveyUser
	baseStmt := m.SurveyUserQueryFilter(filters)
	selectStmt, args, err := m.listSelectStatement(baseStmt, orderBy, limit, &cursor)
	if err != nil {
		return nil, nil, err
	}
	res, err := m.db.Query(selectStmt, args...)
	if err != nil {
		return nil, nil, err
	}
	err = res.Iterate(func(d document.Document) error {
		var surveyUser SurveyUser
		if err = document.StructScan(d, &surveyUser); err != nil {
			return err
		}
		surveyUsers = append(surveyUsers, &surveyUser)
		return nil
	})
	if err != nil {
		return nil, nil, err
	}
	return surveyUsers, &surveyUsers[len(surveyUsers)-1].CreatedAt, nil
}

func (m *ModDiscoDB) InsertSurveyUser(sp *discoRpc.NewSurveyUserRequest) (*discoRpc.SurveyUser, error) {
	newPkgSurveyUser := &discoRpc.SurveyUser{
		SurveyUserId:           sysCoreSvc.NewID(),
		SysAccountAccountRefId: sp.SysAccountUserRefId,
		SurveyProjectRefId:     sp.SurveyProjectRefId,
		SurveySchemaValues:     sp.SurveySchemaTypes,
		SurveySchemaFilters:    sp.SurveyFilterTypes,
		CreatedAt:              timestamppb.Now(),
		UpdatedAt:              timestamppb.Now(),
	}
	sproj, err := m.FromPkgSurveyUser(newPkgSurveyUser)
	if err != nil {
		return nil, err
	}
	queryParam, err := sysCoreSvc.AnyToQueryParam(sproj, true)
	if err != nil {
		return nil, err
	}
	columns, values := queryParam.ColumnsAndValues()
	if len(columns) != len(values) {
		return nil, fmt.Errorf("error: length mismatch: cols: %d, vals: %d", len(columns), len(values))
	}
	stmt, args, err := sq.Insert(SurveyUsersTableName).
		Columns(columns...).
		Values(values...).
		ToSql()
	if err != nil {
		return nil, err
	}
	m.log.WithFields(log.Fields{
		"statement": stmt,
		"args":      args,
	}).Debugf("insert to %s table", SurveyUsersTableName)
	err = m.db.Exec(stmt, args...)
	if err != nil {
		return nil, err
	}
	daoSurvey, err := m.GetSurveyUser(map[string]interface{}{"survey_user_id": newPkgSurveyUser.SurveyUserId})
	if err != nil {
		return nil, err
	}
	surveyUser, err := daoSurvey.ToPkgSurveyUser()
	if err != nil {
		return nil, err
	}
	return surveyUser, nil
}

func (m *ModDiscoDB) UpdateSurveyUser(usp *discoRpc.UpdateSurveyUserRequest) error {
	sp, err := m.GetSurveyUser(map[string]interface{}{"survey_user_id": usp.SurveyUserId})
	if err != nil {
		return err
	}
	if usp.SurveySchemaValues != nil {
		schemaValues, err := sysCoreSvc.UnmarshalToMap(usp.SurveySchemaValues)
		if err != nil {
			return err
		}
		sp.SurveySchemaValues = schemaValues
	}
	if usp.SurveyFilterValues != nil {
		sfilter, err := sysCoreSvc.UnmarshalToMap(usp.SurveyFilterValues)
		if err != nil {
			return err
		}
		sp.SurveySchemaFilters = sfilter
	}
	filterParam, err := sysCoreSvc.AnyToQueryParam(sp, true)
	if err != nil {
		return err
	}
	delete(filterParam.Params, "survey_user_id")
	delete(filterParam.Params, "sys_account_account_ref_id")
	delete(filterParam.Params, "updated_at")
	filterParam.Params["updated_at"] = sysCoreSvc.CurrentTimestamp()
	stmt, args, err := sq.Update(SurveyUsersTableName).SetMap(filterParam.Params).
		Where(sq.Eq{"survey_user_id": sp.SurveyUserId}).ToSql()
	if err != nil {
		return err
	}
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) DeleteSurveyUser(id string) error {
	stmt, args, err := sq.Delete(SurveyUsersTableName).Where("survey_project_id = ?", id).ToSql()
	if err != nil {
		return err
	}
	return m.db.BulkExec(map[string][]interface{}{
		stmt: args,
	})
}
