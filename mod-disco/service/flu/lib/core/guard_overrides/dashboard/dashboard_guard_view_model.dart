import 'package:flutter/material.dart';
import 'package:sys_share_sys_account_service/pkg/guards/guardian_view_model.dart';

class DashboardGuardViewModel extends GuardianViewModel {
  Future<void> _grantAdminAndSuperAccess(
      BuildContext context, Widget widget) async {
    await checkUserLoggedIn(context);
    if (currentAccount.id.isEmpty) {
      await fetchAccountId();
    }
    await verifySuperuser();
    await verifyAdmin();
    if (!isUserAdmin && !isUserSuperuser) {
      setErrMsg(context, "cannot access page, user is not authorized");
      return;
    }
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext ctx) => widget));
  }

  Future<void> grantAccessFunc(BuildContext context, Widget widget) async {
    return _grantAdminAndSuperAccess(context, widget);
  }
}
