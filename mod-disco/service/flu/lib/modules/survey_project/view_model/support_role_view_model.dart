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
  List<List<SupportRoleType>> _srtLists = [];
  List<SupportRoleType> _srtList = [];
  Map<String, double> _minHours = {};
  DynamicWidgetService dwService = DynamicWidgetService();
  bool _isLoading = false;

  String get projectId => _projectId;

  Project get project => _project;

  NewSurveyUserRequest get nsuReq => _nsuReq;

  bool get isLoading => _isLoading;

  List<SupportRoleType> get supportRoles => _srtList;

  Map<String, double> get minHours => _minHours;

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

  // init
  void initOnReady() {
    setBuzy(true);
    _surveyProjects.forEach((element) {
      _srtLists.add(element.supportRoleTypes);
    });
    _srtList = _srtLists.expand((i) => i).toList();
    notifyListeners();
    setBuzy(false);
  }

  void selectMinHours(double value, String id) {
    _minHours[id] = value;
    notifyListeners();
  }
  
  void onSave() {

  }
}
