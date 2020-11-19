import 'package:fixnum/fixnum.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart'
    as repo;

class NewOrgViewModel extends BaseModel {
  List<Org> orgs = List<Org>();

  // constructor
  NewOrgViewModel({this.orgs});

  Int64 _nextPageId = Int64.ZERO;
  List<bool> _selected = List<bool>();
  bool _isLoading = false;

  List<bool> get selected => _selected;

  bool get isLoading => _isLoading;

  void changeSelection(bool value, int index) {
    _selected[index] = value;
    notifyListeners();
  }

  List<Project> getCurrentOrgProject(String id) {
    final projList = orgs.firstWhere((element) => element.id == id).projects;
    notifyListeners();
    return projList;
  }

  Future<void> fetchInitialOrgs() async {
    _setLoading(true);
    await repo.OrgProjRepo.listUserOrgs(
            filters: List<int>(), orderBy: 'name', isDescending: false)
        .then((res) {
      orgs = res.orgs;
      notifyListeners();
    }).catchError((e) {
      throw e;
    });
    _setLoading(false);
  }

  Future<void> fetchNextOrgs() async {
    _setLoading(true);
    await repo.OrgProjRepo.listUserOrgs(
      currentPageId: _nextPageId,
      filters: List<int>(),
      orderBy: 'name',
      isDescending: false,
    ).then((res) {
      orgs.addAll(res.orgs);
      _setnextPageId(Int64.parseInt(res.nextPageId));
      notifyListeners();
    }).catchError((e) {
      throw e;
    });
    _setLoading(false);
  }

  void _resetOrgs() {
    orgs = List<Org>();
    notifyListeners();
  }

  void _setnextPageId(Int64 val) {
    _nextPageId = val;
    notifyListeners();
  }

  void _updateSelectedList() {
    final _count = orgs.length;
    List<bool> _orgListBool = orgs.map((o) => false);
    _selected = _orgListBool;
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
