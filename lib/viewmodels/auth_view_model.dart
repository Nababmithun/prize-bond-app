import 'package:flutter/foundation.dart';
import '../data/repositories/auth_repository.dart';
import '../core/storage/token_storage.dart';
import '../core/network/api_client.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  AuthViewModel(this._repo);

  bool _loading = false;
  String? _error;

  bool get isLoading => _loading;
  String? get error => _error;

  Future<bool> tryAutoAttachToken() async {
    final token = await TokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      ApiClient.setAuthToken(token);
      return true;
    }
    return false;
  }

  Future<bool> isLoggedIn() => TokenStorage.isLoggedIn();

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    final res = await _repo.login(email: email, password: password);
    _setLoading(false);

    final ok = res['ok'] == true;
    _error = ok ? null : res['message'];
    if (ok) {
      await _repo.persistLogin(token: res['token'], email: email);
    }
    notifyListeners();
    return ok;
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    String? nid,
    String? referral,
  }) async {
    _setLoading(true);
    final res = await _repo.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      nid: nid,
      referral: referral,
    );
    _setLoading(false);

    final ok = res['ok'] == true;
    _error = ok ? null : res['message'];
    notifyListeners();
    return ok;
  }

  Future<bool> verifyOtp(String otp, {String? emailArg}) async {
    final email = emailArg ?? (await TokenStorage.getPendingEmail()) ?? '';
    if (email.isEmpty) {
      _error = 'No pending email';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    final res = await _repo.verifyRegisterOtp(email: email, otp: otp);
    _setLoading(false);

    final ok = res['ok'] == true;
    _error = ok ? null : res['message'];
    notifyListeners();

    if (ok) {
      await TokenStorage.clearPendingEmail();
    }
    return ok;
  }


  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    final res = await _repo.forgotPassword(email: email);
    _setLoading(false);
    final ok = res['ok'] == true;
    _error = ok ? null : res['message'];
    notifyListeners();
    return ok;
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    _setLoading(true);
    final res = await _repo.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
    _setLoading(false);
    final ok = res['ok'] == true;
    _error = ok ? null : res['message'];
    notifyListeners();
    return ok;
  }



  Future<void> logout() async {
    await _repo.logout();
    notifyListeners();
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
