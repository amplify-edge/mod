package repo

import (
	"context"
	corepkg "github.com/getcouragenow/sys-share/sys-core/service/go/pkg"
	"strconv"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	sysCoreSvc "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
)

func (md *ModDiscoRepo) getCursor(currentCursor string) (int64, error) {
	if currentCursor != "" {
		return strconv.ParseInt(currentCursor, 10, 64)
	} else {
		return 0, nil
	}
}

func (md *ModDiscoRepo) surveyProjectExists(surveyProjectId, surveyProjectName string) (bool, string) {
	const surveyProjectIdKey = "survey_project_id"
	const surveyProjectNameKey = "survey_project_name"
	params := map[string]interface{}{}
	if surveyProjectId != "" {
		params[surveyProjectIdKey] = surveyProjectId
	}
	if surveyProjectName != "" {
		params[surveyProjectNameKey] = surveyProjectName
	}
	sp, err := md.store.GetSurveyProject(params)
	if err != nil {
		return false, ""
	}
	return true, sp.SurveyProjectId
}

func (md *ModDiscoRepo) sysAccountUserExists(ctx context.Context, accountId, accountEmail string) (bool, string, error) {
	const accountIdKey = "sys_account_user_ref_id"
	const accountNameKey = "sys_account_user_ref_name"
	in := newSysExistsInput(accountIdKey, accountNameKey, accountId, accountEmail, "onCheckAccountExists")
	return md.checkExists(ctx, in)
}

func (md *ModDiscoRepo) sysAccountProjectExists(ctx context.Context, projectId, projectName string) (bool, string, error) {
	const (
		projectIdKey   = "sys_account_project_ref_id"
		projectNameKey = "sys_account_project_ref_name"
	)
	in := newSysExistsInput(projectIdKey, projectNameKey, projectId, projectName, "onCheckProjectExists")
	return md.checkExists(ctx, in)
}

type sysExistsInput struct {
	idKey     string
	nameKey   string
	idInput   string
	nameInput string
	eventName string
}

func newSysExistsInput(idKey, nameKey, idInput, nameInput, eventName string) *sysExistsInput {
	return &sysExistsInput{
		idKey:     idKey,
		nameKey:   nameKey,
		idInput:   idInput,
		nameInput: nameInput,
		eventName: eventName,
	}
}

func (md *ModDiscoRepo) checkExists(ctx context.Context, in *sysExistsInput) (bool, string, error) {
	params := map[string]interface{}{}
	if in.idInput != "" {
		params[in.idKey] = in.idInput
	}
	if in.nameInput != "" {
		params[in.nameKey] = in.nameInput
	}
	payloadBytes, err := sysCoreSvc.MarshalToBytes(params)
	if err != nil {
		return false, "", err
	}
	resp, err := md.busClient.Broadcast(ctx, &corepkg.EventRequest{
		EventName:   in.eventName,
		Initiator:   moduleName,
		JsonPayload: payloadBytes,
	})
	if err != nil {
		return false, "", err
	}
	replyResp, err := sysCoreSvc.UnmarshalToMap(resp.Reply)
	if err != nil {
		return false, "", err
	}
	if !replyResp["exists"].(bool) {
		return false, "", status.Errorf(codes.InvalidArgument, "does not exists")
	}
	return true, replyResp[in.idKey].(string), nil
}
