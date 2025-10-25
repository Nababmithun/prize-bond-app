import 'package:dio/dio.dart';

/// A centralized API client using Dio for all network requests.
///
/// This class handles:
/// - Global [Dio] configuration (base URL, timeout, headers)
/// - Error handling for common network issues
/// - Attaching/removing Bearer tokens dynamically
///
/// Usage example:
/// ```dart
/// final response = await ApiClient.dio.get('users');
/// ```
///
/// To set or clear an authorization token:
/// ```dart
/// ApiClient.setAuthToken(token);
/// ```
class ApiClient {
  ApiClient._(); // Private constructor: prevents direct instantiation

  /// The shared Dio instance used across the app.
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://prize-bond-test.peopleplusbd.com/api/',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 25),
      headers: {
        'Accept': 'application/json',
      },
      // Allow manual error handling for any non-2xx response.
      validateStatus: (status) =>
      status != null && status >= 200 && status < 600,
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        /// Runs before every request (good for adding headers or logging).
        onRequest: (options, handler) {
          // Example: print request info for debugging
          // print('[${options.method}] ${options.uri}');
          handler.next(options);
        },

        /// Runs on every successful response.
        onResponse: (response, handler) {
          // print([${response.statusCode}] ${response.requestOptions.uri}');
          handler.next(response);
        },

        /// Global error handler (network, timeout, etc.)
        onError: (DioException e, handler) {
          if (e.type == DioExceptionType.unknown) {
            e = DioException(
              requestOptions: e.requestOptions,
              error: 'No Internet connection or server unreachable.',
            );
          } else if (e.type == DioExceptionType.connectionTimeout) {
            e = DioException(
              requestOptions: e.requestOptions,
              error: 'Connection timeout. Please try again.',
            );
          } else if (e.type == DioExceptionType.receiveTimeout) {
            e = DioException(
              requestOptions: e.requestOptions,
              error: 'Server took too long to respond.',
            );
          }
          handler.next(e);
        },
      ),
    );

  /// Dynamically attaches or removes Bearer tokens in request headers.
  ///
  /// If [token] is `null` or empty, the `Authorization` header is removed.
  /// Otherwise, a `Bearer` token header is added.
  static void setAuthToken(String? token) {
    if (token == null || token.isEmpty) {
      dio.options.headers.remove('Authorization');
    } else {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
}
