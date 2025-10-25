import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import '../../core/storage/token_storage.dart';
import '../repositories/auth_repository.dart';


/// ViewModel (Provider Layer) for Authentication.
///
/// Handles:
/// - Login, Register, Verify OTP
/// - Forgot / Reset password
/// - Logout
/// - Token persistence and auto-attach
///
/// Uses [AuthRepository] for all API calls.
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo;

  AuthViewModel(this._repo);

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  bool _loading = false;
  String? _error;

  bool get isLoading => _loading;
  String? get error => _error;

  // ---------------------------------------------------------------------------
  // Token / Session Helpers
  // ---------------------------------------------------------------------------

  /// Try to attach stored token to API client automatically (app startup).
  Future<bool> tryAutoAttachToken() async {
    final token = await TokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      ApiClient.setAuthToken(token);
      return true;
    }
    return false;
  }

  /// Check if user is already logged in.
  Future<bool> isLoggedIn() => TokenStorage.isLoggedIn();

  // ---------------------------------------------------------------------------
  // LOGIN
  // ---------------------------------------------------------------------------

  /// Login with [email] and [password].
  ///
  /// On success:
  /// - Persists token and email to storage.
  /// - Attaches auth header to [ApiClient].
  ///
  /// Returns true if success, false otherwise.
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

  // ---------------------------------------------------------------------------
  // REGISTER
  // ---------------------------------------------------------------------------

  /// Register new user.
  ///
  /// After successful registration, OTP verification is required.
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

  // ---------------------------------------------------------------------------
  // VERIFY OTP
  // ---------------------------------------------------------------------------

  /// Verify OTP for registration.
  ///
  /// Uses pending email from storage if [emailArg] is not provided.
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

  // ---------------------------------------------------------------------------
  // FORGOT PASSWORD
  // ---------------------------------------------------------------------------

  /// Request password reset code to be sent to [email].
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    final res = await _repo.forgotPassword(email: email);
    _setLoading(false);

    final ok = res['ok'] == true;
    _error = ok ? null : res['message'];
    notifyListeners();
    return ok;
  }

  // ---------------------------------------------------------------------------
  // RESET PASSWORD
  // ---------------------------------------------------------------------------

  /// Reset password using email, OTP and new password.
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

  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------

  /// Clear all local session data and reset token.
  Future<void> logout() async {
    await _repo.logout();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
