import 'package:fluwer/utility/helper.dart';

import 'dart:async';

class Jenkins {
  // APIs
  static const API_Host = "http://YOUR_JENKINS_HOST";
  static const API_Jobs = "/api/json";

  // Keys
  static const String KEY_TOKEN = "KEY_JENKINS_TOKEN";

  static Future<Map<String, String>> requestHeader() async {
    var header = new Map<String, String>();
    header["Authorization"] = await Helper.getString(KEY_TOKEN);
    return header;
  }
}
