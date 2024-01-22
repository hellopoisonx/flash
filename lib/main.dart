import 'package:flutter/material.dart';
import './pages/groups.dart';
import './pages/home.dart';
import './pages/logs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const List<BottomNavigationBarItem> _naviItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups"),
    BottomNavigationBarItem(icon: Icon(Icons.bug_report), label: "Logs"),
  ];
  int _idx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: () {
        switch (_idx) {
          case 0:
            return const HomePage();
          case 1:
            return const GroupsPage();
          case 2:
            return const LogsPage();
          default:
            return null;
        }
      }(),
      bottomNavigationBar: BottomNavigationBar(
        items: _naviItems,
        currentIndex: _idx,
        onTap: (value) {
          setState(() {
            _idx = value;
          });
        },
      ),
    );
  }
}
