import 'package:fixnum/fixnum.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/auth_repo.dart';
import 'package:sys_share_sys_account_service/pkg/shared_repositories/orgproj_repo.dart';
import 'package:sys_share_sys_account_service/pkg/shared_services/base_model.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';
import 'package:sys_share_sys_account_service/view/widgets/view_model/auth_nav_view_model.dart';

class ProjectViewModel extends BaseModel {
  int perPageEntriesDefault = 30;
  List<Org> orgs = List<Org>.empty(growable: true);

  void setHasMoreItems(bool val) {
    _hasMoreItems = val;
    notifyListeners();
  }

  Project _selectedProject;

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

  void changeSelection(bool value, int index) {
    _selected[index] = value;
    notifyListeners();
  }

  void _setHasMoreItems(bool val) {
    _hasMoreItems = val;
    notifyListeners();
  }

  ProjectViewModel({List<Org> organizations, String orgId}) {
    if (organizations != null) {
      orgs = organizations;
      setHasMoreItems(false);
    }
  }

  void _isLoggedIn() {
    final isLoggedOn = Modular.get<AuthNavViewModel>().isLoggedIn;
    _isLoggedOn = isLoggedOn;
    notifyListeners();
  }

  void isUserLoggedIn() {
    return _isLoggedIn();
  }

  Future<void> fetchExistingOrgsProjects({String oid}) async {
    if (oid.isNotEmpty) {
      final _org = await OrgProjRepo.getOrg(id: oid);
      orgs = [_org];
      notifyListeners();
    }
  }

  Future<void> _fetchOrgs(
      {Map<String, dynamic> filters,
      void Function(String, List<Org>) nextPageFunc}) async {
    setLoading(true);
    _isLoggedIn();
    String _accountId = '';
    if (_isLoggedOn) {
      _accountId = await getAccountId();
    }
    await OrgProjRepo.listNonSubbedOrgs(
      orderBy: 'name',
      isDescending: false,
      perPageEntries: perPageEntriesDefault,
      filters: filters,
      currentPageId: _nextPageId,
      accountId: _accountId,
    ).then((res) async {
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
    orgs = List<Org>.empty(growable: true);
    notifyListeners();
  }

  void _setNextPageId(Int64 val) {
    _nextPageId = val;
    notifyListeners();
  }

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
