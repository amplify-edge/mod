package dao

import (
	"fmt"
	sq "github.com/Masterminds/squirrel"
	"github.com/genjidb/genji/document"

	discoRpc "go.amplifyedge.org/mod-v2/mod-disco/service/go/rpc/v2"
	sharedConfig "go.amplifyedge.org/sys-share-v2/sys-core/service/config"
	sysCoreSvc "go.amplifyedge.org/sys-v2/sys-core/service/go/pkg/coredb"
)

type UserNeedsType struct {
	Id                 string `json:"id" genji:"id" coredb:"primary"`
	SurveyProjectRefId string `json:"surveyProjectRefId" genji:"survey_project_ref_id" coredb:"not_null"`
	Name               string `json:"name" genji:"name"`
	QuestionGroup      string `json:"questionGroup" genji:"question_group"`
	Comment            string `json:"comment" genji:"comment"`
	Description        string `json:"description" genji:"description"`
	UnitOfMeasures     string `json:"unitOfMeasures" genji:"unit_of_measures"`
	QuestionType       string `json:"questionType" genji:"question_type"`
	DropdownQuestion   string `json:"dropdownQuestion" genji:"dropdown_question"`
}

var (
	userNeedTypesUniqueIdx = fmt.Sprintf("CREATE UNIQUE INDEX IF NOT EXISTS idx_%s_name ON %s(name)", UserNeedTypesTable, UserNeedTypesTable)
)

func (s *UserNeedsType) ToProto() *discoRpc.UserNeedsType {
	return &discoRpc.UserNeedsType{
		Id:                 s.Id,
		SurveyProjectRefId: s.SurveyProjectRefId,
		Name:               s.Name,
		Comment:            s.Comment,
		Description:        s.Description,
		UnitOfMeasures:     s.UnitOfMeasures,
		QuestionGroup:      s.QuestionGroup,
		QuestionType:       s.QuestionType,
		DropdownQuestion:   s.DropdownQuestion,
	}
}

func (m *ModDiscoDB) InsertFromNewUserNeedsType(in *discoRpc.NewUserNeedsType) error {
	nunt := &UserNeedsType{
		Id:                 sharedConfig.NewID(),
		SurveyProjectRefId: in.GetSurveyProjectRefId(),
		Name:               in.GetName(),
		Comment:            in.GetComment(),
		Description:        in.GetDescription(),
		UnitOfMeasures:     in.GetUnitOfMeasures(),
		QuestionGroup:      in.GetQuestionGroup(),
		QuestionType:       in.GetQuestionType(),
		DropdownQuestion:   in.GetDropdownQuestion(),
	}
	err := m.InsertUserNeedsType(nunt)
	if err != nil {
		return err
	}
	return nil
}

func (s UserNeedsType) CreateSQL() []string {
	fields := sysCoreSvc.GetStructTags(s)
	tbl := sysCoreSvc.NewTable(UserNeedTypesTable, fields, []string{userNeedTypesUniqueIdx})
	return tbl.CreateTable()
}

func (m *ModDiscoDB) InsertUserNeedsType(srt *UserNeedsType) error {
	queryParam, err := sysCoreSvc.AnyToQueryParam(srt, true)
	if err != nil {
		return err
	}
	columns, values := queryParam.ColumnsAndValues()
	if len(columns) != len(values) {
		return fmt.Errorf("error: length mismatch: cols: %d, vals: %d", len(columns), len(values))
	}
	stmt, args, err := sq.Insert(UserNeedTypesTable).
		Columns(columns...).
		Values(values...).
		ToSql()
	if err != nil {
		return err
	}
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) GetUserNeedsType(id, name string) (*UserNeedsType, error) {
	var srt UserNeedsType
	var stmt string
	var args []interface{}
	if id != "" {
		stmt = fmt.Sprintf("SELECT %s FROM %s WHERE id = ?", m.userNeedTypeColumns, UserNeedTypesTable)
		args = []interface{}{id}
	}
	if name != "" {
		stmt = fmt.Sprintf("SELECT %s FROM %s WHERE name = ?", m.userNeedTypeColumns, UserNeedTypesTable)
		args = []interface{}{name}
	}
	doc, err := m.db.QueryOne(stmt, args...)
	if err != nil {
		return nil, err
	}
	if err = doc.StructScan(&srt); err != nil {
		return nil, err
	}
	return &srt, nil
}

func (m *ModDiscoDB) ListUserNeedsType(filters map[string]interface{}) ([]*UserNeedsType, error) {
	var srts []*UserNeedsType
	baseStmt := sq.Select(m.userNeedTypeColumns).From(UserNeedTypesTable)
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
		var srt UserNeedsType
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

func (m *ModDiscoDB) UpdateUserNeedsType(usrt *UserNeedsType) error {
	srt, err := m.GetUserNeedsType(usrt.Id, "")
	if err != nil {
		return err
	}
	filterParam, err := sysCoreSvc.AnyToQueryParam(srt, true)
	if err != nil {
		return err
	}
	delete(filterParam.Params, "id")
	delete(filterParam.Params, "survey_project_ref_id")
	stmt, args, err := sq.Update(UserNeedTypesTable).SetMap(filterParam.Params).
		Where(sq.Eq{"id": usrt.Id}).ToSql()
	if err != nil {
		return err
	}
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) DeleteUserNeedsType(id, surveyProjectRefId string) error {
	var stmt string
	var args []interface{}
	var err error
	if id != "" {
		stmt, args, err = sq.Delete(UserNeedTypesTable).Where("id = ?", id).ToSql()
		if err != nil {
			return err
		}
	}
	if surveyProjectRefId != "" {
		stmt, args, err = sq.Delete(UserNeedTypesTable).Where("survey_project_ref_id = ?", id).ToSql()
		if err != nil {
			return err
		}
	}
	return m.db.Exec(stmt, args...)
}
