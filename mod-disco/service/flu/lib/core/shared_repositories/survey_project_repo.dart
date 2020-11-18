import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:mod_disco/rpc/v2/mod_disco_services.pbgrpc.dart';
import 'package:sys_core/sys_core.dart';
import 'package:fixnum/fixnum.dart';
import 'package:sys_share_sys_account_service/pkg/pkg.dart';

class SurveyProjectRepo {
  static Future<SurveyProject> newSurveyProject({
    @required String sysAccountProjectRefId,
    @required String surveyProjectName,
    @required String supportRoleTypeNames,
    @required List<NewUserNeedsType> userNeedsTypes,
    @required List<NewSupportRoleType> supportRoleTypes,
  }) async {
    final req = NewSurveyProjectRequest()
      ..surveyProjectName = surveyProjectName
      ..sysAccountProjectRefId = sysAccountProjectRefId;
    req.userNeedTypes.addAll(userNeedsTypes);
    req.supportRoleTypes.addAll(supportRoleTypes);
    try {
      final client = await discoClient();
      final resp = await client
          .newSurveyProject(req, options: await getCallOptions())
          .then((res) {
        return res;
      });
      return resp;
    } catch (e) {
      throw e;
    }
  }

  static Future<SurveyProject> updateSurveyProject({
    @required String surveyProjectId,
    List<UserNeedsType> userNeedsTypes,
    List<SupportRoleType> supportRoleTypes,
  }) async {
    final req = UpdateSurveyProjectRequest()..surveyProjectId = surveyProjectId;
    req.userNeedTypes.addAll(userNeedsTypes);
    req.supportRoleTypes.addAll(supportRoleTypes);
    try {
      final client = await discoClient();
      final resp = await client
          .updateSurveyProject(req, options: await getCallOptions())
          .then((res) {
        return res;
      });
      return resp;
    } catch (e) {
      throw e;
    }
  }

  static Future<void> deleteSurveyProject({
    @required String surveyProjectId,
  }) async {
    final req = IdRequest()..surveyProjectId = surveyProjectId;
    try {
      final client = await discoClient();
      final resp = await client
          .deleteSurveyProject(req, options: await getCallOptions())
          .then((res) {
        return res;
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<SurveyProject> getSurveyProject({
    String surveyProjectId,
    String sysAccountProjectRefId,
  }) async {
    final req = IdRequest();
    if (surveyProjectId != null && surveyProjectId.isNotEmpty) {
      req..surveyProjectId = surveyProjectId;
    }
    if (sysAccountProjectRefId != null && sysAccountProjectRefId.isNotEmpty) {
      req..sysAccountProjectId = sysAccountProjectRefId;
    }
    try {
      final client = await discoClient();
      final resp = await client
          .getSurveyProject(req, options: await getCallOptions())
          .then((res) {
        return res;
      });
      return resp;
    } catch (e) {
      throw e;
    }
  }

  static Future<List<SurveyProject>> listSurveyProjects({
    String surveyProjectId,
    String sysAccountProjectRefId,
    int currentPageId = 0,
    String orderBy,
    int perPageEntries = 50,
    bool isDescending = false,
    Map<String, dynamic> filters,
  }) async {
    final ppe = Int64(perPageEntries);
    final idRequest = IdRequest();
    if (surveyProjectId != null && surveyProjectId.isNotEmpty) {
      idRequest..surveyProjectId = surveyProjectId;
    }
    if (sysAccountProjectRefId != null && sysAccountProjectRefId.isNotEmpty) {
      idRequest..sysAccountProjectId = sysAccountProjectRefId;
    }
    final req = ListRequest()
      ..idRequest = idRequest
      ..perPageEntries = ppe
      ..isDescending = isDescending
      ..orderBy = orderBy;
    if (filters != null) {
      final jbytes = utf8.encode(jsonEncode(filters));
      req..filters = jbytes;
    }
    try {
      final client = await discoClient();
      final resp = await client
          .listSurveyProject(req, options: await getCallOptions())
          .then((res) {
        return res;
      });
      return resp.surveyProjects;
    } catch (e) {
      throw e;
    }
  }

  static Future<SurveyServiceClient> discoClient() async {
    return SurveyServiceClient(await BaseRepo.grpcWebClientChannel());
  }
}
