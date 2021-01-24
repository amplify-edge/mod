import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/routes/paths.dart';
import 'package:sys_share_sys_account_service/pkg/guards/guardian_view_model.dart';

class SplashGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String path, ModularRoute router) async {
    Modular.to.pushReplacementNamed(Modular.get<Paths>().projects);
    return true;
  }
}

class DashboardGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String path, ModularRoute router) async {
    final gmod = Modular.get<GuardianViewModel>();
    await gmod.getLoginStatus();
    if (gmod.isUserLoggedIn) {
      if (gmod.currentAccount.id.isEmpty) {
        await gmod.fetchAccountId();
      }
      await gmod.verifySuperuser();
      await gmod.verifyAdmin();
      if (gmod.isUserAdmin || gmod.isUserSuperuser) {
        return true;
      }
    }
    return false;
  }
}
