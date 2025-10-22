import '../models/user.dart';

class AuthRepository {
  bool _loggedIn = false;
  User? _me;

  bool get isLoggedIn => _loggedIn;
  User? get me => _me;

  Future<bool> login(String email, String pass) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _loggedIn = true;
    _me = User(name: 'Pieton Bosak', email: email);
    return true;
  }

  Future<void> logout() async {
    _loggedIn = false;
    _me = null;
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String email,
    String? nid,
    String? referral,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _me = User(name: name, email: email, phone: phone, nid: nid);
    _loggedIn = true;
    return true;
  }
}
