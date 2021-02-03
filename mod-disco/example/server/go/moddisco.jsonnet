local loadVar = import "vendor/github.com/amplify-cms/sys-share/sys-core/service/config/mixins/mixin.loadfn.libsonnet";
local discoTpl = import "../../../service/go/template.moddisco.libsonnet";

local cfg = {
    modDiscoConfig: discoTpl.modDiscoConfig {
        sysCoreConfig: {
            sysCoreConfig: {
                db: discoTpl.CoreDB {
                    encryptKey: loadVar(prefixName="MOD_DISCO", env="DB_ENCRYPT_KEY").val,
                },
                cron: discoTpl.CoreCron,
            }
        },
        unauthenticatedRoutes: discoTpl.UnauthenticatedRoutes,
    }
};

std.manifestYamlDoc(cfg)