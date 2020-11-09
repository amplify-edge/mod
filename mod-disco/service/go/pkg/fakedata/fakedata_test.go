package fakedata_test

import (
	"io/ioutil"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/getcouragenow/mod/mod-disco/service/go/pkg/fakedata"
)

func TestBootstrapFakeData(t *testing.T) {
	b, err := fakedata.BootstrapFakeData()
	require.NoError(t, err)
	t.Log(string(b))
	
	require.NoError(t, ioutil.WriteFile("./bs-mod-disco.json", b, 0644))

	bmd, err := fakedata.BootstrapModDiscoFromFilepath("./bs-mod-disco.json")
	require.NoError(t, err)

	nsps := bmd.GetSurveyProjects()
	require.NotEmpty(t, nsps)
}
