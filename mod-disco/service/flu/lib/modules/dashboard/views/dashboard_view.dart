import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/modules/dashboard/view_model/dashboard_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:sys_core/sys_core.dart';
import 'package:sys_share_sys_account_service/rpc/v2/sys_account_models.pb.dart';

import 'dashboard_detail_view.dart';

class DashboardView extends StatelessWidget {
  final String id;
  final String orgId;
  final String routePlaceholder;

  DashboardView({Key key, this.id = '', this.orgId = '', this.routePlaceholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModelBuilder: () => DashboardViewModel(),
      onModelReady: (DashboardViewModel model) async {
        if (model.orgs == null || model.orgs.isEmpty) {
          await model.getPermissions();
          await model.getInitialAdminOrgs();
        }
      },
      builder: (context, DashboardViewModel model, child) =>
          GCMasterDetail<Org, Project>(
        enableSearchBar: true,
        parentId: orgId,
        childId: id,
        items: model.orgs,
        labelBuilder: (item) => item.name,
        imageBuilder: (item) => item.logo,
        routeWithIdPlaceholder: routePlaceholder,
        detailsBuilder: (context, parentId, childId, isFullScreen) {
          return DashboardDetailView(
            orgId: parentId,
            projectId: childId,
            isFullScreen: isFullScreen,
          );
        },
        noItemsAvailable: Center(
          child: Text(
            ModDiscoLocalizations.of(context).translate('noCampaigns'),
          ),
        ),
        noItemsSelected: Center(
            child: Text(ModDiscoLocalizations.of(context)
                .translate('noItemsSelected'))),
        disableBackButtonOnNoItemSelected: false,
        masterAppBarTitle:
            Text(ModDiscoLocalizations.of(context).translate('selectCampaign')),
        isLoadingMoreItems: model.isLoading,
        fetchNextItems: model.getNextAdminOrgs,
        hasMoreItems: model.hasMoreItems,
        searchFunction: model.searchAdminOrgs,
        resetSearchFunction: model.onResetSearchOrgs,
        itemChildren: (org) => org.projects,
        childBuilder: (project, id) => <Widget>[
          ...[
            SizedBox(width: 16),
            CircleAvatar(
              radius: 20,
              backgroundImage: MemoryImage(
                Uint8List.fromList(project.logo),
              ),
            ),
          ],
          SizedBox(width: 16),
          //logic taken from ListTile
          Expanded(
            child: Text(
              project.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1.merge(
                    TextStyle(
                      color: project.id != id
                          ? Theme.of(context).textTheme.subtitle1.color
                          : Theme.of(context).accentColor,
                    ),
                  ),
            ),
          ),
          SizedBox(width: 30),
        ],
      ),
    );
  }
}
