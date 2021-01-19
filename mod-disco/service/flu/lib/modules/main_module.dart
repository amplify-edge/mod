import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/routes/dashboard_guards.dart';
import 'package:mod_disco/modules/dashboard/views/org_master_detail_view.dart';
import 'package:mod_disco/modules/projects/views/proj_view.dart';
import 'package:mod_disco/modules/survey_project/views/support_role_view.dart';
import 'package:mod_disco/modules/survey_project/views/survey_project_view.dart';
import 'package:sys_share_sys_account_service/pkg/guards/guardian_view_model.dart';

class MainAppModule extends ChildModule {
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
        Bind.singleton((i) => GuardianViewModel())
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          baseRoute,
          child: (_, args) => Container(),
          guards: [SplashGuard()],
        ),
        ChildRoute(
          "/projects",
          child: (_, args) => ProjectView(
            orgs: args.data,
          ),
        ),
        ChildRoute(
          "/projects/:orgId/:id",
          child: (_, args) => ProjectView(
            orgId: args.params['orgId'] ?? '',
            id: args.params['id'] ?? '',
          ),
        ),
        ChildRoute(
          "/survey/projects/",
          child: (_, args) => SurveyProjectView(
            project: args.data,
          ),
        ),
        ChildRoute(
          "/support_roles/projects/",
          child: (_, args) => SurveySupportRoleView(
            project: args.data['project'],
            surveyUserRequest: args.data['surveyUserRequest'],
            accountId: args.data['accountId'],
            surveyProjectList: args.data['surveyProjectList'],
          ),
        ),
        /// Admin Dashboard Routes
        ChildRoute(
          "/dashboard/orgs",
          child: (_, args) => OrgMasterDetailView(),
          guards: [DashboardGuard()],
        ),
        ChildRoute(
          "/dashboard/orgs/:orgId/:id",
          child: (_, args) => OrgMasterDetailView(
            id: args.params['id'] ?? '',
            orgId: args.params['orgId'] ?? '',
          ),
          guards: [DashboardGuard()],
        ),
      ];

  static Inject get to => Inject<MainAppModule>();
}
