import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/routes/paths.dart';
import 'package:sys_share_sys_account_service/pkg/guards/guardian_view_model.dart';

class SplashGuardViewModel extends GuardianViewModel {
  Future<void> _rerouteAccess(BuildContext context, Widget widget) async {
    await getLoginStatus();
    if (isUserLoggedIn) {
      if (currentAccount.id.isEmpty) {
        await fetchAccountId();
      }
      await verifySuperuser();
      await verifyAdmin();
      if (!isUserAdmin && !isUserSuperuser) {
        return _navigateToProject(context);
      }
      return _navigateToDashboard(context);
    }
    return _navigateToProject(context);
  }

  void _navigateToProject(BuildContext context) {
    Navigator.pop(context);
    Modular.to.pushNamed(Modular.get<Paths>().projects);
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.pop(context);
    Modular.to.pushNamed(Modular.get<Paths>().dashboard);
  }

  Future<void> grantAccessFunc(BuildContext context, Widget widget) async {
    return _rerouteAccess(context, widget);
  }
}
