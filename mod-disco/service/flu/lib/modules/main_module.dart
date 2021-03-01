import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/routes/dashboard_guards.dart';
import 'package:mod_disco/modules/dashboard/views/dashboard_view.dart';
import 'package:mod_disco/modules/projects/views/proj_view.dart';
import 'package:mod_disco/modules/survey_project/views/support_role_view.dart';
import 'package:mod_disco/modules/survey_project/views/survey_project_view.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:random_string/random_string.dart';
import 'package:sys_share_sys_account_service/pkg/guards/guardian_view_model.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

class AdminDashboardModule extends Module {
  final String baseRoute;

  AdminDashboardModule({this.baseRoute = '/dashboard'});

  @override
  List<Bind> get binds => [
        Bind.singleton((i) => DashboardPaths(baseRoute)),
        Bind.lazySingleton((i) => GuardianViewModel()),
      ];

  @override
  List<ModularRoute> get routes => [
        /// Admin Dashboard Routes
        ChildRoute(
          '/orgs',
          child: (_, args) => DashboardView(
            key: Key(randomString(32)),
            id: args.params['id'] ?? '',
            orgId: args.params['orgId'] ?? '',
            routePlaceholder: DashboardPaths(this.baseRoute).dashboardId,
          ),
          guards: [DashboardGuard()],
        ),
        ChildRoute(
          '/orgs/:orgId/:id',
          child: (_, args) => DashboardView(
            key: Key(randomString(32)),
            id: args.params['id'] ?? '',
            orgId: args.params['orgId'] ?? '',
            routePlaceholder: DashboardPaths(this.baseRoute).dashboardId,
          ),
          guards: [DashboardGuard()],
        ),
      ];
}

class MainAppModule extends Module {
  final String baseRoute;
  final String url;
  final String urlNative;

  MainAppModule({
    String baseRoute,
    String url,
    String urlNative,
  })  : this.baseRoute = (baseRoute == '/') ? '' : baseRoute,
        this.url = url,
        this.urlNative = urlNative;

  @override
  List<Bind> get binds => [
        Bind.singleton((i) => Paths(baseRoute)),
        Bind.singleton((i) => GuardianViewModel()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/subbed/:oid',
          child: (_, args) => ProjectView(
            key: Key(randomString(32)),
            oid: args.params['oid'] ?? '',
            orgs: args.data ?? List<Org>.empty(),
            orgId: args.queryParams['orgId'] ?? '',
            id: args.queryParams['id'] ?? '',
            routePlaceholder: Paths(this.baseRoute).projectsId,
          ),
        ),
        ChildRoute(
          "/projects",
          child: (_, args) => ProjectView(
            // body: args.data['body'],
            key: Key(randomString(32)),
            orgs: args.data ?? List<Org>.empty(),
            orgId: args.params['orgId'] ?? '',
            id: args.params['id'] ?? '',
            routePlaceholder: Paths(this.baseRoute).projectsId,
          ),
        ),
        ChildRoute(
          '/projects/:orgId/:id',
          child: (_, args) => ProjectView(
            // body: args.data['body'],
            key: Key(randomString(32)),
            orgs: args.data ?? List<Org>.empty(),
            orgId: args.params['orgId'] ?? '',
            id: args.params['id'] ?? '',
            routePlaceholder: Paths(this.baseRoute).projectsId,
          ),
        ),
        ChildRoute(
          "/survey/:id",
          child: (_, args) => SurveyProjectView(
            key: Key(randomString(32)),
            projectId: args.params['id'] ?? '',
          ),
        ),
        ChildRoute(
          "/support_roles",
          child: (_, args) => SurveySupportRoleView(
            key: Key(randomString(32)),
            project: args.data['project'] ?? Project(),
            surveyUserRequest:
                args.data['surveyUserRequest'] ?? NewSurveyUserRequest(),
            accountId: args.data['accountId'] ?? '',
            surveyProjectList:
                args.data['surveyProjectList'] ?? List<SurveyProject>.empty(),
          ),
        ),
      ];

  static Inject get to => Inject<MainAppModule>();
}
