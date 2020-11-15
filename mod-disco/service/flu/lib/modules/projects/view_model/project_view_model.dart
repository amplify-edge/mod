import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart'
    as repo;

class ProjectViewModel extends BaseModel {
  List<Project> projects = List<Project>();

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
        .then((res) {
      projects = res.projects;
      notifyListeners();
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
    ).then((res) {
      projects.addAll(res.projects);
      _setnextPageId(int.parse(res.nextPageId));
      notifyListeners();
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
