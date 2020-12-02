package dao

import (
	"fmt"
	sq "github.com/Masterminds/squirrel"
	"github.com/genjidb/genji/document"
	"strconv"

	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sharedConfig "github.com/getcouragenow/sys-share/sys-core/service/config"
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
)

func (m *ModDiscoDB) GetStats(filters map[string]interface{}, limit, cursor int64, tableName, orderBy string) (*discoRpc.StatisticResponse, error) {
	unvpas := []*discoRpc.UserNeedsValuePlusAccount{}
	srvpas := []*discoRpc.SupportRoleValuePlusAccount{}
	switch tableName {
	case "user_need_values":
		counts, err := m.countValues(filters, UserNeedValuesTable)
		if err != nil {
			return nil, err
		}
		unvs, err := m.paginatedListUserNeedsValue(filters, orderBy, limit, cursor)
		if err != nil {
			return nil, err
		}
		for _, unv := range unvs {
			surveyUser, err := m.GetSurveyUser(map[string]interface{}{"survey_user_id": unv.SurveyUserRefId})
			if err != nil {
				return nil, err
			}
			unvpa := &discoRpc.UserNeedsValuePlusAccount{
				Id:                    unv.Id,
				SysAccountUserRefName: surveyUser.SysAccountAccountRefId,
				CreatedAt:             sharedConfig.UnixToUtcTS(surveyUser.CreatedAt),
			}
			unvpas = append(unvpas, unvpa)
		}
		if len(unvpas) == 1 {
			return &discoRpc.StatisticResponse{
				SupportRoleValuesPlusAccount: srvpas,
				UserNeedValuesPlusAccount:    unvpas,
				NextPageId:                   strconv.FormatInt(sharedConfig.TsToUnixUTC(unvpas[0].CreatedAt), 10),
				TotalCount:                   *counts,
			}, nil
		}
		return &discoRpc.StatisticResponse{
			SupportRoleValuesPlusAccount: srvpas,
			UserNeedValuesPlusAccount:    unvpas,
			NextPageId:                   strconv.FormatInt(sharedConfig.TsToUnixUTC(unvpas[len(unvpas)-1].CreatedAt), 10),
			TotalCount:                   *counts,
		}, nil
	case "support_role_values":
		counts, err := m.countValues(filters, SupportRoleValuesTable)
		if err != nil {
			return nil, err
		}
		srvs, err := m.paginatedListSupportRoleValue(filters, orderBy, limit, cursor)
		if err != nil {
			return nil, err
		}
		for _, srv := range srvs {
			surveyUser, err := m.GetSurveyUser(map[string]interface{}{"survey_user_id": srv.SurveyUserRefId})
			if err != nil {
				return nil, err
			}
			srvpa := &discoRpc.SupportRoleValuePlusAccount{
				Id:                    srv.Id,
				SysAccountUserRefName: surveyUser.SysAccountAccountRefId,
				Pledged:               srv.Pledged,
				CreatedAt:             sharedConfig.UnixToUtcTS(srv.CreatedAt),
			}
			srvpas = append(srvpas, srvpa)
		}
		if len(srvpas) == 1 {
			return &discoRpc.StatisticResponse{
				SupportRoleValuesPlusAccount: srvpas,
				UserNeedValuesPlusAccount:    unvpas,
				NextPageId:                   strconv.FormatInt(sharedConfig.TsToUnixUTC(srvpas[0].CreatedAt), 10),
				TotalCount:                   *counts,
			}, nil
		}
		return &discoRpc.StatisticResponse{
			SupportRoleValuesPlusAccount: srvpas,
			UserNeedValuesPlusAccount:    unvpas,
			NextPageId:                   strconv.FormatInt(sharedConfig.TsToUnixUTC(srvpas[len(srvpas)-1].CreatedAt), 10),
			TotalCount:                   *counts,
		}, nil
	default:
		return nil, fmt.Errorf("unknown table")
	}
}

func (m *ModDiscoDB) paginatedListUserNeedsValue(filters map[string]interface{}, orderBy string, limit, cursor int64) ([]*UserNeedsValue, error) {
	var userNeedValues []*UserNeedsValue
	baseStmt := sysCoreSvc.BaseQueryBuilder(filters, UserNeedValuesTable, m.userNeedValueColumns, func(k string, v interface{}) sysCoreSvc.StmtIFacer {
		return sq.Like{k: m.BuildSearchQuery(v.(string))}
	})
	stmt, args, err := sysCoreSvc.ListSelectStatement(baseStmt, orderBy, limit, &cursor, DefaultCursor)
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
		userNeedValues = append(userNeedValues, &unv)
		return nil
	})
	_ = res.Close()
	return userNeedValues, nil
}

func (m *ModDiscoDB) paginatedListSupportRoleValue(filters map[string]interface{}, orderBy string, limit int64, cursor int64) ([]*SupportRoleValue, error) {
	var srvs []*SupportRoleValue
	baseStmt := sysCoreSvc.BaseQueryBuilder(filters, SupportRoleValuesTable, m.supportRoleValueColumns, func(k string, v interface{}) sysCoreSvc.StmtIFacer {
		return sq.Like{k: m.BuildSearchQuery(v.(string))}
	})
	stmt, args, err := sysCoreSvc.ListSelectStatement(baseStmt, orderBy, limit, &cursor, DefaultCursor)
	if err != nil {
		return nil, err
	}
	res, err := m.db.Query(stmt, args...)
	if err != nil {
		return nil, err
	}
	err = res.Iterate(func(d document.Document) error {
		var srv SupportRoleValue
		if err = document.StructScan(d, &srv); err != nil {
			return err
		}
		srvs = append(srvs, &srv)
		return nil
	})
	_ = res.Close()
	return srvs, nil
}

func (m *ModDiscoDB) countValues(filters map[string]interface{}, tableName string) (*int64, error) {
	baseStmt := sq.Select("COUNT(*)").
		From(tableName)
	for k, v := range filters {
		baseStmt = baseStmt.Where(sq.Like{k: m.BuildSearchQuery(v.(string))})
	}
	stmt, args, err := baseStmt.ToSql()
	if err != nil {
		return nil, err
	}
	doc, err := m.db.QueryOne(stmt, args...)
	if err != nil {
		return nil, err
	}
	f, err := doc.Doc.GetByField("COUNT(*)")
	if err != nil {
		return nil, err
	}
	v := f.V.(int64)
	return &v, nil
}
