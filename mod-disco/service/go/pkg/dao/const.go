package dao

import (
	"strings"
)

// const.go contains
// all the table columns / fields basically.
const (
	SurveyProjectTableName   = "survey_projects"
	SurveyUsersTableName     = "survey_users"
	SurveyProjectColumns     = `survey_project_id, sys_account_project_ref_id, survey_schema_types, survey_filter_types, created_at, updated_at`
	SurveyProjectColumnsType = `TEXT, TEXT, BLOB, BLOB, INT, INT`
	SurveyUsersColumns       = `survey_user_id, survey_project_ref_id, sys_account_account_ref_id, survey_schema_values, survey_schema_filters, created_at, updated_at`
	SurveyUsersColumnsType   = `TEXT, TEXT, TEXT, BLOB, BLOB, INT, INT`
	DefaultLimit             = 50
	DefaultCursor            = `created_at`
)

// initFields will only be called once during SurveyProjectountDB initialization (singleton)
func initFields(columns string, values string) map[string]string {
	ret := map[string]string{}
	vals := strings.Split(values, ",")
	for i, col := range strings.Split(columns, ",") {
		if i == 0 {
			ret[col] = vals[i] + " PRIMARY KEY"
		} else {
			ret[col] = vals[i]
		}
	}
	return ret
}
