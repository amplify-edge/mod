package dao

import sq "github.com/Masterminds/squirrel"

func (m *ModDiscoDB) listSelectStatement(baseStmt sq.SelectBuilder, orderBy string, limit int64, cursor *int64) (string, []interface{}, error) {
	csr := *cursor
	if cursor == nil {
		csr = 0
	}
	baseStmt = baseStmt.Where(sq.Gt{DefaultCursor: csr})
	baseStmt = baseStmt.Limit(uint64(limit)).OrderBy(orderBy)
	return baseStmt.ToSql()
}
