import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/shared_repositories/disco_project_repo.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart'
    as repo;

class ProjectViewModel extends BaseModel {
  List<Project> projects = List<Project>();
  List<DiscoProject> projectDetails = List<DiscoProject>();

  // constructor
  ProjectViewModel({this.projects});

  int _nextPageId = 0;
  List<bool> _selected = List<bool>();
  bool _isLoading = false;

  List<bool> get selected => _selected;

  bool get isLoading => _isLoading;

  void changeSelection(bool value, int index) {
    _selected[index] = value;
    notifyListeners();
  }

  Future<void> fetchInitialProjects() async {
    _setLoading(true);
    await repo.OrgProjRepo.listUserProjects(
            orderBy: 'name', isDescending: false)
        .then((res) async {
      this.projects = res.projects;
      notifyListeners();
      print("FETCHING PROJECT DETAILS");
      await DiscoProjectRepo.listProjectDetails(
              currentPageId: _nextPageId, orderBy: "sys_account_project_ref_id")
          .then((listProjectDetails) {
        projectDetails.addAll(listProjectDetails);
        notifyListeners();
      });
    }).catchError((e) {
      throw e;
    });
    _setLoading(false);
  }

  Future<void> fetchNextProjects() async {
    _setLoading(true);
    await repo.OrgProjRepo.listUserProjects(
      currentPageId: _nextPageId.toString(),
      orderBy: 'name',
      isDescending: false,
    ).then((res) async {
      projects.addAll(res.projects);
      _setnextPageId(int.parse(res.nextPageId));
      notifyListeners();
      this.projects.forEach((proj) async {
        print("FETCHING PROJECT DETAILS");
        await DiscoProjectRepo.listProjectDetails(
                currentPageId: _nextPageId,
                orderBy: "sys_account_project_ref_id")
            .then((listProjectDetails) {
          projectDetails.addAll(listProjectDetails);
          notifyListeners();
        });
      });
    }).catchError((e) {
      throw e;
    });
    _setLoading(false);
  }

  void _resetProjects() {
    projects = List<Project>();
    notifyListeners();
  }

  void _setnextPageId(int val) {
    _nextPageId = val;
    notifyListeners();
  }

  void _updateSelectedList() {
    final _count = projects.length;
    List<bool> _projListBool = projects.map((o) => false);
    _selected = _projListBool;
    notifyListeners();
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
