import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';

class BondRepository {
  final Dio _dio = ApiClient.dio;

  //List of series
  Future<Map<String, dynamic>> fetchSeries() async {
    try {
      final res = await _dio.get(Endpoints.bondSeriesList);
      if (res.statusCode == 200 && res.data is Map) {
        final list = (res.data['data']?['serieses'] ?? []) as List;
        return {'ok': true, 'series': list};
      } else {
        return {
          'ok': false,
          'message': res.data?['message'] ?? 'Failed to load series list',
        };
      }
    } on DioException catch (e) {
      return {'ok': false, 'message': e.message ?? 'Network error'};
    }
  }

  //Single Bond
  Future<Map<String, dynamic>> createSingle({
    required String bondSeriesId,
    required String price,
    required String code,
  }) async {
    try {
      final res = await _dio.post(
        Endpoints.prizeBondStore,
        data: FormData.fromMap({
          'bond_series_id': bondSeriesId,
          'price': price,
          'code': code,
        }),
      );
      return {
        'ok': res.statusCode == 200 && res.data['success'] == true,
        'message': res.data['message'] ?? 'Prize bond created successfully',
      };
    } on DioException catch (e) {
      return {'ok': false, 'message': e.message ?? 'Network error'};
    }
  }

  //Multi -bond
  Future<Map<String, dynamic>> createBulk({
    required String bondSeriesId,
    required String price,
    required String startPrizeBondNumber,
    required String totalBond,
  }) async {
    try {
      final res = await _dio.post(
        Endpoints.prizeBondBulkStore,
        data: FormData.fromMap({
          'bond_series_id': bondSeriesId,
          'price': price,
          'start_prize_bond_number': startPrizeBondNumber,
          'total_bond': totalBond,
        }),
      );
      return {
        'ok': res.statusCode == 200 && res.data['success'] == true,
        'message': res.data['message'] ?? 'Prize bond created successfully',
      };
    } on DioException catch (e) {
      return {'ok': false, 'message': e.message ?? 'Network error'};
    }
  }
}
