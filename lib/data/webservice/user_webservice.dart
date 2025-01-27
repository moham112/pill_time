import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pill_time/helper/dio_helper.dart';

class UserWebservice {
  final DioHelper dioHelper = DioHelper();

  Future<Response> updateUser(
      Map<String, dynamic> userData, id, File? profilePicutre) async {
    return await dioHelper.post(
      files: profilePicutre == null ? {} : {'profile_picture': profilePicutre},
      '/user/$id',
      data: userData,
      needAuthrization: true,
    );
  }
}
