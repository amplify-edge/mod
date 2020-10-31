local dbcfg = import "vendor/github.com/getcouragenow/sys-share/sys-core/service/config/mixins/mixin.db.libsonnet";
local tokencfg = import "vendor/github.com/getcouragenow/sys-share/sys-core/service/config/mixins/mixin.jwt.libsonnet";
{
    local cfg = self,
    UnauthenticatedRoutes:: [
    	"/grpc.reflection.v1alpha.ServerReflection/ServerReflectionInfo",
    ],
    CoreDB:: dbcfg.DB {
        name: "mod_disco.db"
    },
    CoreCron:: dbcfg.Cron,
    AccessToken:: tokencfg.Token {
        secret: "some_jwt_access_secret",
        expiry: 3600,
    },
    RefreshToken:: tokencfg.Token {
        secret: "some_jwt_refresh_secret",
        expiry: cfg.AccessToken.expiry * 100,
    },
    modDiscoConfig: {
        unauthenticatedRoutes: cfg.UnauthenticatedRoutes,
        sysCoreConfig: {
            sysCoreConfig: {
                db: cfg.CoreDB,
                cron: cfg.CoreCron,
            }
        },
        jwt: {
            access: cfg.AccessToken,
            refresh: cfg.RefreshToken,
        }
    }
}