import 'package:flutter/material.dart';

class LogLevel extends StatefulWidget {
  const LogLevel({super.key});

  @override
  State<LogLevel> createState() => _LogLevelState();
}

class _LogLevelState extends State<LogLevel> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("LogLevel"),
      children: ["info", "warning", "debug", "error"].map((e) {
        return buildDialogOption(e, e);
      }).toList(),
    );
  }

  Widget buildDialogOption(String popVal, String text) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, popVal);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(text),
      ),
    );
  }
}
