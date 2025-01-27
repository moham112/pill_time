  import 'package:shared_preferences/shared_preferences.dart';

  class CacheHelper {
    static SharedPreferences? _preferences;

    static Future<void> init() async {
      _preferences = await SharedPreferences.getInstance();
    }

    static Future<bool> setData(String key, dynamic value) async {
      if (value is String) return await _preferences!.setString(key, value);
      if (value is int) return await _preferences!.setInt(key, value);
      if (value is bool) return await _preferences!.setBool(key, value);
      if (value is double) return await _preferences!.setDouble(key, value);
      if (value is List<String>) return await _preferences!.setStringList(key, value);
      return false;
    }

    static dynamic getData(String key) {
      return _preferences!.get(key);
    }

    static Future<bool> removeData(String key) async {
      return await _preferences!.remove(key);
    }

    static Future<bool> clearData() async {
      return await _preferences!.clear();
    }
  }
