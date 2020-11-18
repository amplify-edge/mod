import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/shared_repositories/survey_project_repo.dart';
import 'package:mod_disco/core/shared_services/dynamic_widget_service.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

class SurveyProjectViewModel extends BaseModel {
  String _projectId;
  Project _project;
  List<SurveyProject> _surveyProjects = List<SurveyProject>();
  List<List<UserNeedsType>> _userNeedsLists = List<List<UserNeedsType>>();
  DynamicWidgetService dwService = DynamicWidgetService();
  bool _isLoading = false;

  // final orgService = Modular.get<OrgsService>();
  // final userNeedService = Modular.get<UserNeedService>();
  // final userNeedAnswerService = Modular.get<UserNeedAnswerService>();

  String get projectId => _projectId;

  Project get project => _project;

  bool get isLoading => _isLoading;

  Map<String, dynamic> _value = <String, dynamic>{};

  Map<String, dynamic> get value => _value;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  SurveyProjectViewModel({@required String sysAccountProjectRefId}) {
    _projectId = sysAccountProjectRefId;
    notifyListeners();
  }

  Future<void> fetchSurveyProject() async {
    await OrgProjRepo.getProject(id: _projectId).then((res) {
      _project = res;
      notifyListeners();
    });
    await SurveyProjectRepo.listSurveyProjects(
            sysAccountProjectRefId: _projectId, orderBy: 'name')
        .then((res) {
      _surveyProjects = res;
      res.forEach((sp) {
        _userNeedsLists.add(sp.userNeedTypes);
      });
      notifyListeners();
    });
  }

// initializeData(String projectId) {
//   setBuzy(true);
//
//   _orgId = orgId;
//   _org = orgService.getOrgById(orgId);
//   _userNeedsByGroup = userNeedService.getGroupedUserNeedsByOrgId(orgId);
//
//   this.initializeDropdownSelectionData(_userNeedsByGroup);
//
//   setBuzy(false);
// }
//
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

  String _formatData(dynamic data) {
    if (data.runtimeType == 'bool') {
      return data == true ? '1' : '0';
    }

    return data.toString();
  }

// TODO create the ones that don't already exist, update the ones that do
// void save() {
//   this.value.forEach((key, value) {
//     this.userNeedAnswerService.repository.createUserNeedAnswer(
//       answer: this._formatData(value),
//       refQuestionId: key,
//       refUserId: "199",
//       // TODO update with user session data
//       prod: "1",
//       comment: "n/a",
//     );
//   });
// }

  void navigateNext(BuildContext context) {
    showActionDialogBox(
      onPressedNo: () {
        print("SAVE THE TEMP USER RESPONSE HERE");
        // this.save();
        // Modular.to.pushNamed('/account/signup');
      },
      onPressedYes: () {
        print("SAVE THE TEMP USER RESPONSE HERE");
        Modular.to.pop();
        Modular.to.pushNamed(
            Modular.get<Paths>().supportRoles.replaceAll(':id', _projectId));
      },
      title: ModDiscoLocalizations.of(context).translate('supportRole'),
      description:
          ModDiscoLocalizations.of(context).translate('provideSupportRole'),
      buttonText: ModDiscoLocalizations.of(context).translate('yes'),
      buttonTextCancel: ModDiscoLocalizations.of(context).translate('no'),
    );
  }

  /// Builds all of the dynamic questions from the userNeed objects
  List<Widget> buildWidgetList(BuildContext context) {
    int questionCount = 1;
    const SizedBox spacer = SizedBox(height: 8.0);
    List<Widget> viewWidgetList = [];

    this._userNeedsLists.forEach((userNeedGroup) {
      if (userNeedGroup.length > 1) {
        Map<String, String> data = {};
        userNeedGroup
            .forEach((userNeed) => data[userNeed.description] = userNeed.id);

        String dropdownOptionKey = generateDropdownKey(userNeedGroup);

        // Create new button
        DynamicDropdownButton ddb = DynamicDropdownButton(
            data: data,
            selectedOption: this.dwService.selectedDropdownOptions[
                dropdownOptionKey], // The selected description
            callbackInjection: (data, selected) {
              // the onChangedCallback
              // Because each dropdown option is technically a "question" in the db
              // We need to set each option/question as true/false based on its relative selection
              data.forEach((userNeedDesc, userNeedId) {
                // Needs to go through each "option" in the dropdown
                if (userNeedDesc == selected) {
                  // If we selected it this time set that question id to true
                  this.selectNeed(userNeedId, true, deferNotify: true);
                  this.dwService.selectedDropdownOptions[dropdownOptionKey] =
                      selected;
                } else {
                  // Otherwise set the others to false
                  this.selectNeed(userNeedId, false, deferNotify: true);
                }
              });
              notifyListeners();
            });

        viewWidgetList.add(Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (questionCount++).toString() +
                        '. ' +
                        'Help us understand your needs',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  spacer,
                  ddb,
                ])));
      } else if (userNeedGroup.first.isTextbox) {
        // If there is only 1 and it's a textbox
        UserNeedsType _userNeed = userNeedGroup.first;

        viewWidgetList.add(DynamicMultilineTextFormField(
          question: (questionCount++).toString() + '. ' + _userNeed.description,
          callbackInjection: (String value) {
            this.selectNeed(_userNeed.id, value);
          },
        ));
      } else {
        // If there is only 1 and it is NOT a textbox
        UserNeedsType _userNeed = userNeedGroup.first;

        viewWidgetList.add(CheckboxListTile(
          title: Text(
            (questionCount++).toString() + '. ' + _userNeed.description,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          value: this.value[_userNeed.id] ?? false,
          onChanged: (bool value) {
            this.selectNeed(_userNeed.id, value);
          },
          //secondary: const Icon(FontAwesomeIcons.peopleCarry),
        ));
      }

      // Add the spacer
      viewWidgetList.add(spacer);
    });

    return viewWidgetList;
  }
}
