///
//  Generated code. Do not modify.
//  source: mod_disco_models.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const SurveyProject$json = const {
  '1': 'SurveyProject',
  '2': const [
    const {'1': 'survey_project_id', '3': 1, '4': 1, '5': 9, '10': 'surveyProjectId'},
    const {'1': 'sys_account_project_ref_id', '3': 2, '4': 1, '5': 9, '10': 'sysAccountProjectRefId'},
    const {'1': 'support_role_types', '3': 3, '4': 1, '5': 12, '10': 'supportRoleTypes'},
    const {'1': 'user_need_types', '3': 4, '4': 1, '5': 12, '10': 'userNeedTypes'},
    const {'1': 'created_at', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'updated_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

const SurveyUser$json = const {
  '1': 'SurveyUser',
  '2': const [
    const {'1': 'survey_user_id', '3': 1, '4': 1, '5': 9, '10': 'surveyUserId'},
    const {'1': 'survey_project_ref_id', '3': 2, '4': 1, '5': 9, '10': 'surveyProjectRefId'},
    const {'1': 'sys_account_account_ref_id', '3': 3, '4': 1, '5': 9, '10': 'sysAccountAccountRefId'},
    const {'1': 'support_role_values', '3': 4, '4': 1, '5': 12, '10': 'supportRoleValues'},
    const {'1': 'user_need_values', '3': 5, '4': 1, '5': 12, '10': 'userNeedValues'},
    const {'1': 'created_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'updated_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

const DiscoProject$json = const {
  '1': 'DiscoProject',
  '2': const [
    const {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    const {'1': 'sys_account_project_ref_id', '3': 2, '4': 1, '5': 9, '10': 'sysAccountProjectRefId'},
    const {'1': 'sys_account_org_ref_id', '3': 3, '4': 1, '5': 9, '10': 'sysAccountOrgRefId'},
    const {'1': 'goal', '3': 4, '4': 1, '5': 9, '10': 'goal'},
    const {'1': 'already_pledged', '3': 5, '4': 1, '5': 4, '10': 'alreadyPledged'},
    const {'1': 'action_time', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'actionTime'},
    const {'1': 'action_location', '3': 7, '4': 1, '5': 9, '10': 'actionLocation'},
    const {'1': 'min_pioneers', '3': 8, '4': 1, '5': 4, '10': 'minPioneers'},
    const {'1': 'min_rebels_media', '3': 9, '4': 1, '5': 4, '10': 'minRebelsMedia'},
    const {'1': 'min_rebels_to_win', '3': 10, '4': 1, '5': 4, '10': 'minRebelsToWin'},
    const {'1': 'action_length', '3': 11, '4': 1, '5': 9, '10': 'actionLength'},
    const {'1': 'action_type', '3': 12, '4': 1, '5': 9, '10': 'actionType'},
    const {'1': 'category', '3': 14, '4': 1, '5': 9, '10': 'category'},
    const {'1': 'contact', '3': 15, '4': 1, '5': 9, '10': 'contact'},
    const {'1': 'hist_precedents', '3': 16, '4': 1, '5': 9, '10': 'histPrecedents'},
    const {'1': 'strategy', '3': 17, '4': 1, '5': 9, '10': 'strategy'},
    const {'1': 'video_url', '3': 18, '4': 3, '5': 9, '10': 'videoUrl'},
    const {'1': 'unit_of_measures', '3': 19, '4': 1, '5': 9, '10': 'unitOfMeasures'},
    const {'1': 'created_at', '3': 20, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'updated_at', '3': 21, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

const NewDiscoProjectRequest$json = const {
  '1': 'NewDiscoProjectRequest',
  '2': const [
    const {'1': 'sys_account_project_ref_id', '3': 1, '4': 1, '5': 9, '10': 'sysAccountProjectRefId'},
    const {'1': 'sys_account_org_ref_id', '3': 2, '4': 1, '5': 9, '10': 'sysAccountOrgRefId'},
    const {'1': 'goal', '3': 3, '4': 1, '5': 9, '10': 'goal'},
    const {'1': 'already_pledged', '3': 4, '4': 1, '5': 4, '10': 'alreadyPledged'},
    const {'1': 'action_time', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'actionTime'},
    const {'1': 'action_location', '3': 6, '4': 1, '5': 9, '10': 'actionLocation'},
    const {'1': 'min_pioneers', '3': 7, '4': 1, '5': 4, '10': 'minPioneers'},
    const {'1': 'min_rebels_media', '3': 8, '4': 1, '5': 4, '10': 'minRebelsMedia'},
    const {'1': 'min_rebels_to_win', '3': 9, '4': 1, '5': 4, '10': 'minRebelsToWin'},
    const {'1': 'action_length', '3': 10, '4': 1, '5': 9, '10': 'actionLength'},
    const {'1': 'action_type', '3': 11, '4': 1, '5': 9, '10': 'actionType'},
    const {'1': 'category', '3': 12, '4': 1, '5': 9, '10': 'category'},
    const {'1': 'contact', '3': 13, '4': 1, '5': 9, '10': 'contact'},
    const {'1': 'hist_precedents', '3': 14, '4': 1, '5': 9, '10': 'histPrecedents'},
    const {'1': 'strategy', '3': 15, '4': 1, '5': 9, '10': 'strategy'},
    const {'1': 'video_url', '3': 16, '4': 3, '5': 9, '10': 'videoUrl'},
    const {'1': 'unit_of_measures', '3': 17, '4': 1, '5': 9, '10': 'unitOfMeasures'},
  ],
};

const UpdateDiscoProjectRequest$json = const {
  '1': 'UpdateDiscoProjectRequest',
  '2': const [
    const {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    const {'1': 'goal', '3': 2, '4': 1, '5': 9, '10': 'goal'},
    const {'1': 'already_pledged', '3': 3, '4': 1, '5': 4, '10': 'alreadyPledged'},
    const {'1': 'action_time', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'actionTime'},
    const {'1': 'action_location', '3': 5, '4': 1, '5': 9, '10': 'actionLocation'},
    const {'1': 'min_pioneers', '3': 6, '4': 1, '5': 4, '10': 'minPioneers'},
    const {'1': 'min_rebels_media', '3': 7, '4': 1, '5': 4, '10': 'minRebelsMedia'},
    const {'1': 'min_rebels_to_win', '3': 8, '4': 1, '5': 4, '10': 'minRebelsToWin'},
    const {'1': 'action_length', '3': 9, '4': 1, '5': 9, '10': 'actionLength'},
    const {'1': 'action_type', '3': 10, '4': 1, '5': 9, '10': 'actionType'},
    const {'1': 'category', '3': 11, '4': 1, '5': 9, '10': 'category'},
    const {'1': 'contact', '3': 12, '4': 1, '5': 9, '10': 'contact'},
    const {'1': 'hist_precedents', '3': 13, '4': 1, '5': 9, '10': 'histPrecedents'},
    const {'1': 'strategy', '3': 14, '4': 1, '5': 9, '10': 'strategy'},
    const {'1': 'video_url', '3': 15, '4': 1, '5': 9, '10': 'videoUrl'},
    const {'1': 'unit_of_measures', '3': 16, '4': 1, '5': 9, '10': 'unitOfMeasures'},
  ],
};

const IdRequest$json = const {
  '1': 'IdRequest',
  '2': const [
    const {'1': 'survey_user_id', '3': 1, '4': 1, '5': 9, '10': 'surveyUserId'},
    const {'1': 'sys_account_project_id', '3': 2, '4': 1, '5': 9, '10': 'sysAccountProjectId'},
    const {'1': 'survey_project_id', '3': 3, '4': 1, '5': 9, '10': 'surveyProjectId'},
    const {'1': 'sys_account_account_id', '3': 4, '4': 1, '5': 9, '10': 'sysAccountAccountId'},
    const {'1': 'disco_project_id', '3': 5, '4': 1, '5': 9, '10': 'discoProjectId'},
    const {'1': 'sys_account_org_id', '3': 6, '4': 1, '5': 9, '10': 'sysAccountOrgId'},
  ],
};

const ListRequest$json = const {
  '1': 'ListRequest',
  '2': const [
    const {'1': 'id_request', '3': 1, '4': 1, '5': 11, '6': '.v2.mod_disco.services.IdRequest', '10': 'idRequest'},
    const {'1': 'per_page_entries', '3': 2, '4': 1, '5': 3, '10': 'perPageEntries'},
    const {'1': 'order_by', '3': 3, '4': 1, '5': 9, '10': 'orderBy'},
    const {'1': 'current_page_id', '3': 4, '4': 1, '5': 9, '10': 'currentPageId'},
    const {'1': 'filters', '3': 5, '4': 1, '5': 12, '10': 'filters'},
    const {'1': 'isDescending', '3': 6, '4': 1, '5': 8, '10': 'isDescending'},
  ],
};

const ListResponse$json = const {
  '1': 'ListResponse',
  '2': const [
    const {'1': 'survey_projects', '3': 1, '4': 3, '5': 11, '6': '.v2.mod_disco.services.SurveyProject', '10': 'surveyProjects'},
    const {'1': 'survey_users', '3': 2, '4': 3, '5': 11, '6': '.v2.mod_disco.services.SurveyUser', '10': 'surveyUsers'},
    const {'1': 'next_page_id', '3': 3, '4': 1, '5': 3, '10': 'nextPageId'},
    const {'1': 'disco_projects', '3': 4, '4': 3, '5': 11, '6': '.v2.mod_disco.services.DiscoProject', '10': 'discoProjects'},
  ],
};

const NewSurveyProjectRequest$json = const {
  '1': 'NewSurveyProjectRequest',
  '2': const [
    const {'1': 'sys_account_project_ref_id', '3': 1, '4': 1, '5': 9, '10': 'sysAccountProjectRefId'},
    const {'1': 'support_role_types', '3': 2, '4': 3, '5': 12, '10': 'supportRoleTypes'},
    const {'1': 'user_need_types', '3': 3, '4': 3, '5': 12, '10': 'userNeedTypes'},
  ],
};

const NewSurveyUserRequest$json = const {
  '1': 'NewSurveyUserRequest',
  '2': const [
    const {'1': 'survey_project_ref_id', '3': 1, '4': 1, '5': 9, '10': 'surveyProjectRefId'},
    const {'1': 'sys_account_user_ref_id', '3': 2, '4': 1, '5': 9, '10': 'sysAccountUserRefId'},
    const {'1': 'support_role_values', '3': 3, '4': 3, '5': 12, '10': 'supportRoleValues'},
    const {'1': 'user_need_values', '3': 4, '4': 3, '5': 12, '10': 'userNeedValues'},
  ],
};

const UpdateSurveyProjectRequest$json = const {
  '1': 'UpdateSurveyProjectRequest',
  '2': const [
    const {'1': 'survey_project_id', '3': 1, '4': 1, '5': 9, '10': 'surveyProjectId'},
    const {'1': 'support_role_types', '3': 2, '4': 3, '5': 12, '10': 'supportRoleTypes'},
    const {'1': 'user_need_types', '3': 3, '4': 3, '5': 12, '10': 'userNeedTypes'},
  ],
};

const UpdateSurveyUserRequest$json = const {
  '1': 'UpdateSurveyUserRequest',
  '2': const [
    const {'1': 'survey_user_id', '3': 1, '4': 1, '5': 9, '10': 'surveyUserId'},
    const {'1': 'support_role_values', '3': 2, '4': 3, '5': 12, '10': 'supportRoleValues'},
    const {'1': 'user_need_values', '3': 3, '4': 3, '5': 12, '10': 'userNeedValues'},
  ],
};

