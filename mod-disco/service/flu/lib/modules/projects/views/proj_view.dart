import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/modules/projects/view_model/project_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:sys_core/sys_core.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

import 'proj_detail_view.dart';

class ProjectView extends StatefulWidget {
  final List<Org> orgs;
  final String oid;
  final String orgId;
  final String id;
  final String routePlaceholder;
  final Widget body;

  const ProjectView(
      {Key key,
      this.id = '',
      this.orgId = '',
      this.oid = '',
      this.orgs,
      this.body,
      this.routePlaceholder})
      : super(key: key);

  @override
  _ProjectViewState createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      disposeViewModel: false,
      viewModelBuilder: () => ProjectViewModel(organizations: widget.orgs),
      onModelReady: (ProjectViewModel model) async {
        if ((model.orgs == null || model.orgs.isEmpty) && widget.oid.isEmpty) {
          await model.fetchInitialProjects();
        } else {
          await model.fetchExistingOrgsProjects(oid: widget.oid);
        }
      },
      builder: (context, ProjectViewModel model, child) => Scaffold(
        body: widget.body != null
            ? widget.body
            : GCMasterDetail<Org, Project>(
                enableSearchBar: true,
                parentId: widget.orgId,
                childId: widget.id,
                items: model.orgs,
                labelBuilder: (item) => item.name,
                imageBuilder: (item) => item.logo,
                routeWithIdPlaceholder: widget.routePlaceholder,
                detailsBuilder: (context, parentId, detailsId, isFullScreen) {
                  // model.getSelectedProjectAndDetails(parentId, detailsId);
                  return ProjectDetailView(
                    projectId: detailsId,
                    showBackButton: isFullScreen,
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
                masterAppBarTitle: Text(ModDiscoLocalizations.of(context)
                    .translate('selectCampaign')),
                isLoadingMoreItems: model.isLoading,
                fetchNextItems: model.fetchNextProjects,
                hasMoreItems: model.hasMoreItems,
                searchFunction: model.searchProjects,
                resetSearchFunction: model.onResetSearchProjects,
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
      ),
    );
  }
}
