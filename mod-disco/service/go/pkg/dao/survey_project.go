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

type SurveyProject struct {
	SurveyProjectId        string `json:"surveyProjectId" genji:"survey_project_id" coredb:"primary"`
	SurveyProjectName      string `json:"surveyProjectName" genji:"survey_project_name"`
	SysAccountProjectRefId string `json:"sysAccountProjectRefId" genji:"sys_account_project_ref_id" coredb:"not_null"`
	CreatedAt              int64  `json:"createdAt" genji:"created_at"`
	UpdatedAt              int64  `json:"updatedAt" genji:"updated_at"`
}

var (
	surveyProjectUniqueIndex   = fmt.Sprintf("CREATE UNIQUE INDEX IF NOT EXISTS idx_%s_sys_account_ref ON %s(sys_account_project_ref_id)", SurveyProjectTableName, SurveyProjectTableName)
	surveyProjectNameUniqueIdx = fmt.Sprintf("CREATE UNIQUE INDEX IF NOT EXISTS idx_%s_name ON %s(survey_project_name)", SurveyProjectTableName, SurveyProjectTableName)
)

func (m *ModDiscoDB) FromPkgSurveyProject(sp *discoRpc.SurveyProject) (*SurveyProject, error) {
	surveyProjectId := sp.SurveyProjectId
	if surveyProjectId == "" {
		surveyProjectId = sharedConfig.NewID()
	}
	return &SurveyProject{
		SurveyProjectId:        surveyProjectId,
		SurveyProjectName:      sp.SurveyProjectName,
		SysAccountProjectRefId: sp.SysAccountProjectRefId,
		CreatedAt:              sp.CreatedAt.Seconds,
		UpdatedAt:              sp.UpdatedAt.Seconds,
	}, nil
}

func (m *ModDiscoDB) ToPkgSurveyProject(sp *SurveyProject) (*discoRpc.SurveyProject, error) {
	supportRoleTypes, err := m.ListSupportRoleType(map[string]interface{}{"survey_project_ref_id": sp.SurveyProjectId})
	if err != nil {
		return nil, err
	}
	var srts []*discoRpc.SupportRoleType
	for _, srt := range supportRoleTypes {
		srts = append(srts, srt.ToProto())
	}
	var unts []*discoRpc.UserNeedsType
	userNeedTypes, err := m.ListUserNeedsType(map[string]interface{}{"survey_project_ref_id": sp.SurveyProjectId})
	if err != nil {
		return nil, err
	}
	for _, unt := range userNeedTypes {
		unts = append(unts, unt.ToProto())
	}
	return &discoRpc.SurveyProject{
		SurveyProjectId:        sp.SurveyProjectId,
		SurveyProjectName:      sp.SurveyProjectName,
		SysAccountProjectRefId: sp.SysAccountProjectRefId,
		SupportRoleTypes:       srts,
		UserNeedTypes:          unts,
		CreatedAt:              sharedConfig.UnixToUtcTS(sp.CreatedAt),
		UpdatedAt:              sharedConfig.UnixToUtcTS(sp.UpdatedAt),
	}, nil
}

func (sp SurveyProject) CreateSQL() []string {
	fields := sysCoreSvc.GetStructTags(sp)
	tbl := sysCoreSvc.NewTable(SurveyProjectTableName, fields, []string{surveyProjectUniqueIndex, surveyProjectNameUniqueIdx})
	return tbl.CreateTable()
}

func (m *ModDiscoDB) surveyProjectQueryFilter(filter map[string]interface{}) sq.SelectBuilder {
	baseStmt := sq.Select(m.surveyProjectColumns).From(SurveyProjectTableName)
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
	if d != nil {
		if err = document.StructScan(d, &sp); err != nil {
			return nil, err
		}
		return &sp, nil
	}
	return nil, fmt.Errorf("document not found")
}

func (m *ModDiscoDB) ListSurveyProject(filters map[string]interface{}, orderBy string, limit, cursor int64) ([]*SurveyProject, *int64, error) {
	surveyProjects := []*SurveyProject{}
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
	_ = res.Close()
	if len(surveyProjects) == 0 {
		return surveyProjects, nil, nil
	}
	if len(surveyProjects) == 1 {
		next := int64(0)
		return surveyProjects, &next, nil
	}
	return surveyProjects, &surveyProjects[len(surveyProjects)-1].CreatedAt, nil
}

