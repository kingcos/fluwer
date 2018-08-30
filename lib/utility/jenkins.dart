import 'dart:async';

import 'package:fluwer/utility/helper.dart';

class Jenkins {
  // APIs
  static const API_JSON_SUFFIX = "/api/json";
  static const API_JOB = "/job/";
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

  static Map<String, String> buildRequestBody(
      {List<String> keys, List<String> values}) {
    assert(keys.length == values.length);

    var body = new Map<String, String>();
    body['json'] = '{\"parameter\":[';

    for (var i = 0; i < keys.length; i += 1) {
      body['json'] += '{\"name\":\"${keys[i]}\",\"value\":\"${values[i]}\"},';
    }

    body['json'] += ']}}';
    
    return body;
  }
}
