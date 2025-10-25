import 'package:flutter/foundation.dart';
import '../data/repositories/bond_repository.dart';

class BondViewModel extends ChangeNotifier {
  final BondRepository _repo;
  BondViewModel(this._repo);

  bool _loading = false;
  bool get isLoading => _loading;

  List<Map<String, dynamic>> _series = [];
  List<Map<String, dynamic>> get series => _series;

  String? selectedSeriesId;
  String? selectedSeriesCode;
  String? message;

  Future<void> loadSeries() async {
    _loading = true;
    notifyListeners();

    final res = await _repo.fetchSeries();

    _loading = false;
    if (res['ok'] == true) {
      _series = List<Map<String, dynamic>>.from(res['series']);
    } else {
      _series = [];
      message = res['message'];
    }
    notifyListeners();
  }

  void setSelectedSeries(String id, String code) {
    selectedSeriesId = id;
    selectedSeriesCode = code;
    notifyListeners();
  }

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
