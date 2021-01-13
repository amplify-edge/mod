package telemetry

import (
	"github.com/VictoriaMetrics/metrics"
	"github.com/sirupsen/logrus"
)

const (
	// total number of people pledged to a certain project
	METRICS_ALREADY_PLEDGED = "mod_disco_already_pledged"
	//METRICS_MIN_PIONEERS_COUNT    = "mod_disco_pioneers_count"
	//METRICS_MIN_REBELS_MEDIA      = "mod_disco_min_rebels_media"
	//METRICS_MIN_REBELS_WIN        = "mod_disco_min_rebels_win"
	// cumulative pledged hours for certain role in support role
	METRICS_PLEDGED_HOURS         = "mod_disco_pledged_hours"
	ModDiscoLabelledMetricsFormat = "%s{sys_project_id=%s, disco_project_id=%s}"
)

type ModDiscoMetrics struct {
	AlreadyPledgedMetrics *metrics.Counter
	//PioneersCountMetrics  *metrics.Counter
	//MinRebelsMediaMetrics *metrics.Counter
	//MinRebelsWin          *metrics.Counter
	PledgedHoursMetrics *metrics.Histogram
}

func NewModDiscoMetrics(logger *logrus.Entry) *ModDiscoMetrics {
	logger.Infof("Registering Mod-Disco Metrics")
	return &ModDiscoMetrics{
		AlreadyPledgedMetrics: metrics.NewCounter(METRICS_ALREADY_PLEDGED),
		//PioneersCountMetrics:  metrics.NewCounter(METRICS_MIN_PIONEERS_COUNT),
		//MinRebelsMediaMetrics: metrics.NewCounter(METRICS_MIN_REBELS_MEDIA),
		//MinRebelsWin:          metrics.NewCounter(METRICS_MIN_REBELS_WIN),
		PledgedHoursMetrics: metrics.NewHistogram(METRICS_PLEDGED_HOURS),
	}
}
