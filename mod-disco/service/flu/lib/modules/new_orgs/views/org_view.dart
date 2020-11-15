import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/modules/new_orgs/view_model/org_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:mod_disco/core/core.dart';
import 'package:sys_core/sys_core.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

import 'org_detail_view.dart';

class NewOrgView extends StatelessWidget {
  final String id;

  const NewOrgView({Key key, this.id = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModelBuilder: () => NewOrgViewModel(),
      viewModel: NewOrgViewModel(),
      onModelReady: (NewOrgViewModel model) async {
        if (model.orgs == null || model.orgs.isEmpty) {
          await model.fetchInitialOrgs();
        }
      },
      builder: (context, NewOrgViewModel model, child) => model.isLoading
          ? Container(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              body: NewGetCourageMasterDetail<Org>(
                enableSearchBar: true,
                id: id,
                items: model.orgs,
                labelBuilder: (item) => item.name,
                imageBuilder: (item) => item.logo,
                routeWithIdPlaceholder: Modular.get<Paths>().orgsId,
                detailsBuilder: (context, detailsId, isFullScreen) =>
                    NewOrgDetailView(
                        org:
                            model.orgs.firstWhere((org) => org.id == detailsId),
                        showBackButton: isFullScreen),
                noItemsAvailable: Center(
                  child: Text(
                    ModDiscoLocalizations.of(context).translate('noCampaigns'),
                  ),
                ),
                noItemsSelected: Center(
                    child: Text(ModDiscoLocalizations.of(context)
                        .translate('noItemsSelected'))),
                disableBackButtonOnNoItemSelected: false,
                masterAppBarTitle: Text(ModDiscoLocalizations.of(context)
                    .translate('selectCampaign')),
                // item.projects != null && item.projects.isNotEmpty
                //     ? item.projects
                //         .map(
                //   (project) => InkWell(
                //     child: Container(
                //       height: 56,
                //       child: Row(
                //         children: [
                //           SizedBox(width: 16),
                //           CircleAvatar(
                //             radius: 20,
                //             backgroundImage: MemoryImage(
                //                 Uint8List.fromList(project.logo)),
                //           ),
                //           SizedBox(width: 16),
                //           Expanded(
                //             child: Text(
                //               project.name,
                //               textAlign: TextAlign.center,
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .subtitle1
                //                   .merge(
                //                     TextStyle(
                //                       color: Theme.of(context)
                //                           .accentColor,
                //                     ),
                //                   ),
                //             ),
                //           ),
                //           SizedBox(width: 30),
                //         ],
                //       ),
                //     ),
                //     onTap: () {
                //       _pushDetailsRoute(project.id, context);
                //     },
                //   ),
                // )
                // .toList()
              ),
            ),
    );
  }
}
