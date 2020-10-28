package dao

import sq "github.com/Masterminds/squirrel"

func (m *ModDiscoDB) listSelectStatement(baseStmt sq.SelectBuilder, orderBy string, limit int64, cursor *int64) (string, []interface{}, error) {
	var csr int
	if cursor == nil {
		csr = 0
	}
	baseStmt.Where(sq.GtOrEq{DefaultCursor: csr}).Limit(uint64(limit)).OrderBy(orderBy)
	return baseStmt.ToSql()
}
