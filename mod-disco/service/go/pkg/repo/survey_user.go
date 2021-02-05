package repo

import (
	"context"
	"fmt"
	"github.com/VictoriaMetrics/metrics"
	"go.amplifyedge.org/mod-v2/mod-disco/service/go/pkg/dao"
	"go.amplifyedge.org/mod-v2/mod-disco/service/go/pkg/telemetry"
	discoRpc "go.amplifyedge.org/mod-v2/mod-disco/service/go/rpc/v2"
	sharedAuth "go.amplifyedge.org/sys-share-v2/sys-account/service/go/pkg/shared"
	sysCoreSvc "go.amplifyedge.org/sys-v2/sys-core/service/go/pkg/coredb"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
)

func (md *ModDiscoRepo) NewSurveyUser(ctx context.Context, in *discoRpc.NewSurveyUserRequest) (*discoRpc.SurveyUser, error) {
	if in == nil {
		return nil, status.Errorf(codes.InvalidArgument, "cannot insert survey user: %v", sharedAuth.Error{Reason: sharedAuth.ErrInvalidParameters})
	}
	exists, accountId, err := md.sysAccountUserExists(ctx, in.SysAccountUserRefId, in.SysAccountUserRefName)
	if err != nil || !exists {
		return nil, status.Errorf(codes.InvalidArgument, "no user account exists with id: %s or name: %s", in.SysAccountUserRefId, in.SysAccountUserRefName)
	}
	in.SysAccountUserRefId = accountId
	surveyProjectExists, surveyProjectId := md.surveyProjectExists(in.SurveyProjectRefId, in.SurveyProjectRefName)
	if !surveyProjectExists {
		return nil, status.Errorf(codes.InvalidArgument, "no survey project exists with id: %s or name: %s", in.SurveyProjectRefId, in.SurveyProjectRefName)
	}
	in.SurveyProjectRefId = surveyProjectId
	surveyProject, err := md.GetSurveyProject(ctx, &discoRpc.IdRequest{SurveyProjectId: surveyProjectId})
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "no survey project exists with id: %s", in.SurveyProjectRefId)
	}
	discoProject, err := md.GetDiscoProject(ctx, &discoRpc.IdRequest{SysAccountProjectId: surveyProject.SysAccountProjectRefId})
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "no project exists with id: %s", surveyProject.SysAccountProjectRefId)
	}
	if err = md.store.UpdateDiscoProject(&discoRpc.UpdateDiscoProjectRequest{
		ProjectId:      discoProject.GetProjectId(),
		AlreadyPledged: discoProject.GetAlreadyPledged() + 1,
	}); err != nil {
		return nil, err
	}

	sp, err := md.store.InsertSurveyUser(in)
	if err != nil {
		return nil, err
	}

	alreadyPledgedMetrics := metrics.GetOrCreateCounter(fmt.Sprintf(telemetry.ModDiscoLabelledMetricsFormat, telemetry.METRICS_ALREADY_PLEDGED, discoProject.SysAccountProjectRefId, discoProject.ProjectId))
	go func() {
		alreadyPledgedMetrics.Inc()
	}()

	return sp, nil
}

func (md *ModDiscoRepo) GetSurveyUser(ctx context.Context, in *discoRpc.IdRequest) (*discoRpc.SurveyUser, error) {
	if in == nil || (in.SurveyUserId == "" && in.SurveyProjectId == "" && in.SysAccountAccountId == "") {
		return nil, status.Errorf(codes.InvalidArgument, "cannot get survey user: %v", sharedAuth.Error{Reason: sharedAuth.ErrInvalidParameters})
	}
	params := map[string]interface{}{}
	if in.GetSurveyProjectId() != "" {
		params["survey_project_id"] = in.GetSurveyProjectId()
	}
	if in.GetSurveyUserId() != "" {
		params["survey_user_id"] = in.GetSurveyUserId()
	}
	if in.GetSysAccountAccountId() != "" {
		params["sys_account_account_ref_id"] = in.GetSysAccountAccountId()
	}
	if in.GetSysAccountProjectId() != "" {
		params["sys_account_project_ref_id"] = in.GetSysAccountProjectId()
	}
	sp, err := md.store.GetSurveyUser(params)
	if err != nil {
		return nil, err
	}
	return md.store.ToPkgSurveyUser(sp)
}

