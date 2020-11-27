import 'package:mod_disco/core/shared_repositories/survey_project_repo.dart';
import 'package:mod_disco/core/shared_repositories/survey_user_repo.dart';
import 'package:mod_disco/core/shared_services/base_model.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/auth_repo.dart';

class DashboardDetailViewModel extends BaseModel {
  String _orgId;
  String _projectId;
  List<SurveyProject> _surveyProjects = [];
  Map<String, List<SurveyUser>> _surveyUserMap = {};

  DashboardDetailViewModel({String orgId, String projectId}) {
    this._orgId = orgId;
    this._projectId = projectId;
    notifyListeners();
  }

  Future<void> _fetchSurveyProject() async {
    setLoading(true);
    await isLoggedIn();
    await SurveyProjectRepo.listSurveyProjects(
            sysAccountProjectRefId: _projectId, orderBy: 'name')
        .then((res) {
      _surveyProjects = res;
      notifyListeners();
    });
    setLoading(false);
  }

  Future<void> _fetchRelatedSurveyUsers() async {
    _surveyProjects.forEach((sp) async {
      await SurveyUserRepo.listSurveyUsers(
        surveyProjectId: sp.surveyProjectId,
        orderBy: 'survey_user_id',
      ).then((res) {
        _surveyUserMap[sp.surveyProjectId] = res;
      });
    });
    notifyListeners();
  }

  Future<void> fetchUserDatas() async {
    await _fetchSurveyProject().then((_) async {
      await _fetchRelatedSurveyUsers();
    });
  }
}
