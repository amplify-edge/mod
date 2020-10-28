package dao

import (
	"fmt"
	sq "github.com/Masterminds/squirrel"
	"github.com/genjidb/genji/document"
	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sharedConfig "github.com/getcouragenow/sys-share/sys-core/service/config"
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	"github.com/segmentio/encoding/json"
	log "github.com/sirupsen/logrus"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type SurveyProject struct {
	SurveyProjectId        string                 `json:"surveyProjectId" genji:"survey_project_id"`
	SysAccountProjectRefId string                 `json:"sysAccountProjectRefId" genji:"sys_account_project_ref_id"`
	SurveySchemaTypes      map[string]interface{} `json:"surveySchemaTypes" genji:"survey_schema_types"`
	SurveyFilterTypes      SurveyFilter           `json:"surveyFilterTypes" genji:"survey_filter_types"`
	CreatedAt              int64                  `json:"createdAt" genji:"created_at"`
	UpdatedAt              int64                  `json:"updatedAt" genji:"updated_at"`
}

type SurveyFilter struct {
	Conditions   map[string]string      `json:"conditions,omitempty"`
	SupportRoles map[string][]string    `json:"supportRoles,omitempty"`
	Others       map[string]interface{} `json:"others,omitempty"`
}

var (
	surveyProjectUniqueIndex = fmt.Sprintf("CREATE UNIQUE INDEX IF NOT EXISTS idx_%s_sys_account_ref ON %s(sys_account_project_ref_id)", SurveyProjectTableName, SurveyProjectTableName)
)

func (m *ModDiscoDB) FromPkgSurveyProject(sp *discoRpc.SurveyProject) (*SurveyProject, error) {
	var err error
	schemaType := map[string]interface{}{}
	if sp.SurveySchemaTypes != nil && len(sp.SurveySchemaTypes) != 0 {
		schemaType, err = sysCoreSvc.UnmarshalToMap(sp.SurveySchemaTypes)
		if err != nil {
			return nil, err
		}
	}
	sfilter := SurveyFilter{}
	if sp.SurveyFilterTypes != nil && len(sp.SurveyFilterTypes) != 0 {
		err = json.Unmarshal(sp.SurveyFilterTypes, &sfilter)
		if err != nil {
			return nil, err
		}
	}
	surveyProjectId := sp.SurveyProjectId
	if surveyProjectId == "" {
		surveyProjectId = sysCoreSvc.NewID()
	}
	return &SurveyProject{
		SurveyProjectId:        surveyProjectId,
		SysAccountProjectRefId: sp.SysAccountProjectRefId,
		SurveySchemaTypes:      schemaType,
		SurveyFilterTypes:      sfilter,
		CreatedAt:              sp.CreatedAt.Seconds,
		UpdatedAt:              sp.UpdatedAt.Seconds,
	}, nil
}

func (sp *SurveyProject) ToPkgSurveyProject() (*discoRpc.SurveyProject, error) {
	surveyFilterTypeBytes, err := sysCoreSvc.MarshalToBytes(sp.SurveyFilterTypes)
	if err != nil {
		return nil, err
	}
	schemaTypeBytes, err := sysCoreSvc.MarshalToBytes(sp.SurveySchemaTypes)
	if err != nil {
		return nil, err
	}
	return &discoRpc.SurveyProject{
		SurveyProjectId:        sp.SurveyProjectId,
		SysAccountProjectRefId: sp.SysAccountProjectRefId,
		SurveySchemaTypes:      schemaTypeBytes,
		SurveyFilterTypes:      surveyFilterTypeBytes,
		CreatedAt:              sharedConfig.UnixToUtcTS(sp.CreatedAt),
		UpdatedAt:              sharedConfig.UnixToUtcTS(sp.UpdatedAt),
	}, nil
}

func (sp SurveyProject) CreateSQL() []string {
	fields := initFields(SurveyProjectColumns, SurveyProjectColumnsType)
	tbl := sysCoreSvc.NewTable(SurveyProjectTableName, fields, []string{surveyProjectUniqueIndex})
	return tbl.CreateTable()
}

func (m *ModDiscoDB) surveyProjectQueryFilter(filter map[string]interface{}) sq.SelectBuilder {
	baseStmt := sq.Select(SurveyProjectColumns).From(SurveyProjectTableName)
	if filter != nil {
		for k, v := range filter {
			baseStmt = baseStmt.Where(sq.Eq{k: v})
		}
	}
	return baseStmt
}

func (m *ModDiscoDB) GetSurveyProject(filters map[string]interface{}) (*SurveyProject, error) {
	var sp SurveyProject
	selectStmt, args, err := m.surveyProjectQueryFilter(filters).ToSql()
	if err != nil {
		return nil, err
	}
	m.log.WithFields(log.Fields{
		"queryStatement": selectStmt,
		"arguments":      args,
	}).Debugf("GetSurveyProject %s", SurveyProjectTableName)
	doc, err := m.db.Query(selectStmt, args...)
	if err != nil {
		return nil, err
	}
	d, err := doc.First()
	if err != nil {
		return nil, err
	}
	if err = document.StructScan(d, &sp); err != nil {
		return nil, err
	}
	return &sp, nil
}

func (m *ModDiscoDB) ListSurveyProject(filters map[string]interface{}, orderBy string, limit, cursor int64) ([]*SurveyProject, *int64, error) {
	var surveyProjects []*SurveyProject
	baseStmt := m.surveyProjectQueryFilter(filters)
	selectStmt, args, err := m.listSelectStatement(baseStmt, orderBy, limit, &cursor)
	if err != nil {
		return nil, nil, err
	}
	res, err := m.db.Query(selectStmt, args...)
	if err != nil {
		return nil, nil, err
	}
	err = res.Iterate(func(d document.Document) error {
		var surveyProject SurveyProject
		if err = document.StructScan(d, &surveyProject); err != nil {
			return err
		}
		surveyProjects = append(surveyProjects, &surveyProject)
		return nil
	})
	if err != nil {
		return nil, nil, err
	}
	return surveyProjects, &surveyProjects[len(surveyProjects)-1].CreatedAt, nil
}

func (m *ModDiscoDB) InsertSurveyProject(sp *discoRpc.NewSurveyProjectRequest) error {
	newPkgSurveyProject := &discoRpc.SurveyProject{
		SurveyProjectId:        sysCoreSvc.NewID(),
		SysAccountProjectRefId: sp.SysAccountProjectRefId,
		SurveySchemaTypes:      sp.SurveySchemaTypes,
		SurveyFilterTypes:      sp.SurveyFilterTypes,
		CreatedAt:              timestamppb.Now(),
		UpdatedAt:              timestamppb.Now(),
	}
	sproj, err := m.FromPkgSurveyProject(newPkgSurveyProject)
	if err != nil {
		return err
	}
	queryParam, err := sysCoreSvc.AnyToQueryParam(sproj, true)
	if err != nil {
		return err
	}
	columns, values := queryParam.ColumnsAndValues()
	if len(columns) != len(values) {
		return fmt.Errorf("error: length mismatch: cols: %d, vals: %d", len(columns), len(values))
	}
	stmt, args, err := sq.Insert(SurveyProjectTableName).
		Columns(columns...).
		Values(values...).
		ToSql()
	if err != nil {
		return err
	}
	m.log.WithFields(log.Fields{
		"statement": stmt,
		"args":      args,
	}).Debugf("insert to %s table", SurveyProjectTableName)
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) UpdateSurveyProject(usp *discoRpc.UpdateSurveyProjectRequest) error {
	sp, err := m.GetSurveyProject(map[string]interface{}{"survey_project_id": usp.SurveyProjectId})
	if err != nil {
		return err
	}
	if usp.SurveySchemaTypes != nil {
		schemaType, err := sysCoreSvc.UnmarshalToMap(usp.SurveySchemaTypes)
		if err != nil {
			return err
		}
		sp.SurveySchemaTypes = schemaType
	}
	if usp.SurveyFilterTypes != nil {
		var sfilter SurveyFilter
		err = json.Unmarshal(usp.SurveyFilterTypes, &sfilter)
		if err != nil {
			return err
		}
		sp.SurveyFilterTypes = sfilter
	}
	filterParam, err := sysCoreSvc.AnyToQueryParam(sp, true)
	if err != nil {
		return err
	}
	delete(filterParam.Params, "survey_project_id")
	delete(filterParam.Params, "sys_account_project_ref_id")
	delete(filterParam.Params, "updated_at")
	filterParam.Params["updated_at"] = sysCoreSvc.CurrentTimestamp()
	stmt, args, err := sq.Update(SurveyProjectTableName).SetMap(filterParam.Params).
		Where(sq.Eq{"survey_project_id": sp.SurveyProjectId}).ToSql()
	if err != nil {
		return err
	}
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) DeleteSurveyProject(id string) error {
	stmt, args, err := sq.Delete(SurveyProjectTableName).Where("survey_project_id = ?", id).ToSql()
	if err != nil {
		return err
	}
	pstmt, pargs, err := sq.Delete(SurveyUsersTableName).Where("survey_project_ref_id = ?", id).ToSql()
	if err != nil {
		return err
	}
	return m.db.BulkExec(map[string][]interface{}{
		stmt:  args,
		pstmt: pargs,
	})
}
