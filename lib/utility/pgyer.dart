import 'dart:async';

import 'package:fluwer/utility/helper.dart';

class Pgyer {
  // APIs
  static const API_PREFIX = "https://www.pgyer.com/apiv2/app/";
  static const API_APP_ICON_PREFIX =
      "https://appicon.pgyer.com/image/view/app_icons/";
  static const API_APP_ALL_BUILDS = "builds";

  // Keys
  static const KEY_APP = "PGYER_KEY_APP";
  static const KEY_API = "PGYER_KEY_API";

  static Future<String> fetchAppKey() async {
    var host = await Helper.getString(KEY_APP);

    return host;
  }

  static Future<String> fetchAPIKey() async {
    var host = await Helper.getString(KEY_API);

    return host;
  }
}
