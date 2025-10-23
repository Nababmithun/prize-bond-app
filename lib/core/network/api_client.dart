import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://prizebond.peopleplusbd.com/api/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(InterceptorsWrapper(
    onError: (DioException e, handler) {
      if (e.type == DioExceptionType.unknown) {
        // Handle no internet / DNS issue gracefully
        e = DioException(
          requestOptions: e.requestOptions,
          error: 'No Internet or Server not reachable. Check connection.',
        );
      }
      return handler.next(e);
    },
  ));

  // Attach/remove bearer token dynamically
  static void setAuthToken(String? token) {
    if (token == null || token.isEmpty) {
      dio.options.headers.remove('Authorization');
    } else {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
}
