class Paths {
  final String baseRoute;
  String userInfo;
  String orgs;
  String orgsId;
  String projects;
  String projectsId;
  String ready;
  String supportRoles;
  String myNeeds;
  String splash;
  String dashboard;
  String dashboardId;

  Paths(this.baseRoute)
      : dashboard = '$baseRoute/dashboard/orgs',
        // Admin dashboard routes
        dashboardId = '$baseRoute/dashboard/orgs/:id',
        // Admin dashboard routes
        userInfo = '$baseRoute/userInfo',
        // Non-Admin routes
        orgs = '$baseRoute/orgs',
        orgsId = '$baseRoute/orgs/:id',
        projects = '$baseRoute/projects',
        projectsId = '$baseRoute/projects/:id',
        ready = '$baseRoute/ready',
        supportRoles = '$baseRoute/supportRoles/projects/:id',
        myNeeds = '$baseRoute/myneeds/projects/:id',
        splash = '$baseRoute/';
}
