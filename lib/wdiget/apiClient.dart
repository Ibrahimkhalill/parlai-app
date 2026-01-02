import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parlai/wdiget/appCredentilas.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;
  String? _token;
  bool _tokenLoaded = false;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: backendUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );
  }

  // ================= TOKEN =================

  Future<void> _ensureTokenLoaded() async {
    if (_tokenLoaded) return;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('access_token');
    _tokenLoaded = true;
  }

  Future<void> setToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    _token = token;
    _tokenLoaded = true;

    if (token == null) {
      await prefs.remove('access_token');
    } else {
      await prefs.setString('access_token', token);
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('access_token_valid_till');
    await prefs.remove('email_address');
    await prefs.remove('role');
    await prefs.remove('is_verified');
    await prefs.remove('profile');

    _token = null;
    _tokenLoaded = true;
    dio.options.headers.remove('Authorization');
  }

  // ================= INTERCEPTORS =================

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await _ensureTokenLoaded();

    if (_token != null && _token!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_token';
    }

    handler.next(options);
  }

  Future<void> _onError(DioException e, ErrorInterceptorHandler handler) async {
    if (e.response?.statusCode == 401) {
      await clearSession();

      handler.reject(
        DioException(
          requestOptions: e.requestOptions,
          message: "Session expired. Please login again.",
          type: DioExceptionType.badResponse,
        ),
      );
      return;
    }

    handler.reject(_handleDioError(e));
  }

  // ================= HTTP =================

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) => dio.get(endpoint, queryParameters: queryParameters);

  Future<Response> post(String endpoint, {dynamic data}) =>
      _sendRequest('POST', endpoint, data: data);

  Future<Response> put(String endpoint, {dynamic data}) =>
      _sendRequest('PUT', endpoint, data: data);

  Future<Response> delete(String endpoint, {Map<String, dynamic>? data}) =>
      dio.delete(endpoint, data: data);

  // ================= PRIVATE SEND REQUEST =================

  Future<Response> _sendRequest(
    String method,
    String endpoint, {
    dynamic data,
  }) async {
    Options options = Options();

    // If FormData, set multipart automatically
    if (data is FormData) {
      options.contentType = 'multipart/form-data';
    } else {
      options.contentType = 'application/json';
    }

    switch (method) {
      case 'POST':
        return dio.post(endpoint, data: data, options: options);
      case 'PUT':
        return dio.put(endpoint, data: data, options: options);
      default:
        throw UnsupportedError(
          'HTTP method $method not supported in _sendRequest',
        );
    }
  }

  // ================= ERROR HANDLING =================

  DioException _handleDioError(DioException e) {
    String message = "Something went wrong";

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      message = "Connection timeout. Please try again.";
    } else if (e.type == DioExceptionType.connectionError &&
        e.error is SocketException) {
      message = "No internet connection";
    } else if (e.response?.data != null) {
      message = _extractMessage(e.response!.data, e);
    }

    return DioException(
      requestOptions: e.requestOptions,
      message: message,
      type: e.type,
      response: e.response,
    );
  }

  String _extractMessage(dynamic data, DioException e) {
    try {
      if (data is Map<String, dynamic>) {
        if (data['message'] != null) return data['message'].toString();
        if (data['detail'] != null) return data['detail'].toString();

        if (data['details'] is Map &&
            data['details']['credentials'] is List &&
            data['details']['credentials'].isNotEmpty) {
          return data['details']['credentials'][0].toString();
        }
      }

      if (data is String && data.startsWith('{')) {
        return _extractMessage(jsonDecode(data), e);
      }
    } catch (_) {}

    if (e.type == DioExceptionType.connectionError &&
        e.error is SocketException) {
      return "No internet connection";
    }

    return "Something went wrong";
  }
}

// global instance
final apiClient = ApiClient();
