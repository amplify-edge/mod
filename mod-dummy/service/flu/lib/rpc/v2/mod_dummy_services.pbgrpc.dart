///
//  Generated code. Do not modify.
//  source: mod_dummy_services.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'mod_dummy_models.pb.dart' as $0;
export 'mod_dummy_services.pb.dart';

class DummyServiceClient extends $grpc.Client {
  static final _$getAccount =
      $grpc.ClientMethod<$0.GetAccountRequest, $0.Account>(
          '/v2.mod_services.DummyService/GetAccount',
          ($0.GetAccountRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Account.fromBuffer(value));

  DummyServiceClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.Account> getAccount($0.GetAccountRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAccount, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class DummyServiceBase extends $grpc.Service {
  $core.String get $name => 'v2.mod_services.DummyService';

  DummyServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetAccountRequest, $0.Account>(
        'GetAccount',
        getAccount_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetAccountRequest.fromBuffer(value),
        ($0.Account value) => value.writeToBuffer()));
  }

  $async.Future<$0.Account> getAccount_Pre($grpc.ServiceCall call,
      $async.Future<$0.GetAccountRequest> request) async {
    return getAccount(call, await request);
  }

  $async.Future<$0.Account> getAccount(
      $grpc.ServiceCall call, $0.GetAccountRequest request);
}
