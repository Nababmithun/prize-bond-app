import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';

class ChangePasswordRepository {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final formData = FormData.fromMap({
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      });

      final res = await _dio.post(Endpoints.changePassword, data: formData);

      if (res.statusCode == 200 && res.data['success'] == true) {
        return {
          'ok': true,
          'message': res.data['message'] ?? 'Password changed successfully'
        };
      } else {
        return {
          'ok': false,
          'message': res.data['message'] ?? 'Failed to change password'
        };
      }
    } on DioException catch (e) {
      return {
        'ok': false,
        'message': e.response?.data['message'] ?? e.message ?? 'Network error'
      };
    }
  }
}
