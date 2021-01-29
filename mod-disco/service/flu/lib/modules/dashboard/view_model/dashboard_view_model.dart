import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/auth_repo.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart';
import 'package:sys_share_sys_account_service/pkg/shared_services/base_model.dart';
import 'package:sys_share_sys_account_service/rpc/v2/sys_account_models.pb.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sys_share_sys_account_service/view/widgets/view_model/auth_nav_view_model.dart';

class DashboardViewModel extends BaseModel {
  int perPageEntriesDefault = 30;
  List<Org> orgs = List<Org>.empty(growable: true);
  Map<int, UserRoles> _mapRoles = Map<int, UserRoles>();
  String _errMsg = '';
  Int64 _currentPageId = Int64.ZERO;
  String _orderBy = 'name';
  bool _isDescending = false;
  bool _hasMoreItems = false;
  Map<String, List<String>> _subscribedProjects = {};
  Account _currentAccount = Modular.get<AuthNavViewModel>().currentAccount;

  bool get hasMoreItems => _hasMoreItems;

  void _setHasMoreItems(bool val) {
    _hasMoreItems = val;
    notifyListeners();
  }

  // constructor
  DashboardViewModel({List<Org> organizations}) {
    this.orgs = organizations;
  }

  void _setSubscribedProjects(Map<String, List<String>> subscribed) {
    _subscribedProjects = subscribed;
    notifyListeners();
  }

  void setErrMsg(String value) {
    _errMsg = value;
    notifyListeners();
  }

  void setCurrentPageId(Int64 value) {
    _currentPageId = value;
    notifyListeners();
  }

  void _setOrgs(List<Org> value) {
    if (this.orgs == null) {
      this.orgs = value;
    } else {
      this.orgs.addAll(value);
    }
    notifyListeners();
  }

  Future<void> _fetchOrgs(
      {@required Map<String, dynamic> filter,
      @required void Function(String, List<Org>) nextPageFunc,
      @required String matcher}) async {
    setLoading(true);
    await OrgProjRepo.listUserOrgs(
      currentPageId: _currentPageId,
      orderBy: _orderBy,
      isDescending: _isDescending,
      perPageEntries: perPageEntriesDefault,
      filters: filter,
      matcher: matcher,
    ).then((resp) {
      notifyListeners();
      nextPageFunc(resp.nextPageId, resp.orgs);
    }).catchError((e) {
      setErrMsg(e.toString());
    });
    setLoading(false);
  }

  void _commonOrgFilter() {
    if (!Modular.get<AuthNavViewModel>().isSuperuser) {
      orgs = orgs.map((_org) {
        List<Project> _orgProjects = [];
        _org.projects.forEach((p) {
          if (_subscribedProjects[_org.id].contains(p.id)) {
            _orgProjects.add(p);
          }
        });
        _org.projects.clear();
        _org.projects.addAll(_orgProjects);
        return _org;
      }).toList();
      notifyListeners();
    }
  }

  Future<void> getInitialAdminOrgs() async {
    final nextPgFunc = (String tkn, List<Org> ps) {
      final nanos = Int64.parseInt(tkn);
      if (orgs == null || orgs.isEmpty) {
        orgs = ps;
        notifyListeners();
      }
      if (!Modular.get<AuthNavViewModel>().isSuperuser) {
        _commonOrgFilter();
      }
      if (ps.isNotEmpty &&
          nanos != Int64.ZERO &&
          ps.length == perPageEntriesDefault) {
        setCurrentPageId(nanos);
        _setHasMoreItems(true);
      } else {
        _setHasMoreItems(false);
      }
    };
    if (!Modular.get<AuthNavViewModel>().isSuperuser) {
      final orgIds = getSubscribedOrgs(_currentAccount);
      await _fetchOrgs(
          filter: {"id": orgIds}, matcher: "in", nextPageFunc: nextPgFunc);
    } else {
      await _fetchOrgs(
          filter: Map<String, dynamic>(),
          matcher: "like",
          nextPageFunc: nextPgFunc);
    }
  }

  Future<void> getNextAdminOrgs() async {
    final nextPgFunc = (String tkn, List<Org> ps) {
      if (ps.isEmpty) {
        _setHasMoreItems(false);
      }
      if (!Modular.get<AuthNavViewModel>().isSuperuser) {
        _commonOrgFilter();
      }
      final lastFetchedNanos = Int64.parseInt(tkn);
      if (_currentPageId == lastFetchedNanos ||
          ps.length < perPageEntriesDefault) {
        _setHasMoreItems(false);
      } else {
        orgs.addAll(ps);
        setCurrentPageId(lastFetchedNanos);
        _setHasMoreItems(true);
      }
    };
    if (!Modular.get<AuthNavViewModel>().isSuperuser) {
      final orgIds = getSubscribedOrgs(_currentAccount);
      await _fetchOrgs(
          filter: {"id": orgIds}, matcher: "in", nextPageFunc: nextPgFunc);
    } else {
      await _fetchOrgs(
          filter: Map<String, dynamic>(),
          matcher: "like",
          nextPageFunc: nextPgFunc);
    }
  }

  Future<void> searchAdminOrgs(String name) async {
    final nextPgFunc = (String tkn, List<Org> ps) {
      if (ps != null && ps.isNotEmpty) {
        _resetOrgs();
        orgs.addAll(ps);
        if (!Modular.get<AuthNavViewModel>().isSuperuser) {
          _commonOrgFilter();
        }
        _setHasMoreItems(false);
      }
    };
    if (!Modular.get<AuthNavViewModel>().isSuperuser) {
      final orgIds = getSubscribedOrgs(_currentAccount);
      await _fetchOrgs(
          filter: {"id": orgIds, "name": name},
          matcher: "in",
          nextPageFunc: nextPgFunc);
    } else {
      await _fetchOrgs(
          filter: Map<String, dynamic>(),
          matcher: "like",
          nextPageFunc: nextPgFunc);
    }
  }

  void _resetOrgs() {
    orgs = [];
    notifyListeners();
  }

  Future<void> onResetSearchOrgs() async {
    _resetOrgs();
    await getInitialAdminOrgs();
  }

  void setHasMoreItems(bool val) {
    _hasMoreItems = val;
    notifyListeners();
  }

  Project _selectedProject;

  Int64 _nextPageId = Int64(0);
  List<bool> _selected = [];
  bool _isLoading = false;

  List<bool> get selected => _selected;

  bool get isLoading => _isLoading;

  Project get selectedProject => _selectedProject;

  void changeSelection(bool value, int index) {
    _selected[index] = value;
    notifyListeners();
  }

  Future<void> fetchExistingOrgsProjects({String oid}) async {
    if (oid.isNotEmpty) {
      final _org = await OrgProjRepo.getOrg(id: oid);
      orgs.add(_org);
      notifyListeners();
    }
  }

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
