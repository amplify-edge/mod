import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

import 'dashboard_guard_view_model.dart';

class DashboardGuardianWidget extends StatelessWidget {
  final Widget widget;

  const DashboardGuardianWidget({@required this.widget});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModelBuilder: () => DashboardGuardViewModel(),
      onModelReady: (DashboardGuardViewModel model) async {
        model.getPermissions(
            context: context,
            widget: widget,
            grantAccessFunction: model.grantAccessFunc);
      },
      builder: (BuildContext context, DashboardGuardViewModel model, child) {
        return Container();
      },
    );
  }
}
