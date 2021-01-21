import 'package:asuka/asuka.dart' as asuka;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/shared_repositories/disco_project_repo.dart';
import 'package:mod_disco/core/shared_repositories/survey_project_repo.dart';
import 'package:mod_disco/core/shared_repositories/survey_user_repo.dart';
import 'package:mod_disco/core/shared_services/dynamic_widget_service.dart';
import 'package:mod_disco/core/shared_widgets/dialog_widget.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:random_string/random_string.dart';
import 'package:sys_core/sys_core.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/auth_repo.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

class SurveyProjectViewModel extends BaseModel {
  String _projectId;
  Project _project;
  List<SurveyProject> _surveyProjects =
      List<SurveyProject>.empty(growable: true);
  List<List<UserNeedsType>> _userNeedsLists =
      List<List<UserNeedsType>>.empty(growable: true);
  Map<String, NewUserNeedsValue> _userNeedsValueMap = {};
  NewSurveyUserRequest _surveyUser = NewSurveyUserRequest();
  UpdateSurveyUserRequest _updateSurveyUserRequest = UpdateSurveyUserRequest();
  String _accountId = "";
  Map<String, Map<String, List<UserNeedsType>>> _userNeedsQuestionMap =
      Map<String, Map<String, List<UserNeedsType>>>();
  bool _isLoggedOn = false;

  Map<String, Map<String, String>> dwService = {};
  bool _isLoading = false;
  UserRoles _userRole = UserRoles();

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

  SurveyProjectViewModel({@required String sysAccountProjectId}) {
    _projectId = sysAccountProjectId;
  }

  Future<void> fetchSurveyProject() async {
    _setLoading(true);
    final _proj = await OrgProjRepo.getProject(id: _projectId);
    _project = _proj;
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
    initializeDropdownSelectionData();
    _setLoading(false);
  }

  void selectNeed(String key, value, {bool deferNotify: false}) {
    _value[key] = value;

    if (!deferNotify) {
      notifyListeners();
    }
  }

//
  void initializeDropdownSelectionData() {
    if (this.dwService.length == 0) {
      // We need to track which option of the dropdown was selected
      // userNeedsList.forEach((group) {
      //   String key = generateDropdownKey(group);
      //   this.dwService[key] = null;
      // });
      this._userNeedsQuestionMap.forEach((key, value) {
        _userNeedsQuestionMap[key]
            .forEach((questionTypeKey, questionTypeValues) {
          if (questionTypeKey == "dropdown") {
            // group by its question group
            final grouped = groupBy(
                questionTypeValues, (UserNeedsType unt) => unt.questionGroup);
            grouped.forEach((k, v) {
              String key = generateDropdownKey(v);
              this.dwService[k] = {key: null};
            });
          }
        });
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
    List<NewUserNeedsValue> _untList = [];
    _userNeedsValueMap.forEach((key, value) {
      _untList.add(value);
    });
    showActionDialogBox(
      onPressedNo: () async {
        _userRole
          ..role = Roles.USER
          ..projectId = _projectId
          ..orgId = _project.orgId;
        if (!_isLoggedOn) {
          asuka.showDialog(
            builder: (context) => AuthDialog(
              isSignIn: false,
              userRole: _userRole,
              callback: () async {
                _accountId = await getTempAccountId();
                _surveyUser.sysAccountUserRefId = _accountId;
                await SurveyUserRepo.newSurveyUser(
                  surveyProjectId: _surveyUser.surveyProjectRefId,
                  sysAccountAccountRefId: _surveyUser.sysAccountUserRefId,
                  surveyUserName: _surveyUser.surveyUserName,
                  userNeedsValueList: _untList,
                ).then((_) {
                  notify(
                    context: context,
                    message:
                        "You joined ${project.name}, login to see your detail",
                    error: false,
                  );
                });
                await DiscoProjectRepo.getProjectDetails(
                        accountProjRefId: _projectId)
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
            surveyProjectId: _surveyUser.surveyProjectRefId,
            sysAccountAccountRefId: _surveyUser.sysAccountUserRefId,
            surveyUserName: _surveyUser.surveyUserName,
            userNeedsValueList: _untList,
          );
          await DiscoProjectRepo.getProjectDetails(accountProjRefId: _projectId)
              .then((res) {
            DiscoProjectRepo.updateDiscoProject(
              discoProjectId: res.projectId,
              pledged: res.alreadyPledged + 1,
            );
          });
        }
      },
      onPressedYes: () {
        if (_surveyUser.userNeedValues.isEmpty) {
          _surveyUser.userNeedValues.addAll(_untList);
        } else {
          _surveyUser.userNeedValues.clear();
          _surveyUser.userNeedValues.addAll(_untList);
        }
        Modular.to.pushReplacementNamed(Modular.get<Paths>().supportRoles,
            arguments: {
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
            grouped.forEach((k, v) {
              Map<String, String> questionData = {};
              v.forEach(
                  (userNeed) => questionData[userNeed.name] = userNeed.id);
              String dropdownOptionKey =
                  generateDropdownKey(questionTypeValues);
              _surveyUser
                ..surveyProjectRefId =
                    questionTypeValues.first.surveyProjectRefId;
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
                      DynamicDropdownButton(
                        data: questionData,
                        selectedOption: this.dwService[k]
                            [dropdownOptionKey], // The selected answer
                        callbackInjection: (data, selected) {
                          // the onChangedCallback
                          // Because each dropdown option is technically a "question" in the db
                          // We need to set each option/question as true/false based on its relative selection
                          data.forEach((userNeedAnswer, userNeedId) {
                            // Needs to go through each "option" in the dropdown
                            if (userNeedAnswer == selected) {
                              // If we selected it this time set that question id to true
                              this.selectNeed(userNeedId, true,
                                  deferNotify: true);
                              final newUserNeedValue =
                                  SurveyProjectRepo.createUserNeedsValue(
                                surveyUserRefName: _surveyUser.surveyUserName,
                                comment: _accountId + "answer",
                                userNeedsTypeRefId: userNeedId,
                              );
                              _appendUserNeedsValue(
                                  newUserNeedValue, dropdownOptionKey);
                              this.dwService[k][dropdownOptionKey] = selected;
                            } else {
                              // Otherwise set the others to false
                              this.selectNeed(userNeedId, false,
                                  deferNotify: true);
                            }
                            notifyListeners();
                          });
                        },
                      ),
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
                  _surveyUser
                    ..surveyProjectRefId = userNeedsType.surveyProjectRefId;
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
                  _surveyUser
                    ..surveyProjectRefId = userNeedsType.surveyProjectRefId;
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
