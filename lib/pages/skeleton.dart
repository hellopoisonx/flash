import 'package:flash/pages/connections.dart';
import 'package:flash/pages/home.dart';
import 'package:flash/pages/logs.dart';
import 'package:flash/pages/proxies.dart';
import 'package:flash/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flash/widgets/nav.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key, required this.appBar});
  final AppBar appBar;
  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  late final NavBar navBar;
  late final AppBar appBar;
  late final List<NavItem> items = [];
  late final List<Widget> _pages;
  int _idx = 0;
  @override
  void initState() {
    super.initState();
    appBar = widget.appBar;
    _pages = [
      const Center(child: HomePage()),
      const Center(child: ProxiesPage()),
      const Center(child: ConnectionsPage()),
      const Center(child: LogsPage()),
      const Center(child: SettingsPage()),
    ];
    final List<String> itemsS = [
      "Home",
      "Proxies",
      "Connections",
      "Logs",
      "Settings"
    ];
    for (var i = 0; i < itemsS.length; i++) {
      items.add(NavItem(
        onTap: () => i != _idx
            ? setState(() {
                _idx = i;
              })
            : null,
        widthFactor: 0.9,
        heightFactor: 0.2,
        padding: const EdgeInsets.all(5),
        child: Text(itemsS[i]),
      ));
    }
    navBar = NavBar(height: 800, width: 100, items: items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: <Widget>[navBar, Expanded(child: _pages[_idx])],
      ),
    );
  }
}
