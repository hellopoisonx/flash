import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar(
      {super.key,
      required this.height,
      required this.width,
      required this.items,
      this.backgroundColor = Colors.grey});
  final double width;
  final double height;
  final Color backgroundColor;
  final List<NavItem> items;
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late final double width;
  late final double height;
  late final Color backgroundColor;
  late final List<NavItem> items;
  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
    backgroundColor = widget.backgroundColor;
    items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          // border: const Border(),
          color: backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items,
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem(
      {super.key,
      required this.onTap,
      required this.child,
      required this.widthFactor,
      required this.heightFactor,
      required this.padding});
  final void Function() onTap;
  final Widget child;
  final double widthFactor, heightFactor;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: Container(
          padding: padding,
          child: Center(child: child),
        ),
      ),
    ));
  }
}
