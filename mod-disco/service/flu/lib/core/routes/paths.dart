class Paths {
  final String baseRoute;
  String userInfo;
  String orgs;
  String orgsId;
  String projects;
  String projectsId;
  String supportRoles;
  String surveyProject;
  String splash;

  Paths(this.baseRoute)
      : userInfo = '$baseRoute/userInfo',
        // Non-Admin routes
        orgs = '$baseRoute/orgs',
        orgsId = '$baseRoute/orgs/:orgId/:id',
        projects = '$baseRoute/projects',
        projectsId = '$baseRoute/projects/:orgId/:id',
        supportRoles = '$baseRoute/support_roles',
        surveyProject = '$baseRoute/survey/:id',
        splash = '$baseRoute/';
}

class DashboardPaths {
  final String baseRoute;
  String dashboard;
  String dashboardId;

  DashboardPaths(this.baseRoute)
      : dashboard = '$baseRoute/orgs',
        // Admin dashboard routes
        dashboardId = '$baseRoute/:orgId/:id';
}
