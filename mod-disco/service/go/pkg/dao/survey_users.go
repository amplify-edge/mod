package dao

import (
	"fmt"
	sq "github.com/Masterminds/squirrel"
	"github.com/genjidb/genji/document"
	"github.com/google/go-cmp/cmp"
	"github.com/google/go-cmp/cmp/cmpopts"
	"github.com/segmentio/encoding/json"
	log "github.com/sirupsen/logrus"
	"google.golang.org/protobuf/types/known/timestamppb"

	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sharedConfig "github.com/getcouragenow/sys-share/sys-core/service/config"
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
)

type SurveyUser struct {
	SurveyUserId           string `json:"surveyUserId" genji:"survey_user_id" coredb:"primary"`
	SurveyUserName         string `json:"surveyUserName" genji:"survey_user_name"`
	SurveyProjectRefId     string `json:"surveyProjectRefId" genji:"survey_project_ref_id" coredb:"not_null"`
	SysAccountAccountRefId string `json:"sysAccountAccountRefId" genji:"sys_account_account_ref_id"`
	CreatedAt              int64  `json:"createdAt" genji:"created_at"`
	UpdatedAt              int64  `json:"updatedAt" genji:"updated_at"`
}

var (
	surveyUserUniqueIdx = fmt.Sprintf("CREATE UNIQUE INDEX IF NOT EXISTS idx_%s_name ON %s(survey_user_name)", SurveyUsersTableName, SurveyUsersTableName)
)

func (m *ModDiscoDB) FromPkgSurveyUser(sp *discoRpc.SurveyUser) (*SurveyUser, error) {
	surveyUserId := sp.SurveyUserId
	if surveyUserId == "" {
		surveyUserId = sharedConfig.NewID()
	}
	return &SurveyUser{
		SurveyUserId:           surveyUserId,
		SurveyUserName:         sp.GetSurveyUserName(),
		SurveyProjectRefId:     sp.SurveyProjectRefId,
		SysAccountAccountRefId: sp.SysAccountAccountRefId,
		CreatedAt:              sp.CreatedAt.Seconds,
		UpdatedAt:              sp.UpdatedAt.Seconds,
	}, nil
}

func (m *ModDiscoDB) ToPkgSurveyUser(sp *SurveyUser) (*discoRpc.SurveyUser, error) {
	supportRoleValues, err := m.ListSupportRoleValue(map[string]interface{}{"survey_user_ref_id": sp.SurveyUserId})
	if err != nil {
		return nil, err
	}
	var srvs []*discoRpc.SupportRoleValue
	for _, srv := range supportRoleValues {
		srvs = append(srvs, srv.ToProto())
	}
	userNeedValues, err := m.ListUserNeedsValue(map[string]interface{}{"survey_user_ref_id": sp.SurveyUserId})
	if err != nil {
		return nil, err
	}
	var unvs []*discoRpc.UserNeedsValue
	for _, unv := range userNeedValues {
		unvs = append(unvs, unv.ToProto())
	}
	return &discoRpc.SurveyUser{
		SurveyUserId:           sp.SurveyUserId,
		SurveyUserName:         sp.SurveyUserName,
		SurveyProjectRefId:     sp.SurveyProjectRefId,
		SysAccountAccountRefId: sp.SysAccountAccountRefId,
		SupportRoleValues:      srvs,
		UserNeedValues:         unvs,
		CreatedAt:              sharedConfig.UnixToUtcTS(sp.CreatedAt),
		UpdatedAt:              sharedConfig.UnixToUtcTS(sp.UpdatedAt),
	}, nil
}

func (sp SurveyUser) CreateSQL() []string {
	fields := sysCoreSvc.GetStructTags(sp)
	tbl := sysCoreSvc.NewTable(SurveyUsersTableName, fields, []string{surveyUserUniqueIdx})
	return tbl.CreateTable()
}

func (m *ModDiscoDB) SurveyUserQueryFilter(filter map[string]interface{}) sq.SelectBuilder {
	baseStmt := sq.Select(m.surveyUserColumns).From(SurveyUsersTableName)
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
	surveyUsers := []*SurveyUser{}
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
	_ = res.Close()
	if len(surveyUsers) == 0 {
		return surveyUsers, nil, nil
	}
	if len(surveyUsers) == 1 {
		next := int64(0)
		return surveyUsers, &next, nil
	}
	return surveyUsers, &surveyUsers[len(surveyUsers)-1].CreatedAt, nil
}

