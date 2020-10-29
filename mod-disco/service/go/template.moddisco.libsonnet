{
    local cfg = self,
    UnauthenticatedRoutes:: [
    	"/grpc.reflection.v1alpha.ServerReflection/ServerReflectionInfo",
    ],
    modDiscoConfig: {
        unauthenticatedRoutes: cfg.UnauthenticatedRoutes,
    }
}