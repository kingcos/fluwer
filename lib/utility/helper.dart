import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Helper {

  // Save string by key locally
  static Future<bool> saveString(String value, String key) async {
    var sp = await SharedPreferences.getInstance();

    return sp.setString(key, value);
  }

  // Get string by key
  static Future<String> getString(String key) async {
    var sp = await SharedPreferences.getInstance();

    return sp.getString(key);
  }

}