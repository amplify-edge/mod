import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/shared_services/dynamic_widget_service.dart';
import 'package:mod_disco/modules/projects/views/proj_header.dart';
import 'package:mod_disco/modules/survey_project/view_model/support_role_view_model.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:sys_share_sys_account_service/rpc/v2/sys_account_models.pb.dart';

class SurveySupportRoleView extends StatelessWidget {
  final Project project;
  final NewSurveyUserRequest surveyUserRequest;
  final String accountId;
  final List<SurveyProject> surveyProjectList;

  SurveySupportRoleView(
      {Key key,
      @required this.project,
      @required this.surveyUserRequest,
      @required this.surveyProjectList,
      @required this.accountId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModelBuilder: () => SupportRoleViewModel(
        project: this.project,
        accountId: this.accountId,
        newSurveyUserRequest: this.surveyUserRequest,
        surveyProjectList: this.surveyProjectList,
      ),
      onModelReady: (SupportRoleViewModel model) => model.initOnReady(),
      builder: (context, SupportRoleViewModel model, child) => Scaffold(
        appBar: AppBar(
          title: Text(ModDiscoLocalizations.of(context).supportRoles()),
          automaticallyImplyLeading: false,
        ),
        body: (model.isLoading)
            ? Center(child: Offstage())
            : Column(
                children: [
                  ProjectHeader(project: this.project),
                  Expanded(
                    child: _buildSupportRolesList(context, model),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _getNextButton(BuildContext context, SupportRoleViewModel model) =>
      ButtonBar(children: [
        RaisedButton(
          onPressed: () async {
            await model.onSave(context);
          },
          child: Text(ModDiscoLocalizations.of(context).translate('next')),
        )
      ]);

  Widget _buildSupportRolesList(context, SupportRoleViewModel model) {
    return ListView.builder(
      itemCount: model.supportRoles.length + 1, // +1 is for the next button
      itemBuilder: (BuildContext context, int index) {
        //add next button as last item to the list
        if (index == model.supportRoles.length) {
          return _getNextButton(context, model);
        } else {
          SupportRoleType sp = model.supportRoles[index];
          return DynamicSlider(
            uom: sp.unitOfMeasures,
            title: sp.name,
            question: sp.description,
            current: model.minHours[sp.id] ?? 0.0,
            min: 0.0,
            max: 8.0,
            callbackInjection: (String value) {
              model.selectMinHours(double.tryParse(value) ?? 0.0, sp.id);
            },
          );
        }
      },
    );
  }
}
