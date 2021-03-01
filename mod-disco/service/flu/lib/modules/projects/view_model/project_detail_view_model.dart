import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:mod_disco/core/shared_repositories/disco_project_repo.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart';
import 'package:sys_share_sys_account_service/pkg/shared_services/base_model.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

class ProjectDetailViewModel extends BaseModel {
  String projectId;
  Project _proj;
  DiscoProject _discoProject;

  // constructor
  ProjectDetailViewModel({@required this.projectId});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Project get project => _proj;

  DiscoProject get selectedProjectDetails => _discoProject;

  Future<void> fetchProjectDetail() async {
    _setLoading(true);
    await OrgProjRepo.getProject(id: projectId).then((res) {
      _proj = res;
      notifyListeners();
    });
    await DiscoProjectRepo.getProjectDetails(accountProjRefId: projectId)
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
}
