import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar(
      {super.key,
      // required this.height,
      required this.width,
      required this.items,
      this.backgroundColor = const Color.fromARGB(255, 245, 245, 245)});
  final double width;
  // final double height;
  final Color backgroundColor;
  final List<NavItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: height,
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
      this.padding,
      required this.onTap,
      required this.child,
      this.width,
      this.height,
      this.backgroundColor = const Color.fromARGB(255, 245, 245, 245)});
  final void Function() onTap;
  final Widget child;
  final double? width, height;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      padding: padding,
      child: InkWell(onTap: onTap, child: child),
    );
  }
}
