import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './log_extend.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:9090"));
  final _scrollController = ScrollController();
  List<Widget> logs = <ListTile>[const ListTile(leading: Text(""))];
  StreamSubscription<dynamic>? _streamSubscription;

  String logLevel = "info";
  int maxLines = 300;
  @override
  void initState() {
    super.initState();
    _streamSubscription = query().listen((_) {});
  }

  Stream<dynamic> query() {
    return Stream.periodic(const Duration(milliseconds: 2000), (_) async {
      if (logs.length > maxLines) {
        logs.clear();
      }
      try {
        final resp = await dio.get<ResponseBody>("/logs",
            queryParameters: {"level": logLevel},
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
          final newL = ListTile(
            leading: Text(obj["type"]),
            subtitle: Text(obj["payload"]),
          );
          if (logs.contains(newL)) {
            return;
          }
          logs.insert(0, newL);
          try {
            setState(() {});
          } catch (e) {
            print(e);
          }
        });
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<String?> showDialogLogLevel() {
    return showDialog<String>(
        context: context,
        builder: (ctx) {
          return const LogLevel();
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: query(),
        builder: (context, snapshot) {
          return Scaffold(
            floatingActionButton: ElevatedButton(
              onPressed: () async {
                final level = await showDialogLogLevel();
                if (level == null) {
                  return;
                } else {
                  logLevel = level;
                  setState(() {});
                }
              },
              child: Text(logLevel),
            ),
            body: ListView.builder(
                controller: _scrollController,
                itemCount: logs.length,
                itemBuilder: (ctx, idx) {
                  return logs[idx];
                }),
          );
        });
  }
}
