import 'package:http/http.dart' as http;

import 'dart:async';

class Network {
  // HTTP GET
  static Future<String> get(String url,
      {Map<String, String> params, Map<String, String> headers}) async {
    if (params != null && params.isNotEmpty) {
      StringBuffer sb = new StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=" + "$value" + "&");
      });

      String param = sb.toString();
      url += param.substring(0, param.length - 1);
    }

    http.Response response = await http.get(url, headers: headers);
    return response.body;
  }
}
