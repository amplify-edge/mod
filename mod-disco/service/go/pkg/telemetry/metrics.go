package telemetry

import (
	"github.com/VictoriaMetrics/metrics"
	"github.com/sirupsen/logrus"
)

const (
	METRICS_ALREADY_PLEDGED    = "mod_disco_already_pledged"
	METRICS_MIN_PIONEERS_COUNT = "mod_disco_pioneers_count"
	METRICS_MIN_REBELS_MEDIA   = "mod_disco_min_rebels_media"
	METRICS_MIN_REBELS_WIN     = "mod_disco_min_rebels_win"
)

type ModDiscoMetrics struct {
	AlreadyPledgedMetrics *metrics.Counter
	PioneersCountMetrics  *metrics.Counter
	MinRebelsMediaMetrics *metrics.Counter
	MinRebelsWin          *metrics.Counter
}

func NewModDiscoMetrics(logger *logrus.Entry) *ModDiscoMetrics {
	logger.Infof("Registering Mod-Disco Metrics")
	return &ModDiscoMetrics{
		AlreadyPledgedMetrics: metrics.NewCounter(METRICS_ALREADY_PLEDGED),
		PioneersCountMetrics:  metrics.NewCounter(METRICS_MIN_PIONEERS_COUNT),
		MinRebelsMediaMetrics: metrics.NewCounter(METRICS_MIN_REBELS_MEDIA),
		MinRebelsWin:          metrics.NewCounter(METRICS_MIN_REBELS_WIN),
	}
}
