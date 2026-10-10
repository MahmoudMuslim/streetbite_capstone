import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../error/exceptions.dart';

/// Thin, testable wrapper around [Dio].
///
/// Design notes
/// ------------
/// * A **single instance** is registered in GetIt (see `injection.dart`) —
///   creating more than one [Dio] would open a second connection pool.
/// * All transport concerns (timeouts, status validation, error translation)
///   live *here* so that no other file has to know about DioError types. This
///   satisfies the "no duplicated error handling code" requirement.
class DioClient {
  DioClient({Dio? dio}) : _dio = dio ?? _default();

  final Dio _dio;

  /// Default configuration shared by every StreetBite request.
  static Dio _default() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.networkTimeout,
        receiveTimeout: AppConstants.networkTimeout,
        sendTimeout: AppConstants.networkTimeout,
        responseType: ResponseType.json,
        headers: {'Accept': 'application/json'},
      ),
    );

    // Interceptor: converts any transport problem into our own
    // `NetworkException` so callers only ever deal with one error type.
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              type: DioExceptionType.badResponse,
              error: NetworkException(
                _describe(error),
                statusCode: error.response?.statusCode,
              ),
            ),
          );
        },
      ),
    );

    return dio;
  }

  /// Human readable, non technical description of a Dio failure.
  static String _describe(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => 'timeout',
      DioExceptionType.connectionError => 'offline',
      DioExceptionType.badCertificate => 'badCertificate',
      DioExceptionType.badResponse => 'status_${error.response?.statusCode}',
      DioExceptionType.cancel => 'cancelled',
      DioExceptionType.unknown => 'offline',
    };
  }

  /// Performs a `GET` and returns the decoded JSON map.
  ///
  /// Throws [NetworkException] on any transport problem and
  /// [SerializationException] when the body is not a JSON object.
  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      throw const SerializationException('Expected a JSON object response');
    } on NetworkException {
      rethrow;
    } on SerializationException {
      rethrow;
    } on DioException catch (error) {
      // Safety net: the interceptor above normally converts DioException, but a
      // malformed URL could still slip through.
      final wrapped = error.error;
      if (wrapped is NetworkException) throw wrapped;
      throw NetworkException(_describe(error));
    }
  }
}
