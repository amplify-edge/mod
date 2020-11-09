package dao

import (
	"fmt"
	sq "github.com/Masterminds/squirrel"
	"github.com/genjidb/genji/document"

	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
)

type SupportRoleType struct {
	Id                 string `json:"id,omitempty" genji:"id" coredb:"primary"`
	SurveyProjectRefId string `json:"surveyProjectRefId,omitempty" genji:"survey_project_ref_id"`
	Name               string `json:"name,omitempty" genji:"name"`
	Comment            string `json:"comment,omitempty" genji:"comment"`
	Description        string `json:"description,omitempty" genji:"description"`
	UnitOfMeasures     string `json:"unitOfMeasures,omitempty" genji:"unit_of_measures"`
}

var (
	supportRoleTypeUniqueIdx = fmt.Sprintf("CREATE UNIQUE INDEX IF NOT EXISTS idx_%s_name ON %s(name)", SupportRoleTypesTable, SupportRoleTypesTable)
)

func NewSupportRoleType(id, surveyProjectId, name, comment, desc, uom string) *SupportRoleType {
	srtId := id
	if srtId == "" {
		srtId = sysCoreSvc.NewID()
	}
	return &SupportRoleType{
		Id:                 srtId,
		SurveyProjectRefId: surveyProjectId,
		Name:               name,
		Comment:            comment,
		Description:        desc,
		UnitOfMeasures:     uom,
	}
}

func (s *SupportRoleType) ToProto() *discoRpc.SupportRoleType {
	return &discoRpc.SupportRoleType{
		Id:                 s.Id,
		SurveyProjectRefId: s.SurveyProjectRefId,
		Name:               s.Name,
		Comment:            s.Comment,
		Description:        s.Description,
		UnitOfMeasures:     s.UnitOfMeasures,
	}
}

func (m *ModDiscoDB) InsertFromNewSupportRoleType(in *discoRpc.NewSupportRoleType) error {
	nsprt := &SupportRoleType{
		Id:                 sysCoreSvc.NewID(),
		SurveyProjectRefId: in.SurveyProjectRefId,
		Name:               in.GetName(),
		Comment:            in.GetComment(),
		Description:        in.GetDescription(),
		UnitOfMeasures:     in.GetUnitOfMeasures(),
	}
	err := m.InsertSupportRoleType(nsprt)
	if err != nil {
		return err
	}
	return nil
}

func (s SupportRoleType) CreateSQL() []string {
	fields := sysCoreSvc.GetStructTags(s)
	tbl := sysCoreSvc.NewTable(SupportRoleTypesTable, fields, []string{supportRoleTypeUniqueIdx})
	return tbl.CreateTable()
}

func (m *ModDiscoDB) InsertSupportRoleType(srt *SupportRoleType) error {
	queryParam, err := sysCoreSvc.AnyToQueryParam(srt, true)
	if err != nil {
		return err
	}
	columns, values := queryParam.ColumnsAndValues()
	if len(columns) != len(values) {
		return fmt.Errorf("error: length mismatch: cols: %d, vals: %d", len(columns), len(values))
	}
	stmt, args, err := sq.Insert(SupportRoleTypesTable).
		Columns(columns...).
		Values(values...).
		ToSql()
	if err != nil {
		return err
	}
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) GetSupportRoleType(id string) (*SupportRoleType, error) {
	var srt SupportRoleType
	stmt := fmt.Sprintf("SELECT %s FROM %s WHERE id = ?", m.supportRoleTypeColumns, SupportRoleTypesTable)
	args := []interface{}{id}
	doc, err := m.db.QueryOne(stmt, args...)
	if err != nil {
		return nil, err
	}
	if err = doc.StructScan(&srt); err != nil {
		return nil, err
	}
	return &srt, nil
}

func (m *ModDiscoDB) ListSupportRoleType(filters map[string]interface{}) ([]*SupportRoleType, error) {
	var srts []*SupportRoleType
	baseStmt := sq.Select(m.supportRoleTypeColumns).From(SupportRoleTypesTable)
	if filters != nil {
		for k, v := range filters {
			baseStmt = baseStmt.Where(sq.Eq{k: v})
		}
	}
	stmt, args, err := baseStmt.ToSql()
	if err != nil {
		return nil, err
	}
	res, err := m.db.Query(stmt, args...)
	if err != nil {
		return nil, err
	}
	err = res.Iterate(func(d document.Document) error {
		var srt SupportRoleType
		if err = document.StructScan(d, &srt); err != nil {
			return err
		}
		srts = append(srts, &srt)
		return nil
	})
	res.Close()
	if err != nil {
		return nil, err
	}
	return srts, nil
}

func (m *ModDiscoDB) UpdateSupportRoleType(usrt *SupportRoleType) error {
	srt, err := m.GetSupportRoleType(usrt.Id)
	if err != nil {
		return err
	}
	filterParam, err := sysCoreSvc.AnyToQueryParam(srt, true)
	if err != nil {
		return err
	}
	delete(filterParam.Params, "id")
	delete(filterParam.Params, "survey_project_ref_id")
	stmt, args, err := sq.Update(SupportRoleTypesTable).SetMap(filterParam.Params).
		Where(sq.Eq{"id": usrt.Id}).ToSql()
	if err != nil {
		return err
	}
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) DeleteSupportRoleType(id, surveyProjectRefId string) error {
	var stmt string
	var args []interface{}
	var err error
	if id != "" {
		stmt, args, err = sq.Delete(SupportRoleTypesTable).Where("id = ?", id).ToSql()
		if err != nil {
			return err
		}
	}
	if surveyProjectRefId != "" {
		stmt, args, err = sq.Delete(SupportRoleTypesTable).Where("survey_project_ref_id = ?", id).ToSql()
		if err != nil {
			return err
		}
	}
	return m.db.Exec(stmt, args...)
}
