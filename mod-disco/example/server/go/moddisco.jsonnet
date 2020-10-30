local discoTpl = import "../../../service/go/template.moddisco.libsonnet";

local cfg = {
    modDiscoConfig: discoTpl.modDiscoConfig {
        unauthenticatedRoutes: discoTpl.UnauthenticatedRoutes,
    }
};

std.manifestYamlDoc(cfg)