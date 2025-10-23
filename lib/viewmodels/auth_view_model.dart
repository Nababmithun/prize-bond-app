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

  /// Try to attach token automatically if already stored
  Future<bool> tryAutoAttachToken() async {
    final token = await TokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      ApiClient.setAuthToken(token);
      return true;
    }
    return false;
  }

  /// Check login status from local storage
  Future<bool> isLoggedIn() => TokenStorage.isLoggedIn();

  /// Login process
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

  /// Registration process
  Future<bool> register({
    required String name,
    required String phone,
    required String email,
    String? nid,
    String? referral,
  }) async {
    _setLoading(true);
    final res = await _repo.register(
      name: name,
      phone: phone,
      email: email,
      nid: nid,
      referral: referral,
    );
    _setLoading(false);

    final ok = res['ok'] == true;
    _error = ok ? null : res['message'];
    notifyListeners();
    return ok;
  }

  /// Verify OTP after registration
  Future<bool> verifyOtp(String otp) async {
    final email = await TokenStorage.getPendingEmail() ?? '';
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
      // Verified → consider user as logged-in so next is home
      await _repo.persistLogin(token: null, email: email);
    }
    return ok;
  }

  /// Logout
  Future<void> logout() async {
    await _repo.logout();
    notifyListeners();
  }

  // --------------------------
  // PRIVATE HELPERS
  // --------------------------
  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
