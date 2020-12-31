package dao

import (
	"fmt"
	sq "github.com/Masterminds/squirrel"
	"github.com/genjidb/genji/document"
	log "github.com/sirupsen/logrus"

	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sharedConfig "github.com/getcouragenow/sys-share/sys-core/service/config"
	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
)

type DiscoProject struct {
	ProjectId              string   `json:"projectId,omitempty" genji:"project_id" coredb:"primary"`
	SysAccountProjectRefId string   `json:"sysAccountProjectRefId,omitempty" genji:"sys_account_project_ref_id" coredb:"not_null"`
	SysAccountOrgRefId     string   `json:"SysAccountOrgRefId,omitempty" genji:"sys_account_org_ref_id"`
	Goal                   string   `json:"goal,omitempty" genji:"goal"`
	AlreadyPledged         uint64   `json:"alreadyPledged,omitempty" genji:"already_pledged"`
	ActionTime             int64    `json:"actionTime,omitempty" genji:"action_time"`
	ActionLocation         string   `json:"actionLocation,omitempty" genji:"action_location"`
	MinPioneers            uint64   `json:"minPioneers,omitempty" genji:"min_pioneers"`
	MinRebelsMedia         uint64   `json:"minRebelsMedia,omitempty" genji:"min_rebels_media"`
	MinRebelsToWin         uint64   `json:"minRebelsToWin,omitempty" genji:"min_rebels_to_win"`
	ActionLength           string   `json:"actionLength,omitempty" genji:"action_length"`
	ActionType             string   `json:"actionType,omitempty" genji:"action_type"`
	Category               string   `json:"category,omitempty" genji:"category"`
	Contact                string   `json:"contact,omitempty" genji:"contact"`
	HistPrecedents         string   `json:"histPrecedents,omitempty" genji:"hist_precedents"`
	Strategy               string   `json:"strategy,omitempty" genji:"strategy"`
	VideoUrl               []string `json:"videoUrl,omitempty" genji:"video_url"`
	ImageResourceIds       []string `json:"imageResourceIds,omitempty" genji:"image_resource_ids"`
	UnitOfMeasures         string   `json:"unitOfMeasures,omitempty" genji:"unit_of_measures"`
	CreatedAt              int64    `json:"createdAt,omitempty" genji:"created_at"`
	UpdatedAt              int64    `json:"updatedAt,omitempty" genji:"updated_at"`
}

var (
	discoProjectUniqueKey1 = fmt.Sprintf("CREATE UNIQUE INDEX IF NOT EXISTS idx_%s_sys_account_ref ON %s(sys_account_project_ref_id)", DiscoProjectTableName, DiscoProjectTableName)
)

func (m *ModDiscoDB) FromPkgDiscoProject(dp *discoRpc.DiscoProject) (*DiscoProject, error) {
	projectId := dp.ProjectId
	if projectId == "" {
		projectId = sharedConfig.NewID()
	}
	vidUrl := []string{}
	if dp.GetVideoUrl() == nil {
		dp.VideoUrl = vidUrl
	}
	return &DiscoProject{
		ProjectId:              projectId,
		SysAccountProjectRefId: dp.SysAccountProjectRefId,
		SysAccountOrgRefId:     dp.SysAccountOrgRefId,
		Goal:                   dp.Goal,
		AlreadyPledged:         dp.AlreadyPledged,
		ActionTime:             dp.ActionTime.AsTime().UnixNano(),
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
		CreatedAt:              int64(dp.GetCreatedAt().GetNanos()),
		UpdatedAt:              int64(dp.GetUpdatedAt().GetNanos()),
	}, nil
}

func (m *ModDiscoDB) FromNewPkgDiscoProject(dp *discoRpc.NewDiscoProjectRequest, imageResourceIds []string) (*DiscoProject, error) {
	vidUrl := []string{}
	if dp.GetVideoUrl() == nil {
		dp.VideoUrl = vidUrl
	}
	imgResourceIds := []string{}
	if imageResourceIds != nil {
		imgResourceIds = imageResourceIds
	}
	return &DiscoProject{
		ProjectId:              sharedConfig.NewID(),
		SysAccountProjectRefId: dp.SysAccountProjectRefId,
		SysAccountOrgRefId:     dp.SysAccountOrgRefId,
		Goal:                   dp.Goal,
		AlreadyPledged:         dp.AlreadyPledged,
		ActionTime:             dp.GetActionTimeNano(),
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
		CreatedAt:              sharedConfig.CurrentTimestamp(),
		UpdatedAt:              sharedConfig.CurrentTimestamp(),
		ImageResourceIds:       imgResourceIds,
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
		ImageResourceIds:       dp.ImageResourceIds,
	}, nil
}

func (dp DiscoProject) CreateSQL() []string {
	fields := sysCoreSvc.GetStructTags(dp)
	tbl := sysCoreSvc.NewTable(DiscoProjectTableName, fields, []string{discoProjectUniqueKey1})
	return tbl.CreateTable()
}

func (m *ModDiscoDB) GetDiscoProject(filters map[string]interface{}) (*DiscoProject, error) {
	var dp DiscoProject
	selectStmt, args, err := sysCoreSvc.BaseQueryBuilder(
		filters,
		DiscoProjectTableName,
		m.discoProjectColumns,
		"eq",
	).ToSql()
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

func (m *ModDiscoDB) ListDiscoProject(filters map[string]interface{}, orderBy string, limit, cursor int64, sqlMatcher string) ([]*DiscoProject, *int64, error) {
	var discoProjects []*DiscoProject
	baseStmt := sysCoreSvc.BaseQueryBuilder(
		filters,
		DiscoProjectTableName,
		m.discoProjectColumns,
		sqlMatcher,
	)
	// baseStmt := m.discoProjectLikeFilter(filters)
	selectStmt, args, err := sysCoreSvc.ListSelectStatement(baseStmt, orderBy, limit, &cursor, DefaultCursor)
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
	res.Close()
	if len(discoProjects) == 1 {
		next := int64(0)
		return discoProjects, &next, nil
	}
	return discoProjects, &discoProjects[len(discoProjects)-1].CreatedAt, nil
}

func (m *ModDiscoDB) InsertDiscoProject(dp *discoRpc.NewDiscoProjectRequest, imageResourceIds []string) (*discoRpc.DiscoProject, error) {
	newPkgDiscoReq, err := m.FromNewPkgDiscoProject(dp, imageResourceIds)
	if err != nil {
		return nil, err
	}
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
	filterParam.Params["updated_at"] = sharedConfig.CurrentTimestamp()
	if filterParam.Params["goal"] == "" {
		delete(filterParam.Params, "goal")
	}
	if filterParam.Params["already_pledged"] == 0 {
		delete(filterParam.Params, "already_pledged")
	}
	if udp.GetActionTime() == nil {
		delete(filterParam.Params, "action_time")
	}
	if udp.GetActionTime() != nil {
		filterParam.Params["action_time"] = sharedConfig.TsToUnixUTC(udp.GetActionTime())
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
	if udp.GetImageResourceIds() == nil {
		delete(filterParam.Params, "image_resource_ids")
	} else {
		for _, v := range dp.ImageResourceIds {
			dp.ImageResourceIds = append(dp.ImageResourceIds, v)
		}
		dp.ImageResourceIds = sharedConfig.DedupSlice(dp.ImageResourceIds)
		filterParam.Params["image_resource_ids"] = dp.ImageResourceIds
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
