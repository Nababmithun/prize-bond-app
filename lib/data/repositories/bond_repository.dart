import '../models/bond.dart';

class BondRepository {
  final List<Bond> _bonds = [];
  List<Bond> get bonds => List.unmodifiable(_bonds);
  Future<void> add(Bond b) async { await Future.delayed(const Duration(milliseconds: 300)); _bonds.add(b); }
}
