import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/modules/projects/view_model/project_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:mod_disco/core/core.dart';
import 'package:sys_core/sys_core.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

import 'proj_detail_view.dart';

class ProjectView extends StatelessWidget {
  final String id;

  const ProjectView({Key key, this.id = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModelBuilder: () => ProjectViewModel(),
      viewModel: ProjectViewModel(),
      onModelReady: (ProjectViewModel model) async {
        if (model.projects == null || model.projects.isEmpty) {
          await model.fetchInitialProjects();
        }
      },
      builder: (context, ProjectViewModel model, child) => model.isLoading
          ? Container(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              body: NewGetCourageMasterDetail<Project>(
                enableSearchBar: true,
                id: id,
                items: model.projects,
                labelBuilder: (item) => item.name,
                imageBuilder: (item) => item.logo,
                routeWithIdPlaceholder: Modular.get<Paths>().orgsId,
                detailsBuilder: (context, detailsId, isFullScreen) =>
                    ProjectDetailView(
                        project: model.projects
                            .firstWhere((org) => org.id == detailsId),
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
