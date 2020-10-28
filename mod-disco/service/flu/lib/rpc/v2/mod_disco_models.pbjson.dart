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
    const {'1': 'survey_schema_types', '3': 3, '4': 1, '5': 12, '10': 'surveySchemaTypes'},
    const {'1': 'survey_filter_types', '3': 4, '4': 1, '5': 12, '10': 'surveyFilterTypes'},
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
    const {'1': 'survey_schema_values', '3': 4, '4': 1, '5': 12, '10': 'surveySchemaValues'},
    const {'1': 'survey_schema_filters', '3': 5, '4': 1, '5': 12, '10': 'surveySchemaFilters'},
    const {'1': 'created_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'updated_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

const IdRequest$json = const {
  '1': 'IdRequest',
  '2': const [
    const {'1': 'survey_user_id', '3': 1, '4': 1, '5': 9, '10': 'surveyUserId'},
    const {'1': 'sys_account_project_id', '3': 2, '4': 1, '5': 9, '10': 'sysAccountProjectId'},
    const {'1': 'survey_project_id', '3': 3, '4': 1, '5': 9, '10': 'surveyProjectId'},
    const {'1': 'sys_account_account_id', '3': 4, '4': 1, '5': 9, '10': 'sysAccountAccountId'},
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
  ],
};

const ListResponse$json = const {
  '1': 'ListResponse',
  '2': const [
    const {'1': 'survey_projects', '3': 1, '4': 3, '5': 11, '6': '.v2.mod_disco.services.SurveyProject', '10': 'surveyProjects'},
    const {'1': 'survey_users', '3': 2, '4': 3, '5': 11, '6': '.v2.mod_disco.services.SurveyUser', '10': 'surveyUsers'},
    const {'1': 'next_page_id', '3': 3, '4': 1, '5': 3, '10': 'nextPageId'},
  ],
};

const NewSurveyProjectRequest$json = const {
  '1': 'NewSurveyProjectRequest',
  '2': const [
    const {'1': 'sys_account_project_ref_id', '3': 1, '4': 1, '5': 9, '10': 'sysAccountProjectRefId'},
    const {'1': 'survey_schema_types', '3': 2, '4': 1, '5': 12, '10': 'surveySchemaTypes'},
    const {'1': 'survey_filter_types', '3': 3, '4': 1, '5': 12, '10': 'surveyFilterTypes'},
  ],
};

const NewSurveyUserRequest$json = const {
  '1': 'NewSurveyUserRequest',
  '2': const [
    const {'1': 'survey_project_ref_id', '3': 1, '4': 1, '5': 9, '10': 'surveyProjectRefId'},
    const {'1': 'sys_account_user_ref_id', '3': 2, '4': 1, '5': 9, '10': 'sysAccountUserRefId'},
    const {'1': 'survey_schema_types', '3': 3, '4': 1, '5': 12, '10': 'surveySchemaTypes'},
    const {'1': 'survey_filter_types', '3': 4, '4': 1, '5': 12, '10': 'surveyFilterTypes'},
  ],
};

const UpdateSurveyProjectRequest$json = const {
  '1': 'UpdateSurveyProjectRequest',
  '2': const [
    const {'1': 'survey_project_ref_id', '3': 1, '4': 1, '5': 9, '10': 'surveyProjectRefId'},
    const {'1': 'survey_schema_types', '3': 2, '4': 1, '5': 12, '10': 'surveySchemaTypes'},
    const {'1': 'survey_filter_types', '3': 3, '4': 1, '5': 12, '10': 'surveyFilterTypes'},
  ],
};

const UpdateSurveyUserRequest$json = const {
  '1': 'UpdateSurveyUserRequest',
  '2': const [
    const {'1': 'survey_user_ref_id', '3': 1, '4': 1, '5': 9, '10': 'surveyUserRefId'},
    const {'1': 'survey_schema_types', '3': 2, '4': 1, '5': 12, '10': 'surveySchemaTypes'},
    const {'1': 'survey_filter_types', '3': 3, '4': 1, '5': 12, '10': 'surveyFilterTypes'},
  ],
};

