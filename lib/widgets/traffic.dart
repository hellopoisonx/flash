import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../common/net.dart';

class Traffic extends StatefulWidget {
  const Traffic({super.key});

  @override
  State<Traffic> createState() => _TrafficState();
}

class _TrafficState extends State<Traffic> {
  var trafficStreamController = StreamController<Widget>();
  @override
  void initState() {
    super.initState();
    startGettingTraffic();
  }

  Future<void> startGettingTraffic() async {
    try {
      await for (var t in getTraffic()) {
        trafficStreamController.add(t);
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<Widget> getTraffic() async* {
    try {
      final resp = await Query.dio
          .get("/traffic", options: Options(responseType: ResponseType.stream));
      await for (List<int> chunk in resp.data.stream) {
        final traffic = json.decode(utf8.decode(chunk));
        final trafficP =
            parseTraffic(traffic["up"].toDouble(), traffic["down"].toDouble());
        yield Center(
          child: Column(
            children: [
              SizedBox(
                child: Text(
                  "↑ ${trafficP["up"]?.trim()}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(
                child: Text("↓ ${trafficP["down"]?.trim()}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
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
        stream: trafficStreamController.stream,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Woops ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }

  @override
  void dispose() {
    super.dispose();
    trafficStreamController.close();
  }
}