func (m *ModDiscoDB) InsertSurveyProject(sp *discoRpc.NewSurveyProjectRequest) (*discoRpc.SurveyProject, error) {
	newPkgSurveyProject := &discoRpc.SurveyProject{
		SurveyProjectId:        sharedConfig.NewID(),
		SurveyProjectName:      sp.GetSurveyProjectName(),
		SysAccountProjectRefId: sp.SysAccountProjectRefId,
		CreatedAt:              timestamppb.Now(),
		UpdatedAt:              timestamppb.Now(),
	}
	sproj, err := m.FromPkgSurveyProject(newPkgSurveyProject)
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
	stmt, args, err := sq.Insert(SurveyProjectTableName).
		Columns(columns...).
		Values(values...).
		ToSql()
	if err != nil {
		return nil, err
	}
	m.log.WithFields(log.Fields{
		"statement": stmt,
		"args":      args,
	}).Debugf("insert to %s table", SurveyProjectTableName)
	if err := m.db.Exec(stmt, args...); err != nil {
		return nil, err
	}

	if sp.GetSupportRoleTypes() != nil && len(sp.GetSupportRoleTypes()) != 0 {
		for _, srv := range sp.GetSupportRoleTypes() {
			srv.SurveyProjectRefId = sproj.SurveyProjectId
			if err = m.InsertFromNewSupportRoleType(srv); err != nil {
				return nil, err
			}
		}
	}

	if sp.GetUserNeedTypes() != nil && len(sp.GetUserNeedTypes()) != 0 {
		for _, srv := range sp.GetUserNeedTypes() {
			srv.SurveyProjectRefId = sproj.SurveyProjectId
			if err = m.InsertFromNewUserNeedsType(srv); err != nil {
				return nil, err
			}
		}
	}

	dsp, err := m.GetSurveyProject(map[string]interface{}{"survey_project_id": newPkgSurveyProject.SurveyProjectId})
	if err != nil {
		return nil, err
	}
	surveyProj, err := m.ToPkgSurveyProject(dsp)
	if err != nil {
		return nil, err
	}
	return surveyProj, nil
}

func (m *ModDiscoDB) UpdateSurveyProject(usp *discoRpc.UpdateSurveyProjectRequest) error {
	sp, err := m.GetSurveyProject(map[string]interface{}{"survey_project_id": usp.SurveyProjectId})
	if err != nil {
		return err
	}

	filterParam, err := sysCoreSvc.AnyToQueryParam(sp, true)
	if err != nil {
		return err
	}
	if usp.GetSupportRoleTypes() != nil && len(usp.GetSupportRoleTypes()) != 0 {
		for _, srv := range usp.GetSupportRoleTypes() {
			var s SupportRoleType
			m.log.Warnf("SupportRoleType from Update: %v", s)
			srvBytes, err := sysCoreSvc.MarshalToBytes(srv)
			if err != nil {
				return err
			}
			if err := json.Unmarshal(srvBytes, &s); err != nil {
				return err
			}
			actualSrv, err := m.GetSupportRoleType(s.Id)
			if err != nil {
				if err.Error() == "document not found" {
					s.SurveyProjectRefId = sp.SurveyProjectId
					if err = m.InsertSupportRoleType(&s); err != nil {
						return err
					}
				}
				return err
			} else {
				if eq := cmp.Equal(actualSrv, s, cmpopts.IgnoreUnexported()); !eq {
					if err = m.UpdateSupportRoleType(&s); err != nil {
						return err
					}
				}
			}

		}
	}

	if usp.GetUserNeedTypes() != nil && len(usp.GetUserNeedTypes()) != 0 {
		for _, srv := range usp.GetUserNeedTypes() {
			var u UserNeedsType
			untBytes, err := sysCoreSvc.MarshalToBytes(srv)
			if err != nil {
				return err
			}
			if err := json.Unmarshal(untBytes, &u); err != nil {
				return err
			}
			actualUnv, err := m.GetUserNeedsType(u.Id)
			if err != nil {
				if err.Error() == "document not found" {
					u.SurveyProjectRefId = sp.SurveyProjectId
					if err = m.InsertUserNeedsType(&u); err != nil {
						return err
					}
					continue
				}
				return err
			} else {
				if eq := cmp.Equal(actualUnv, u, cmpopts.IgnoreUnexported()); !eq {
					if err = m.UpdateUserNeedsType(&u); err != nil {
						return err
					}
				}
				continue
			}
		}
	}
	delete(filterParam.Params, "survey_project_id")
	delete(filterParam.Params, "sys_account_project_ref_id")
	delete(filterParam.Params, "updated_at")
	filterParam.Params["updated_at"] = sharedConfig.CurrentTimestamp()
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
	srtStmt, srtArgs, err := sq.Delete(SupportRoleTypesTable).Where("survey_project_ref_id = ?", id).ToSql()
	if err != nil {
		return err
	}
	untStmt, untArgs, err := sq.Delete(UserNeedTypesTable).Where("survey_project_ref_id = ?", id).ToSql()
	if err != nil {
		return err
	}
	return m.db.BulkExec(map[string][]interface{}{
		stmt:    args,
		pstmt:   pargs,
		srtStmt: srtArgs,
		untStmt: untArgs,
	})
}
