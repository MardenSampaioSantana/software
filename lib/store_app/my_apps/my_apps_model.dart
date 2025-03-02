/*
 * Copyright (C) 2022 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import 'dart:async';

import 'package:packagekit/packagekit.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:snapd/snapd.dart';
import 'package:software/services/app_change_service.dart';
import 'package:software/services/package_service.dart';

class MyAppsModel extends SafeChangeNotifier {
  final PackageService _packageService;
  MyAppsModel(
    this._packageService,
    this._snapDClient,
    this._appChangeService,
  ) : _localSnaps = [];

  StreamSubscription<bool>? _installedSub;

  List<PackageKitPackageId> get installedApps => _packageService.installedApps;

  final SnapdClient _snapDClient;
  final AppChangeService _appChangeService;
  StreamSubscription<bool>? _snapChangesSub;
  final List<Snap> _localSnaps;
  List<Snap> get localSnaps => _localSnaps;

  Snap? _selectedSnap;
  Snap? get selectedSnap => _selectedSnap;
  set selectedSnap(Snap? snap) {
    if (snap == _selectedSnap) return;
    _selectedSnap = snap;
    notifyListeners();
  }

  PackageKitPackageId? _selectedPackage;
  PackageKitPackageId? get selectedPackage => _selectedPackage;
  set selectedPackage(PackageKitPackageId? id) {
    if (id == _selectedPackage) return;
    _selectedPackage = id;
    notifyListeners();
  }

  Future<void> init() async {
    await _loadLocalSnaps();
    _snapChangesSub = _appChangeService.snapChangesInserted.listen((_) {
      if (_appChangeService.snapChanges.isEmpty) {
        _loadLocalSnaps().then((value) => notifyListeners());
      }
    });
    _installedSub = _packageService.installedAppsChanged.listen((event) {
      notifyListeners();
    });
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _snapChangesSub?.cancel();
    _installedSub?.cancel();

    super.dispose();
  }

  Future<void> _loadLocalSnaps() async {
    await _snapDClient.loadAuthorization();
    final snaps = (await _snapDClient.getSnaps())
        .where(
          (snap) => _appChangeService.getChange(snap) == null,
        )
        .toList();
    snaps.sort((a, b) => a.name.compareTo(b.name));
    _localSnaps.clear();
    _localSnaps.addAll(snaps);
  }

  void clearSelection() {
    selectedSnap = null;
    selectedPackage = null;
  }
}
