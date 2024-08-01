import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:xml/xml.dart';
import '../../common/common.dart';
import '../../core/core.dart';

class DioClient {
  DioClient._();

  final Dio _dio = Dio(
    BaseOptions(
      validateStatus: (_) => true,
    ),
  );

  static final DioClient _instance = DioClient._();

  factory DioClient({
    Logger? logger,
    SharedPrefClient? sharedPrefClient,
  }) {
    if (logger != null) {
      _instance._dio.interceptors.add(
        LoggingInterceptor(
          logger: logger,
        ),
      );
    }
    return _instance;
  }

  final SecureStorageClient _secureStorageClient = SecureStorageClient.instance;

  bool isSuccess(int? statusCode) => statusCode == 200 || statusCode == 201;
  Future<String?> _getToken() async {
    return await _secureStorageClient.getByKey(
      SharedPrefKey.accessToken,
    );
  }

  /// get
  Future<Response> get({
    required String url,
    String? token,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    ResponseType responseType = ResponseType.json,
    bool dynamicUrl = false,
  }) async {
    headers ??= {};

    token ??= await _getToken();
    if (token != null) headers['Authorization'] = 'Bearer $token';
    //headers add allow origin
    headers['Access-Control-Allow-Origin'] = '*';

    try {
      final Response response = await _dio.get(
        dynamicUrl ? url : UrlConstant.baseUrl + url,
        options: Options(
          headers: headers,
          contentType: 'application/json',
          responseType: responseType,
        ),
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// post
  Future<Response> post({
    required String url,
    dynamic data,
    String? token,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    bool dynamicUrl = false,
  }) async {
    headers ??= {};

    token ??= await _getToken();
    if (token != null) headers['Authorization'] = 'Bearer $token';
    try {
      final Response response = await _dio.post(
        dynamicUrl ? url : UrlConstant.baseUrl + url,
        data: data,
        options: Options(
          headers: headers,
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// post
  Future<Response> login({
    required String url,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    bool dynamicUrl = false,
  }) async {
    headers ??= {};

    try {
      final Response response = await _dio.post(
        dynamicUrl ? url : UrlConstant.baseUrl + url,
        data: data,
        options: Options(
          headers: headers,
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// patch
  Future<Response> patch({
    required String url,
    dynamic data,
    String? token,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    bool dynamicUrl = false,
  }) async {
    headers ??= {};

    token ??= await _getToken();
    if (token != null) headers['Authorization'] = 'Bearer $token';
    try {
      final Response response = await _dio.patch(
        dynamicUrl ? url : UrlConstant.baseUrl + url,
        data: data,
        options: Options(
          headers: headers,
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// put
  Future<Response> put({
    required String url,
    dynamic data,
    String? token,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    bool dynamicUrl = false,
  }) async {
    headers ??= {};

    token ??= await _getToken();
    if (token != null) headers['Authorization'] = 'Bearer $token';
    try {
      final Response response = await _dio.put(
        dynamicUrl ? url : UrlConstant.baseUrl + url,
        data: data,
        options: Options(
          headers: headers,
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// delete
  Future<Response> delete({
    required String url,
    dynamic data,
    String? token,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    bool dynamicUrl = false,
  }) async {
    headers ??= {};

    token ??= await _getToken();
    if (token != null) headers['Authorization'] = 'Bearer $token';
    try {
      final Response response = await _dio.delete(
        dynamicUrl ? url : UrlConstant.baseUrl + url,
        data: data,
        options: Options(
          headers: headers,
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// refresh token
  Future<Response> refreshToken({
    required String email,
    required String password,
  }) async {
    try {
      final Response response = await _dio.post(
        UrlConstant.baseUrl + UrlConstant.login,
        data: {
          'email': email,
          'password': password,
          'mode': 'json',
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}

class LoggingInterceptor extends Interceptor {
  final Logger logger;

  LoggingInterceptor({
    required this.logger,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      // Log request details
      logger.d(
        "Request: ${options.method} ${options.path}\nHeaders: ${options.headers}\nQuery Parameters: ${options.queryParameters}\nBody: ${options.data}",
      );
    }
    // Continue with request
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (kDebugMode) {
      // Log response details
      logger.d("Response: ${response.requestOptions.path}\nStatus Code: ${response.statusCode}\nData: ${isXmlString(response.data) ? 'XML' : response.data}");
      // if (response.statusCode == 401 && response.data['errors'][0]['extensions']['code'] == 'TOKEN_EXPIRED') {
      //   SharedPrefClient sharedPrefClient = SharedPrefClient.instance;
      //   DioClient dioClient = DioClient._instance;
      //   String email = await sharedPrefClient.getByKey(
      //         key: SharedPrefKey.authEmail,
      //       ) ??
      //       '';
      //   String password = await sharedPrefClient.getByKey(
      //         key: SharedPrefKey.authPassword,
      //       ) ??
      //       '';
      //   Response responseRefreshToken = await dioClient.refreshToken(email: email, password: password);

      //   if (responseRefreshToken.statusCode == 200) {
      //     String accessToken = responseRefreshToken.data['data']['access_token'];

      //     // save access token to local storage
      //     await sharedPrefClient.saveKey(
      //       key: SharedPrefKey.accessToken,
      //       data: accessToken,
      //     );

      //     final clonedRequest = await dioClient._dio.request(
      //       response.requestOptions.path,
      //       options: Options(
      //         headers: {
      //           'Authorization': 'Bearer $accessToken',
      //         },
      //         contentType: 'application/json',
      //         responseType: ResponseType.json,
      //       ),
      //       data: response.requestOptions.data,
      //       queryParameters: response.requestOptions.queryParameters,
      //     );

      //     return handler.resolve(clonedRequest);
      //   }
      // }
    }
    // Continue with response
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      // Log error details
      logger.e("Error: ${err.type} ${err.message}");
    }
    // Continue with error handling
    super.onError(err, handler);
  }

  bool isXmlString(dynamic input) {
    if (input.runtimeType == String) {
      try {
        XmlDocument.parse(input);
        return true;
      } on XmlException {
        return false;
      }
    }
    return false;
  }
}