func (m *ModDiscoDB) InsertSurveyUser(sp *discoRpc.NewSurveyUserRequest) (*discoRpc.SurveyUser, error) {
	newPkgSurveyUser := &discoRpc.SurveyUser{
		SurveyUserId:           sharedConfig.NewID(),
		SurveyUserName:         sp.GetSurveyUserName(),
		SysAccountAccountRefId: sp.SysAccountUserRefId,
		SurveyProjectRefId:     sp.SurveyProjectRefId,
		CreatedAt:              timestamppb.Now(),
		UpdatedAt:              timestamppb.Now(),
	}

	suser, err := m.FromPkgSurveyUser(newPkgSurveyUser)
	if err != nil {
		return nil, err
	}
	queryParam, err := sysCoreSvc.AnyToQueryParam(suser, true)
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
	if sp.GetSupportRoleValues() != nil && len(sp.GetSupportRoleValues()) != 0 {
		for _, srv := range sp.GetSupportRoleValues() {
			srv.SurveyUserRefId = suser.SurveyUserId
			if err = m.InsertFromNewSupportRoleValue(srv); err != nil {
				return nil, err
			}
		}
	}

	if sp.GetUserNeedValues() != nil && len(sp.GetUserNeedValues()) != 0 {
		for _, srv := range sp.GetUserNeedValues() {
			srv.SurveyUserRefId = suser.SurveyUserId
			if err = m.InsertFromNewUserNeedsValue(srv); err != nil {
				return nil, err
			}
		}
	}

	daoSurvey, err := m.GetSurveyUser(map[string]interface{}{"survey_user_id": newPkgSurveyUser.SurveyUserId})
	if err != nil {
		return nil, err
	}
	surveyUser, err := m.ToPkgSurveyUser(daoSurvey)
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
	if usp.GetSupportRoleValues() != nil && len(usp.GetSupportRoleValues()) != 0 {
		for _, srv := range usp.GetSupportRoleValues() {
			var s SupportRoleValue
			var actualSrv *SupportRoleValue
			srvBytes, err := sysCoreSvc.MarshalToBytes(srv)
			if err != nil {
				return err
			}
			if err := sharedConfig.UnmarshalJson(srvBytes, &s); err != nil {
				return err
			}
			actualSrv, err = m.GetSupportRoleValue(s.Id)
			if err != nil {
				if err.Error() == "document not found" {
					s.SurveyUserRefId = sp.SurveyUserId
					if err = m.InsertSupportRoleValue(&s); err != nil {
						return err
					}
					continue
				}
				return err
			} else {
				if eq := cmp.Equal(actualSrv, s, cmpopts.IgnoreUnexported()); !eq {
					if err = m.UpdateSupportRoleValue(&s); err != nil {
						return err
					}
				}
				continue
			}

		}
	}

	if usp.GetUserNeedValues() != nil && len(usp.GetUserNeedValues()) != 0 {
		for _, srv := range usp.GetUserNeedValues() {
			var u UserNeedsValue
			unvBytes, err := sysCoreSvc.MarshalToBytes(srv)
			if err != nil {
				return err
			}
			if err := json.Unmarshal(unvBytes, &u); err != nil {
				return err
			}
			actualUnv, err := m.GetUserNeedsValue(u.Id)
			if err != nil {
				if err.Error() == "document not found" {
					u.SurveyUserRefId = sp.SurveyUserId
					if err = m.InsertUserNeedsValue(&u); err != nil {
						return err
					}
					continue
				}
				return err
			} else {
				if eq := cmp.Equal(actualUnv, u, cmpopts.IgnoreUnexported()); !eq {
					if err = m.UpdateUserNeedsValue(&u); err != nil {
						return err
					}
					continue
				}
			}

		}
	}
	filterParam, err := sysCoreSvc.AnyToQueryParam(sp, true)
	if err != nil {
		return err
	}
	delete(filterParam.Params, "survey_user_id")
	delete(filterParam.Params, "sys_account_account_ref_id")
	delete(filterParam.Params, "survey_project_ref_id")
	delete(filterParam.Params, "updated_at")
	filterParam.Params["updated_at"] = sharedConfig.CurrentTimestamp()
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
	srvStmt, srvArgs, err := sq.Delete(SupportRoleValuesTable).Where("survey_user_ref_id = ?", id).ToSql()
	if err != nil {
		return err
	}
	unvStmt, unvArgs, err := sq.Delete(UserNeedValuesTable).Where("survey_user_ref_id = ?", id).ToSql()
	if err != nil {
		return err
	}
	return m.db.BulkExec(map[string][]interface{}{
		unvStmt: unvArgs,
		srvStmt: srvArgs,
		stmt:    args,
	})
}
