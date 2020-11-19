import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/shared_repositories/survey_project_repo.dart';
import 'package:mod_disco/core/shared_services/dynamic_widget_service.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:random_string/random_string.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/auth_repo.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';
import 'package:collection/collection.dart';

class SurveyProjectViewModel extends BaseModel {
  String _projectId;
  Project _project;
  List<SurveyProject> _surveyProjects = List<SurveyProject>();
  List<List<UserNeedsType>> _userNeedsLists = List<List<UserNeedsType>>();
  Map<String, NewUserNeedsValue> _userNeedsValueMap = {};
  NewSurveyUserRequest _surveyUser = NewSurveyUserRequest();
  String _accountId = "";
  Map<String, Map<String, List<UserNeedsType>>> _userNeedsQuestionMap =
      Map<String, Map<String, List<UserNeedsType>>>();
  bool _isLoggedOn = false;

  DynamicWidgetService dwService = DynamicWidgetService();
  bool _isLoading = false;

  String get projectId => _projectId;

  Project get project => _project;

  bool get isLoading => _isLoading;
  Map<String, dynamic> _value = <String, dynamic>{};

  Map<String, dynamic> get value => _value;

  Map<String, Map<String, List<UserNeedsType>>> get userNeedsQuestionMap =>
      _userNeedsQuestionMap;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _appendUserNeedsValue(NewUserNeedsValue unv, String uniqueWidgetKey) {
    _userNeedsValueMap[uniqueWidgetKey] = unv;
    // notifyListeners();
  }

  Future<void> _isLoggedIn() async {
    final isLoggedOn = await isLoggedIn();
    _isLoggedOn = isLoggedOn;
    notifyListeners();
  }

  SurveyProjectViewModel({@required Project sysAccountProject}) {
    _project = sysAccountProject;
    _projectId = sysAccountProject.id;
    notifyListeners();
  }

  Future<void> fetchSurveyProject() async {
    _setLoading(true);
    await _isLoggedIn();
    if (_isLoggedOn) {
      _accountId = await getAccountId();
    } else {
      _accountId = await SurveyProjectRepo.getNewTempId();
    }
    _surveyUser.sysAccountUserRefId = _accountId;
    notifyListeners();
    await SurveyProjectRepo.listSurveyProjects(
            sysAccountProjectRefId: _projectId, orderBy: 'name')
        .then((res) {
      _surveyProjects = res;
      res.forEach((sp) {
        _userNeedsLists.add(sp.userNeedTypes);
      });
      notifyListeners();
      _userNeedsQuestionMap =
          SurveyProjectRepo.getGroupedUserNeedsType(_userNeedsLists);
      notifyListeners();
    });
    _setLoading(false);
  }

  void selectNeed(String key, value, {bool deferNotify: false}) {
    _value[key] = value;

    if (!deferNotify) {
      notifyListeners();
    }
  }

//
  void initializeDropdownSelectionData(
      List<List<UserNeedsType>> userNeedsList) {
    if (this.dwService.selectedDropdownOptions.length == 0) {
      // We need to track which option of the dropdown was selected
      userNeedsList.forEach((group) {
        String key = generateDropdownKey(group);
        this.dwService.selectedDropdownOptions[key] = null;
      });
    }
  }

  String generateDropdownKey(List<UserNeedsType> userNeeds) {
    String key = '';
    userNeeds.forEach((userNeed) => key += '|' + userNeed.id);

    // Remove the | off the font
    return key.substring(1);
  }

  void navigateNext(BuildContext context) {
    showActionDialogBox(
      onPressedNo: () {
        print("SAVE THE TEMP USER RESPONSE HERE");
        // this.save();
        // Modular.to.pushNamed('/account/signup');
      },
      onPressedYes: () {
        List<NewUserNeedsValue> _untList = [];
        _userNeedsValueMap.forEach((key, value) {
          _untList.add(value);
        });
        Modular.to.pop();
        Modular.to.pushNamed(Modular.get<Paths>().supportRoles, arguments: {
          'surveyProjectList': _surveyProjects,
          'surveyUserRequest': _surveyUser,
          'project': project,
          'accountId': _accountId
        });
      },
      title: ModDiscoLocalizations.of(context).translate('supportRole'),
      description:
          ModDiscoLocalizations.of(context).translate('provideSupportRole'),
      buttonText: ModDiscoLocalizations.of(context).translate('yes'),
      buttonTextCancel: ModDiscoLocalizations.of(context).translate('no'),
    );
  }

