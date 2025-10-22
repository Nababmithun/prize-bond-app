import 'package:flutter/material.dart';
import '../data/models/bond.dart';
import '../data/repositories/bond_repository.dart';

class BondViewModel extends ChangeNotifier {
  final BondRepository _repo;
  BondViewModel(this._repo);
  List<Bond> get bonds => _repo.bonds;
  Future<void> add(Bond b) async { await _repo.add(b); notifyListeners(); }
}
