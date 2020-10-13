import 'package:mod_dummy/pkg/shared_repositories/base_repo.dart';
import 'package:mod_dummy/mod_dummy.dart' as rpc;
import 'package:grpc/grpc_web.dart';

class UserRepo {
  // TODO @winwisely268: this is ugly, ideally we want flu side interceptor
  // as well so each request will have authorization metadata.
  static Future<rpc.ListAccountsResponse> listUser({String accessToken}) async {
    final req = rpc.ListAccountsRequest();

    try {
      final resp = await accountClient(accessToken)
          .listAccounts(req,
              options: CallOptions(metadata: {"Authorization": accessToken}))
          .then((res) {
        return res;
      });
      return resp;
    } catch (e) {
      throw e;
    }
  }

  static rpc.AccountServiceClient accountClient(String accessToken) {
    return rpc.AccountServiceClient(BaseRepo.channel);
  }
}
