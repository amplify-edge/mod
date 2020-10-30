package dao

import (
	"fmt"
	sq "github.com/Masterminds/squirrel"
	"github.com/genjidb/genji/document"
	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sharedConfig "github.com/getcouragenow/sys-share/sys-core/service/config"
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	log "github.com/sirupsen/logrus"
)

type DiscoProject struct {
	ProjectId              string   `json:"projectId" genji:"project_id"`
	SysAccountProjectRefId string   `json:"sysAccountProjectRefId" genji:"sys_account_project_ref_id"`
	SysAccountOrgRefId     string   `json:"SysAccountOrgRefId" genji:"sys_account_org_ref_id"`
	Goal                   string   `json:"goal" genji:"goal"`
	AlreadyPledged         uint64   `json:"alreadyPledged" genji:"already_pledged"`
	ActionTime             int64    `json:"actionTime" genji:"action_time"`
	ActionLocation         string   `json:"actionLocation" genji:"action_location"`
	MinPioneers            uint64   `json:"minPioneers" genji:"min_pioneers"`
	MinRebelsMedia         uint64   `json:"minRebelsMedia" genji:"min_rebels_media"`
	MinRebelsToWin         uint64   `json:"minRebelsToWin" genji:"min_rebels_to_win"`
	ActionLength           string   `json:"actionLength" genji:"action_length"`
	ActionType             string   `json:"actionType" genji:"action_type"`
	Category               string   `json:"category" genji:"category"`
	Contact                string   `json:"contact" genji:"contact"`
	HistPrecedents         string   `json:"histPrecedents" genji:"hist_precedents"`
	Strategy               string   `json:"strategy" genji:"strategy"`
	VideoUrl               []string `json:"videoUrl" genji:"video_url"`
	UnitOfMeasures         string   `json:"unitOfMeasures" genji:"unit_of_measures"`
	CreatedAt              int64    `json:"createdAt" genji:"created_at"`
	UpdatedAt              int64    `json:"updatedAt" genji:"updated_at"`
}

var (
	discoProjectUniqueKey1 = fmt.Sprintf("CREATE UNIQUE INDEX IF NOT EXISTS idx_%s_sys_account_ref ON %s(sys_account_project_ref_id)", DiscoProjectTableName, DiscoProjectTableName)
	discoProjectUniqueKey2 = fmt.Sprintf("CREATE UNIQUE INDEX IF NOT EXISTS idx_%s_sys_account_ref ON %s(sys_account_org_ref_id)", DiscoProjectTableName, DiscoProjectTableName)
)

func (m *ModDiscoDB) FromPkgDiscoProject(dp *discoRpc.DiscoProject) (*DiscoProject, error) {
	projectId := dp.ProjectId
	if projectId == "" {
		projectId = sysCoreSvc.NewID()
	}
	return &DiscoProject{
		ProjectId:              projectId,
		SysAccountProjectRefId: dp.SysAccountProjectRefId,
		SysAccountOrgRefId:     dp.SysAccountOrgRefId,
		Goal:                   dp.Goal,
		AlreadyPledged:         dp.AlreadyPledged,
		ActionTime:             dp.ActionTime.Seconds,
		ActionLocation:         dp.ActionLocation,
		MinPioneers:            dp.MinPioneers,
		MinRebelsMedia:         dp.MinRebelsMedia,
		MinRebelsToWin:         dp.MinRebelsToWin,
		ActionLength:           dp.GetActionLength(),
		ActionType:             dp.GetActionType(),
		Category:               dp.GetCategory(),
		Contact:                dp.GetContact(),
		HistPrecedents:         dp.GetHistPrecedents(),
		Strategy:               dp.GetStrategy(),
		VideoUrl:               dp.GetVideoUrl(),
		UnitOfMeasures:         dp.GetUnitOfMeasures(),
		CreatedAt:              dp.GetCreatedAt().Seconds,
		UpdatedAt:              dp.GetUpdatedAt().Seconds,
	}, nil
}

