import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:mod_disco/core/shared_repositories/disco_project_repo.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/auth_repo.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart'
    as repo;
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

class BaseModel extends ChangeNotifier {
  int perPageEntriesDefault = 30;
  List<Org> orgs = List<Org>.empty(growable: true);

  // List<Project> projects = [];
  List<DiscoProject> projectDetails = List<DiscoProject>.empty(growable: true);

  // constructor
  BaseModel({List<Org> orglist}) {
    if (orglist != null) {
      this.orgs = orglist;
      _setHasMoreItems(false);
    }
  }

  void setHasMoreItems(bool val) {
    _hasMoreItems = val;
    notifyListeners();
  }

  Project _selectedProject;
  DiscoProject _selectedDiscoProject;

  Int64 _nextPageId = Int64(0);
  List<bool> _selected = [];
  bool _isLoading = false;
  bool _hasMoreItems = false;
  bool _isLoggedOn = false;

  List<bool> get selected => _selected;

  bool get isLoading => _isLoading;

  bool get hasMoreItems => _hasMoreItems;

  bool get isLoggedOn => _isLoggedOn;

  Project get selectedProject => _selectedProject;

  DiscoProject get selectedProjectDetails => _selectedDiscoProject;

  void changeSelection(bool value, int index) {
    _selected[index] = value;
    notifyListeners();
  }

  void _setHasMoreItems(bool val) {
    _hasMoreItems = val;
    notifyListeners();
  }

  Future<void> _isLoggedIn() async {
    final isLoggedOn = await isLoggedIn();
    _isLoggedOn = isLoggedOn;
    notifyListeners();
  }

  Future<void> isUserLoggedIn() async {
    return await _isLoggedIn();
  }

  Future<void> _fetchOrgs(
      {Map<String, dynamic> filters,
      void Function(String, List<Org>) nextPageFunc}) async {
    setLoading(true);
    await _isLoggedIn();
    String _accountId = '';
    if (_isLoggedOn) {
      _accountId = await getAccountId();
    }
    await repo.OrgProjRepo.listNonSubbedOrgs(
      orderBy: 'name',
      isDescending: false,
      perPageEntries: perPageEntriesDefault,
      filters: filters,
      currentPageId: _nextPageId,
      accountId: _accountId,
    ).then((res) async {
      res.orgs.forEach((org) async {
        org.projects.forEach((p) async {
          await DiscoProjectRepo.getProjectDetails(accountProjRefId: p.id)
              .then((details) {
            projectDetails.add(details);
          }).catchError((e) => print(e));
        });
      });
      notifyListeners();
      // f(this.projects);
      nextPageFunc(res.nextPageId, res.orgs);
    }).catchError((e) {
      throw e;
    });
    setLoading(false);
  }

  Future<void> fetchInitialProjects() async {
    await _fetchOrgs(nextPageFunc: (tkn, ps) {
      final nanos = Int64.parseInt(tkn);
      if (orgs == null || orgs.isEmpty) {
        orgs = ps;
        notifyListeners();
      }
      if (ps.isNotEmpty &&
          nanos != Int64.ZERO &&
          ps.length == perPageEntriesDefault) {
        _setNextPageId(nanos);
        _setHasMoreItems(true);
      } else {
        _setHasMoreItems(false);
      }
    });
  }

  Future<void> fetchNextProjects() async {
    await _fetchOrgs(nextPageFunc: (tkn, ps) {
      if (ps.isEmpty) {
        _setHasMoreItems(false);
      }
      final lastFetchedNanos = Int64.parseInt(tkn);
      if (_nextPageId == lastFetchedNanos ||
          ps.length < perPageEntriesDefault) {
        _setHasMoreItems(false);
      } else {
        orgs.addAll(ps);
        _setNextPageId(lastFetchedNanos);
        _setHasMoreItems(true);
      }
    });
  }

  Future<void> searchProjects(String name) async {
    await _fetchOrgs(
        nextPageFunc: (tkn, ps) {
          if (ps != null && ps.isNotEmpty) {
            _resetProjects();
            orgs.addAll(ps);
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
    orgs = [];
    notifyListeners();
  }

  void _setNextPageId(Int64 val) {
    _nextPageId = val;
    notifyListeners();
  }

  // void _updateSelectedList() {
  //   final _count = orgs.length;
  //   List<bool> _projListBool = orgs.map((o) => false);
  //   _selected = _projListBool;
  //   notifyListeners();
  // }

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void getSelectedProjectAndDetails(String orgId, String id) {
    Project _proj;
    final _org = orgs.firstWhere((org) => org.id == orgId);
    final p = _org.projects.firstWhere((element) => element.id == id);
    if (p != null) {
      _proj = p;
    } else {
      throw "Error no project found";
    }
    _selectedProject = _proj;
    _selectedDiscoProject = projectDetails
        .firstWhere((element) => element.sysAccountProjectRefId == _proj.id);
  }
}
