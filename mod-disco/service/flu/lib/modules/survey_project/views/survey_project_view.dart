import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mod_disco/core/shared_services/dynamic_widget_service.dart';
import 'package:mod_disco/modules/survey_project/view_model/survey_project_view_model.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:mod_disco/core/core.dart';

class SurveyProjectView extends StatefulWidget {
  final String projectId;

  SurveyProjectView({Key key, this.projectId}) : super(key: key);

  @override
  _SurveyProjectViewState createState() => _SurveyProjectViewState();
}

class _SurveyProjectViewState extends State<SurveyProjectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModelBuilder: () =>
          SurveyProjectViewModel(sysAccountProjectRefId: widget.projectId),
      onModelReady: (SurveyProjectViewModel model) async {
        await model.fetchSurveyProject();
      },
      builder: (context, SurveyProjectViewModel model, child) => Scaffold(
        appBar: AppBar(
          title: Text(ModDiscoLocalizations.of(context).translate('yourNeeds')),
        ),
        body: (model.isLoading)
            ? Center(child: Offstage())
            : ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: MemoryImage(
                              Uint8List.fromList(model.project.logo)),
                        ),
                        title: Text(
                          model.project.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        isThreeLine: true,
                        subtitle: Text(model.project.org.name),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ListTile(
                    title: Text(
                      ModDiscoLocalizations.of(context)
                          .translate('needsSatisifiedRequirement'),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  ...model.buildSurveyUserNeeds(context),

                  ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          model.navigateNext(context);
                        },
                        child: Text(ModDiscoLocalizations.of(context)
                            .translate('next')),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
