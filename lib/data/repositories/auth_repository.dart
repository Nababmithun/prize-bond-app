import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/storage/token_storage.dart';

/// 🔐 Handles all authentication API requests:
/// - Login
/// - Register
/// - Verify OTP
/// - Logout
/// - Persist user session
class AuthRepository {
  final Dio _dio = ApiClient.dio;

  // -------------------------
  // LOGIN
  // -------------------------
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        Endpoints.login,
        data: {'email': email, 'password': password},
      );

      if (res.statusCode == 200 && res.data['status'] == 'success') {
        final token = res.data['token'] ?? res.data['payload']?['token'];

        return {
          'ok': true,
          'message': null,
          'token': token,
        };
      }

      return {
        'ok': false,
        'message': res.data['message']?.toString() ?? 'Login failed',
        'token': null,
      };
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : e.message;
      return {
        'ok': false,
        'message': msg ?? 'Network error during login',
        'token': null,
      };
    } catch (e) {
      return {
        'ok': false,
        'message': 'Unexpected error during login',
        'token': null,
      };
    }
  }

  // -------------------------
  // REGISTER
  // -------------------------
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String email,
    String? nid,
    String? referral,
  }) async {
    try {
      final res = await _dio.post(
        Endpoints.register,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': '123456', // Demo value
          'password_confirmation': '123456',
          'nid': nid ?? '',
          'referred_by': referral ?? '',
        },
      );

      if (res.statusCode == 200 && res.data['status'] == 'success') {
        await TokenStorage.savePendingEmail(email);
        return {'ok': true, 'message': null};
      }

      return {
        'ok': false,
        'message': res.data['message']?.toString() ?? 'Registration failed',
      };
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : e.message;
      return {'ok': false, 'message': msg ?? 'Network error during registration'};
    } catch (e) {
      return {'ok': false, 'message': 'Unexpected error during registration'};
    }
  }

  // -------------------------
  // VERIFY REGISTER OTP
  // -------------------------
  Future<Map<String, dynamic>> verifyRegisterOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await _dio.post(
        Endpoints.verifyRegisterOtp,
        data: {'email': email, 'otp': otp},
      );

      if (res.statusCode == 200 && res.data['status'] == 'success') {
        await TokenStorage.clearPendingEmail();
        return {'ok': true, 'message': null};
      }

      return {
        'ok': false,
        'message': res.data['message']?.toString() ?? 'OTP verification failed',
      };
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : e.message;
      return {'ok': false, 'message': msg ?? 'Network error during OTP verification'};
    } catch (e) {
      return {'ok': false, 'message': 'Unexpected error during OTP verification'};
    }
  }

  // -------------------------
  // SAVE TOKEN & EMAIL LOCALLY
  // -------------------------
  Future<void> persistLogin({String? token, required String email}) async {
    if (token != null && token.isNotEmpty) {
      await TokenStorage.saveToken(token);
      ApiClient.setAuthToken(token);
    }
    await TokenStorage.saveEmail(email);
    await TokenStorage.setLoggedIn(true);
  }

  // -------------------------
  // LOGOUT (CLEAR ALL LOCAL DATA)
  // -------------------------
  Future<void> logout() async {
    await TokenStorage.clearAll();
    ApiClient.setAuthToken(null);
  }
}
