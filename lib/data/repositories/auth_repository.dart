import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/storage/token_storage.dart';

/// Repository layer for all Authentication-related API calls.
///
/// NOTE:
/// - Logic/behavior unchanged from your version.
/// - Only docs & comments added for clarity.
/// - Uses `FormData` to match backend expectations.
/// - `success == true` is treated as OK across endpoints.
class AuthRepository {
  AuthRepository();

  /// Shared Dio instance (configured in [ApiClient]).
  final Dio _dio = ApiClient.dio;

  // ---------------------------------------------------------------------------
  // LOGIN
  // ---------------------------------------------------------------------------

  /// Login with [email] and [password].
  ///
  /// Returns:
  ///   - `{'ok': true, 'message': null, 'token': <String>}` on success
  ///   - `{'ok': false, 'message': <String>}` on failure
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        Endpoints.login,
        data: FormData.fromMap({'email': email, 'password': password}),
      );

      final data = res.data;
      final ok = (data is Map) && data['success'] == true;

      if (ok) {
        // Token is expected at: data.data.user.token
        final token = data['data']?['user']?['token']?.toString();
        if (token == null || token.isEmpty) {
          return {'ok': false, 'message': 'Token missing in response'};
        }
        return {'ok': true, 'message': null, 'token': token};
      }

      return {
        'ok': false,
        'message': data is Map
            ? (data['message']?.toString() ?? 'Login failed')
            : 'Login failed',
      };
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : e.message;
      return {'ok': false, 'message': msg ?? 'Network error during login'};
    } catch (_) {
      return {'ok': false, 'message': 'Unexpected error during login'};
    }
  }

  // ---------------------------------------------------------------------------
  // REGISTER
  // ---------------------------------------------------------------------------

  /// Register a new user.
  ///
  /// Backend exact keys respected:
  /// - `confirm_password`
  /// - `referral_code`
  ///
  /// On success, saves pending email to [TokenStorage] (for OTP flow).
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    String? nid,
    String? referral,
  }) async {
    try {
      final res = await _dio.post(
        Endpoints.register,
        data: FormData.fromMap({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'confirm_password': confirmPassword, // exact key
          'nid': nid ?? '',
          'referral_code': referral ?? '',     // exact key from screenshot
        }),
      );

      final data = res.data;
      final ok = (data is Map) && data['success'] == true;

      if (ok) {
        await TokenStorage.savePendingEmail(email);
        return {'ok': true, 'message': null};
      }

      return {
        'ok': false,
        'message': data is Map
            ? (data['message']?.toString() ?? 'Registration failed')
            : 'Registration failed',
      };
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : e.message;
      return {
        'ok': false,
        'message': msg ?? 'Network error during registration',
      };
    } catch (_) {
      return {'ok': false, 'message': 'Unexpected error during registration'};
    }
  }

  // ---------------------------------------------------------------------------
  // VERIFY OTP
  // ---------------------------------------------------------------------------

  /// Verify registration OTP with [email] and [otp].
  ///
  /// On success, clears pending email in [TokenStorage].
  Future<Map<String, dynamic>> verifyRegisterOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await _dio.post(
        Endpoints.verifyOtp,
        data: FormData.fromMap({'email': email, 'otp': otp}),
      );

      final data = res.data;
      final ok = (data is Map) && data['success'] == true;

      if (ok) {
        await TokenStorage.clearPendingEmail();
        return {'ok': true, 'message': null};
      }

      return {
        'ok': false,
        'message': data is Map
            ? (data['message']?.toString() ?? 'OTP verification failed')
            : 'OTP verification failed',
      };
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : e.message;
      return {
        'ok': false,
        'message': msg ?? 'Network error during OTP verification',
      };
    } catch (_) {
      return {
        'ok': false,
        'message': 'Unexpected error during OTP verification',
      };
    }
  }

  // ---------------------------------------------------------------------------
  // SESSION PERSIST
  // ---------------------------------------------------------------------------

  /// Persist a logged-in session (token + email + logged_in=true),
  /// and attach token to [ApiClient] for subsequent calls.
  Future<void> persistLogin({
    required String token,
    required String email,
  }) async {
    await TokenStorage.saveToken(token);
    await TokenStorage.saveEmail(email);
    await TokenStorage.setLoggedIn(true);
    ApiClient.setAuthToken(token);
  }

  // ---------------------------------------------------------------------------
  // FORGOT PASSWORD (Send OTP to email)
  // ---------------------------------------------------------------------------

  /// Request a forgot-password OTP to be sent to [email].
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final res = await _dio.post(
        Endpoints.forgotPassword,
        data: FormData.fromMap({'email': email}),
      );

      final data = res.data;
      final ok = (data is Map) && data['success'] == true;

      return {
        'ok': ok,
        'message': data is Map
            ? (data['message']?.toString() ?? 'Failed to send code')
            : 'Failed to send code',
      };
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : e.message;
      return {
        'ok': false,
        'message': msg ?? 'Network error during forgot password',
      };
    } catch (_) {
      return {
        'ok': false,
        'message': 'Unexpected error during forgot password',
      };
    }
  }

  // ---------------------------------------------------------------------------
  // RESET PASSWORD (with email + otp + new_password)
  // ---------------------------------------------------------------------------

  /// Reset password using [email], [otp] and [newPassword].
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final res = await _dio.post(
        Endpoints.resetPassword,
        data: FormData.fromMap({
          'email': email,
          'otp': otp,
          'new_password': newPassword,
        }),
      );

      final data = res.data;
      final ok = (data is Map) && data['success'] == true;

      return {
        'ok': ok,
        'message': data is Map
            ? (data['message']?.toString() ?? 'Failed to reset password')
            : 'Failed to reset password',
      };
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : e.message;
      return {
        'ok': false,
        'message': msg ?? 'Network error during reset password',
      };
    } catch (_) {
      return {'ok': false, 'message': 'Unexpected error during reset password'};
    }
  }

  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------

  /// Clear all session data and detach token from [ApiClient].
  Future<void> logout() async {
    await TokenStorage.clearAll();
    ApiClient.setAuthToken(null);
  }
}
