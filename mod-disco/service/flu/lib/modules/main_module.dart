import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/guard_overrides/dashboard/dashboard_guard_widget.dart';
import 'package:mod_disco/modules/dashboard/views/org_master_detail_view.dart';
import 'package:mod_disco/modules/projects/views/proj_view.dart';
import 'package:mod_disco/modules/survey_project/views/support_role_view.dart';
import 'package:mod_disco/modules/survey_project/views/survey_project_view.dart';
import 'package:sys_share_sys_account_service/rpc/v2/sys_account_models.pb.dart';
import 'splash/views/splash_view.dart';

class MainAppModule extends ChildModule {
  final String baseRoute;
  final String url;
  final String urlNative;

  // static String cutOffBaseRoute(String route) {
  //   if (route.indexOf(baseRoute) < 0) return route;
  //   return route.substring(
  //       route.indexOf(baseRoute) + baseRoute.length, route.length);
  // }

  MainAppModule({
    String baseRoute,
    String url,
    String urlNative,
  })  : this.baseRoute = (baseRoute == '/') ? '' : baseRoute,
        this.url = url,
        this.urlNative = urlNative;

  @override
  List<Bind> get binds => [
        Bind((i) => Paths(baseRoute)),
        Bind((i) => EnvConfig(url, urlNative)),
        // Bind((i) => OrgsService(repository: MockOrgRepository())),
        // // TODO Replace this later with OrgRepository
        // Bind((i) => UserNeedService(repository: MockUserNeedRepository())),
        // // TODO Replace this later with UserNeedRepository
        // Bind((i) =>
        //     UserNeedAnswerService(repository: MockUserNeedAnswerRepository())),
        // // TODO Replace this later with UserNeedAnswerRepository
        // Bind(
        //     (i) => SupportRoleService(repository: MockSupportRoleRepository())),
        // // TODO Replace this later with SupportRoleRepository
        // Bind((i) => SupportRoleAnswerService(
        //     repository: MockSupportRoleAnswerRepository())),
        // TODO Replace this later with SupportRoleRepository
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter("/", child: (_, args) => SplashView()),
        ModularRouter(
          "/projects",
          child: (_, args) => ProjectView(
            orgs: args.data,
          ),
        ),
        ModularRouter(
          "/projects/:orgId/:id",
          child: (_, args) => ProjectView(
            orgId: args.params['orgId'] ?? '',
            id: args.params['id'] ?? '',
          ),
        ),
        ModularRouter(
          "/survey/projects/",
          child: (_, args) => SurveyProjectView(
            project: args.data,
          ),
        ),
        ModularRouter(
          "/support_roles/projects/",
          child: (_, args) => SurveySupportRoleView(
            project: args.data['project'],
            surveyUserRequest: args.data['surveyUserRequest'],
            accountId: args.data['accountId'],
            surveyProjectList: args.data['surveyProjectList'],
          ),
        ),

        /// Admin Dashboard Routes
        ModularRouter("/dashboard/orgs",
            child: (_, args) =>
                DashboardGuardianWidget(widget: OrgMasterDetailView())),
        ModularRouter(
          "/dashboard/orgs/:orgId/:id",
          child: (_, args) => DashboardGuardianWidget(
            widget: OrgMasterDetailView(
              id: args.params['id'] ?? '',
              orgId: args.params['orgId'] ?? '',
            ),
          ),
        ),
      ];

  static Inject get to => Inject<MainAppModule>.of();
}
