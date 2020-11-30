import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/shared_repositories/survey_project_repo.dart';
import 'package:mod_disco/core/shared_repositories/survey_user_repo.dart';
import 'package:mod_disco/core/shared_services/base_model.dart';
import 'package:mod_disco/core/shared_widgets/filter_widget.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/auth_repo.dart';
import 'package:collection/collection.dart';

class DashboardDetailViewModel extends BaseModel {
  String _orgId;
  String _projectId;
  List<SurveyProject> _surveyProjects = [];
  Map<String, List<SurveyUser>> _surveyUserMap = {};
  Map<String, Map<String, List<UserNeedsType>>> _userNeedsQuestionMap =
      Map<String, Map<String, List<UserNeedsType>>>();
  Map<String, Map<String, List<SupportRoleType>>> _supportRoleTypeMap =
      Map<String, Map<String, List<SupportRoleType>>>();
  Map<String, bool> _selectedCondData = {};
  Map<String, bool> _selectedRolesData = {};

  DashboardDetailViewModel(
      {@required String orgId, @required String projectId}) {
    this._orgId = orgId;
    this._projectId = projectId;
    notifyListeners();
  }

  Future<void> _fetchSurveyProject() async {
    List<List<UserNeedsType>> _userNeedsTypeList = [];
    List<List<SupportRoleType>> _supportRoleTypeList = [];
    setLoading(true);
    await isLoggedIn();
    await SurveyProjectRepo.listSurveyProjects(
            sysAccountProjectRefId: _projectId, orderBy: 'name')
        .then((res) {
      _surveyProjects = res;
      notifyListeners();
    }).then((_) {
      _surveyProjects.forEach((sp) {
        _userNeedsTypeList.add(sp.userNeedTypes);
        _supportRoleTypeList.add(sp.supportRoleTypes);
      });
      _userNeedsQuestionMap =
          SurveyProjectRepo.getGroupedUserNeedsType(_userNeedsTypeList);
      _supportRoleTypeMap =
          SurveyProjectRepo.getGroupedSupportRoleType(_supportRoleTypeList);
    });
    notifyListeners();
    setLoading(false);
  }

  Future<void> _fetchRelatedSurveyUsers() async {
    setLoading(true);
    _surveyProjects.forEach((sp) async {
      await SurveyUserRepo.listSurveyUsers(
        surveyProjectId: sp.surveyProjectId,
        orderBy: 'survey_user_id',
      ).then((res) {
        if (res != null && res.isNotEmpty) {
          _surveyUserMap[sp.surveyProjectId] = res;
        }
      });
    });
    notifyListeners();
    setLoading(false);
  }

  Future<void> fetchUserDatas() async {
    await _fetchSurveyProject();
    // await _fetchRelatedSurveyUsers();
    _userNeedsQuestionMap.forEach((key, value) {
      _userNeedsQuestionMap[key].forEach((questionTypeKey, questionTypeValues) {
        questionTypeValues.forEach((unt) {
          _selectedCondData[unt.id] = false;
        });
      });
    });
    _supportRoleTypeMap.forEach((key, value) {
      _supportRoleTypeMap[key].forEach((srtKey, srtVals) {
        srtVals.forEach((srt) {
          _selectedRolesData[srt.id] = false;
        });
      });
    });
  }

  void _toggleselectedCondData(String id, bool val) {
    _selectedCondData.forEach((key, value) {
      key == id ? _selectedCondData[key] = val : _selectedCondData[key] = false;
    });
    notifyListeners();
  }

  void _toggleSelectedRolesData(String id, bool val) {
    _selectedRolesData.forEach((key, value) {
      key == id
          ? _selectedRolesData[key] = val
          : _selectedRolesData[key] = false;
    });
    notifyListeners();
  }

  Widget buildConditionsFilter(BuildContext context) {
    List<Widget> conditionsFilterList = [];
    _userNeedsQuestionMap.forEach((key, value) {
      _userNeedsQuestionMap[key].forEach((questionTypeKey, questionTypeValues) {
        switch (questionTypeKey) {
          case 'singlecheckbox':
            questionTypeValues.forEach((unt) {
              conditionsFilterList.add(
                FilterCheckbox(
                  checkboxVal: _selectedCondData[unt.id],
                  onChanged: (val) => _toggleselectedCondData(unt.id, val),
                  description: unt.description,
                ),
              );
            });
            break;
          case 'textfield':
            questionTypeValues.forEach((unt) {
              conditionsFilterList.add(
                FilterCheckbox(
                  checkboxVal: _selectedCondData[unt.id],
                  onChanged: (val) => _toggleselectedCondData(unt.id, val),
                  description: unt.description,
                ),
              );
            });
            break;
          case "dropdown":
            final grouped = groupBy(
                questionTypeValues, (UserNeedsType unt) => unt.questionGroup);
            grouped.forEach((k, v) {
              conditionsFilterList.add(
                ExpansionTile(
                  title: Text(v.first.dropdownQuestion,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.w500)),
                  children: v.map((unt) {
                    return FilterCheckbox(
                      checkboxVal: _selectedCondData[unt.id],
                      onChanged: (val) => _toggleselectedCondData(unt.id, val),
                      description: unt.comment,
                    );
                  }).toList(),
                ),
              );
            });
            break;
          default:
            break;
        }
      });
    });
    return ExpansionTile(
      title: Text(
        ModDiscoLocalizations.of(context).translate('conditions'),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontWeight: FontWeight.bold),
      ),
      children: conditionsFilterList,
    );
  }

  Widget buildRolesFilter(BuildContext context) {
    List<Widget> rolesFilterList = [];
    _supportRoleTypeMap.forEach((key, value) {
      _supportRoleTypeMap[key].forEach((supportKey, supportValue) {
        supportValue.forEach((srt) {
          rolesFilterList.add(
            FilterCheckbox(
              checkboxVal: _selectedRolesData[srt.id],
              onChanged: (val) => _toggleSelectedRolesData(srt.id, val),
              description: srt.description,
            ),
          );
        });
      });
    });
    return ExpansionTile(
      title: Text(
        ModDiscoLocalizations.of(context).translate('roles'),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontWeight: FontWeight.bold),
      ),
      children: rolesFilterList,
    );
  }
}
