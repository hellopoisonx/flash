import 'package:flash/pages/skeleton.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Skeleton(
      appBar: AppBar(title: const Text("Flash")),
    ));
  }
}
