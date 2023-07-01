import 'package:box_cricket/network/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioSingleton {
  static final DioSingleton _shared = DioSingleton._internal();
  Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(
        milliseconds: 60000,
      ),
      receiveTimeout: const Duration(
        milliseconds: 60000,
      ),
      receiveDataWhenStatusError: true,
    ),
  );

  factory DioSingleton() {
    return _shared;
  }

  DioSingleton._internal();

  Future<Response> get({
    String? baseUrl,
    required String endPoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    baseUrl ??= BaseUrl.baseUrl;
    return await dio.get(
      baseUrl + endPoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        receiveTimeout: const Duration(milliseconds: 5000),
      ),
    );
  }

  dynamic requestInterceptor(RequestOptions options) async {
    if (options.headers.containsKey("requiresToken")) {
      //remove the auxiliary header
      options.headers.remove("requiresToken");

      return options;
    }
  }

  Future<Response> post({
    String? baseUrl,
    required String endPoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: ((options, handler) {
        // options.headers.addAll({
        //   "Accept": "*/*",
        //   "Accept-Encoding": 'gzip, deflate, br',
        //   "Connection": "keep-alive",
        // });
        debugPrint("Request: ${options.uri}");
        debugPrint("Headers: ${options.headers}");
        debugPrint("QueryParameters: ${options.queryParameters}");
        debugPrint(
            "Body: ${options.data} ${options.data is FormData ? "${(options.data as FormData).fields}" : ""}");
        handler.next(options);
      }), onResponse: ((response, handler) {
        debugPrint("Response --------------------->\n${response.data}");
        handler.next(response);
      }), onError: ((exception, handler) {
        debugPrint("Error ------------> ${exception.message} ${exception.stackTrace} ${exception.response} ${exception.error} ${exception.type}");
        handler.next(exception);
      })),
    );
    baseUrl ??= BaseUrl.baseUrl;
    return await dio.post(
      baseUrl + endPoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        // sendTimeout: const Duration(milliseconds: 5000),
        headers: headers,
        // receiveTimeout: const Duration(milliseconds: 5000),
      ),
    );
  }

  Future<Response> put({
    String? baseUrl,
    required String endPoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    baseUrl ??= BaseUrl.baseUrl;
    return await dio.put(
      baseUrl + endPoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
      ),
    );
  }
}
