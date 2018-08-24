import 'dart:async';

import 'package:fluwer/utility/helper.dart';

class Jenkins {
  // APIs
  static const API_JSON_SUFFIX = "/api/json";
  static const API_JOB_DETAILS = "/job/";
  static const API_BUILD = "/build";

  // Keys
  static const String KEY_HOST = "JENKINS_KEY_HOST";
  static const String KEY_TOKEN = "JENKINS_KEY_TOKEN";

  // Constants
  static const String BUILD_PARAM_TYPE_STRING =
      "hudson.model.StringParameterDefinition";
  static const String BUILD_PARAM_TYPE_CHOICE =
      "hudson.model.ChoiceParameterDefinition";

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
