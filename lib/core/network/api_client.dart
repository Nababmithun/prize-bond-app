import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://prize-bond-test.peopleplusbd.com/api/',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 25),
      headers: {
        'Accept': 'application/json',
      },
      // We’ll handle 4xx/5xx ourselves
      validateStatus: (status) => status != null && status >= 200 && status < 600,
    ),
  )..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) => handler.next(options),
    onResponse: (resp, handler) => handler.next(resp),
    onError: (DioException e, handler) {
      if (e.type == DioExceptionType.unknown) {
        e = DioException(
          requestOptions: e.requestOptions,
          error: 'No Internet or server unreachable.',
        );
      }
      handler.next(e);
    },
  ));

  /// Attach/remove bearer token dynamically
  static void setAuthToken(String? token) {
    if (token == null || token.isEmpty) {
      dio.options.headers.remove('Authorization');
    } else {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
}
