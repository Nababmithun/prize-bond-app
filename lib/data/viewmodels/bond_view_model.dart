import 'package:flutter/foundation.dart';

import '../repositories/bond_repository.dart';

/// ViewModel Layer for managing Prize Bond related operations.
///
/// Handles:
/// - Fetching Series list (for dropdown)
/// - Selecting series
/// - Submitting single bond
/// - Submitting multiple bonds
///
/// Uses [BondRepository] for all API calls.
/// Keeps [_loading], [_series], [message] to update UI via [ChangeNotifier].
class BondViewModel extends ChangeNotifier {
  final BondRepository _repo;

  BondViewModel(this._repo);

  // ---------------------------------------------------------------------------
  // State Variables
  // ---------------------------------------------------------------------------

  bool _loading = false;
  bool get isLoading => _loading;

  List<Map<String, dynamic>> _series = [];
  List<Map<String, dynamic>> get series => _series;

  String? selectedSeriesId;
  String? selectedSeriesCode;
  String? message;

  // ---------------------------------------------------------------------------
  // Fetch Series List
  // ---------------------------------------------------------------------------

  /// Loads all prize bond series for dropdown list.
  Future<void> loadSeries() async {
    _loading = true;
    notifyListeners();

    final res = await _repo.fetchSeries();
    _loading = false;

    if (res['ok'] == true) {
      _series = List<Map<String, dynamic>>.from(res['series']);
      message = null;
    } else {
      _series = [];
      message = res['message'];
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Set Selected Series
  // ---------------------------------------------------------------------------

  /// Sets currently selected series [id] and [code].
  void setSelectedSeries(String id, String code) {
    selectedSeriesId = id;
    selectedSeriesCode = code;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Submit Single Bond
  // ---------------------------------------------------------------------------

  /// Submits a single bond to the API.
  ///
  /// Requires:
  /// - [price]
  /// - [code]
  ///
  /// Returns `true` if success, else `false`.
  Future<bool> submitSingle({
    required String price,
    required String code,
  }) async {
    if (selectedSeriesId == null) {
      message = 'Select a series first';
      notifyListeners();
      return false;
    }

    _loading = true;
    notifyListeners();

    final res = await _repo.createSingle(
      bondSeriesId: selectedSeriesId!,
      price: price,
      code: code,
    );

    _loading = false;
    message = res['message'];
    notifyListeners();
    return res['ok'] == true;
  }

  // ---------------------------------------------------------------------------
  // Submit Bulk Bonds
  // ---------------------------------------------------------------------------

  /// Submits multiple prize bonds in bulk.
  ///
  /// Requires:
  /// - [price]
  /// - [startPrizeBondNumber]
  /// - [totalBond]
  ///
  /// Returns `true` if success, else `false`.
  Future<bool> submitBulk({
    required String price,
    required String startPrizeBondNumber,
    required String totalBond,
  }) async {
    if (selectedSeriesId == null) {
      message = 'Select a series first';
      notifyListeners();
      return false;
    }

    _loading = true;
    notifyListeners();

    final res = await _repo.createBulk(
      bondSeriesId: selectedSeriesId!,
      price: price,
      startPrizeBondNumber: startPrizeBondNumber,
      totalBond: totalBond,
    );

    _loading = false;
    message = res['message'];
    notifyListeners();
    return res['ok'] == true;
  }
}