func (md *ModDiscoRepo) ListSurveyUser(ctx context.Context, in *discoRpc.ListRequest) (*discoRpc.ListResponse, error) {
	if in == nil {
		return nil, status.Errorf(codes.InvalidArgument, "cannot list survey user: %v", sharedAuth.Error{Reason: sharedAuth.ErrInvalidParameters})
	}
	var cursor int64
	orderBy := in.OrderBy
	var err error
	filter := map[string]interface{}{}
	if in.Filters != nil && len(in.Filters) > 0 {
		filter, err = sysCoreSvc.UnmarshalToMap(in.Filters)
		if err != nil {
			return nil, err
		}
	}
	if in.IdRequest != nil {
		if in.IdRequest.SurveyUserId != "" {
			filter["survey_user_id"] = in.IdRequest.SurveyUserId
		}
		if in.IdRequest.SurveyProjectId != "" {
			filter["survey_project_id"] = in.IdRequest.SurveyProjectId
		}
		if in.IdRequest.SysAccountProjectId != "" {
			filter["sys_account_project_ref_id"] = in.IdRequest.SysAccountProjectId
		}
		if in.IdRequest.SysAccountAccountId != "" {
			filter["sys_account_account_ref_id"] = in.IdRequest.SysAccountAccountId
		}
	}
	cursor, err = md.getCursor(in.GetCurrentPageId())
	if err != nil {
		return nil, err
	}
	if in.GetIsDescending() {
		orderBy += " DESC"
	} else {
		orderBy += " ASC"
	}
	limit := in.PerPageEntries
	if limit == 0 {
		limit = dao.DefaultLimit
	}
	daoSurveyUsers, next, err := md.store.ListSurveyUser(filter, orderBy, limit, cursor, in.GetMatcher())
	if err != nil {
		return nil, err
	}
	var pkgSurveyUsers []*discoRpc.SurveyUser
	for _, su := range daoSurveyUsers {
		surveyUser, err := md.store.ToPkgSurveyUser(su)
		if err != nil {
			return nil, err
		}
		pkgSurveyUsers = append(pkgSurveyUsers, surveyUser)
	}
	return &discoRpc.ListResponse{
		SurveyUsers: pkgSurveyUsers,
		NextPageId:  *next,
	}, nil
}

func (md *ModDiscoRepo) UpdateSurveyUser(ctx context.Context, in *discoRpc.UpdateSurveyUserRequest) (*discoRpc.SurveyUser, error) {
	if in == nil || in.SurveyUserId == "" {
		return nil, status.Errorf(codes.InvalidArgument, "cannot update survey user: %v", sharedAuth.Error{Reason: sharedAuth.ErrInvalidParameters})
	}
	daoSurveyUser, err := md.store.GetSurveyUser(map[string]interface{}{"survey_user_id": in.SurveyUserId})
	if err != nil {
		return nil, err
	}
	allowed := md.allowSurveyUser(ctx, daoSurveyUser.SysAccountAccountRefId)
	if !allowed {
		return nil, status.Errorf(codes.PermissionDenied, "cannot insert disco project: permission denied", sharedAuth.Error{Reason: sharedAuth.ErrInsufficientRights})
	}
	if err := md.store.UpdateSurveyUser(in); err != nil {
		return nil, err
	}
	daoSurveyUser, err = md.store.GetSurveyUser(map[string]interface{}{"survey_user_id": in.SurveyUserId})
	if err != nil {
		return nil, err
	}
	return md.store.ToPkgSurveyUser(daoSurveyUser)
}

func (md *ModDiscoRepo) DeleteSurveyUser(ctx context.Context, in *discoRpc.IdRequest) (*emptypb.Empty, error) {
	if in == nil || in.SurveyUserId == "" {
		return nil, status.Errorf(codes.InvalidArgument, "cannot delete survey user: %v", sharedAuth.Error{Reason: sharedAuth.ErrInvalidParameters})
	}
	daoSurveyUser, err := md.store.GetSurveyUser(map[string]interface{}{"survey_user_id": in.SurveyUserId})
	if err != nil {
		return nil, err
	}
	allowed := md.allowSurveyUser(ctx, daoSurveyUser.SysAccountAccountRefId)
	if !allowed {
		return nil, status.Errorf(codes.PermissionDenied, "cannot insert disco project: permission denied", sharedAuth.Error{Reason: sharedAuth.ErrInsufficientRights})
	}
	err = md.store.DeleteSurveyUser(in.SurveyProjectId)
	if err != nil {
		return nil, err
	}
	return &emptypb.Empty{}, nil
}

func (md *ModDiscoRepo) GetProjectStatistics(ctx context.Context, in *discoRpc.StatisticRequest) (*discoRpc.StatisticResponse, error) {
	if in == nil {
		return nil, status.Errorf(codes.InvalidArgument, "cannot get project statistics: %v", "invalid argument")
	}
	var cursor int64
	orderBy := in.GetOrderBy()
	var err error
	filter := map[string]interface{}{}
	if in.GetFilters() != nil && len(in.GetFilters()) > 0 {
		filter, err = sysCoreSvc.UnmarshalToMap(in.GetFilters())
		if err != nil {
			return nil, err
		}
	}
	cursor, err = md.getCursor(in.GetCurrentPageId())
	if err != nil {
		return nil, err
	}
	if in.GetIsDescending() {
		orderBy += " DESC"
	} else {
		orderBy += " ASC"
	}
	limit := in.GetPerPageEntries()
	if limit == 0 {
		limit = dao.DefaultLimit
	}
	return md.store.GetStats(ctx, filter, limit, cursor, in.GetTableName(), orderBy, md.busClient)
}