func (m *ModDiscoDB) FromNewPkgDiscoProject(dp *discoRpc.NewDiscoProjectRequest) (*DiscoProject, error) {
	return &DiscoProject{
		ProjectId:              sysCoreSvc.NewID(),
		SysAccountProjectRefId: dp.SysAccountProjectRefId,
		SysAccountOrgRefId:     dp.SysAccountOrgRefId,
		Goal:                   dp.Goal,
		AlreadyPledged:         dp.AlreadyPledged,
		ActionTime:             dp.ActionTime.Seconds,
		ActionLocation:         dp.ActionLocation,
		MinPioneers:            dp.MinPioneers,
		MinRebelsMedia:         dp.MinRebelsMedia,
		MinRebelsToWin:         dp.MinRebelsToWin,
		ActionLength:           dp.GetActionLength(),
		ActionType:             dp.GetActionType(),
		Category:               dp.GetCategory(),
		Contact:                dp.GetContact(),
		HistPrecedents:         dp.GetHistPrecedents(),
		Strategy:               dp.GetStrategy(),
		VideoUrl:               dp.GetVideoUrl(),
		UnitOfMeasures:         dp.GetUnitOfMeasures(),
		CreatedAt:              sysCoreSvc.CurrentTimestamp(),
		UpdatedAt:              sysCoreSvc.CurrentTimestamp(),
	}, nil
}

func (dp *DiscoProject) ToPkgDiscoProject() (*discoRpc.DiscoProject, error) {
	return &discoRpc.DiscoProject{
		ProjectId:              dp.ProjectId,
		SysAccountProjectRefId: dp.SysAccountProjectRefId,
		SysAccountOrgRefId:     dp.SysAccountOrgRefId,
		Goal:                   dp.Goal,
		AlreadyPledged:         dp.AlreadyPledged,
		ActionTime:             sharedConfig.UnixToUtcTS(dp.ActionTime),
		ActionLocation:         dp.ActionLocation,
		MinPioneers:            dp.MinPioneers,
		MinRebelsMedia:         dp.MinRebelsMedia,
		MinRebelsToWin:         dp.MinRebelsToWin,
		ActionLength:           dp.ActionLength,
		ActionType:             dp.ActionType,
		Category:               dp.Category,
		Contact:                dp.Contact,
		HistPrecedents:         dp.HistPrecedents,
		Strategy:               dp.Strategy,
		VideoUrl:               dp.VideoUrl,
		UnitOfMeasures:         dp.UnitOfMeasures,
		CreatedAt:              sharedConfig.UnixToUtcTS(dp.CreatedAt),
		UpdatedAt:              sharedConfig.UnixToUtcTS(dp.UpdatedAt),
	}, nil
}

func (dp DiscoProject) CreateSQL() []string {
	fields := initFields(DiscoProjectColumns, DiscoProjectColumnsType)
	tbl := sysCoreSvc.NewTable(DiscoProjectTableName, fields, []string{discoProjectUniqueKey1, discoProjectUniqueKey2})
	return tbl.CreateTable()
}

func (m *ModDiscoDB) discoProjectQueryFilter(filter map[string]interface{}) sq.SelectBuilder {
	baseStmt := sq.Select(DiscoProjectColumns).From(DiscoProjectTableName)
	if filter != nil {
		for k, v := range filter {
			baseStmt = baseStmt.Where(sq.Eq{k: v})
		}
	}
	return baseStmt
}

func (m *ModDiscoDB) GetDiscoProject(filters map[string]interface{}) (*DiscoProject, error) {
	var dp DiscoProject
	selectStmt, args, err := m.discoProjectQueryFilter(filters).ToSql()
	if err != nil {
		return nil, err
	}
	res, err := m.db.QueryOne(selectStmt, args...)
	if err != nil {
		return nil, err
	}
	m.log.WithFields(log.Fields{
		"queryStatement": selectStmt,
		"arguments":      args,
	}).Debugf("GetDiscoProject %s", DiscoProjectTableName)
	err = res.StructScan(&dp)
	if err != nil {
		return nil, err
	}
	return &dp, nil
}

func (m *ModDiscoDB) ListDiscoProject(filters map[string]interface{}, orderBy string, limit, cursor int64) ([]*DiscoProject, *int64, error) {
	var discoProjects []*DiscoProject
	baseStmt := m.discoProjectQueryFilter(filters)
	selectStmt, args, err := m.listSelectStatement(baseStmt, orderBy, limit, &cursor)
	if err != nil {
		return nil, nil, err
	}
	res, err := m.db.Query(selectStmt, args...)
	if err != nil {
		return nil, nil, err
	}
	err = res.Iterate(func(d document.Document) error {
		var discoProj DiscoProject
		if err = document.StructScan(d, &discoProj); err != nil {
			return err
		}
		discoProjects = append(discoProjects, &discoProj)
		return nil
	})
	if err != nil {
		return nil, nil, err
	}
	return discoProjects, &discoProjects[len(discoProjects)-1].CreatedAt, nil
}

