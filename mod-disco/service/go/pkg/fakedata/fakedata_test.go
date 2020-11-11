package fakedata_test

import (
	"io/ioutil"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/getcouragenow/mod/mod-disco/service/go/pkg/fakedata"
	fakeAccount "github.com/getcouragenow/sys-share/sys-account/service/go/pkg/fakedata"
)

func TestBootstrapFakeData(t *testing.T) {
	const domain = "getcouragenow.org"
	accRc, orgRc, projRc, _, err := fakeAccount.BootstrapFakeData(domain)
	require.NoError(t, err)
	b, err := fakedata.BootstrapFakeData(domain, accRc, orgRc, projRc)
	require.NoError(t, err)
	t.Log(string(b))

	require.NoError(t, ioutil.WriteFile("./bs-mod-disco.json", b, 0644))

	bmd, err := fakedata.BootstrapModDiscoFromFilepath("./bs-mod-disco.json")
	require.NoError(t, err)

	nsps := bmd.GetDiscoProjects()
	require.NotEmpty(t, nsps)
}
