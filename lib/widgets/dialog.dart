import 'package:flutter/material.dart';

class InputDialog extends StatelessWidget {
  const InputDialog({super.key, required this.title, required this.items});
  final String title;
  final Map<String, String?> items;
  @override
  Widget build(BuildContext context) {
    Map<String, String?> res = {};
    res.addEntries(items.entries);
    return AlertDialog(
      // padding: const EdgeInsets.all(8),
      content: Column(
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          () {
            List<Widget> children = [];
            items.forEach((item, def) => children.add(TextField(
                decoration:
                    InputDecoration(labelText: item, hintText: def?.toString()),
                onChanged: (v) => res.addAll({item: v}))));
            return Column(
              children: children,
            );
          }(),
          IconButton(
              onPressed: () => Navigator.pop(context, res),
              icon: const Icon(Icons.check_circle))
        ],
      ),
    );
  }
}
