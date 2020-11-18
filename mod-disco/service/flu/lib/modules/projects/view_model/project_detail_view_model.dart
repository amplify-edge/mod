import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/shared_repositories/disco_project_repo.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

class ProjectDetailViewModel extends BaseModel {
  Project proj;
  DiscoProject _discoProject;

  // constructor
  ProjectDetailViewModel({this.proj});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  DiscoProject get projectDetails => _discoProject;

  Future<void> fetchProjectDetail() async {
    _setLoading(true);
    await DiscoProjectRepo.getProjectDetails(accountProjRefId: proj.id)
        .then((res) {
      _discoProject = res;
      notifyListeners();
    }).catchError((e) {
      throw e;
    });
    _setLoading(false);
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void navigateToReady() {
    Modular.to.pushNamed(Modular.get<Paths>().ready);
  }

  void navigateToNotReady(int index) {}
}
