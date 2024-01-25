import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Traffic extends StatefulWidget {
  const Traffic({super.key});

  @override
  State<Traffic> createState() => _TrafficState();
}

class _TrafficState extends State<Traffic> {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:9090"));
  Map<String, int> traffic = {};
  Stream<dynamic> query() {
    return Stream.periodic(const Duration(milliseconds: 1000), (_) async {
      final resp = await dio.get<ResponseBody>("/traffic",
          options: Options(responseType: ResponseType.stream));
      StreamTransformer<Uint8List, List<int>> uint8Transformer =
          StreamTransformer.fromHandlers(handleData: (data, sink) {
        sink.add(List<int>.from(data));
      });
      resp.data?.stream
          .transform(uint8Transformer)
          .transform(const Utf8Decoder())
          .listen((event) {
        final obj = jsonDecode(event);
        traffic.addAll(Map<String, int>.from(obj));
        setState(() {});
      });
    });
  }

  Map<String, String> parseTraffic(double up, double down) {
    int count = 0;
    String upS;
    String downS;
    while (up >= 1024) {
      up /= 1024;
      count++;
    }
    upS = up.toStringAsFixed(2);
    switch (count) {
      case 0:
        upS = "${upS}Byte/s";
        break;
      case 1:
        upS = "${upS}KB/s";
        break;
      case 2:
        upS = "${upS}MB/s";
        break;
      case 3:
        upS = "${upS}TB/s";
        break;
    }
    count = 0;
    while (down >= 1024) {
      down /= 1024;
      count++;
    }
    downS = down.toStringAsFixed(2);
    switch (count) {
      case 0:
        downS = "${downS}Byte/s";
        break;
      case 1:
        downS = "${downS}KB/s";
        break;
      case 2:
        downS = "${downS}MB/s";
        break;
      case 3:
        downS = "${downS}TB/s";
        break;
    }
    return {"up": upS, "down": downS};
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: query(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            default:
              if (traffic.isEmpty) {
                return const CircularProgressIndicator();
              }
              final t = parseTraffic(
                  traffic['up']!.toDouble(), traffic['down']!.toDouble());
              return Column(
                children: [Text("Up: ${t["up"]}"), Text("Down: ${t["down"]}")],
              );
          }
        }));
  }
}
