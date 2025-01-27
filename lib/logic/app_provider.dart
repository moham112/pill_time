import 'package:flutter/material.dart';
import 'package:pill_time/helper/cache_helper.dart';

class AppProvider extends ChangeNotifier {
  // Constants of available language

  // Change localization language
  void changeLanguage(String langCode, BuildContext context) {
    CacheHelper.setData("lang", langCode);
  }
}
