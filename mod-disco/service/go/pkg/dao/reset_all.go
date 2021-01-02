package dao

import "fmt"

func delAllStmt(tblName string) string {
	return fmt.Sprintf("DELETE FROM %s", tblName)
}

func (m *ModDiscoDB) ResetAll() error {
	deleteUserNeedsValue := delAllStmt(UserNeedValuesTable)
	deleteSupportRoleValue := delAllStmt(SupportRoleValuesTable)
	deleteSurveyUsers := delAllStmt(SurveyUsersTableName)
	deleteUserNeedsType := delAllStmt(UserNeedTypesTable)
	deleteSupportRoleType := delAllStmt(SupportRoleTypesTable)
	deleteSurveyProject := delAllStmt(SurveyProjectTableName)
	deleteDiscoProject := delAllStmt(DiscoProjectTableName)

	return m.db.BulkExec(map[string][]interface{}{
		deleteUserNeedsValue:   nil,
		deleteSupportRoleValue: nil,
		deleteSurveyUsers:      nil,
		deleteUserNeedsType:    nil,
		deleteSupportRoleType:  nil,
		deleteSurveyProject:    nil,
		deleteDiscoProject:     nil,
	})
}
