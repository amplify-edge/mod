package pkg

import (
	sysSharePkg "github.com/getcouragenow/sys-share/sys-account/service/go/pkg"
	"google.golang.org/protobuf/types/known/structpb"

	accountRpc "github.com/getcouragenow/mod/mod-dummy/service/go/rpc/v2"
)

type Roles int32

func (r Roles) ToProto() accountRpc.Roles {
	return accountRpc.Roles(r)
}

func RolesFromProto(r accountRpc.Roles) Roles {
	return Roles(r.Number())
}

func RolesFromSys(r sysSharePkg.Roles) Roles {
	return Roles(r)
}

type UserRoles struct {
	Role      Roles  `json:"role,omitempty"`
	ProjectID string `json:"projectId,omitempty"`
	OrgID     string `json:"orgId,omitempty"`
	All       bool   `json:"all,omitempty"`
}

func (ur *UserRoles) ToProto() *accountRpc.UserRoles {
	role := ur.Role.ToProto()
	return &accountRpc.UserRoles{
		Role:    role,
		Project: &accountRpc.Project{Id: ur.ProjectID},
		Org:     &accountRpc.Org{Id: ur.OrgID},
		All:     ur.All,
	}
}

func UserRolesFromSys(in *sysSharePkg.UserRoles) *UserRoles {
	return &UserRoles{
		Role:      RolesFromSys(in.Role),
		ProjectID: in.ProjectID,
		OrgID:     in.OrgID,
		All:       in.All,
	}
}

func UserRolesFromProto(in *accountRpc.UserRoles) *UserRoles {
	return &UserRoles{
		Role:      RolesFromProto(in.GetRole()),
		ProjectID: in.GetProject().Id,
		OrgID:     in.GetOrg().Id,
		All:       in.GetAll(),
	}
}

type UserDefinedFields struct {
	Fields map[string]interface{} `json:"fields,omitempty"`
}

func UserDefinedFieldsFromProto(in *accountRpc.UserDefinedFields) *UserDefinedFields {
	fields := map[string]interface{}{}
	if in != nil {
		for k, v := range in.Fields {
			fields[k] = v
		}
	}
	return &UserDefinedFields{Fields: fields}
}

func (udf *UserDefinedFields) ToProto() (*accountRpc.UserDefinedFields, error) {
	userFields := map[string]*structpb.Value{}
	var err error
	for k, v := range udf.Fields {
		userFields[k], err = structpb.NewValue(v)
		if err != nil {
			return nil, err
		}
	}
	return &accountRpc.UserDefinedFields{Fields: userFields}, nil
}

type Account struct {
	Id        string             `json:"id,omitempty"`
	Email     string             `json:"email,omitempty"`
	Password  string             `json:"password,omitempty"`
	Role      *UserRoles         `json:"role,omitempty"`
	CreatedAt int64              `json:"created_at,omitempty"`
	UpdatedAt int64              `json:"updated_at,omitempty"`
	LastLogin int64              `json:"last_login,omitempty"`
	Disabled  bool               `json:"disabled,omitempty"`
	Fields    *UserDefinedFields `json:"fields,omitempty"`
}

func (acc *Account) GetEmail() string {
	return acc.Email
}

func (acc *Account) GetRole() *UserRoles {
	return acc.Role
}

func (acc *Account) ToProto() (*accountRpc.Account, error) {
	role := acc.Role.ToProto()
	fields, err := acc.Fields.ToProto()
	if err != nil {
		return nil, err
	}
	return &accountRpc.Account{
		Id:        acc.Id,
		Email:     acc.Email,
		Password:  acc.Password,
		Role:      role,
		CreatedAt: unixToUtcTS(acc.CreatedAt),
		UpdatedAt: unixToUtcTS(acc.UpdatedAt),
		LastLogin: unixToUtcTS(acc.LastLogin),
		Disabled:  acc.Disabled,
		Fields:    fields,
	}, nil
}

func AccountFromProto(in *accountRpc.Account) *Account {
	role := UserRolesFromProto(in.GetRole())
	fields := UserDefinedFieldsFromProto(in.Fields)
	return &Account{
		Id:        in.GetId(),
		Email:     in.GetEmail(),
		Password:  in.GetPassword(),
		Role:      role,
		CreatedAt: tsToUnixUTC(in.GetCreatedAt()),
		UpdatedAt: tsToUnixUTC(in.GetUpdatedAt()),
		LastLogin: tsToUnixUTC(in.GetLastLogin()),
		Disabled:  in.Disabled,
		Fields:    fields,
	}
}

func AccountFromSys(in *sysSharePkg.Account) *Account {
	role := UserRolesFromSys(in.GetRole())
	fields := UserDefinedFields{Fields: in.Fields.Fields}
	return &Account{
		Id:        in.Id,
		Email:     in.GetEmail(),
		Password:  in.Password,
		Role:      role,
		CreatedAt: in.CreatedAt,
		UpdatedAt: in.UpdatedAt,
		LastLogin: in.LastLogin,
		Disabled:  in.Disabled,
		Fields:    &fields,
	}
}

type ListAccountsRequest struct {
	PerPageEntries int64  `json:"perPageEntries,omitempty"`
	OrderBy        string `json:"orderBy,omitempty"`
	CurrentPageId  string `json:"currentPageId,omitempty"`
}

func (lar *ListAccountsRequest) ToProto() *accountRpc.ListAccountsRequest {
	return &accountRpc.ListAccountsRequest{
		PerPageEntries: lar.PerPageEntries,
		OrderBy:        lar.OrderBy,
		CurrentPageId:  lar.CurrentPageId,
	}
}

func (lar *ListAccountsRequest) ToSysShareProto() *sysSharePkg.ListAccountsRequest {
	return &sysSharePkg.ListAccountsRequest{
		PerPageEntries: lar.PerPageEntries,
		OrderBy:        lar.OrderBy,
		CurrentPageId:  lar.CurrentPageId,
	}
}

func ListAccountsRequestFromProto(in *accountRpc.ListAccountsRequest) *ListAccountsRequest {
	return &ListAccountsRequest{
		PerPageEntries: in.GetPerPageEntries(),
		OrderBy:        in.GetOrderBy(),
		CurrentPageId:  in.GetCurrentPageId(),
	}
}

type ListAccountsResponse struct {
	Accounts   []*Account `json:"accounts,omitempty"`
	NextPageId string     `json:"nextPageId,omitempty"`
}

func (lsp *ListAccountsResponse) ToProto() (*accountRpc.ListAccountsResponse, error) {
	var accs []*accountRpc.Account
	for _, acc := range lsp.Accounts {
		account, err := acc.ToProto()
		if err != nil {
			return nil, err
		}
		accs = append(accs, account)
	}
	return &accountRpc.ListAccountsResponse{
		Accounts:   accs,
		NextPageId: lsp.NextPageId,
	}, nil
}

func ListAccountsResponseFromProto(resp *accountRpc.ListAccountsResponse) *ListAccountsResponse {
	var accs []*Account
	for _, acc := range resp.Accounts {
		account := AccountFromProto(acc)
		accs = append(accs, account)
	}
	return &ListAccountsResponse{
		Accounts:   accs,
		NextPageId: resp.GetNextPageId(),
	}
}

func ListAccountsResponseFromSys(resp *sysSharePkg.ListAccountsResponse) *ListAccountsResponse {
	var accs []*Account
	for _, acc := range resp.Accounts {
		accs = append(accs, AccountFromSys(acc))
	}
	return &ListAccountsResponse{
		Accounts:   accs,
		NextPageId: resp.NextPageId,
	}
}
