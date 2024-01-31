import 'dart:async';
import 'package:dio/dio.dart';

class Query {
  static final Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:9090"));
  static String delayUrl = "https://www.gstatic.com/generate_204";
  static Future<Map<String, dynamic>?> getProxies() async {
    Map<String, dynamic> resp = {};
    try {
      var res = await dio.get("/proxies");
      resp = Map<String, dynamic>.from(res.data);
    } catch (e) {
      print(e);
      return null;
    }
    return resp;
  }

  static Future<Map<String, int>?> getDelay(String target, String type) async {
    final Response resp;
    try {
      resp = await dio.get("/$type/$target/delay",
          queryParameters: {"url": delayUrl, "timeout": 2000});
      return Map<String, int>.from(resp.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> toggleProxy(String selector, String target) async {
    try {
      await dio.put("/proxies/$selector", data: "{\"name\":\"$target\"}");
    } catch (e) {
      print(e);
    }
  }
}
