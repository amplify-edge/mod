///
//  Generated code. Do not modify.
//  source: mod_disco_models.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/timestamp.pb.dart' as $2;

class SurveyProject extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SurveyProject', package: const $pb.PackageName('v2.mod_disco.services'), createEmptyInstance: create)
    ..aOS(1, 'surveyProjectId')
    ..aOS(2, 'sysAccountProjectRefId')
    ..a<$core.List<$core.int>>(3, 'surveySchemaTypes', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(4, 'surveyFilterTypes', $pb.PbFieldType.OY)
    ..aOM<$2.Timestamp>(5, 'createdAt', subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(6, 'updatedAt', subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false
  ;

  SurveyProject._() : super();
  factory SurveyProject() => create();
  factory SurveyProject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SurveyProject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SurveyProject clone() => SurveyProject()..mergeFromMessage(this);
  SurveyProject copyWith(void Function(SurveyProject) updates) => super.copyWith((message) => updates(message as SurveyProject));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SurveyProject create() => SurveyProject._();
  SurveyProject createEmptyInstance() => create();
  static $pb.PbList<SurveyProject> createRepeated() => $pb.PbList<SurveyProject>();
  @$core.pragma('dart2js:noInline')
  static SurveyProject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SurveyProject>(create);
  static SurveyProject _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get surveyProjectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set surveyProjectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSurveyProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurveyProjectId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sysAccountProjectRefId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sysAccountProjectRefId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSysAccountProjectRefId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSysAccountProjectRefId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get surveySchemaTypes => $_getN(2);
  @$pb.TagNumber(3)
  set surveySchemaTypes($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSurveySchemaTypes() => $_has(2);
  @$pb.TagNumber(3)
  void clearSurveySchemaTypes() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get surveyFilterTypes => $_getN(3);
  @$pb.TagNumber(4)
  set surveyFilterTypes($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSurveyFilterTypes() => $_has(3);
  @$pb.TagNumber(4)
  void clearSurveyFilterTypes() => clearField(4);

  @$pb.TagNumber(5)
  $2.Timestamp get createdAt => $_getN(4);
  @$pb.TagNumber(5)
  set createdAt($2.Timestamp v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => clearField(5);
  @$pb.TagNumber(5)
  $2.Timestamp ensureCreatedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $2.Timestamp get updatedAt => $_getN(5);
  @$pb.TagNumber(6)
  set updatedAt($2.Timestamp v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasUpdatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdatedAt() => clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureUpdatedAt() => $_ensure(5);
}

class SurveyUser extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SurveyUser', package: const $pb.PackageName('v2.mod_disco.services'), createEmptyInstance: create)
    ..aOS(1, 'surveyUserId')
    ..aOS(2, 'surveyProjectRefId')
    ..aOS(3, 'sysAccountAccountRefId')
    ..a<$core.List<$core.int>>(4, 'surveySchemaValues', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(5, 'surveySchemaFilters', $pb.PbFieldType.OY)
    ..aOM<$2.Timestamp>(6, 'createdAt', subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(7, 'updatedAt', subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false
  ;

  SurveyUser._() : super();
  factory SurveyUser() => create();
  factory SurveyUser.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SurveyUser.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SurveyUser clone() => SurveyUser()..mergeFromMessage(this);
  SurveyUser copyWith(void Function(SurveyUser) updates) => super.copyWith((message) => updates(message as SurveyUser));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SurveyUser create() => SurveyUser._();
  SurveyUser createEmptyInstance() => create();
  static $pb.PbList<SurveyUser> createRepeated() => $pb.PbList<SurveyUser>();
  @$core.pragma('dart2js:noInline')
  static SurveyUser getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SurveyUser>(create);
  static SurveyUser _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get surveyUserId => $_getSZ(0);
  @$pb.TagNumber(1)
  set surveyUserId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSurveyUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurveyUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get surveyProjectRefId => $_getSZ(1);
  @$pb.TagNumber(2)
  set surveyProjectRefId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSurveyProjectRefId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSurveyProjectRefId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sysAccountAccountRefId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sysAccountAccountRefId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSysAccountAccountRefId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSysAccountAccountRefId() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get surveySchemaValues => $_getN(3);
  @$pb.TagNumber(4)
  set surveySchemaValues($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSurveySchemaValues() => $_has(3);
  @$pb.TagNumber(4)
  void clearSurveySchemaValues() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get surveySchemaFilters => $_getN(4);
  @$pb.TagNumber(5)
  set surveySchemaFilters($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSurveySchemaFilters() => $_has(4);
  @$pb.TagNumber(5)
  void clearSurveySchemaFilters() => clearField(5);

  @$pb.TagNumber(6)
  $2.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($2.Timestamp v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $2.Timestamp get updatedAt => $_getN(6);
  @$pb.TagNumber(7)
  set updatedAt($2.Timestamp v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensureUpdatedAt() => $_ensure(6);
}

class IdRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('IdRequest', package: const $pb.PackageName('v2.mod_disco.services'), createEmptyInstance: create)
    ..aOS(1, 'surveyUserId')
    ..aOS(2, 'sysAccountProjectId')
    ..aOS(3, 'surveyProjectId')
    ..aOS(4, 'sysAccountAccountId')
    ..hasRequiredFields = false
  ;

  IdRequest._() : super();
  factory IdRequest() => create();
  factory IdRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IdRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  IdRequest clone() => IdRequest()..mergeFromMessage(this);
  IdRequest copyWith(void Function(IdRequest) updates) => super.copyWith((message) => updates(message as IdRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IdRequest create() => IdRequest._();
  IdRequest createEmptyInstance() => create();
  static $pb.PbList<IdRequest> createRepeated() => $pb.PbList<IdRequest>();
  @$core.pragma('dart2js:noInline')
  static IdRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IdRequest>(create);
  static IdRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get surveyUserId => $_getSZ(0);
  @$pb.TagNumber(1)
  set surveyUserId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSurveyUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurveyUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sysAccountProjectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sysAccountProjectId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSysAccountProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSysAccountProjectId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get surveyProjectId => $_getSZ(2);
  @$pb.TagNumber(3)
  set surveyProjectId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSurveyProjectId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSurveyProjectId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sysAccountAccountId => $_getSZ(3);
  @$pb.TagNumber(4)
  set sysAccountAccountId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSysAccountAccountId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSysAccountAccountId() => clearField(4);
}

class ListRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListRequest', package: const $pb.PackageName('v2.mod_disco.services'), createEmptyInstance: create)
    ..aOM<IdRequest>(1, 'idRequest', subBuilder: IdRequest.create)
    ..aInt64(2, 'perPageEntries')
    ..aOS(3, 'orderBy')
    ..aOS(4, 'currentPageId')
    ..a<$core.List<$core.int>>(5, 'filters', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ListRequest._() : super();
  factory ListRequest() => create();
  factory ListRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ListRequest clone() => ListRequest()..mergeFromMessage(this);
  ListRequest copyWith(void Function(ListRequest) updates) => super.copyWith((message) => updates(message as ListRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListRequest create() => ListRequest._();
  ListRequest createEmptyInstance() => create();
  static $pb.PbList<ListRequest> createRepeated() => $pb.PbList<ListRequest>();
  @$core.pragma('dart2js:noInline')
  static ListRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRequest>(create);
  static ListRequest _defaultInstance;

  @$pb.TagNumber(1)
  IdRequest get idRequest => $_getN(0);
  @$pb.TagNumber(1)
  set idRequest(IdRequest v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasIdRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdRequest() => clearField(1);
  @$pb.TagNumber(1)
  IdRequest ensureIdRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get perPageEntries => $_getI64(1);
  @$pb.TagNumber(2)
  set perPageEntries($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPerPageEntries() => $_has(1);
  @$pb.TagNumber(2)
  void clearPerPageEntries() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get orderBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set orderBy($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOrderBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderBy() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get currentPageId => $_getSZ(3);
  @$pb.TagNumber(4)
  set currentPageId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrentPageId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentPageId() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get filters => $_getN(4);
  @$pb.TagNumber(5)
  set filters($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFilters() => $_has(4);
  @$pb.TagNumber(5)
  void clearFilters() => clearField(5);
}

class ListResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListResponse', package: const $pb.PackageName('v2.mod_disco.services'), createEmptyInstance: create)
    ..pc<SurveyProject>(1, 'surveyProjects', $pb.PbFieldType.PM, subBuilder: SurveyProject.create)
    ..pc<SurveyUser>(2, 'surveyUsers', $pb.PbFieldType.PM, subBuilder: SurveyUser.create)
    ..aInt64(3, 'nextPageId')
    ..hasRequiredFields = false
  ;

  ListResponse._() : super();
  factory ListResponse() => create();
  factory ListResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ListResponse clone() => ListResponse()..mergeFromMessage(this);
  ListResponse copyWith(void Function(ListResponse) updates) => super.copyWith((message) => updates(message as ListResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListResponse create() => ListResponse._();
  ListResponse createEmptyInstance() => create();
  static $pb.PbList<ListResponse> createRepeated() => $pb.PbList<ListResponse>();
  @$core.pragma('dart2js:noInline')
  static ListResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListResponse>(create);
  static ListResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SurveyProject> get surveyProjects => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<SurveyUser> get surveyUsers => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get nextPageId => $_getI64(2);
  @$pb.TagNumber(3)
  set nextPageId($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNextPageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextPageId() => clearField(3);
}

class NewSurveyProjectRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('NewSurveyProjectRequest', package: const $pb.PackageName('v2.mod_disco.services'), createEmptyInstance: create)
    ..aOS(1, 'sysAccountProjectRefId')
    ..a<$core.List<$core.int>>(2, 'surveySchemaTypes', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(3, 'surveyFilterTypes', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  NewSurveyProjectRequest._() : super();
  factory NewSurveyProjectRequest() => create();
  factory NewSurveyProjectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NewSurveyProjectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  NewSurveyProjectRequest clone() => NewSurveyProjectRequest()..mergeFromMessage(this);
  NewSurveyProjectRequest copyWith(void Function(NewSurveyProjectRequest) updates) => super.copyWith((message) => updates(message as NewSurveyProjectRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NewSurveyProjectRequest create() => NewSurveyProjectRequest._();
  NewSurveyProjectRequest createEmptyInstance() => create();
  static $pb.PbList<NewSurveyProjectRequest> createRepeated() => $pb.PbList<NewSurveyProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static NewSurveyProjectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NewSurveyProjectRequest>(create);
  static NewSurveyProjectRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sysAccountProjectRefId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sysAccountProjectRefId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSysAccountProjectRefId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSysAccountProjectRefId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get surveySchemaTypes => $_getN(1);
  @$pb.TagNumber(2)
  set surveySchemaTypes($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSurveySchemaTypes() => $_has(1);
  @$pb.TagNumber(2)
  void clearSurveySchemaTypes() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get surveyFilterTypes => $_getN(2);
  @$pb.TagNumber(3)
  set surveyFilterTypes($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSurveyFilterTypes() => $_has(2);
  @$pb.TagNumber(3)
  void clearSurveyFilterTypes() => clearField(3);
}

class NewSurveyUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('NewSurveyUserRequest', package: const $pb.PackageName('v2.mod_disco.services'), createEmptyInstance: create)
    ..aOS(1, 'surveyProjectRefId')
    ..aOS(2, 'sysAccountUserRefId')
    ..a<$core.List<$core.int>>(3, 'surveySchemaTypes', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(4, 'surveyFilterTypes', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  NewSurveyUserRequest._() : super();
  factory NewSurveyUserRequest() => create();
  factory NewSurveyUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NewSurveyUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  NewSurveyUserRequest clone() => NewSurveyUserRequest()..mergeFromMessage(this);
  NewSurveyUserRequest copyWith(void Function(NewSurveyUserRequest) updates) => super.copyWith((message) => updates(message as NewSurveyUserRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NewSurveyUserRequest create() => NewSurveyUserRequest._();
  NewSurveyUserRequest createEmptyInstance() => create();
  static $pb.PbList<NewSurveyUserRequest> createRepeated() => $pb.PbList<NewSurveyUserRequest>();
  @$core.pragma('dart2js:noInline')
  static NewSurveyUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NewSurveyUserRequest>(create);
  static NewSurveyUserRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get surveyProjectRefId => $_getSZ(0);
  @$pb.TagNumber(1)
  set surveyProjectRefId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSurveyProjectRefId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurveyProjectRefId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sysAccountUserRefId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sysAccountUserRefId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSysAccountUserRefId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSysAccountUserRefId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get surveySchemaTypes => $_getN(2);
  @$pb.TagNumber(3)
  set surveySchemaTypes($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSurveySchemaTypes() => $_has(2);
  @$pb.TagNumber(3)
  void clearSurveySchemaTypes() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get surveyFilterTypes => $_getN(3);
  @$pb.TagNumber(4)
  set surveyFilterTypes($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSurveyFilterTypes() => $_has(3);
  @$pb.TagNumber(4)
  void clearSurveyFilterTypes() => clearField(4);
}

class UpdateSurveyProjectRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UpdateSurveyProjectRequest', package: const $pb.PackageName('v2.mod_disco.services'), createEmptyInstance: create)
    ..aOS(1, 'surveyProjectRefId')
    ..a<$core.List<$core.int>>(2, 'surveySchemaTypes', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(3, 'surveyFilterTypes', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  UpdateSurveyProjectRequest._() : super();
  factory UpdateSurveyProjectRequest() => create();
  factory UpdateSurveyProjectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateSurveyProjectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  UpdateSurveyProjectRequest clone() => UpdateSurveyProjectRequest()..mergeFromMessage(this);
  UpdateSurveyProjectRequest copyWith(void Function(UpdateSurveyProjectRequest) updates) => super.copyWith((message) => updates(message as UpdateSurveyProjectRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateSurveyProjectRequest create() => UpdateSurveyProjectRequest._();
  UpdateSurveyProjectRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateSurveyProjectRequest> createRepeated() => $pb.PbList<UpdateSurveyProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateSurveyProjectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateSurveyProjectRequest>(create);
  static UpdateSurveyProjectRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get surveyProjectRefId => $_getSZ(0);
  @$pb.TagNumber(1)
  set surveyProjectRefId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSurveyProjectRefId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurveyProjectRefId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get surveySchemaTypes => $_getN(1);
  @$pb.TagNumber(2)
  set surveySchemaTypes($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSurveySchemaTypes() => $_has(1);
  @$pb.TagNumber(2)
  void clearSurveySchemaTypes() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get surveyFilterTypes => $_getN(2);
  @$pb.TagNumber(3)
  set surveyFilterTypes($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSurveyFilterTypes() => $_has(2);
  @$pb.TagNumber(3)
  void clearSurveyFilterTypes() => clearField(3);
}

class UpdateSurveyUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UpdateSurveyUserRequest', package: const $pb.PackageName('v2.mod_disco.services'), createEmptyInstance: create)
    ..aOS(1, 'surveyUserRefId')
    ..a<$core.List<$core.int>>(2, 'surveySchemaTypes', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(3, 'surveyFilterTypes', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  UpdateSurveyUserRequest._() : super();
  factory UpdateSurveyUserRequest() => create();
  factory UpdateSurveyUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateSurveyUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  UpdateSurveyUserRequest clone() => UpdateSurveyUserRequest()..mergeFromMessage(this);
  UpdateSurveyUserRequest copyWith(void Function(UpdateSurveyUserRequest) updates) => super.copyWith((message) => updates(message as UpdateSurveyUserRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateSurveyUserRequest create() => UpdateSurveyUserRequest._();
  UpdateSurveyUserRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateSurveyUserRequest> createRepeated() => $pb.PbList<UpdateSurveyUserRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateSurveyUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateSurveyUserRequest>(create);
  static UpdateSurveyUserRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get surveyUserRefId => $_getSZ(0);
  @$pb.TagNumber(1)
  set surveyUserRefId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSurveyUserRefId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurveyUserRefId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get surveySchemaTypes => $_getN(1);
  @$pb.TagNumber(2)
  set surveySchemaTypes($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSurveySchemaTypes() => $_has(1);
  @$pb.TagNumber(2)
  void clearSurveySchemaTypes() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get surveyFilterTypes => $_getN(2);
  @$pb.TagNumber(3)
  set surveyFilterTypes($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSurveyFilterTypes() => $_has(2);
  @$pb.TagNumber(3)
  void clearSurveyFilterTypes() => clearField(3);
}

