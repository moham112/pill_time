import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pill_time/data/model/auth_response.dart';
import 'package:pill_time/data/model/user.dart';
import 'package:pill_time/data/webservice/auth_webservice.dart';
import 'package:pill_time/data/webservice/user_webservice.dart';
import 'package:pill_time/helper/cache_helper.dart';
import 'package:pill_time/helper/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthProvider extends ChangeNotifier {
  AuthWebService? _authWebService;
  UserWebservice? _userWebservice;

  String? _token;
  bool _isAuthenticated = false;
  // ignore: non_constant_identifier_names
  String? _FCMToken;

  String? get token => _token;
  // ignore: non_constant_identifier_names
  String? get FCMToken => _FCMToken;
  late User user;

  bool isAuthenticated() {
    if (_isAuthenticated) {
      user = User.fromJson({
        'id': int.parse(CacheHelper.getData('user_id')),
        'email': CacheHelper.getData('user_email'),
        'first_name': CacheHelper.getData('user_first_name'),
        'last_name': CacheHelper.getData('user_last_name'),
        'profile_picture': CacheHelper.getData('user_profile_picture'),
        'birth_date': CacheHelper.getData('user_birthdate'),
        'timezone': CacheHelper.getData('timezone'),
      });
    }
    return _isAuthenticated;
  }

  AuthProvider(
      {required AuthWebService authWebService,
      required UserWebservice userWebservice}) {
    _authWebService = authWebService;
    _userWebservice = userWebservice;
    _checkToken();
  }

  Future<AuthResponse> login(Map<String, dynamic> data) async {
    final responaseData = await _authWebService!.login(data);
    final authResponse = AuthResponse.fromJson(responaseData.data);
    _cacheUserAll(authResponse);
    return authResponse;
  }

  Future<void> register(Map<String, dynamic> data, File profilePicutre) async {
    final value = await _authWebService!.register(data, profilePicutre);
    final responseData = AuthResponse.fromJson(value.data);
    _cacheUserAll(responseData);
  }

  Future<void> logout() async {
    await _authWebService!.logout();
    _uncacheUserAll();
  }

  Future<void> getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    _FCMToken = await messaging.getToken();
  }

  Future<void> updateUserData(
    Map<String, dynamic> userData,
    String id, {
    File? profilePicture,
  }) async {
    final value =
        await _userWebservice!.updateUser(userData, id, profilePicture);
    final responseData = User.fromJson(value.data);
    _cacheUserData(responseData);
    updateUser();
  }

  void _cacheUserAll(AuthResponse authResponse) {
    _cacheAuth(authResponse);
    _cacheUserData(authResponse.user);
  }

  void _uncacheUserAll() {
    _uncacheAuth();
    _uncacheUserData();
  }

  void _cacheAuth(AuthResponse authResponse) {
    CacheHelper.setData('token', authResponse.accessToken);
    _token = authResponse.accessToken;
    _isAuthenticated = true;
  }

  void _uncacheAuth() {
    CacheHelper.removeData('token');
    _token = null;
    _isAuthenticated = false;
  }

  void _cacheUserData(User user) {
    CacheHelper.setData('user_email', user.email);
    CacheHelper.setData('user_first_name', user.firstName);
    CacheHelper.setData('user_last_name', user.lastName);
    CacheHelper.setData(
        'user_profile_picture', '$userProfileUrl${user.profilePicture}');
    CacheHelper.setData('user_birthdate', user.birthDate);
    CacheHelper.setData('user_id', user.id.toString());
    CacheHelper.setData('timezone', user.timezone);
  }

  void _uncacheUserData() {
    //Remove User Data from Shared Preferences
    CacheHelper.removeData('user_email');
    CacheHelper.removeData('user_first_name');
    CacheHelper.removeData('user_last_name');
    CacheHelper.removeData('user_profile_picture');
    CacheHelper.removeData('user_birthdate');
    CacheHelper.removeData('user_id');
    CacheHelper.removeData('timezone');
  }

  Future<void> _checkToken() async {
    _token = CacheHelper.getData('token');
    _isAuthenticated = _token != null;
    notifyListeners();
  }

  void updateUser() {
    user = User.fromJson({
      'id': int.parse(CacheHelper.getData('user_id')),
      'email': CacheHelper.getData('user_email'),
      'first_name': CacheHelper.getData('user_first_name'),
      'last_name': CacheHelper.getData('user_last_name'),
      'profile_picture': CacheHelper.getData('user_profile_picture'),
      'birth_date': CacheHelper.getData('user_birthdate'),
      'timezone': CacheHelper.getData('timezone'),
    });
    notifyListeners();
  }
}
