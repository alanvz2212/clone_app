import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/string_constants.dart';
import 'cache_service.dart';
import 'network_service.dart';
class ApiService {
  static const String baseUrl = 'https://tmsapi.abm4trades.com';//tmsapi.abm4trades.com';
  late final Dio _dio;
  final Logger _logger = Logger();
  final CacheService _cacheService;
  final NetworkService _networkService;
  ApiService(this._cacheService, this._networkService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _setupInterceptors();
  }
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.d('Request: ${options.method} ${options.path}');
          _logger.d('Headers: ${options.headers}');
          _logger.d('Data: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            'Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          _logger.d('Data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('Error: ${error.message}');
          _logger.e('Response: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );
  }
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _checkNetworkConnection();
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  Future<Response<T>> getCached<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    Duration? cacheDuration,
    bool forceRefresh = false,
  }) async {
    final cacheKey = _generateCacheKey(path, queryParameters);
    if (!forceRefresh) {
      final cachedData = await _cacheService.getCachedResponse(cacheKey);
      if (cachedData != null) {
        _logger.d('Cache hit for: $path');
        return Response<T>(
          data: cachedData as T,
          statusCode: 200,
          requestOptions: RequestOptions(path: path),
        );
      }
    }
    await _checkNetworkConnection();
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      if (response.statusCode == 200 && response.data != null) {
        await _cacheService.cacheResponse(
          cacheKey,
          response.data as Map<String, dynamic>,
          duration: cacheDuration,
        );
        _logger.d('Cached response for: $path');
      }
      return response;
    } on DioException catch (e) {
      if (!forceRefresh) {
        final cachedData = await _cacheService.getCachedResponse(cacheKey);
        if (cachedData != null) {
          _logger.d('Network failed, using cached data for: $path');
          return Response<T>(
            data: cachedData as T,
            statusCode: 200,
            requestOptions: RequestOptions(path: path),
          );
        }
      }
      throw _handleError(e);
    }
  }
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _checkNetworkConnection();
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  Future<Response<T>> postCustomerLogin<T>(
    String fullUrl, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _checkNetworkConnection();
    try {
      final tempDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      tempDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            _logger.d('Request: ${options.method} ${options.path}');
            _logger.d('Headers: ${options.headers}');
            _logger.d('Data: ${options.data}');
            handler.next(options);
          },
          onResponse: (response, handler) {
            _logger.d(
              'Response: ${response.statusCode} ${response.requestOptions.path}',
            );
            _logger.d('Data: ${response.data}');
            handler.next(response);
          },
          onError: (error, handler) {
            _logger.e('Error: ${error.message}');
            _logger.e('Response: ${error.response?.data}');
            handler.next(error);
          },
        ),
      );
      return await tempDio.post<T>(
        fullUrl,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  Future<Response<T>> getFullUrl<T>(
    String fullUrl, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _checkNetworkConnection();
    try {
      final tempDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': '*/*',
            'Authorization': _dio.options.headers['Authorization'],
          },
        ),
      );
      tempDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            _logger.d('Request: ${options.method} ${options.path}');
            _logger.d('Headers: ${options.headers}');
            handler.next(options);
          },
          onResponse: (response, handler) {
            _logger.d(
              'Response: ${response.statusCode} ${response.requestOptions.path}',
            );
            _logger.d('Data: ${response.data}');
            handler.next(response);
          },
          onError: (error, handler) {
            _logger.e('Error: ${error.message}');
            _logger.e('Response: ${error.response?.data}');
            handler.next(error);
          },
        ),
      );
      return await tempDio.get<T>(
        fullUrl,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _checkNetworkConnection();
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _checkNetworkConnection();
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  Future<void> _checkNetworkConnection() async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      throw NetworkException(
        'No internet connection. Please check your network.',
        NetworkStatus.disconnected,
      );
    }
  }
  String _generateCacheKey(String path, Map<String, dynamic>? queryParameters) {
    final buffer = StringBuffer(path);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      buffer.write('?');
      final sortedKeys = queryParameters.keys.toList()..sort();
      for (int i = 0; i < sortedKeys.length; i++) {
        final key = sortedKeys[i];
        buffer.write('$key=${queryParameters[key]}');
        if (i < sortedKeys.length - 1) buffer.write('&');
      }
    }
    return buffer.toString();
  }
  Future<void> clearCache() async {
    await _cacheService.clearAllCache();
  }
  Future<void> clearCacheForPath(
    String path, [
    Map<String, dynamic>? queryParameters,
  ]) async {
    final cacheKey = _generateCacheKey(path, queryParameters);
    await _cacheService.clearCache(cacheKey);
  }
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: 408,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message =
            error.response?.data?['message'] ??
            error.response?.data?['error'] ??
            'An error occurred';
        return ApiException(message: message, statusCode: statusCode);
      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled', statusCode: 0);
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection. Please check your network.',
          statusCode: 0,
        );
      default:
        return ApiException(
          message: 'An unexpected error occurred',
          statusCode: 0,
        );
    }
  }
}
class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException({required this.message, required this.statusCode});
  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

