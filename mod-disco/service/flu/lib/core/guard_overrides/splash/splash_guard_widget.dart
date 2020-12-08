import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

import 'splash_guard_view_model.dart';

class SplashGuardianWidget extends StatelessWidget {
  final Widget widget;

  const SplashGuardianWidget({@required this.widget});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModelBuilder: () => SplashGuardViewModel(),
      onModelReady: (SplashGuardViewModel model) async {
        model.getPermissions(
            context: context,
            widget: widget,
            grantAccessFunction: model.grantAccessFunc);
      },
      builder: (BuildContext context, SplashGuardViewModel model, child) {
        return Container();
      },
    );
  }
}
