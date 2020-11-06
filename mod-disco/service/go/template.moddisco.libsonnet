local dbcfg = import "vendor/github.com/getcouragenow/sys-share/sys-core/service/config/mixins/mixin.db.libsonnet";
local tokencfg = import "vendor/github.com/getcouragenow/sys-share/sys-core/service/config/mixins/mixin.jwt.libsonnet";
{
    local cfg = self,
    UnauthenticatedRoutes:: [
    	"/grpc.reflection.v1alpha.ServerReflection/ServerReflectionInfo",
    ],
    CoreDB:: dbcfg.DB {
        name: "disco.db",
        encryptKey: "testEncryptKey",
        dbDir: "./db/mod",
        deletePrevious: true,
    },
    CoreCron:: {
        backupSchedule: "@daily",
        rotateSchedule: "@every 24h",
        backupDir: cfg.CoreDB.dbDir + "/backup"
    },
    AccessToken:: tokencfg.Token {
        secret: "some_jwt_access_secret",
        expiry: 3600,
    },
    RefreshToken:: tokencfg.Token {
        secret: "some_jwt_refresh_secret",
        expiry: cfg.AccessToken.expiry * 100,
    },
    BusClientRoutes:: [
        "/v2.sys_account.services.OrgProjService/NewProject",
        "/v2.sys_account.services.OrgProjService/UpdateProject",
        "/v2.sys_account.services.OrgProjService/DeleteProject",
        "/v2.sys_account.services.OrgProjService/NewOrg",
        "/v2.sys_account.services.OrgProjService/UpdateOrg",
        "/v2.sys_account.services.OrgProjService/DeleteOrg",
    ],
    modDiscoConfig: {
        unauthenticatedRoutes: cfg.UnauthenticatedRoutes,
        busClientRoutes: cfg.BusClientRoutes,
        sysCoreConfig: {
            db: cfg.CoreDB,
            cron: cfg.CoreCron,
       },
        jwt: {
            access: cfg.AccessToken,
            refresh: cfg.RefreshToken,
        }
    }
}