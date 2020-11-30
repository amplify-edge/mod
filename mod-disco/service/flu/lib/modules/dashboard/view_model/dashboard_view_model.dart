import 'package:mod_disco/core/shared_services/base_model.dart';
import 'package:sys_share_sys_account_service/rpc/v2/sys_account_models.pb.dart';

class DashboardViewModel extends BaseModel {
  // constructor
  DashboardViewModel({List<Org> organizations}) {
    this.orgs = organizations;
  }
}
