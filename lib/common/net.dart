import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

class Query {
  static final Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:9090"));
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

  static Map<String, dynamic> getDelay(String target, String type) {
    return {target: 300};
  }

}
