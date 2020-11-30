import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:mod_disco/rpc/v2/mod_disco_services.pbgrpc.dart';
import 'package:sys_core/sys_core.dart';
import 'package:fixnum/fixnum.dart';
import 'package:sys_share_sys_account_service/pkg/pkg.dart';

class SurveyUserRepo {
  static Future<SurveyUser> newSurveyUser({
    @required String surveyProjectId,
    @required String sysAccountAccountRefId,
    @required String surveyUserName,
    @required List<NewUserNeedsValue> userNeedsValueList,
    List<NewSupportRoleValue> supportRoleValueList,
  }) async {
    final req = NewSurveyUserRequest()
      ..surveyUserName = surveyUserName
      ..sysAccountUserRefId = sysAccountAccountRefId
      ..surveyProjectRefId = surveyProjectId;
    req.userNeedValues.addAll(userNeedsValueList);
    if (supportRoleValueList != null) {
      req.supportRoleValues.addAll(supportRoleValueList);
    }
    try {
      final client = await discoClient();
      final resp = await client
          .newSurveyUser(req, options: await getCallOptions())
          .then((res) {
        return res;
      });
      return resp;
    } catch (e) {
      throw e;
    }
  }

  static Future<SurveyUser> updateSurveyUser({
    @required String surveyUserId,
    List<UserNeedsValue> userNeedsValueList,
    List<SupportRoleValue> supportRoleValueList,
  }) async {
    final req = UpdateSurveyUserRequest()..surveyUserId = surveyUserId;
    req.userNeedValues.addAll(userNeedsValueList);
    req.supportRoleValues.addAll(supportRoleValueList);
    try {
      final client = await discoClient();
      final resp = await client
          .updateSurveyUser(req, options: await getCallOptions())
          .then((res) {
        return res;
      });
      return resp;
    } catch (e) {
      throw e;
    }
  }

  static Future<void> deleteSurveyUser({
    @required String surveyProjectId,
  }) async {
    final req = IdRequest()..surveyProjectId = surveyProjectId;
    try {
      final client = await discoClient();
      final resp = await client
          .deleteSurveyUser(req, options: await getCallOptions())
          .then((res) {
        return res;
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<SurveyUser> getSurveyUser({
    String surveyProjectId,
    String sysAccountProjectRefId,
    String surveyUserId,
    String sysAccountUserRefId,
  }) async {
    final req = IdRequest();
    if (surveyUserId != null && surveyUserId.isNotEmpty) {
      req..surveyUserId = surveyUserId;
    }
    if (sysAccountUserRefId != null && sysAccountUserRefId.isNotEmpty) {
      req..sysAccountAccountId = sysAccountUserRefId;
    }
    if (surveyProjectId != null && surveyProjectId.isNotEmpty) {
      req..surveyProjectId = surveyProjectId;
    }
    if (sysAccountProjectRefId != null && sysAccountProjectRefId.isNotEmpty) {
      req..sysAccountProjectId = sysAccountProjectRefId;
    }
    try {
      final client = await discoClient();
      final resp = await client
          .getSurveyUser(req, options: await getCallOptions())
          .then((res) {
        return res;
      });
      return resp;
    } catch (e) {
      throw e;
    }
  }

  static Future<List<SurveyUser>> listSurveyUsers({
    String surveyUserId,
    String sysAccountUserRefId,
    String surveyProjectId,
    String sysAccountProjectRefId,
    int currentPageId = 0,
    String orderBy,
    int perPageEntries = 50,
    bool isDescending = false,
    Map<String, dynamic> filters,
  }) async {
    final ppe = Int64(perPageEntries);
    final req = IdRequest();
    if (surveyUserId != null && surveyUserId.isNotEmpty) {
      req..surveyUserId = surveyUserId;
    }
    if (sysAccountUserRefId != null && sysAccountUserRefId.isNotEmpty) {
      req..sysAccountAccountId = sysAccountUserRefId;
    }
    if (surveyProjectId != null && surveyProjectId.isNotEmpty) {
      req..surveyProjectId = surveyProjectId;
    }
    if (sysAccountProjectRefId != null && sysAccountProjectRefId.isNotEmpty) {
      req..sysAccountProjectId = sysAccountProjectRefId;
    }
    final lreq = ListRequest()
      ..idRequest = req
      ..perPageEntries = ppe
      ..isDescending = isDescending
      ..orderBy = orderBy;
    if (filters != null) {
      final jbytes = utf8.encode(jsonEncode(filters));
      lreq..filters = jbytes;
    }
    try {
      final client = await discoClient();
      final resp = await client
          .listSurveyUser(lreq, options: await getCallOptions())
          .then((res) {
        return res;
      });
      return resp.surveyUsers;
    } catch (e) {
      throw e;
    }
  }

  static Future<SurveyServiceClient> discoClient() async {
    return SurveyServiceClient(await BaseRepo.grpcWebClientChannel());
  }
}
