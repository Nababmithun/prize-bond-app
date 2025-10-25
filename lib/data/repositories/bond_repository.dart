import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';

/// Repository layer for all Prize Bond–related API calls.
///
/// NOTE:
/// - Logic/behavior unchanged from your version.
/// - Uses the shared [Dio] client from [ApiClient].
/// - All methods return a uniform map `{ ok: bool, message: String?, ... }`
///   so that ViewModel/UI সহজে handle করতে পারে।
class BondRepository {
  BondRepository();

  /// Shared Dio instance (configured centrally in [ApiClient]).
  final Dio _dio = ApiClient.dio;

  // ---------------------------------------------------------------------------
  // Series List
  // ---------------------------------------------------------------------------

  /// Fetch prize bond series list (dropdown data).
  ///
  /// Returns:
  ///   - `{'ok': true, 'series': <List>}` on success
  ///   - `{'ok': false, 'message': <String>}` on failure
  Future<Map<String, dynamic>> fetchSeries() async {
    try {
      final res = await _dio.get(Endpoints.bondSeriesList);

      if (res.statusCode == 200 && res.data is Map) {
        final list = (res.data['data']?['serieses'] ?? []) as List;
        return {'ok': true, 'series': list};
      }

      // Non-200 or unexpected payload
      return {
        'ok': false,
        'message': (res.data is Map ? res.data['message'] : null) ??
            'Failed to load series list',
      };
    } on DioException catch (e) {
      return {'ok': false, 'message': e.message ?? 'Network error'};
    }
  }

  // ---------------------------------------------------------------------------
  // Single Bond Create
  // ---------------------------------------------------------------------------

  /// Create/store a single prize bond.
  ///
  /// Required payload:
  /// - [bondSeriesId]
  /// - [price]
  /// - [code]
  ///
  /// Returns:
  ///   - `{'ok': true, 'message': <String>}` on success
  ///   - `{'ok': false, 'message': <String>}` on failure
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

  // ---------------------------------------------------------------------------
  // Bulk Bond Create
  // ---------------------------------------------------------------------------

  /// Bulk create/store multiple prize bonds.
  ///
  /// Required payload:
  /// - [bondSeriesId]
  /// - [price]
  /// - [startPrizeBondNumber]
  /// - [totalBond]
  ///
  /// Returns:
  ///   - `{'ok': true, 'message': <String>}` on success
  ///   - `{'ok': false, 'message': <String>}` on failure
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
