import 'dart:async';

import 'package:fluwer/utility/helper.dart';

class Jira {
  // APIs
  static const API_PREFIX = "/rest/api/2";
  static const API_FILTER = "/filter/";

  // Keys
  static const KEY_HOST = "JIRA_KEY_HOST";
  static const KEY_TOKEN = "JIRA_KEY_TOKEN";
  static const KEY_FILTER_ID = "JIRA_KEY_FILTER_ID";

  static Future<String> fetchAPIHost() async {
    var host = await Helper.getString(KEY_HOST);

    return host;
  }

  static Future<Map<String, String>> fetchRequestHeader() async {
    var header = new Map<String, String>();

    header["Authorization"] = await Helper.getString(KEY_TOKEN);
    return header;
  }

  static Future<String> fetchFilterID() async {
    var id = await Helper.getString(KEY_FILTER_ID);

    return id;
  }
}
