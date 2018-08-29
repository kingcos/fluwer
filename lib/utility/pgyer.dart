import 'dart:async';

import 'package:fluwer/utility/helper.dart';

class Pgyer {
  // APIs
  static const API_PREFIX = "https://www.pgyer.com/apiv2/app/";
  static const API_APP_ICON_PREFIX =
      "https://appicon.pgyer.com/image/view/app_icons/";
  static const API_APP_ALL_BUILDS = "builds";
  static const API_APP_DETAILS = "view";
  static const API_INSTALL_APP =
      "itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/";

  // Keys
  static const KEY_APP = "PGYER_KEY_APP";
  static const KEY_API = "PGYER_KEY_API";

  static Future<String> fetchAppKey() async {
    var appKey = await Helper.getString(KEY_APP);

    return appKey;
  }

  static Future<String> fetchAPIKey() async {
    var apiKey = await Helper.getString(KEY_API);

    return apiKey;
  }
}
