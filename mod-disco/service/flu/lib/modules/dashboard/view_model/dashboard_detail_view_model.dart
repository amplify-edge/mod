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
import 'package:fixnum/fixnum.dart';

class DashboardDetailViewModel extends BaseModel {
  String _orgId;
  String _projectId;
  String _errMsg;
  Map<String, dynamic> _filter;
  String _tableName;
  bool _hasError = false;
  bool _isLoadingSurveyData = false;
  List<SurveyProject> _surveyProjects = [];
  Map<String, List<SurveyUser>> _surveyUserMap = {};
  Map<String, Map<String, List<UserNeedsType>>> _userNeedsQuestionMap =
      Map<String, Map<String, List<UserNeedsType>>>();
  Map<String, Map<String, List<SupportRoleType>>> _supportRoleTypeMap =
      Map<String, Map<String, List<SupportRoleType>>>();
  Map<String, bool> _selectedCondData = {};
  Map<String, bool> _selectedRolesData = {};
  StatisticResponse _statisticsResponse;
  int _totalCount = 0;
  int _rowsPerPage = 0;
  int _defaultPerPageEntries = 5;
  Int64 _nextPageId = Int64.ZERO;

  int get rowsPerPage => _rowsPerPage;

  int get totalCount => _totalCount;

  String get errMsg => _errMsg;

  bool get hasError => _hasError;

  bool get isLoadingSurveyData => _isLoadingSurveyData;

  List<SurveyValuePlusAccount> get surveyDatas =>
      _statisticsResponse?.surveyValuePlusAccount;

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

  void _setLoadingSurveyData(bool val) {
    _isLoadingSurveyData = val;
    notifyListeners();
  }

  void _setStatisticsResp(StatisticResponse resp) {
    if (_statisticsResponse == null) {
      _statisticsResponse = resp;
    } else {
      _statisticsResponse.nextPageId = resp.nextPageId;
      _statisticsResponse.surveyValuePlusAccount
          .addAll(resp.surveyValuePlusAccount);
    }
    notifyListeners();
  }

  void _setTotalCount(Int64 val) {
    _totalCount = val.toInt();
    notifyListeners();
  }

  void _setDataFilter(Map<String, dynamic> val) {
    _filter = val;
    notifyListeners();
  }

  void _setTableName(String val) {
    _tableName = val;
    notifyListeners();
  }

  void _setErrMsg(String msg) {
    _errMsg = msg;
    notifyListeners();
  }

  void _setHasError(bool val) {
    _hasError = val;
    notifyListeners();
  }

  void setChangeRowsPerPage(int val) {
    _rowsPerPage = val;
    notifyListeners();
  }

  void _setNextPageId(Int64 val) {
    _nextPageId = val;
    notifyListeners();
  }

  Future<void> _fetchDashboardData() async {
    await SurveyUserRepo.getDashboardTable(
      currentPageId: _nextPageId.toString(),
      tableName: _tableName,
      filters: _filter,
      orderBy: 'id',
      perPageEntries: _defaultPerPageEntries,
    ).then((resp) {
      _setHasError(false);
      _setErrMsg(null);
      _setStatisticsResp(resp);
      _setTotalCount(resp.totalCount);
      _setNextPageId(Int64.parseInt(resp.nextPageId));
      setChangeRowsPerPage(resp.surveyValuePlusAccount?.length ?? 0);
      notifyListeners();
    }).catchError((e) {
      _setErrMsg(e.toString());
      _setHasError(true);
    });
  }

  Future<void> _toggleSelectedCondData(String id, bool val) async {
    _setLoadingSurveyData(true);
    _selectedCondData.forEach((key, value) {
      key == id ? _selectedCondData[key] = val : _selectedCondData[key] = false;
    });
    _setDataFilter({'user_needs_type_ref_id': id});
    _setTableName('user_needs_value');
    _setNextPageId(Int64.ZERO);
    await _fetchDashboardData();
    _setLoadingSurveyData(false);
  }

  Future<void> _toggleSelectedRolesData(String id, bool val) async {
    _setLoadingSurveyData(true);
    _selectedRolesData.forEach((key, value) {
      key == id
          ? _selectedRolesData[key] = val
          : _selectedRolesData[key] = false;
    });
    _setDataFilter({'support_role_type_ref_id': id});
    _setTableName('support_role_values');
    _setNextPageId(Int64.ZERO);
    await _fetchDashboardData();
    _setLoadingSurveyData(false);
  }

  Future<void> handleNextPage() async {
    await _fetchDashboardData();
  }

  Future<void> handleResetAll() async {
    _setErrMsg(null);
    _setDataFilter({});
    _setTableName('');
    _setStatisticsResp(null);
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
                  onChanged: (val) async =>
                      await _toggleSelectedCondData(unt.id, val),
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
                  onChanged: (val) async =>
                      await _toggleSelectedCondData(unt.id, val),
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
                      onChanged: (val) async =>
                          await _toggleSelectedCondData(unt.id, val),
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
        ModDiscoLocalizations.of(context).translate('userNeeds'),
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
              onChanged: (val) async =>
                  await _toggleSelectedRolesData(srt.id, val),
              description: srt.description,
            ),
          );
        });
      });
    });
    return ExpansionTile(
      title: Text(
        ModDiscoLocalizations.of(context).translate('supportRoles'),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontWeight: FontWeight.bold),
      ),
      children: rolesFilterList,
    );
  }
}
