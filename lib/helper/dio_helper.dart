import 'package:dio/dio.dart';
import 'package:pill_time/helper/cache_helper.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:pill_time/helper/constants.dart';
import 'dart:io';

class DioHelper {
  static final DioHelper _instance = DioHelper._internal();
  final Dio dio;

  factory DioHelper() {
    return _instance;
  }

  DioHelper._internal()
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: Duration(seconds: 15),
          receiveTimeout: Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        )) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters,
      bool needAuthrization = false}) async {
    try {
      _addAuthorizationHeader(needAuthrization);
      return await dio.get(url, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String url,
      {Map<String, dynamic>? data,
      Map<String, File>? files,
      bool needAuthrization = false}) async {
    try {
      _addAuthorizationHeader(needAuthrization);

      FormData formData = FormData.fromMap(data ?? {});
      if (files != null && files.isNotEmpty) {
        files.forEach((key, file) async {
          String fileName = file.path.split('/').last;
          formData.files.add(MapEntry(
            key,
            await MultipartFile.fromFile(file.path, filename: fileName),
          ));
        });
      }

      return await dio.post(url, data: formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, File>? files,
    bool needAuthrization = false,
  }) async {
    try {
      _addAuthorizationHeader(needAuthrization);

      FormData formData = FormData.fromMap(data ?? {});
      if (files != null && files.isNotEmpty) {
        files.forEach((key, file) async {
          String fileName = file.path.split('/').last;
          formData.files.add(MapEntry(
            key,
            await MultipartFile.fromFile(file.path, filename: fileName),
          ));
        });
      }

      return await dio.put(url, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String url,
      {Map<String, dynamic>? data, bool needAuthrization = false}) async {
    try {
      _addAuthorizationHeader(needAuthrization);
      return await dio.delete(url, data: data);
    } catch (e) {
      rethrow;
    }
  }

  void _addAuthorizationHeader(bool needAuthorization) {
    final token = CacheHelper.getData('token');
    if (needAuthorization && token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio.options.headers.remove('Authorization');
    }
  }

  void addHeaders(Map<String, dynamic> headers) {
    dio.options.headers.addAll(headers);
  }
}
