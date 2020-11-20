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
      builder: (context, ProjectViewModel model, child) => Scaffold(
        body: NewGetCourageMasterDetail<Project>(
          enableSearchBar: true,
          id: id,
          items: model.projects,
          labelBuilder: (item) => item.name,
          imageBuilder: (item) => item.logo,
          routeWithIdPlaceholder: Modular.get<Paths>().projectsId,
          detailsBuilder: (context, detailsId, isFullScreen) =>
              ProjectDetailView(
            project: model.projects.firstWhere((p) => p.id == detailsId),
            projectDetails: model.projectDetails.firstWhere(
              (projDet) => projDet.sysAccountProjectRefId == detailsId,
            ),
            showBackButton: isFullScreen,
          ),
          noItemsAvailable: Center(
            child: Text(
              ModDiscoLocalizations.of(context).translate('noCampaigns'),
            ),
          ),
          noItemsSelected: Center(
              child: Text(ModDiscoLocalizations.of(context)
                  .translate('noItemsSelected'))),
          disableBackButtonOnNoItemSelected: false,
          masterAppBarTitle: Text(
              ModDiscoLocalizations.of(context).translate('selectCampaign')),
          isLoadingMoreItems: model.isLoading,
          fetchNextItems: model.fetchNextProjects,
          hasMoreItems: model.hasMoreItems,
          searchFunction: model.searchProjects,
          resetSearchFunction: model.onResetSearchProjects,
          childrenBuilder: (item) => [Container(
            child: Text('BOY'),
          )],
        ),
      ),
    );
  }
}
