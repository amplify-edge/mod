///
//  Generated code. Do not modify.
//  source: mod_disco_services.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'mod_disco_models.pb.dart' as $0;
import 'google/protobuf/empty.pb.dart' as $1;
export 'mod_disco_services.pb.dart';

class SurveyServiceClient extends $grpc.Client {
  static final _$newSurveyProject =
      $grpc.ClientMethod<$0.NewSurveyProjectRequest, $0.SurveyProject>(
          '/v2.mod_disco.services.SurveyService/NewSurveyProject',
          ($0.NewSurveyProjectRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.SurveyProject.fromBuffer(value));
  static final _$getSurveyProject =
      $grpc.ClientMethod<$0.IdRequest, $0.SurveyProject>(
          '/v2.mod_disco.services.SurveyService/GetSurveyProject',
          ($0.IdRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.SurveyProject.fromBuffer(value));
  static final _$listSurveyProject =
      $grpc.ClientMethod<$0.ListRequest, $0.ListResponse>(
          '/v2.mod_disco.services.SurveyService/ListSurveyProject',
          ($0.ListRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.ListResponse.fromBuffer(value));
  static final _$updateSurveyProject =
      $grpc.ClientMethod<$0.UpdateSurveyProjectRequest, $0.SurveyProject>(
          '/v2.mod_disco.services.SurveyService/UpdateSurveyProject',
          ($0.UpdateSurveyProjectRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.SurveyProject.fromBuffer(value));
  static final _$deleteSurveyProject =
      $grpc.ClientMethod<$0.IdRequest, $1.Empty>(
          '/v2.mod_disco.services.SurveyService/DeleteSurveyProject',
          ($0.IdRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$newSurveyUser =
      $grpc.ClientMethod<$0.NewSurveyUserRequest, $0.SurveyUser>(
          '/v2.mod_disco.services.SurveyService/NewSurveyUser',
          ($0.NewSurveyUserRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.SurveyUser.fromBuffer(value));
  static final _$getSurveyUser =
      $grpc.ClientMethod<$0.IdRequest, $0.SurveyUser>(
          '/v2.mod_disco.services.SurveyService/GetSurveyUser',
          ($0.IdRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.SurveyUser.fromBuffer(value));
  static final _$listSurveyUser =
      $grpc.ClientMethod<$0.ListRequest, $0.ListResponse>(
          '/v2.mod_disco.services.SurveyService/ListSurveyUser',
          ($0.ListRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.ListResponse.fromBuffer(value));
  static final _$updateSurveyUser =
      $grpc.ClientMethod<$0.UpdateSurveyUserRequest, $0.SurveyUser>(
          '/v2.mod_disco.services.SurveyService/UpdateSurveyUser',
          ($0.UpdateSurveyUserRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.SurveyUser.fromBuffer(value));
  static final _$deleteSurveyUser = $grpc.ClientMethod<$0.IdRequest, $1.Empty>(
      '/v2.mod_disco.services.SurveyService/DeleteSurveyUser',
      ($0.IdRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$getProjectStatistics =
      $grpc.ClientMethod<$0.StatisticRequest, $0.StatisticResponse>(
          '/v2.mod_disco.services.SurveyService/GetProjectStatistics',
          ($0.StatisticRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.StatisticResponse.fromBuffer(value));
  static final _$newDiscoProject =
      $grpc.ClientMethod<$0.NewDiscoProjectRequest, $0.DiscoProject>(
          '/v2.mod_disco.services.SurveyService/NewDiscoProject',
          ($0.NewDiscoProjectRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.DiscoProject.fromBuffer(value));
  static final _$getDiscoProject =
      $grpc.ClientMethod<$0.IdRequest, $0.DiscoProject>(
          '/v2.mod_disco.services.SurveyService/GetDiscoProject',
          ($0.IdRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.DiscoProject.fromBuffer(value));
  static final _$listDiscoProject =
      $grpc.ClientMethod<$0.ListRequest, $0.ListResponse>(
          '/v2.mod_disco.services.SurveyService/ListDiscoProject',
          ($0.ListRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.ListResponse.fromBuffer(value));
  static final _$updateDiscoProject =
      $grpc.ClientMethod<$0.UpdateSurveyProjectRequest, $0.DiscoProject>(
          '/v2.mod_disco.services.SurveyService/UpdateDiscoProject',
          ($0.UpdateSurveyProjectRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.DiscoProject.fromBuffer(value));
  static final _$deleteDiscoProject =
      $grpc.ClientMethod<$0.IdRequest, $1.Empty>(
          '/v2.mod_disco.services.SurveyService/DeleteDiscoProject',
          ($0.IdRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$genTempId = $grpc.ClientMethod<$1.Empty, $0.GenIdResponse>(
      '/v2.mod_disco.services.SurveyService/GenTempId',
      ($1.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GenIdResponse.fromBuffer(value));

  SurveyServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.SurveyProject> newSurveyProject(
      $0.NewSurveyProjectRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$newSurveyProject, request, options: options);
  }

  $grpc.ResponseFuture<$0.SurveyProject> getSurveyProject($0.IdRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getSurveyProject, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListResponse> listSurveyProject(
      $0.ListRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$listSurveyProject, request, options: options);
  }

  $grpc.ResponseFuture<$0.SurveyProject> updateSurveyProject(
      $0.UpdateSurveyProjectRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$updateSurveyProject, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteSurveyProject($0.IdRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$deleteSurveyProject, request, options: options);
  }

  $grpc.ResponseFuture<$0.SurveyUser> newSurveyUser(
      $0.NewSurveyUserRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$newSurveyUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.SurveyUser> getSurveyUser($0.IdRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getSurveyUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListResponse> listSurveyUser($0.ListRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$listSurveyUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.SurveyUser> updateSurveyUser(
      $0.UpdateSurveyUserRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$updateSurveyUser, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteSurveyUser($0.IdRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$deleteSurveyUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.StatisticResponse> getProjectStatistics(
      $0.StatisticRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getProjectStatistics, request, options: options);
  }

  $grpc.ResponseFuture<$0.DiscoProject> newDiscoProject(
      $0.NewDiscoProjectRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$newDiscoProject, request, options: options);
  }

  $grpc.ResponseFuture<$0.DiscoProject> getDiscoProject($0.IdRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getDiscoProject, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListResponse> listDiscoProject($0.ListRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$listDiscoProject, request, options: options);
  }

  $grpc.ResponseFuture<$0.DiscoProject> updateDiscoProject(
      $0.UpdateSurveyProjectRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$updateDiscoProject, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteDiscoProject($0.IdRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$deleteDiscoProject, request, options: options);
  }

  $grpc.ResponseFuture<$0.GenIdResponse> genTempId($1.Empty request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$genTempId, request, options: options);
  }
}

abstract class SurveyServiceBase extends $grpc.Service {
  $core.String get $name => 'v2.mod_disco.services.SurveyService';

  SurveyServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.NewSurveyProjectRequest, $0.SurveyProject>(
            'NewSurveyProject',
            newSurveyProject_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.NewSurveyProjectRequest.fromBuffer(value),
            ($0.SurveyProject value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdRequest, $0.SurveyProject>(
        'GetSurveyProject',
        getSurveyProject_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.IdRequest.fromBuffer(value),
        ($0.SurveyProject value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRequest, $0.ListResponse>(
        'ListSurveyProject',
        listSurveyProject_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListRequest.fromBuffer(value),
        ($0.ListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateSurveyProjectRequest, $0.SurveyProject>(
            'UpdateSurveyProject',
            updateSurveyProject_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateSurveyProjectRequest.fromBuffer(value),
            ($0.SurveyProject value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdRequest, $1.Empty>(
        'DeleteSurveyProject',
        deleteSurveyProject_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.IdRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.NewSurveyUserRequest, $0.SurveyUser>(
        'NewSurveyUser',
        newSurveyUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.NewSurveyUserRequest.fromBuffer(value),
        ($0.SurveyUser value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdRequest, $0.SurveyUser>(
        'GetSurveyUser',
        getSurveyUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.IdRequest.fromBuffer(value),
        ($0.SurveyUser value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRequest, $0.ListResponse>(
        'ListSurveyUser',
        listSurveyUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListRequest.fromBuffer(value),
        ($0.ListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateSurveyUserRequest, $0.SurveyUser>(
        'UpdateSurveyUser',
        updateSurveyUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateSurveyUserRequest.fromBuffer(value),
        ($0.SurveyUser value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdRequest, $1.Empty>(
        'DeleteSurveyUser',
        deleteSurveyUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.IdRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StatisticRequest, $0.StatisticResponse>(
        'GetProjectStatistics',
        getProjectStatistics_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StatisticRequest.fromBuffer(value),
        ($0.StatisticResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.NewDiscoProjectRequest, $0.DiscoProject>(
        'NewDiscoProject',
        newDiscoProject_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.NewDiscoProjectRequest.fromBuffer(value),
        ($0.DiscoProject value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdRequest, $0.DiscoProject>(
        'GetDiscoProject',
        getDiscoProject_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.IdRequest.fromBuffer(value),
        ($0.DiscoProject value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRequest, $0.ListResponse>(
        'ListDiscoProject',
        listDiscoProject_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListRequest.fromBuffer(value),
        ($0.ListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateSurveyProjectRequest, $0.DiscoProject>(
            'UpdateDiscoProject',
            updateDiscoProject_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateSurveyProjectRequest.fromBuffer(value),
            ($0.DiscoProject value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IdRequest, $1.Empty>(
        'DeleteDiscoProject',
        deleteDiscoProject_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.IdRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Empty, $0.GenIdResponse>(
        'GenTempId',
        genTempId_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($0.GenIdResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SurveyProject> newSurveyProject_Pre($grpc.ServiceCall call,
      $async.Future<$0.NewSurveyProjectRequest> request) async {
    return newSurveyProject(call, await request);
  }

  $async.Future<$0.SurveyProject> getSurveyProject_Pre(
      $grpc.ServiceCall call, $async.Future<$0.IdRequest> request) async {
    return getSurveyProject(call, await request);
  }

  $async.Future<$0.ListResponse> listSurveyProject_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ListRequest> request) async {
    return listSurveyProject(call, await request);
  }

  $async.Future<$0.SurveyProject> updateSurveyProject_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.UpdateSurveyProjectRequest> request) async {
    return updateSurveyProject(call, await request);
  }

  $async.Future<$1.Empty> deleteSurveyProject_Pre(
      $grpc.ServiceCall call, $async.Future<$0.IdRequest> request) async {
    return deleteSurveyProject(call, await request);
  }

  $async.Future<$0.SurveyUser> newSurveyUser_Pre($grpc.ServiceCall call,
      $async.Future<$0.NewSurveyUserRequest> request) async {
    return newSurveyUser(call, await request);
  }

  $async.Future<$0.SurveyUser> getSurveyUser_Pre(
      $grpc.ServiceCall call, $async.Future<$0.IdRequest> request) async {
    return getSurveyUser(call, await request);
  }

  $async.Future<$0.ListResponse> listSurveyUser_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ListRequest> request) async {
    return listSurveyUser(call, await request);
  }

  $async.Future<$0.SurveyUser> updateSurveyUser_Pre($grpc.ServiceCall call,
      $async.Future<$0.UpdateSurveyUserRequest> request) async {
    return updateSurveyUser(call, await request);
  }

  $async.Future<$1.Empty> deleteSurveyUser_Pre(
      $grpc.ServiceCall call, $async.Future<$0.IdRequest> request) async {
    return deleteSurveyUser(call, await request);
  }

  $async.Future<$0.StatisticResponse> getProjectStatistics_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.StatisticRequest> request) async {
    return getProjectStatistics(call, await request);
  }

  $async.Future<$0.DiscoProject> newDiscoProject_Pre($grpc.ServiceCall call,
      $async.Future<$0.NewDiscoProjectRequest> request) async {
    return newDiscoProject(call, await request);
  }

  $async.Future<$0.DiscoProject> getDiscoProject_Pre(
      $grpc.ServiceCall call, $async.Future<$0.IdRequest> request) async {
    return getDiscoProject(call, await request);
  }

  $async.Future<$0.ListResponse> listDiscoProject_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ListRequest> request) async {
    return listDiscoProject(call, await request);
  }

  $async.Future<$0.DiscoProject> updateDiscoProject_Pre($grpc.ServiceCall call,
      $async.Future<$0.UpdateSurveyProjectRequest> request) async {
    return updateDiscoProject(call, await request);
  }

  $async.Future<$1.Empty> deleteDiscoProject_Pre(
      $grpc.ServiceCall call, $async.Future<$0.IdRequest> request) async {
    return deleteDiscoProject(call, await request);
  }

  $async.Future<$0.GenIdResponse> genTempId_Pre(
      $grpc.ServiceCall call, $async.Future<$1.Empty> request) async {
    return genTempId(call, await request);
  }

  $async.Future<$0.SurveyProject> newSurveyProject(
      $grpc.ServiceCall call, $0.NewSurveyProjectRequest request);
  $async.Future<$0.SurveyProject> getSurveyProject(
      $grpc.ServiceCall call, $0.IdRequest request);
  $async.Future<$0.ListResponse> listSurveyProject(
      $grpc.ServiceCall call, $0.ListRequest request);
  $async.Future<$0.SurveyProject> updateSurveyProject(
      $grpc.ServiceCall call, $0.UpdateSurveyProjectRequest request);
  $async.Future<$1.Empty> deleteSurveyProject(
      $grpc.ServiceCall call, $0.IdRequest request);
  $async.Future<$0.SurveyUser> newSurveyUser(
      $grpc.ServiceCall call, $0.NewSurveyUserRequest request);
  $async.Future<$0.SurveyUser> getSurveyUser(
      $grpc.ServiceCall call, $0.IdRequest request);
  $async.Future<$0.ListResponse> listSurveyUser(
      $grpc.ServiceCall call, $0.ListRequest request);
  $async.Future<$0.SurveyUser> updateSurveyUser(
      $grpc.ServiceCall call, $0.UpdateSurveyUserRequest request);
  $async.Future<$1.Empty> deleteSurveyUser(
      $grpc.ServiceCall call, $0.IdRequest request);
  $async.Future<$0.StatisticResponse> getProjectStatistics(
      $grpc.ServiceCall call, $0.StatisticRequest request);
  $async.Future<$0.DiscoProject> newDiscoProject(
      $grpc.ServiceCall call, $0.NewDiscoProjectRequest request);
  $async.Future<$0.DiscoProject> getDiscoProject(
      $grpc.ServiceCall call, $0.IdRequest request);
  $async.Future<$0.ListResponse> listDiscoProject(
      $grpc.ServiceCall call, $0.ListRequest request);
  $async.Future<$0.DiscoProject> updateDiscoProject(
      $grpc.ServiceCall call, $0.UpdateSurveyProjectRequest request);
  $async.Future<$1.Empty> deleteDiscoProject(
      $grpc.ServiceCall call, $0.IdRequest request);
  $async.Future<$0.GenIdResponse> genTempId(
      $grpc.ServiceCall call, $1.Empty request);
}
