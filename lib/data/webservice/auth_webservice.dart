import 'dart:io';

import 'package:pill_time/helper/dio_helper.dart';
import 'package:dio/dio.dart';

class AuthWebService {
  final DioHelper dioHelper = DioHelper();

  Future<Response> login(Map<String, dynamic> params) async {
    return await dioHelper.post(
      '/login',
      data: params,
    );
  }

  Future<Response> register(
      Map<String, dynamic> params, File profilePicures) async {
    return await dioHelper.post(
      '/register',
      data: params,
      files: {
        'profile_picture': profilePicures,
      },
    );
  }

  Future<Response> logout() async {
    return await dioHelper.post(
      '/logout',
      needAuthrization: true,
    );
  }
}
