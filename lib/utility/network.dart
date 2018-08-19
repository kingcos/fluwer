import 'dart:async';

import 'package:http/http.dart' as http;

class Network {
  // HTTP GET
  static Future<String> get(
      {String url,
      Map<String, String> params,
      Map<String, String> headers}) async {
    if (params != null && params.isNotEmpty) {
      var sb = new StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=" + "$value" + "&");
      });

      var param = sb.toString();
      url += param.substring(0, param.length - 1);
    }

    http.Response response = await http.get(url, headers: headers);
    return response.body;
  }

  // HTTP POST
  static Future<String> post(
      {String url,
      Map<String, String> headers,
      Map<String, String> body}) async {
    var response = await http.post(url, headers: headers, body: body);

    return response.body;
  }
}
