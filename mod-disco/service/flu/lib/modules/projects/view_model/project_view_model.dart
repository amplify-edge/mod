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

  Future<void> fetchExistingOrgsProjects({String oid}) async {
    if (oid.isNotEmpty) {
      final _org = await OrgProjRepo.getOrg(id: oid);
      this.orgs = [_org];
    }
    if (orgs != null && orgs.isNotEmpty) {
      orgs.forEach((org) {
        org.projects.forEach((p) async {
          await DiscoProjectRepo.getProjectDetails(accountProjRefId: p.id)
              .then((details) {
            projectDetails.add(details);
          }).catchError((e) => print(e));
        });
      });
    }
    notifyListeners();
  }
}
