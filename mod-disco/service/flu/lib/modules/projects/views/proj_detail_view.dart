import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:mod_disco/modules/projects/view_model/project_detail_view_model.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';
import './proj_header.dart';
import '../../../core/core.dart';

class ProjectDetailView extends StatelessWidget {
  final Project project;
  final bool showBackButton;

  const ProjectDetailView({Key key, this.project, this.showBackButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModelBuilder: () => ProjectDetailViewModel(proj: this.project),
      onModelReady: (ProjectDetailViewModel model) async {
        await model.fetchProjectDetail();
      },
      builder: (context, ProjectDetailViewModel model, child) => model.isLoading
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: showBackButton,
                title: Text(ModDiscoLocalizations.of(context)
                    .translate('campaignDetails')),
              ),
              body: Column(
                children: [
                  ProjectHeader(project: project),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        //   CarouselWithIndicator(imgList: campaign.videoURL),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('campaignName'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(model.proj.name),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('category'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(model.projectDetails.category),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('actionType'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(model.projectDetails.actionType),
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
                              '${model.projectDetails.actionLocation} / ${DateFormat('yyyy MMM dd HH:MM').format(model.projectDetails.actionTime.toDateTime())}'),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('lengthOfTheAction'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                              '${model.projectDetails.actionLength} ${model.projectDetails.unitOfMeasures}'),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context).translate('goal'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(model.projectDetails.goal),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('strategy'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(model.projectDetails.strategy),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('historicalPrecedents'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(model.projectDetails.histPrecedents),
                        ),
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text(
                            ModDiscoLocalizations.of(context)
                                .translate('peopleAlreadyPledged'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                              model.projectDetails.alreadyPledged.toString()),
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
                                      '${model.projectDetails.minPioneers}',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                        ModDiscoLocalizations.of(context)
                                            .translate('rebelsMedia')),
                                    trailing: Text(
                                      '${model.projectDetails.minRebelsMedia}',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                        ModDiscoLocalizations.of(context)
                                            .translate('rebelsWin')),
                                    trailing: Text(
                                      '${model.projectDetails.minRebelsToWin}',
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
                          subtitle: Text(model.proj.org.contact),
                        ),
                        const SizedBox(height: 16.0),
                        ButtonBar(children: [
                          FlatButton(
                            onPressed: () {
                              Modular.to.pushNamed(Modular.get<Paths>()
                                  .myNeeds
                                  .replaceAll(':id', model.proj.id));
                            },
                            child: Text(ModDiscoLocalizations.of(context)
                                .translate("notReady")),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Modular.to.pushNamed('/account/signup');
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
              )),
    );
  }
}
