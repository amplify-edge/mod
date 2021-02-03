package repo

import (
	"context"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	corepkg "github.com/amplify-cms/sys-share/sys-core/service/go/pkg"
	sysCoreSvc "github.com/amplify-cms/sys/sys-core/service/go/pkg/coredb"
)

// permission check using in-process messaging
type sysAllowInput struct {
	eventName string `json:"event_name"`
	orgId     string `json:"org_id"`
	projectId string `json:"project_id"`
	userId    string `json:"user_id"`
}

// checkAllow checks for permission from the sys-account via the in-process messaging
// if allowed, it will proceed.
func (md *ModDiscoRepo) checkAllow(ctx context.Context, in *sysAllowInput) (bool, error) {
	params := map[string]interface{}{}
	if in.orgId != "" {
		params[in.orgId] = in.orgId
	}
	if in.projectId != "" {
		params[in.projectId] = in.projectId
	}
	payloadBytes, err := sysCoreSvc.MarshalToBytes(params)
	if err != nil {
		return false, err
	}
	resp, err := md.busClient.Broadcast(ctx, &corepkg.EventRequest{
		EventName:   in.eventName,
		Initiator:   moduleName,
		JsonPayload: payloadBytes,
	})
	if err != nil {
		return false, err
	}
	replyResp, err := sysCoreSvc.UnmarshalToMap(resp.Reply)
	if err != nil {
		return false, err
	}
	if !replyResp["allowed"].(bool) {
		return false, status.Errorf(codes.PermissionDenied, "is not allowed")
	}
	return true, nil
}

// DiscoProject creation, update, and delete should be only available for superadmins, org-admin of the project,
// and the project admin itself.
func (md *ModDiscoRepo) allowDiscoProject(ctx context.Context, orgId, projectId string) bool {
	in := &sysAllowInput{
		eventName: "onCheckAllowProject",
		orgId:     orgId,
		projectId: projectId,
	}
	allowed, err := md.checkAllow(ctx, in)
	if err != nil {
		md.log.Debugf("error while checking for permission on create new disco project: %v", err)
		return false
	}
	return allowed
}

// SurveyUser update and delete should only be available for either superuser or its own user.
func (md *ModDiscoRepo) allowSurveyUser(ctx context.Context, userId string) bool {
	in := &sysAllowInput{
		eventName: "onCheckAllowSurveyUser",
		userId:    userId,
	}
	allowed, err := md.checkAllow(ctx, in)
	if err != nil {
		md.log.Debugf("error while checking for permission on create new disco project: %v", err)
		return false
	}
	return allowed
}
