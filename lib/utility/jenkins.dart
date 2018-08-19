import 'dart:async';

import 'package:fluwer/utility/helper.dart';

class Jenkins {
  // APIs
  static const API_SUFFIX = "/api/json";

  // Keys
  static const String KEY_HOST = "JENKINS_KEY_HOST";
  static const String KEY_TOKEN = "JENKINS_KEY_TOKEN";

  static Future<String> fetchAPIHost() async {
    var host = await Helper.getString(KEY_HOST);

    host = "http://172.17.30.245:8080";
    return host;
  }

  static Future<Map<String, String>> fetchRequestHeader() async {
    var header = new Map<String, String>();

    header["Authorization"] = await Helper.getString(KEY_TOKEN);

    header["Authorization"] = "Basic bWFpbWluZzpiZXRwYWctd3Vxa2UwLWtlZ0Jvcg==";
    return header;
  }
}
