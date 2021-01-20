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
  String dashboard;
  String dashboardId;

  Paths(this.baseRoute)
      : dashboard = '$baseRoute/dashboard/orgs',
        // Admin dashboard routes
        dashboardId = '$baseRoute/dashboard/orgs/:orgId/:id',
        // Admin dashboard routes
        userInfo = '$baseRoute/userInfo',
        // Non-Admin routes
        orgs = '$baseRoute/orgs',
        orgsId = '$baseRoute/orgs/:id',
        projects = '$baseRoute/projects',
        projectsId = '$baseRoute/selected_projects/:oid/:id',
        supportRoles = '$baseRoute/support_roles',
        surveyProject = '$baseRoute/survey',
        splash = '$baseRoute/';
}