  List<Widget> buildSurveyUserNeeds(BuildContext context) {
    int questionCount = 1;
    const SizedBox spacer = SizedBox(height: 8.0);
    List<Widget> viewWidgetList = [];
    _surveyUser..surveyUserName = _accountId + randomString(8);
    this._userNeedsQuestionMap.forEach((key, value) {
      _userNeedsQuestionMap[key].forEach((questionTypeKey, questionTypeValues) {
        switch (questionTypeKey) {
          case "dropdown":
            // group by its question group
            final grouped = groupBy(
                questionTypeValues, (UserNeedsType unt) => unt.questionGroup);
            Map<String, Map<String, String>> questionDataMap = {};
            grouped.forEach((k, v) {
              Map<String, String> questionData = {};
              v.forEach(
                  (userNeed) => questionData[userNeed.name] = userNeed.id);
              questionDataMap[k] = questionData;
              String dropdownOptionKey =
                  generateDropdownKey(questionTypeValues);
              DynamicDropdownButton ddb = DynamicDropdownButton(
                  data: questionDataMap[k],
                  selectedOption: this.dwService.selectedDropdownOptions[
                      dropdownOptionKey], // The selected description
                  callbackInjection: (data, selected) {
                    // the onChangedCallback
                    // Because each dropdown option is technically a "question" in the db
                    // We need to set each option/question as true/false based on its relative selection
                    data.forEach((userNeedAnswer, userNeedId) {
                      // Needs to go through each "option" in the dropdown
                      if (userNeedAnswer == selected) {
                        // If we selected it this time set that question id to true
                        this.selectNeed(userNeedId, true, deferNotify: true);
                        final newUserNeedValue =
                            SurveyProjectRepo.createUserNeedsValue(
                          surveyUserRefName: _surveyUser.surveyUserName,
                          comment: _accountId + "answer",
                          userNeedsTypeRefId: userNeedId,
                        );
                        _appendUserNeedsValue(
                            newUserNeedValue, dropdownOptionKey);
                        this
                                .dwService
                                .selectedDropdownOptions[dropdownOptionKey] =
                            selected;
                      } else {
                        // Otherwise set the others to false
                        this.selectNeed(userNeedId, false, deferNotify: true);
                      }
                      notifyListeners();
                    });
                  });

              viewWidgetList.add(
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        (questionCount++).toString() +
                            '. ' +
                            v.first.dropdownQuestion,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      spacer,
                      ddb,
                    ],
                  ),
                ),
              );
            });
            break;
          case "textfield":
            questionTypeValues.forEach((userNeedsType) {
              final qcount = questionCount++;
              final widgetKey = "textfield_" + qcount.toString();
              viewWidgetList.add(DynamicMultilineTextFormField(
                question: qcount.toString() + ". " + userNeedsType.description,
                callbackInjection: (String value) {
                  this.selectNeed(userNeedsType.id, value);
                  final newUserNeedValue =
                      SurveyProjectRepo.createUserNeedsValue(
                    surveyUserRefName: _surveyUser.surveyUserName,
                    comment: _accountId + "answer",
                    userNeedsTypeRefId: userNeedsType.id,
                  );
                  _appendUserNeedsValue(newUserNeedValue, widgetKey);
                },
              ));
            });
            break;
          case "singlecheckbox":
            questionTypeValues.forEach((userNeedsType) {
              final qcount = questionCount++;
              final widgetKey = "checkbox" + qcount.toString();
              viewWidgetList.add(CheckboxListTile(
                title: Text(
                  qcount.toString() + '. ' + userNeedsType.description,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                value: this.value[userNeedsType.id] ?? false,
                onChanged: (bool value) {
                  this.selectNeed(userNeedsType.id, value);
                  final newUserNeedValue =
                      SurveyProjectRepo.createUserNeedsValue(
                    surveyUserRefName: _surveyUser.surveyUserName,
                    comment: _accountId + "answer",
                    userNeedsTypeRefId: userNeedsType.id,
                  );
                  _appendUserNeedsValue(newUserNeedValue, widgetKey);
                },
                //secondary: const Icon(FontAwesomeIcons.peopleCarry),
              ));
            });
            break;
          default:
            print("UNIMPLEMENTED");
        }
      });
    });
    return viewWidgetList;
  }
}
