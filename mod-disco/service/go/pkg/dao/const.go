package dao

// const.go contains
// all the table columns / fields basically.
const (
	SurveyProjectTableName = "survey_projects"
	SurveyUsersTableName   = "survey_users"
	DiscoProjectTableName  = "projects"
	SupportRoleTypesTable  = "support_role_types"
	SupportRoleValuesTable = "support_role_values"
	UserNeedTypesTable     = "user_need_types"
	UserNeedValuesTable    = "user_need_values"
	DefaultLimit           = 50
	DefaultCursor          = `created_at`
)
