import 'package:flash/pages/connections.dart';
import 'package:flash/pages/home.dart';
import 'package:flash/pages/logs.dart';
import 'package:flash/pages/proxies.dart';
import 'package:flash/pages/settings.dart';
import 'package:flash/widgets/traffic.dart';
import 'package:flutter/material.dart';
import 'package:flash/widgets/nav.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key, required this.appBar});
  final AppBar appBar;
  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  late NavBar navBar;
  late final AppBar appBar;
  late final List<NavItem> items = [];
  late final List<Widget> _pages;
  final List<String> _itemsS = ["主页", "代理", "连接", "日志", "设置"];
  // late List<Color> itemsColor;
  int _idx = 0;
  @override
  void initState() {
    super.initState();
    appBar = widget.appBar;
    // itemsColor = [];
    _pages = [
      const Center(child: HomePage()),
      const Center(child: ProxiesPage()),
      const Center(child: ConnectionsPage()),
      const Center(child: LogsPage()),
      const Center(child: SettingsPage()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    items.clear();
    items.add(NavItem(
      onTap: () {},
      // width: 150,
      // height: 25,
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      child: const Traffic(),
    ));
    for (var i = 0; i < _itemsS.length; i++) {
      items.add(NavItem(
        onTap: () => i != _idx
            ? setState(() {
                _idx = i;
              })
            : null,
        width: 150,
        height: 35,
        backgroundColor: i == _idx
            ? const Color.fromARGB(255, 111, 136, 140)
            : const Color.fromARGB(255, 245, 245, 245),
        child: Text(
          _itemsS[i],
          textAlign: TextAlign.center,
        ),
      ));
    }
    navBar = NavBar(width: 150, items: items);
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: <Widget>[navBar, Expanded(child: _pages[_idx])],
      ),
    );
  }
}
