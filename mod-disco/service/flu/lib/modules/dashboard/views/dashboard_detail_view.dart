import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/config/env_config.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/routes/paths.dart';
import 'package:mod_disco/modules/dashboard/view_model/dashboard_detail_view_model.dart';
import 'package:mod_disco/modules/dashboard/widgets/data_pane/data_pane.dart';
import 'package:mod_disco/modules/dashboard/widgets/filter_pane.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DashboardDetailView extends StatelessWidget {
  final String orgId;
  final String projectId;
  final bool isFullScreen;

  DashboardDetailView({
    Key key,
    @required this.orgId,
    @required this.projectId,
    @required this.isFullScreen,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModelBuilder: () => DashboardDetailViewModel(
        orgId: orgId,
        projectId: projectId,
      ),
      onModelReady: (DashboardDetailViewModel model) async =>
          await model.fetchUserDatas(),
      builder: (BuildContext context, DashboardDetailViewModel model, child) {
        return ResponsiveBuilder(
          builder: (context, sizingInfo) {
            return Scaffold(
              appBar: AppBar(
                // iconTheme: Theme.of(context).iconTheme,
                automaticallyImplyLeading: isFullScreen,
                title:
                    Text(ModDiscoLocalizations.of(context).projectDashboard()),
                // this the mock data
                actions: <Widget>[
                  IconButton(
                      tooltip: ModDiscoLocalizations.of(context).copyLink(),
                      icon: Icon(Icons.link),
                      onPressed: () async {
                        String link =
                            "${Modular.get<EnvConfig>().url}/#/${Modular.get<DashboardPaths>().dashboardId.replaceFirst("/", "").replaceAll(":orgId", "$orgId").replaceAll(":id", projectId)}";
                        await Clipboard.setData(new ClipboardData(text: link));
                      })
                ],
              ),
              drawer: (sizingInfo.screenSize.width > 1100)
                  ? null
                  : Drawer(
                      child: FilterPane(
                        isLoading: model.isLoading,
                        conditionsFilterWidget:
                            model.buildConditionsFilter(context),
                        rolesFilterWidget: model.buildRolesFilter(context),
                        // TODO: roles filter
                        sizingInfo: sizingInfo,
                      ),
                    ),
              // : Drawer(child: Container(child: Text('Filter Pane here'))),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  (sizingInfo.screenSize.width <= 768)
                      ? IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            return Modular.to.pop(false);
                          },
                        )
                      : Offstage(),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        (sizingInfo.screenSize.width > 1100)
                            ? FilterPane(
                                isLoading: model.isLoading,
                                conditionsFilterWidget:
                                    model.buildConditionsFilter(context),
                                rolesFilterWidget:
                                    model.buildRolesFilter(context),
                                // TODO: roles filter
                                sizingInfo: sizingInfo,
                              )
                            : Offstage(),
                        SizedBox(width: 16),
                        Expanded(
                            child: DataPane(
                          totalCount: model.totalCount,
                          rowsPerPage: model.rowsPerPage,
                          isLoading: model.isLoadingSurveyData,
                          sizingInfo: sizingInfo,
                          handleNext: model.handleNextPage,
                          onRowsPerPageChanged: model.setChangeRowsPerPage,
                          rowsOffset: 0,
                          handlePrevious: () {},
                          items: model.surveyDatas,
                          onRefresh: model.handleResetAll,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
