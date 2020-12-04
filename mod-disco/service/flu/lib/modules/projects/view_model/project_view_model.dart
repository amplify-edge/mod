import 'package:mod_disco/core/core.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

class ProjectViewModel extends BaseModel {
  ProjectViewModel({List<Org> organizations}) {
    if (organizations != null) {
      this.orgs = organizations;
      setHasMoreItems(false);
    }
  }
}
