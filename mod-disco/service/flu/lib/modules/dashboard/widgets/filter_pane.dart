import 'package:flutter/material.dart';
import 'package:mod_disco/modules/dashboard/view_model/dashboard_detail_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FilterPane extends StatelessWidget {
  final SizingInformation sizingInfo;
  final bool isLoading;
  final Widget conditionsFilterWidget;
  final Widget rolesFilterWidget;

  const FilterPane({
    Key key,
    this.sizingInfo,
    @required this.isLoading,
    @required this.conditionsFilterWidget,
    @required this.rolesFilterWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            width: sizingInfo.localWidgetSize.width * 0.25,
            child: SingleChildScrollView(
                child: Center(child: CircularProgressIndicator())),
          )
        : Container(
            width: sizingInfo.localWidgetSize.width * 0.25,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 32.0),
                    child: Text(
                      "Filter",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                  conditionsFilterWidget,
                  Divider(height: 0),
                  rolesFilterWidget,
                  Divider(height: 0),
                ],
              ),
            ),
          );
    // return _filterPane(context, sizingInfo);
  }
}
