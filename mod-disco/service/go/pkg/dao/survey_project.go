package dao

import (
	"fmt"
	sq "github.com/Masterminds/squirrel"
	"github.com/genjidb/genji/document"
	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sharedConfig "github.com/getcouragenow/sys-share/sys-core/service/config"
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	"github.com/google/go-cmp/cmp"
	"github.com/google/go-cmp/cmp/cmpopts"
	"github.com/segmentio/encoding/json"
	log "github.com/sirupsen/logrus"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type SurveyProject struct {
	SurveyProjectId        string `json:"surveyProjectId" genji:"survey_project_id"`
	SysAccountProjectRefId string `json:"sysAccountProjectRefId" genji:"sys_account_project_ref_id"`
	CreatedAt              int64  `json:"createdAt" genji:"created_at"`
	UpdatedAt              int64  `json:"updatedAt" genji:"updated_at"`
}

var (
	surveyProjectUniqueIndex = fmt.Sprintf("CREATE UNIQUE INDEX IF NOT EXISTS idx_%s_sys_account_ref ON %s(sys_account_project_ref_id)", SurveyProjectTableName, SurveyProjectTableName)
)

func (m *ModDiscoDB) FromPkgSurveyProject(sp *discoRpc.SurveyProject) (*SurveyProject, error) {
	surveyProjectId := sp.SurveyProjectId
	if surveyProjectId == "" {
		surveyProjectId = sysCoreSvc.NewID()
	}
	return &SurveyProject{
		SurveyProjectId:        surveyProjectId,
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
	supportRoleTypesByte, err := sysCoreSvc.MarshalToBytes(supportRoleTypes)
	if err != nil {
		return nil, err
	}
	userNeedTypes, err := m.ListUserNeedsType(map[string]interface{}{"survey_project_ref_id": sp.SurveyProjectId})
	if err != nil {
		return nil, err
	}
	userNeedTypesByte, err := sysCoreSvc.MarshalToBytes(userNeedTypes)
	if err != nil {
		return nil, err
	}
	return &discoRpc.SurveyProject{
		SurveyProjectId:        sp.SurveyProjectId,
		SysAccountProjectRefId: sp.SysAccountProjectRefId,
		SupportRoleTypes:       supportRoleTypesByte,
		UserNeedTypes:          userNeedTypesByte,
		CreatedAt:              sharedConfig.UnixToUtcTS(sp.CreatedAt),
		UpdatedAt:              sharedConfig.UnixToUtcTS(sp.UpdatedAt),
	}, nil
}

func (sp SurveyProject) CreateSQL() []string {
	fields := sysCoreSvc.GetStructTags(sp)
	tbl := sysCoreSvc.NewTable(SurveyProjectTableName, fields, []string{surveyProjectUniqueIndex})
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
	res.Close()
	return surveyProjects, &surveyProjects[len(surveyProjects)-1].CreatedAt, nil
}

func (m *ModDiscoDB) InsertSurveyProject(sp *discoRpc.NewSurveyProjectRequest) (*discoRpc.SurveyProject, error) {
	newPkgSurveyProject := &discoRpc.SurveyProject{
		SurveyProjectId:        sysCoreSvc.NewID(),
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
			var s SupportRoleValue
			if err := json.Unmarshal(srv, &s); err != nil {
				return nil, err
			}
			supportRoleValue := NewSupportRoleValue(s.Id, s.SurveyUserRefId, s.SupportRoleTypeRefId, s.Comment, s.Pledged)
			if err := m.InsertSupportRoleValue(supportRoleValue); err != nil {
				return nil, err
			}
		}
	}

	if sp.GetUserNeedTypes() != nil && len(sp.GetUserNeedTypes()) != 0 {
		for _, srv := range sp.GetUserNeedTypes() {
			var u UserNeedsType
			if err := json.Unmarshal(srv, &u); err != nil {
				return nil, err
			}
			userNeedsType := NewUserNeedsType(u.Id, u.SurveyProjectRefId, u.Name, u.Comment, u.Description, u.UnitOfMeasures)
			if err := m.InsertUserNeedsType(userNeedsType); err != nil {
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
			if err := json.Unmarshal(srv, &s); err != nil {
				return err
			}
			actualSrv, err := m.GetSupportRoleType(s.Id)
			if err != nil {
				if err.Error() == "document not found" {
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
			if err := json.Unmarshal(srv, &u); err != nil {
				return err
			}
			actualUnv, err := m.GetUserNeedsType(u.Id)
			if err != nil {
				if err.Error() == "document not found" {
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
