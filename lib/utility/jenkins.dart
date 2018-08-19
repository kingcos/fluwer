import 'package:fluwer/utility/helper.dart';

import 'dart:async';

class Jenkins {
  // APIs
  static const API_Jobs = "/api/json";

  // Keys
  static const String KEY_HOST = "JENKINS_KEY_HOST";
  static const String KEY_TOKEN = "JENKINS_KEY_TOKEN";

  static Future<String> fetchAPIHost() async {
    var host = await Helper.getString(KEY_HOST);

    return host;
  }

  static Future<Map<String, String>> fetchRequestHeader() async {
    var header = new Map<String, String>();

    header["Authorization"] = await Helper.getString(KEY_TOKEN);

    return header;
  }
}
