package repo

import (
	"context"
	"fmt"
	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"

	sharedCore "github.com/getcouragenow/sys-share/sys-core/service/go/pkg"
	sharedBus "github.com/getcouragenow/sys-share/sys-core/service/go/pkg/bus"
	"github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
)

func (md *ModDiscoRepo) onDeleteDiscoProject(ctx context.Context, in *sharedCore.EventRequest) (map[string]interface{}, error) {
	const sysAccountProjectIdKey = "sys_account_project_ref_id"
	const discoProjectIdKey = "project_id"
	requestMap := make(chan map[string]string, 1)
	errChan := make(chan error, 1)
	var err error

	go func() {
		rmap, err := coredb.UnmarshalToMap(in.JsonPayload)
		if err != nil {
			errChan <- err
		}
		if rmap[discoProjectIdKey] != nil && rmap[discoProjectIdKey].(string) != "" {
			requestMap <- map[string]string{
				discoProjectIdKey: rmap[discoProjectIdKey].(string),
			}
		}
		if rmap[sysAccountProjectIdKey] != nil && rmap[sysAccountProjectIdKey].(string) != "" {
			requestMap <- map[string]string{
				sysAccountProjectIdKey: rmap[sysAccountProjectIdKey].(string),
			}
		}
		errChan <- sharedBus.Error{
			Reason: sharedBus.ErrInvalidEventPayload,
			Err:    fmt.Errorf("no valid %s or %s found", discoProjectIdKey, sysAccountProjectIdKey),
		}
	}()
	if err = <-errChan; err != nil {
		return nil, err
	}
	close(errChan)
	rmap := <-requestMap
	close(requestMap)
	for k, v := range rmap {
		switch k {
		case discoProjectIdKey:
			if _, err := md.DeleteDiscoProject(ctx, &discoRpc.IdRequest{DiscoProjectId: v}); err != nil {
				return nil, err
			}

		case sysAccountProjectIdKey:
			if _, err := md.DeleteDiscoProject(ctx, &discoRpc.IdRequest{SysAccountProjectId: v}); err != nil {
				return nil, err
			}
		default:
			return nil, sharedBus.Error{
				Reason: sharedBus.ErrInvalidEventPayload,
				Err:    fmt.Errorf("%s or %s id is not valid", discoProjectIdKey, sysAccountProjectIdKey),
			}
		}
	}
	return map[string]interface{}{
		"success":    true,
		"successMsg": "successfully deleted disco projects",
	}, nil
}

func (md *ModDiscoRepo) onDeleteSurveyProject(ctx context.Context, in *sharedCore.EventRequest) (map[string]interface{}, error) {
	const sysAccountProjectIdKey = "sys_account_project_ref_id"
	const surveyProjectIdKey = "survey_project_id"
	requestMap := make(chan map[string]string, 1)
	errChan := make(chan error, 1)
	var err error

	go func() {
		rmap, err := coredb.UnmarshalToMap(in.JsonPayload)
		if err != nil {
			errChan <- err
		}
		if rmap[surveyProjectIdKey] != nil && rmap[surveyProjectIdKey].(string) != "" {
			requestMap <- map[string]string{
				surveyProjectIdKey: rmap[surveyProjectIdKey].(string),
			}
		}
		if rmap[sysAccountProjectIdKey] != nil && rmap[sysAccountProjectIdKey].(string) != "" {
			requestMap <- map[string]string{
				sysAccountProjectIdKey: rmap[sysAccountProjectIdKey].(string),
			}
		}
		errChan <- sharedBus.Error{
			Reason: sharedBus.ErrInvalidEventPayload,
			Err:    fmt.Errorf("no valid %s or %s found", surveyProjectIdKey, sysAccountProjectIdKey),
		}
	}()
	if err = <-errChan; err != nil {
		return nil, err
	}
	close(errChan)
	rmap := <-requestMap
	close(requestMap)
	for k, v := range rmap {
		switch k {
		case sysAccountProjectIdKey:
			if _, err := md.DeleteSurveyProject(ctx, &discoRpc.IdRequest{SysAccountProjectId: v}); err != nil {
				return nil, err
			}

		case surveyProjectIdKey:
			if _, err := md.DeleteSurveyProject(ctx, &discoRpc.IdRequest{SurveyProjectId: v}); err != nil {
				return nil, err
			}
		default:
			return nil, sharedBus.Error{
				Reason: sharedBus.ErrInvalidEventPayload,
				Err:    fmt.Errorf("%s or %s id is not valid", surveyProjectIdKey, sysAccountProjectIdKey),
			}
		}
	}
	return map[string]interface{}{
		"success":    true,
		"successMsg": "successfully deleted survey projects",
	}, nil
}

func (md *ModDiscoRepo) onDeleteSurveyUser(ctx context.Context, in *sharedCore.EventRequest) (map[string]interface{}, error) {
	const sysAccountAccountIdKey = "sys_account_project_ref_id"
	const surveyUserIdKey = "survey_user_id"
	requestMap := make(chan map[string]string, 1)
	errChan := make(chan error, 1)
	var err error

	go func() {
		rmap, err := coredb.UnmarshalToMap(in.JsonPayload)
		if err != nil {
			errChan <- err
		}
		if rmap[surveyUserIdKey] != nil && rmap[surveyUserIdKey].(string) != "" {
			requestMap <- map[string]string{
				surveyUserIdKey: rmap[surveyUserIdKey].(string),
			}
		}
		if rmap[sysAccountAccountIdKey] != nil && rmap[sysAccountAccountIdKey].(string) != "" {
			requestMap <- map[string]string{
				sysAccountAccountIdKey: rmap[sysAccountAccountIdKey].(string),
			}
		}
		errChan <- sharedBus.Error{
			Reason: sharedBus.ErrInvalidEventPayload,
			Err:    fmt.Errorf("no valid %s or %s found", surveyUserIdKey, sysAccountAccountIdKey),
		}
	}()
	if err = <-errChan; err != nil {
		return nil, err
	}
	close(errChan)
	rmap := <-requestMap
	close(requestMap)
	for k, v := range rmap {
		switch k {
		case sysAccountAccountIdKey:
			if _, err := md.DeleteSurveyUser(ctx, &discoRpc.IdRequest{SysAccountAccountId: v}); err != nil {
				return nil, err
			}

		case surveyUserIdKey:
			if _, err := md.DeleteSurveyUser(ctx, &discoRpc.IdRequest{SurveyUserId: v}); err != nil {
				return nil, err
			}
		default:
			return nil, sharedBus.Error{
				Reason: sharedBus.ErrInvalidEventPayload,
				Err:    fmt.Errorf("%s or %s id is not valid", surveyUserIdKey, sysAccountAccountIdKey),
			}
		}
	}
	return map[string]interface{}{
		"success":    true,
		"successMsg": "successfully deleted survey projects",
	}, nil
}
