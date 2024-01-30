import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './log_extend.dart';
import '../common/net.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  StreamController<Widget> logsController = StreamController<Widget>();
  List<Widget> logs = <ListTile>[const ListTile(leading: Text(""))];

  String logLevel = "info";
  int maxLines = 300;
  @override
  void initState() {
    super.initState();
    startGettingLogs();
  }

  Future<void> startGettingLogs() async {
    try {
      await for (var log in getLogsStream()) {
        logsController.add(log);
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<Widget> getLogsStream() async* {
    try {
      final resp = await Query.dio.get("/logs",
          queryParameters: {"level": logLevel},
          options: Options(responseType: ResponseType.stream));
      int count = 0;
      await for (List<int> chunk in resp.data.stream) {
        count++;
        final log = utf8.decode(chunk);
        final logObj = json.decode(log);
        yield ListTile(
          leading: Text(count.toString()),
          title: Text(logObj["type"]),
          subtitle: Text(logObj["payload"]),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        child: Text(logLevel),
        onPressed: () async {
          logLevel = (await showDialogLogLevel())!;
          setState(() {});
        },
      ),
      body: StreamBuilder<Widget>(
          stream: logsController.stream,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              logs.insert(0, snapshot.data!);
              return ListView.builder(
                shrinkWrap: true,
                itemCount: logs.length,
                itemBuilder: (ctx, idx) {
                  return logs[idx];
                },
              );
            } else if (snapshot.hasError) {
              return Text("Woops ${snapshot.error}");
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  @override
  void dispose() {
    logsController.close();
    super.dispose();
  }

  Future<String?> showDialogLogLevel() {
    return showDialog<String>(
        context: context,
        builder: (ctx) {
          return const LogLevel();
        });
  }
}
