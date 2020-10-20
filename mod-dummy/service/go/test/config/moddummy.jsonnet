local tpl = import "../../template.moddummy.libsonnet";
//local loadVar = import "../../vendor/github.com/getcouragenow/sys-share/sys-core/service/config/mixin.loadfn.libsonnet";

local cfg = {
    modDummyConfig: {
        db: tpl.DummyDB {
            name: "gcn.db",
//            encryptKey: loadVar(prefixName="MOD_DUMMY", env="DB_ENCRYPT_KEY").val,
            dbDir: "./db",
        },
        cron: tpl.DummyCron {
            backupSchedule: "@daily",
        }
    }
};

std.manifestYamlDoc(cfg)