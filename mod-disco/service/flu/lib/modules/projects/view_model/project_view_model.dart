import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/shared_repositories/disco_project_repo.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart'
    as repo;

class ProjectViewModel extends BaseModel {
  int perPageEntriesDefault = 20;
  List<Project> projects = List<Project>();
  List<DiscoProject> projectDetails = List<DiscoProject>();

  // constructor
  ProjectViewModel({this.projects});

  int _nextPageId = 0;
  List<bool> _selected = List<bool>();
  bool _isLoading = false;
  bool _hasMoreItems = false;

  List<bool> get selected => _selected;

  bool get isLoading => _isLoading;

  bool get hasMoreItems => _hasMoreItems;

  void changeSelection(bool value, int index) {
    _selected[index] = value;
    notifyListeners();
  }

  void _setHasMoreItems(bool val) {
    _hasMoreItems = val;
    notifyListeners();
  }

  Future<void> _fetchProjects(void Function(List<Project>) f,
      {Map<String, dynamic> filters}) async {
    _setLoading(true);
    await repo.OrgProjRepo.listUserProjects(
      orderBy: 'name',
      isDescending: false,
      perPageEntries: perPageEntriesDefault,
      filters: filters,
    ).then((res) async {
      this.projects = res.projects;
      notifyListeners();
      this.projects.forEach((p) async {
        await DiscoProjectRepo.getProjectDetails(accountProjRefId: p.id)
            .then((details) {
          projectDetails.add(details);
          notifyListeners();
        }).catchError((e) => print(e));
      });
      notifyListeners();
      f(this.projects);
    }).catchError((e) {
      throw e;
    });
    _setLoading(false);
  }

  Future<void> fetchInitialProjects() async {
    await _fetchProjects((ps) {
      if (ps.isNotEmpty && ps.last.createdAt.nanos != 0) {
        _setNextPageId(ps.last.createdAt.nanos);
        _setHasMoreItems(true);
      }
    });
  }

  Future<void> fetchNextProjects() async {
    await _fetchProjects((ps) {
      if (ps.isEmpty) {
        _setHasMoreItems(false);
      }
      final lastFetchedNanos = ps.last.createdAt.nanos;
      if (_nextPageId == lastFetchedNanos ) {
        _setHasMoreItems(false);
      } else {
        _setNextPageId(lastFetchedNanos);
        _setHasMoreItems(true);
      }
    });
  }

  Future<void> searchProjects(String name) async {
    await _fetchProjects((ps) {
      if (ps != null && ps.isNotEmpty) {
        _resetProjects();
        projects.addAll(ps);
        _setHasMoreItems(false);
      }
    }, filters: {
      "name": name,
    });
  }

  Future<void> onResetSearchProjects() async {
    _resetProjects();
    await fetchInitialProjects();
  }

  void _resetProjects() {
    projects = List<Project>();
    notifyListeners();
  }

  void _setNextPageId(int val) {
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
