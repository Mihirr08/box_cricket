import 'package:box_cricket/network/base_url.dart';
import 'package:dio/dio.dart';

class DioSingleton {
  static final DioSingleton _shared = DioSingleton._internal();
  Dio dio = Dio();

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
      options: Options(headers: headers),
    );
  }

  Future<Response> post({
    String? baseUrl,
    required String endPoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    baseUrl ??= BaseUrl.baseUrl;
    return await dio.post(
      baseUrl + endPoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
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
