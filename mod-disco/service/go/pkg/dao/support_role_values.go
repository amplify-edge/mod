package dao

import (
	"fmt"
	sq "github.com/Masterminds/squirrel"
	"github.com/genjidb/genji/document"
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
)

type SupportRoleValue struct {
	Id                   string `json:"id" genji:"id" coredb:"primary"`
	SurveyUserRefId      string `json:"surveyUserRefId" genji:"survey_user_ref_id"`
	SupportRoleTypeRefId string `json:"supportRoleTypeRefId" genji:"support_role_type_ref_id"`
	Pledged              uint64 `json:"pledged" genji:"pledged"`
	Comment              string `json:"comment" genji:"comment"`
}

func NewSupportRoleValue(id, surveyUserRefId, supportRoleTypeRefId, comment string, pledged uint64) *SupportRoleValue {
	srtId := id
	if srtId == "" {
		srtId = sysCoreSvc.NewID()
	}
	return &SupportRoleValue{
		Id:                   srtId,
		SurveyUserRefId:      surveyUserRefId,
		SupportRoleTypeRefId: supportRoleTypeRefId,
		Comment:              comment,
		Pledged:              pledged,
	}
}

func (s SupportRoleValue) CreateSQL() []string {
	fields := sysCoreSvc.GetStructTags(s)
	tbl := sysCoreSvc.NewTable(SupportRoleValuesTable, fields, []string{})
	return tbl.CreateTable()
}

func (m *ModDiscoDB) InsertSupportRoleValue(srt *SupportRoleValue) error {
	queryParam, err := sysCoreSvc.AnyToQueryParam(srt, true)
	if err != nil {
		return err
	}
	columns, values := queryParam.ColumnsAndValues()
	if len(columns) != len(values) {
		return fmt.Errorf("error: length mismatch: cols: %d, vals: %d", len(columns), len(values))
	}
	stmt, args, err := sq.Insert(SupportRoleValuesTable).
		Columns(columns...).
		Values(values...).
		ToSql()
	if err != nil {
		return err
	}
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) GetSupportRoleValue(id string) (*SupportRoleValue, error) {
	var srt SupportRoleValue
	stmt := fmt.Sprintf("SELECT %s FROM %s WHERE id = ?", m.supportRoleValueColumns, SupportRoleValuesTable)
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

func (m *ModDiscoDB) ListSupportRoleValue(filters map[string]interface{}) ([]*SupportRoleValue, error) {
	var srts []*SupportRoleValue
	baseStmt := sq.Select(m.supportRoleValueColumns).From(SupportRoleValuesTable)
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
		var srt SupportRoleValue
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

func (m *ModDiscoDB) UpdateSupportRoleValue(usrt *SupportRoleValue) error {
	srt, err := m.GetSupportRoleValue(usrt.Id)
	if err != nil {
		return err
	}
	filterParam, err := sysCoreSvc.AnyToQueryParam(srt, true)
	if err != nil {
		return err
	}
	delete(filterParam.Params, "id")
	delete(filterParam.Params, "survey_user_ref_id")
	stmt, args, err := sq.Update(SurveyProjectTableName).SetMap(filterParam.Params).
		Where(sq.Eq{"id": usrt.Id}).ToSql()
	if err != nil {
		return err
	}
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) DeleteSupportRoleValue(id, SurveyUserRefId string) error {
	var stmt string
	var args []interface{}
	var err error
	if id != "" {
		stmt, args, err = sq.Delete(SupportRoleValuesTable).Where("id = ?", id).ToSql()
		if err != nil {
			return err
		}
	}
	if SurveyUserRefId != "" {
		stmt, args, err = sq.Delete(SupportRoleValuesTable).Where("survey_user_ref_id = ?", id).ToSql()
		if err != nil {
			return err
		}
	}
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) CountRecords() (int, error) {
	stmt, args, err := sq.Select("COUNT(*)").From(SupportRoleValuesTable).Where(sq.GtOrEq{"pledged": 8}).ToSql()
	if err != nil {
		return 0, err
	}
	m.log.Warnf("Statement: %s, Args: %v", stmt, args)
	doc, err := m.db.QueryOne(stmt, args...)
	if err != nil {
		return 0, err
	}
	f, err := doc.Doc.GetByField("COUNT(*)")
	if err != nil {
		return 0, err
	}
	m.log.Warnf("COUNTS: %v", f)
	return 0, nil
}
