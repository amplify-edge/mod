import 'package:flutter/material.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/shared_repositories/survey_project_repo.dart';
import 'package:mod_disco/core/shared_services/dynamic_widget_service.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/auth_repo.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

class SupportRoleViewModel extends BaseModel {
  String _projectId;
  Project _project;
  String _accountId = "";
  List<SurveyProject> _surveyProjects;
  NewSurveyUserRequest _nsuReq;
  Map<String, Map<String, List<SupportRoleType>>> _supportRoleQuestionMap =
      Map<String, Map<String, List<SupportRoleType>>>();

  DynamicWidgetService dwService = DynamicWidgetService();
  bool _isLoading = false;
  String get projectId => _projectId;
  Project get project => _project;
  NewSurveyUserRequest get nsuReq => _nsuReq;
  bool get isLoading => _isLoading;

  // Constructor
  SupportRoleViewModel(
      {@required Project project,
      @required String accountId,
      @required NewSurveyUserRequest newSurveyUserRequest,
      @required List<SurveyProject> surveyProjectList}) {
    _project = project;
    _accountId = accountId;
    _nsuReq = newSurveyUserRequest;
    _surveyProjects = surveyProjectList;
  }
}
