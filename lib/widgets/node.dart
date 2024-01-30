import 'package:flutter/material.dart';

class NodeButton extends StatelessWidget {
  const NodeButton(
      {super.key,
      required this.name,
      required this.delay,
      required this.backgroudColor,
      required this.type,
      required this.udp,
      required this.borderColor,
      required this.onTap});
  final String name;
  final int delay;
  final Color backgroudColor;
  final String type;
  final bool udp;
  final Color borderColor;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: backgroudColor,
            border: Border(left: BorderSide(color: borderColor, width: 5)),
            shape: BoxShape.rectangle),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                //node name
                name,
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ), // const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
            const Spacer(),
            Row(
              children: <Widget>[
                Text(
                  "$type | ",
                  style: const TextStyle(color: Colors.grey,fontSize: 9),
                ),
                () {
                  return udp
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          child: const Text(
                            "UDP",
                            style: TextStyle(fontSize: 9),
                          ),
                        )
                      : const Text("*");
                }(),
                // const Padding(padding: EdgeInsets.only(left: 5, right: 10)),
                const Spacer(),
                Text(
                  delay.toString(),
                  style: TextStyle(
                      color: delay > 400 ? Colors.orange : Colors.green),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
