import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/user.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  AuthViewModel(this._repo);

  bool get loggedIn => _repo.isLoggedIn;
  User? get me => _repo.me;

  Future<bool> login(String email, String pass) => _repo.login(email, pass);
  Future<void> logout() => _repo.logout();

  // ViewModel forward
  Future<bool> register({
    required String name,
    required String phone,
    required String email,
    String? nid,
    String? referral,
  }) async {
    final ok = await _repo.register(
      name: name,
      phone: phone,
      email: email,
      nid: nid,
      referral: referral,
    );
    if (ok) notifyListeners();
    return ok;
  }
}
