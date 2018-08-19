import 'dart:async';

import 'package:fluwer/utility/helper.dart';

class GitLab {
  // APIs
  static const API_PREFIX = "/api/v4";
  static const API_PROJECTS = "/projects/";
  static const API_REPO_BRANCHES = "/repository/branches";

  // Keys
  static const KEY_HOST = "GITLAB_KEY_HOST";
  static const KEY_TOKEN = "GITLAB_KEY_TOKEN";
  static const KEY_PROJECT_ID = "KEY_PROJECT_ID";

  static Future<String> fetchRepoID() async {
    var repoID = await Helper.getString(KEY_PROJECT_ID);

    return repoID;
  }

  static Future<String> fetchAPIHost() async {
    var host = await Helper.getString(KEY_HOST);

    return host;
  }

  static Future<Map<String, String>> fetchRequestHeader() async {
    var header = new Map<String, String>();

    header["PRIVATE-TOKEN"] = await Helper.getString(KEY_TOKEN);

    return header;
  }
}
