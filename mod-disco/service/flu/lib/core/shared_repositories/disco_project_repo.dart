import 'package:fixnum/fixnum.dart';
import 'package:meta/meta.dart';
import 'package:sys_core/sys_core.dart';
import 'package:mod_disco/rpc/v2/mod_disco_services.pb.dart';
import 'package:mod_disco/rpc/v2/mod_disco_services.pbgrpc.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:sys_share_sys_account_service/pkg/pkg.dart';

class DiscoProjectRepo {
  static Future<DiscoProject> getProjectDetails(
      {@required String accountProjRefId}) async {
    final req = IdRequest()..sysAccountProjectId = accountProjRefId;
    try {
      final client = await discoClient();
      final resp = client
          .getDiscoProject(req, options: await getCallOptions())
          .then((res) {
        return res;
      });
      return resp;
    } catch (e) {
      throw e;
    }
  }

  static Future<List<DiscoProject>> listProjectDetails(
      {int currentPageId = 0,
      String orderBy,
      int perPageEntries = 50,
      bool isDescending = false}) async {
    final ppe = Int64(perPageEntries);
    final req = ListRequest()
      ..perPageEntries = ppe
      ..isDescending = isDescending
      ..orderBy = orderBy;
    try {
      final client = await discoClient();
      final resp = client.listDiscoProject(req).then((res) {
        return res.discoProjects;
      });
      return resp;
    } catch (e) {
      throw e;
    }
  }

  static Future<SurveyServiceClient> discoClient() async {
    return SurveyServiceClient(await BaseRepo.grpcWebClientChannel());
  }
}
