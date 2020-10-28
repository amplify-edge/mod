package dao

import (
	"github.com/segmentio/encoding/json"
	coredb "github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
)

type SurveyProject struct {
	SurveyProjectId string `genji:"survey_project_id"`
	SysAccountProjectRefId string `genji:"sys_account_project_ref_id"`
}