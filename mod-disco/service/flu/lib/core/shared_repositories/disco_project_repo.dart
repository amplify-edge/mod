import 'package:meta/meta.dart';
import 'package:sys_core/sys_core.dart';
import 'package:mod_disco/rpc/v2/mod_disco_services.pb.dart';
import 'package:mod_disco/rpc/v2/mod_disco_services.pbgrpc.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';

class DiscoProjectRepo {
  static Future<DiscoProject> getProjectDetails({@required String accountProjRefId}) async {
    final req = IdRequest()..sysAccountProjectId = accountProjRefId;
    try {
      final client = await discoClient();
    } catch(e) {
      throw e;
    }
  }

  static Future<SurveyServiceClient> discoClient() async {
    return SurveyServiceClient(await BaseRepo.grpcWebClientChannel());
  }
}
