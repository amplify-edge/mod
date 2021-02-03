package fakedata_test

import (
	"github.com/amplify-cms/mod/mod-disco/service/go/pkg/fakedata"
	"io/ioutil"
	"testing"

	"github.com/stretchr/testify/require"

	fakeAccount "github.com/amplify-cms/sys-share/sys-account/service/go/pkg/fakedata"
)

func TestBootstrapFakeData(t *testing.T) {
	const domain = "amplify-cms.org"
	accRc, orgRc, projRc, _, err := fakeAccount.BootstrapFakeData(domain)
	require.NoError(t, err)
	fake, err := fakedata.BootstrapFakeData(domain, accRc, orgRc, projRc)
	require.NoError(t, err)

	b, err := fake.MarshalPretty()
	require.NoError(t, err)

	require.NoError(t, ioutil.WriteFile("./bs-mod-disco.json", b, 0644))
	
	b, err = fake.MarshalYAML()
	require.NoError(t, err)
	require.NoError(t, ioutil.WriteFile("./bs-mod-disco.yml", b, 0644))

	bmd, err := fakedata.BootstrapFromFilepath("./bs-mod-disco.json")
	require.NoError(t, err)

	nsps := bmd.GetDiscoProjects()
	require.NotEmpty(t, nsps)
}
