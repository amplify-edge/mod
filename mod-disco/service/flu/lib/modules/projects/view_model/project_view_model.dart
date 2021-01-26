import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/shared_repositories/disco_project_repo.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

class ProjectViewModel extends BaseModel {
  ProjectViewModel({List<Org> organizations, String orgId}) {
    if (organizations != null) {
      this.orgs = organizations;
      setHasMoreItems(false);
    }
  }
}
