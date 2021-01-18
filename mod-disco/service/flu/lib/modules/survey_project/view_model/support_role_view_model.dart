import 'package:flutter/material.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/shared_repositories/disco_project_repo.dart';
import 'package:mod_disco/core/shared_repositories/survey_project_repo.dart';
import 'package:mod_disco/core/shared_repositories/survey_user_repo.dart';
import 'package:mod_disco/core/shared_services/dynamic_widget_service.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/auth_repo.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';
import 'package:sys_core/sys_core.dart';

class SupportRoleViewModel extends BaseModel {
  Project _project;
  String _accountId = "";
  List<SurveyProject> _surveyProjects;
  NewSurveyUserRequest _nsuReq;
  List<List<SupportRoleType>> _srtLists = [];
  List<SupportRoleType> _srtList = [];
  Map<String, double> _minHours = {};
  DynamicWidgetService dwService = DynamicWidgetService();
  bool _isLoading = false;

  Project get project => _project;

  NewSurveyUserRequest get nsuReq => _nsuReq;

  bool get isLoading => _isLoading;

  List<SupportRoleType> get supportRoles => _srtList;

  Map<String, double> get minHours => _minHours;
  Map<String, NewSupportRoleValue> _supportRoleMap = {};

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
  Future<void> initOnReady() async {
    setLoading(true);
    _surveyProjects.forEach((element) {
      _srtLists.add(element.supportRoleTypes);
    });
    _srtList = _srtLists.expand((i) => i).toList();
    await isUserLoggedIn();
    notifyListeners();
    setLoading(false);
  }

  void selectMinHours(double value, String id) {
    _minHours[id] = value;
    _supportRoleMap[id] = SurveyProjectRepo.createSupportRoleValue(
      pledged: value.toInt(),
      surveyUserRefName: _nsuReq.surveyUserName,
      supportRoleTypeRefId: id,
    );
    notifyListeners();
  }

  Future<void> onSave(BuildContext context) async {
    List<NewSupportRoleValue> _srvList = [];
    _supportRoleMap.forEach((key, value) {
      _srvList.add(value);
    });
    final _userRole = UserRoles()
      ..role = Roles.USER
      ..projectId = _project.id
      ..orgId = _project.orgId;
    if (!isLoggedOn) {
      showDialog(
        context: context,
        builder: (context) => AuthDialog(
          isSignIn: false,
          userRole: _userRole,
          callback: () async {
            _accountId = await getTempAccountId();
            _nsuReq.sysAccountUserRefId = _accountId;
            await SurveyUserRepo.newSurveyUser(
              surveyProjectId: _nsuReq.surveyProjectRefId,
              sysAccountAccountRefId: _nsuReq.sysAccountUserRefId,
              surveyUserName: _nsuReq.surveyUserName,
              userNeedsValueList: _nsuReq.userNeedValues,
              supportRoleValueList: _srvList,
            ).then((_) {
              notify(
                context: context,
                message:
                    "You've joined ${project.name}, login to see your detail",
                error: false,
              );
            });
            await DiscoProjectRepo.getProjectDetails(
                    accountProjRefId: _project.id)
                .then((res) {
              DiscoProjectRepo.updateDiscoProject(
                discoProjectId: res.projectId,
                pledged: res.alreadyPledged + 1,
              );
            });
          },
        ),
      );
    } else {
      await SurveyUserRepo.newSurveyUser(
        surveyProjectId: _nsuReq.surveyProjectRefId,
        sysAccountAccountRefId: _nsuReq.sysAccountUserRefId,
        surveyUserName: _nsuReq.surveyUserName,
        userNeedsValueList: _nsuReq.userNeedValues,
        supportRoleValueList: _srvList,
      ).then((_) {
        notify(
          context: context,
          message: "You've joined ${project.name}, login to see your detail",
          error: false,
        );
      });
      await DiscoProjectRepo.getProjectDetails(accountProjRefId: _project.id)
          .then((res) {
        DiscoProjectRepo.updateDiscoProject(
          discoProjectId: res.projectId,
          pledged: res.alreadyPledged + 1,
        );
      });
    }
  }
}
