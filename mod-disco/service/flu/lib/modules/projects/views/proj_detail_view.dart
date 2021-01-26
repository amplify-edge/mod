import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:mod_disco/modules/projects/view_model/project_detail_view_model.dart';
import 'package:mod_disco/modules/projects/views/proj_image_carousel.dart';

// import 'package:mod_disco/modules/projects/views/proj_video_widget.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '';

import './proj_header.dart';
import '../../../core/core.dart';

class ProjectDetailView extends StatelessWidget {
  final String projectId;
  final bool showBackButton;

  const ProjectDetailView({
    Key key,
    this.projectId,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      disposeViewModel: false,
      viewModelBuilder: () => ProjectDetailViewModel(projectId: projectId),
      onModelReady: (ProjectDetailViewModel model) async {
        await model.fetchProjectDetail();
      },
      builder: (context, ProjectDetailViewModel model, child) => model.isLoading
          ? Center(
              child: CircularProgressIndicator(value: 30),
            )
          : Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: showBackButton,
                title: Text(ModDiscoLocalizations.of(context)
                    .translate('campaignDetails')),
              ),
              body: Column(
                children: [
                  ProjectHeader(project: model.project),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        //   CarouselWithIndicator(imgList: campaign.videoURL),
                        ListTile(
                          title: Text(
                            'Gallery',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          // subtitle: ProjectVideoPlayer(
                          //   model.selectedProjectDetails.videoUrl,
                          // ),
                        ),
                        ProjectImageCarousel(
                            images: model.selectedProjectDetails.projectImages),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('campaignName'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(model.project.name),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('category'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(model.selectedProjectDetails.category),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('actionType'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle:
                              Text(model.selectedProjectDetails.actionType),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                    .translate('actionLocation') +
                                ' / ' +
                                ModDiscoLocalizations.of(context)
                                    .translate('time'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                              '${model.selectedProjectDetails.actionLocation} / ${DateFormat('yyyy MMM dd HH:MM').format(model.selectedProjectDetails.actionTime.toDateTime())}'),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('lengthOfTheAction'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                              '${model.selectedProjectDetails.actionLength} ${model.selectedProjectDetails.unitOfMeasures}'),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context).translate('goal'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(model.selectedProjectDetails.goal),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('strategy'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(model.selectedProjectDetails.strategy),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('historicalPrecedents'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle:
                              Text(model.selectedProjectDetails.histPrecedents),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('peopleAlreadyPledged'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(model
                              .selectedProjectDetails.alreadyPledged
                              .toString()),
                        ),
                        const SizedBox(height: 16.0),
                        Card(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      ModDiscoLocalizations.of(context)
                                              .translate('weNeed') +
                                          ' :',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    subtitle: Text(
                                      ModDiscoLocalizations.of(context)
                                          .translate(
                                              'extrapolatedSimilarPastActions'),
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                        ModDiscoLocalizations.of(context)
                                            .translate('pioneersToStart')),
                                    trailing: Text(
                                      '${model.selectedProjectDetails.minPioneers}',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                        ModDiscoLocalizations.of(context)
                                            .translate('rebelsMedia')),
                                    trailing: Text(
                                      '${model.selectedProjectDetails.minRebelsMedia}',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                        ModDiscoLocalizations.of(context)
                                            .translate('rebelsWin')),
                                    trailing: Text(
                                      '${model.selectedProjectDetails.minRebelsToWin}',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('contactDetails'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(model.project.org.contact),
                        ),
                        const SizedBox(height: 16.0),
                        ButtonBar(children: [
                          RaisedButton(
                            onPressed: () {
                              final _nextRoute = Modular.get<Paths>()
                                  .surveyProject
                                  .replaceAll(':id', projectId);
                              Modular.to.navigate(
                                _nextRoute,
                                arguments: projectId,
                              );
                            },
                            child: Text(ModDiscoLocalizations.of(context)
                                .translate("ready")),
                          ),
                        ]),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
