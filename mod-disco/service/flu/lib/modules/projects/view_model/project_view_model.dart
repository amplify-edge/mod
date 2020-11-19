import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_disco/core/core.dart';
import 'package:mod_disco/core/shared_repositories/disco_project_repo.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart'
    as repo;

class ProjectViewModel extends BaseModel {
  int perPageEntriesDefault = 30;
  List<Project> projects = [];
  List<DiscoProject> projectDetails = List<DiscoProject>();

  // constructor
  ProjectViewModel({this.projects});

  Int64 _nextPageId = Int64(0);
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

  Future<void> _fetchProjects(
      {Map<String, dynamic> filters,
      void Function(String, List<Project>) nextPageFunc}) async {
    _setLoading(true);
    await repo.OrgProjRepo.listUserProjects(
      orderBy: 'name',
      isDescending: false,
      perPageEntries: perPageEntriesDefault,
      filters: filters,
      currentPageId: _nextPageId,
    ).then((res) async {
      if (projects == null) {
        projects = res.projects;
      } else {
        projects.addAll(res.projects);
      }
      notifyListeners();
      projects.forEach((p) async {
        await DiscoProjectRepo.getProjectDetails(accountProjRefId: p.id)
            .then((details) {
          projectDetails.add(details);
          notifyListeners();
        }).catchError((e) => print(e));
      });
      notifyListeners();
      // f(this.projects);
      nextPageFunc(res.nextPageId, projects);
    }).catchError((e) {
      throw e;
    });
    _setLoading(false);
  }

  Future<void> fetchInitialProjects() async {
    await _fetchProjects(nextPageFunc: (tkn, ps) {
      final nanos = Int64.parseInt(tkn);
      if (ps.isNotEmpty && nanos != Int64.ZERO) {
        _setNextPageId(nanos);
        _setHasMoreItems(true);
      }
    });
  }

  Future<void> fetchNextProjects() async {
    await _fetchProjects(nextPageFunc: (tkn, ps) {
      if (ps.isEmpty) {
        _setHasMoreItems(false);
      }
      final lastFetchedNanos = Int64.parseInt(tkn);
      if (_nextPageId == lastFetchedNanos ||
          ps.length < perPageEntriesDefault) {
        _setHasMoreItems(false);
      } else {
        _setNextPageId(lastFetchedNanos);
        _setHasMoreItems(true);
      }
    });
  }

  Future<void> searchProjects(String name) async {
    await _fetchProjects(
        nextPageFunc: (tkn, ps) {
          if (ps != null && ps.isNotEmpty) {
            _resetProjects();
            projects.addAll(ps);
            _setHasMoreItems(false);
          }
        },
        filters: {
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

  void _setNextPageId(Int64 val) {
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
