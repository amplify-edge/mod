local dbcfg = import "vendor/github.com/getcouragenow/sys-share/sys-core/service/config/mixin.db.libsonnet";

{
    local cfg = self,
    DummyDB:: dbcfg.DB {
      name: "dummy.db",
    },
    DummyCron:: dbcfg.Cron {
      backupSchedule: "@daily",
      rotateSchedule: "@every 24h",
    },
    modDummyConfig: {
        unauthenticatedRoutes: [
            "/v2.mod.services.Dummy.GetAccount"
        ],
        db: self.DummyDB,
        cron: self.DummyCron,
    }
}

