package dao

import (
	"fmt"
	sq "github.com/Masterminds/squirrel"
	"github.com/genjidb/genji/document"

	discoRpc "go.amplifyedge.org/mod-v2/mod-disco/service/go/rpc/v2"
	sharedConfig "go.amplifyedge.org/sys-share-v2/sys-core/service/config"
	sysCoreSvc "go.amplifyedge.org/sys-v2/sys-core/service/go/pkg/coredb"
)

type UserNeedsValue struct {
	Id                 string `json:"id" genji:"id" coredb:"primary"`
	SurveyUserRefId    string `json:"surveyUserRefId" genji:"survey_user_ref_id" coredb:"not_null"`
	UserNeedsTypeRefId string `json:"userNeedsTypeRefId" genji:"user_needs_type_ref_id" coredb:"not_null"`
	Comment            string `json:"comment" genji:"comment"`
	CreatedAt          int64  `json:"createdAt" genji:"created_at"`
	UpdatedAt          int64  `json:"updatedAt" genji:"updated_at"`
}

func NewUserNeedsValue(id, surveyUserRefId, userNeedsTypeRefId, comment string, pledged uint64) *UserNeedsValue {
	unvId := id
	if unvId == "" {
		unvId = sharedConfig.NewID()
	}
	return &UserNeedsValue{
		Id:                 unvId,
		SurveyUserRefId:    surveyUserRefId,
		UserNeedsTypeRefId: userNeedsTypeRefId,
		Comment:            comment,
		CreatedAt:          sharedConfig.CurrentTimestamp(),
		UpdatedAt:          sharedConfig.CurrentTimestamp(),
	}
}

func (s *UserNeedsValue) ToProto() *discoRpc.UserNeedsValue {
	return &discoRpc.UserNeedsValue{
		Id:                 s.Id,
		SurveyUserRefId:    s.SurveyUserRefId,
		UserNeedsTypeRefId: s.UserNeedsTypeRefId,
		Comments:           s.Comment,
	}
}

func (m *ModDiscoDB) InsertFromNewUserNeedsValue(in *discoRpc.NewUserNeedsValue) error {
	nunt := &UserNeedsValue{
		Id:                 sharedConfig.NewID(),
		SurveyUserRefId:    in.GetSurveyUserRefId(),
		UserNeedsTypeRefId: in.GetUserNeedsTypeRefId(),
		Comment:            in.GetComments(),
		CreatedAt:          sharedConfig.CurrentTimestamp(),
		UpdatedAt:          sharedConfig.CurrentTimestamp(),
	}
	err := m.InsertUserNeedsValue(nunt)
	if err != nil {
		return err
	}
	return nil
}

func (s UserNeedsValue) CreateSQL() []string {
	fields := sysCoreSvc.GetStructTags(s)
	tbl := sysCoreSvc.NewTable(UserNeedValuesTable, fields, []string{})
	return tbl.CreateTable()
}

func (m *ModDiscoDB) InsertUserNeedsValue(unv *UserNeedsValue) error {
	queryParam, err := sysCoreSvc.AnyToQueryParam(unv, true)
	if err != nil {
		return err
	}
	columns, values := queryParam.ColumnsAndValues()
	if len(columns) != len(values) {
		return fmt.Errorf("error: length mismatch: cols: %d, vals: %d", len(columns), len(values))
	}
	stmt, args, err := sq.Insert(UserNeedValuesTable).
		Columns(columns...).
		Values(values...).
		ToSql()
	if err != nil {
		return err
	}
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) GetUserNeedsValue(id string) (*UserNeedsValue, error) {
	var unv UserNeedsValue
	stmt := fmt.Sprintf("SELECT %s FROM %s WHERE id = ?", m.userNeedValueColumns, UserNeedValuesTable)
	args := []interface{}{id}
	doc, err := m.db.QueryOne(stmt, args...)
	if err != nil {
		return nil, err
	}
	if err = doc.StructScan(&unv); err != nil {
		return nil, err
	}
	return &unv, nil
}

func (m *ModDiscoDB) ListUserNeedsValue(filters map[string]interface{}) ([]*UserNeedsValue, error) {
	var unvs []*UserNeedsValue
	baseStmt := sq.Select(m.userNeedValueColumns).From(UserNeedValuesTable)
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
		var unv UserNeedsValue
		if err = document.StructScan(d, &unv); err != nil {
			return err
		}
		unvs = append(unvs, &unv)
		return nil
	})
	_ = res.Close()
	if err != nil {
		return nil, err
	}
	return unvs, nil
}

func (m *ModDiscoDB) UpdateUserNeedsValue(uunv *UserNeedsValue) error {
	srt, err := m.GetUserNeedsValue(uunv.Id)
	if err != nil {
		return err
	}
	filterParam, err := sysCoreSvc.AnyToQueryParam(srt, true)
	if err != nil {
		return err
	}
	delete(filterParam.Params, "id")
	delete(filterParam.Params, "survey_user_ref_id")
	delete(filterParam.Params, "user_needs_type_ref_id")
	filterParam.Params["updated_at"] = sharedConfig.CurrentTimestamp()
	stmt, args, err := sq.Update(UserNeedValuesTable).SetMap(filterParam.Params).
		Where(sq.Eq{"id": uunv.Id}).ToSql()
	if err != nil {
		return err
	}
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) DeleteUserNeedsValue(id, surveyUserRefId string) error {
	var stmt string
	var args []interface{}
	var err error
	if id != "" {
		stmt, args, err = sq.Delete(UserNeedValuesTable).Where("id = ?", id).ToSql()
		if err != nil {
			return err
		}
	}
	if surveyUserRefId != "" {
		stmt, args, err = sq.Delete(UserNeedValuesTable).Where("survey_user_ref_id = ?", id).ToSql()
		if err != nil {
			return err
		}
	}
	return m.db.Exec(stmt, args...)
}
