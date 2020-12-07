import 'package:meta/meta.dart';
import 'package:mod_disco/core/shared_repositories/disco_project_repo.dart';
import 'package:mod_disco/core/shared_services/base_model.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/account_repo.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/auth_repo.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart';
import 'package:sys_share_sys_account_service/rpc/v2/sys_account_models.pb.dart';
import 'package:fixnum/fixnum.dart';

class DashboardViewModel extends BaseModel {
  Account _currentAccount = Account();
  Map<int, UserRoles> _mapRoles = Map<int, UserRoles>();
  String _accountId = '';
  String _errMsg = '';
  Int64 _currentPageId = Int64.ZERO;
  String _orderBy = 'name';
  bool _isDescending = false;
  bool _isSuperuser = false;
  bool _isAdmin = false;
  bool _hasMoreItems = false;
  Map<String, List<String>> _subscribedProjects = {};

  bool get isUserSuperuser => _isSuperuser;

  bool get isUserAdmin => _isAdmin;

  bool get hasMoreItems => _hasMoreItems;

  void _setHasMoreItems(bool val) {
    _hasMoreItems = val;
    notifyListeners();
  }

  void _setSuperUser(bool value) {
    _isSuperuser = value;
    notifyListeners();
  }

  void _setAdmin(bool value) {
    _isAdmin = value;
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

  void _setAccountId(String value) {
    _accountId = value;
    notifyListeners();
  }

  void _setCurrentAccount(Account account) {
    _currentAccount = account;
    notifyListeners();
  }

  Future<void> _fetchCurrentAccount() async {
    final currentUser = await UserRepo.getAccount(id: _accountId);
    _setCurrentAccount(currentUser);
  }

  Future<void> _fetchAccountId() async {
    if (_accountId.isEmpty) {
      final accountId = await getAccountId();
      _setAccountId(accountId);
      await _fetchCurrentAccount();
      if (_currentAccount.id.isNotEmpty) {
        _setAccountId(_currentAccount.id);
      }
    }
  }

  Future<void> verifySuperuser() async {
    if (isLoggedOn) {
      await _fetchAccountId();
      final _isSuperAdmin = isSuperAdmin(_currentAccount);
      if (_isSuperAdmin) {
        _setSuperUser(true);
      }
    }
  }

  Future<void> verifyAdmin() async {
    if (isLoggedOn) {
      await _fetchAccountId();
      _mapRoles = isAdmin(_currentAccount);
      notifyListeners();
      if (_mapRoles.isNotEmpty) {
        _setAdmin(true);
      }
    }
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

  Future<void> getPermissions() async {
    setLoading(true);
    await isUserLoggedIn();
    if (!isLoggedOn) {
      throw "cannot access dashboard, user not logged in";
    }
    if (_currentAccount.id.isEmpty) {
      await _fetchAccountId();
    }
    await verifySuperuser();
    await verifyAdmin();
    if (!_isSuperuser && !_isAdmin) {
      throw "cannot access dashboard, user is not authorized";
    }
    _setSubscribedProjects(getSubscribedProjects(_currentAccount));
    setLoading(false);
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
      resp.orgs.forEach((_org) {
        _org.projects.forEach((p) async {
          if (!_isSuperuser && !_subscribedProjects[_org.id].contains(p.id)) {
          } else {
            await DiscoProjectRepo.getProjectDetails(accountProjRefId: p.id)
                .then((details) {
              projectDetails.add(details);
              notifyListeners();
            }).catchError((e) => setErrMsg(e.toString()));
          }
        });
      });
      notifyListeners();
      nextPageFunc(resp.nextPageId, resp.orgs);
    }).catchError((e) {
      setErrMsg(e.toString());
    });
    setLoading(false);
  }

  void _commonOrgFilter() {
    if (!_isSuperuser) {
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
      if (!_isSuperuser) {
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
    if (!_isSuperuser) {
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
      orgs.addAll(ps);
      if (!_isSuperuser) {
        _commonOrgFilter();
      }
      final lastFetchedNanos = Int64.parseInt(tkn);
      if (_currentPageId == lastFetchedNanos ||
          ps.length < perPageEntriesDefault) {
        _setHasMoreItems(false);
      } else {
        setCurrentPageId(lastFetchedNanos);
        _setHasMoreItems(true);
      }
    };
    if (!_isSuperuser) {
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
        if (!_isSuperuser) {
          _commonOrgFilter();
        }
        _setHasMoreItems(false);
      }
    };
    if (!_isSuperuser) {
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
}
