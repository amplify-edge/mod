package repo

import (
	"context"
	"encoding/json"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	coreRpc "go.amplifyedge.org/sys-share-v2/sys-core/service/go/rpc/v2"
	sysCoreSvc "go.amplifyedge.org/sys-v2/sys-core/service/go/pkg/coredb"
)

// permission check using in-process messaging
type sysAllowInput struct {
	EventName string `json:"-"`
	OrgId     string `json:"org_id,omitempty"`
	ProjectId string `json:"project_id,omitempty"`
	UserId    string `json:"user_id,omitempty"`
}

// checkAllow checks for permission from the sys-account via the in-process messaging
// if allowed, it will proceed.
func (md *ModDiscoRepo) checkAllow(ctx context.Context, in *sysAllowInput) (bool, error) {
	payloadBytes, err := json.Marshal(in)
	if err != nil {
		return false, err
	}
	resp, err := md.busClient.Broadcast(ctx, &coreRpc.EventRequest{
		EventName:   in.EventName,
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
		EventName: "onCheckAllowProject",
		OrgId:     orgId,
		ProjectId: projectId,
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
		EventName: "onCheckAllowSurveyUser",
		UserId:    userId,
	}
	allowed, err := md.checkAllow(ctx, in)
	if err != nil {
		md.log.Debugf("error while checking for permission on create new disco project: %v", err)
		return false
	}
	return allowed
}
