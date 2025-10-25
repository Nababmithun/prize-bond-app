import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';

class ProfileRepository {
  final Dio _dio = ApiClient.dio;

  //  Get Profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final res = await _dio.get(Endpoints.profileEdit);
      if (res.statusCode == 200 && res.data['success'] == true) {
        return {'ok': true, 'user': res.data['data']['user']};
      } else {
        return {'ok': false, 'message': res.data['message'] ?? 'Failed to load profile'};
      }
    } on DioException catch (e) {
      return {'ok': false, 'message': e.message ?? 'Network error'};
    }
  }

  //  Update Profile
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String phone,
    required String nid,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'phone': phone,
        'nid': nid,
        if (image != null)
          'image': await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
      });

      final res = await _dio.post(Endpoints.profileUpdate, data: formData);
      if (res.statusCode == 200 && res.data['success'] == true) {
        return {'ok': true, 'user': res.data['data']['user'], 'message': res.data['message']};
      } else {
        return {'ok': false, 'message': res.data['message'] ?? 'Update failed'};
      }
    } on DioException catch (e) {
      return {'ok': false, 'message': e.message ?? 'Network error'};
    }
  }

  //  Get Prize Bond List
  Future<Map<String, dynamic>> getPrizeBonds() async {
    try {
      final res = await _dio.get(Endpoints.prizeBondList);
      if (res.statusCode == 200 && res.data['success'] == true) {
        final bonds = (res.data['data']['bonds'] ?? []) as List;
        return {'ok': true, 'bonds': bonds};
      } else {
        return {'ok': false, 'message': res.data['message'] ?? 'Failed to load bonds'};
      }
    } on DioException catch (e) {
      return {'ok': false, 'message': e.message ?? 'Network error'};
    }
  }
}
