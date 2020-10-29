package repo

import (
	"strconv"
)

func (md *ModDiscoRepo) getCursor(currentCursor string) (int64, error) {
	if currentCursor != "" {
		return strconv.ParseInt(currentCursor, 10, 64)
	} else {
		return 0, nil
	}
}