func (m *ModDiscoDB) InsertDiscoProject(dp *discoRpc.NewDiscoProjectRequest) (*discoRpc.DiscoProject, error) {
	newPkgDiscoReq, err := m.FromNewPkgDiscoProject(dp)
	if err != nil {
		return nil, err
	}
	m.log.Warnf("CURRENT DISCO ID: %s", newPkgDiscoReq.ProjectId)
	queryParam, err := sysCoreSvc.AnyToQueryParam(newPkgDiscoReq, true)
	if err != nil {
		return nil, err
	}
	columns, values := queryParam.ColumnsAndValues()
	if len(columns) != len(values) {
		return nil, fmt.Errorf("error: length mismatch: cols: %d, vals: %d", len(columns), len(values))
	}
	stmt, args, err := sq.Insert(DiscoProjectTableName).
		Columns(columns...).
		Values(values...).
		ToSql()
	if err != nil {
		return nil, err
	}
	m.log.WithFields(log.Fields{
		"statement": stmt,
		"args":      args,
	}).Debugf("insert to %s table", DiscoProjectTableName)
	err = m.db.Exec(stmt, args...)
	if err != nil {
		return nil, err
	}
	daoDP, err := m.GetDiscoProject(map[string]interface{}{"project_id": newPkgDiscoReq.ProjectId})
	if err != nil {
		return nil, err
	}
	return daoDP.ToPkgDiscoProject()
}

func (m *ModDiscoDB) UpdateDiscoProject(udp *discoRpc.UpdateDiscoProjectRequest) error {
	dp, err := m.GetDiscoProject(map[string]interface{}{"project_id": udp.ProjectId})
	if err != nil {
		return err
	}
	filterParam, err := sysCoreSvc.AnyToQueryParam(udp, true)
	if err != nil {
		return err
	}
	delete(filterParam.Params, "project_id")
	delete(filterParam.Params, "sys_account_project_ref_id")
	delete(filterParam.Params, "updated_at")
	filterParam.Params["updated_at"] = sysCoreSvc.CurrentTimestamp()
	if filterParam.Params["goal"] == "" {
		delete(filterParam.Params, "goal")
	}
	if filterParam.Params["already_pledged"] == 0 {
		delete(filterParam.Params, "already_pledged")
	}
	if udp.GetActionTime() == nil {
		delete(filterParam.Params, "action_time")
	}
	if filterParam.Params["action_location"] == "" {
		delete(filterParam.Params, "action_location")
	}
	if udp.GetMinPioneers() == 0 {
		delete(filterParam.Params, "min_pioneers")
	}
	if udp.GetMinRebelsMedia() == 0 {
		delete(filterParam.Params, "min_rebels_media")
	}
	if udp.GetActionLength() == "" {
		delete(filterParam.Params, "action_length")
	}
	if udp.GetActionType() == "" {
		delete(filterParam.Params, "action_type")
	}
	if udp.GetCategory() == "" {
		delete(filterParam.Params, "category")
	}
	if udp.GetContact() == "" {
		delete(filterParam.Params, "contact")
	}
	if udp.GetHistPrecedents() == "" {
		delete(filterParam.Params, "hist_precedents")
	}
	if udp.GetStrategy() == "" {
		delete(filterParam.Params, "strategy")
	}
	if udp.GetVideoUrl() == "" {
		delete(filterParam.Params, "video_url")
	} else {
		dp.VideoUrl = append(dp.VideoUrl, udp.GetVideoUrl())
		filterParam.Params["video_url"] = dp.VideoUrl
	}
	if udp.GetUnitOfMeasures() == "" {
		delete(filterParam.Params, "unit_of_measures")
	}
	stmt, args, err := sq.Update(DiscoProjectTableName).SetMap(filterParam.Params).
		Where(sq.Eq{"project_id": dp.ProjectId}).ToSql()
	if err != nil {
		return err
	}
	return m.db.Exec(stmt, args...)
}

func (m *ModDiscoDB) DeleteDiscoProject(id, accountProjectId, accountOrgId string) error {
	var stmt string
	var args []interface{}
	var err error
	if id != "" {
		stmt, args, err = sq.Delete(DiscoProjectTableName).Where("project_id = ?", id).ToSql()
		if err != nil {
			return err
		}
	}
	if accountProjectId != "" {
		stmt, args, err = sq.Delete(DiscoProjectTableName).Where("sys_account_project_ref_id", accountProjectId).ToSql()
		if err != nil {
			return err
		}
	}
	if accountOrgId != "" {
		stmt, args, err = sq.Delete(DiscoProjectTableName).Where("sys_account_org_ref_id", accountOrgId).ToSql()
		if err != nil {
			return err
		}
	}

	return m.db.BulkExec(map[string][]interface{}{
		stmt: args,
	})
}
