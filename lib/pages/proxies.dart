import 'package:flash/common/net.dart';
import 'package:flash/widgets/node.dart';
import 'package:flutter/material.dart';

class ProxiesPage extends StatefulWidget {
  const ProxiesPage({super.key});

  @override
  State<ProxiesPage> createState() => _ProxiesPageState();
}

class _ProxiesPageState extends State<ProxiesPage> {
  Widget? pageCache;
  Map<String, dynamic>? proxies;
  Future<List<Map<String, dynamic>>?> _gp() async {
    proxies = await Query.getProxies();
    if (proxies == null || proxies!.isEmpty) {
      return null;
    }
    List<Map<String, dynamic>> selectors = [];
    proxies!.forEach((_, node) => proxies = node);
    proxies?.forEach((_, node) {
      if (node["type"] == "Selector") {
        selectors.add(node);
      }
    });
    selectors.sort((a, b) => b["name"].compareTo(a["name"]));
    return selectors;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
        future: _gp(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return (pageCache == null)
                ? const CircularProgressIndicator()
                : pageCache!;
          } else if (snapshot.hasError) {
            return const Text("Woops");
          } else if (snapshot.connectionState == ConnectionState.done) {
            final selectors = snapshot.data;
            if ((selectors == null || selectors.isEmpty)) {
              return const Text("Woops");
            }
            pageCache = ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: selectors.length,
                itemBuilder: (ctx, idx) {
                  final selector = selectors[idx];
                  // return ListTile(
                  //   title: Text(
                  //     selector["name"],
                  //     textAlign: TextAlign.left,
                  //     style: const TextStyle(fontSize: 18),
                  //   ),
                  //   subtitle: Text(
                  //     selector["now"],
                  //     style: const TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // );
                  return ExpansionTile(
                    title: Text(
                      "${selector["name"]} | ${selector["now"]}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 18),
                    ),
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 5),
                        itemCount: selector["all"].length,
                        itemBuilder: (context, subIndex) {
                          String key = selector["all"][subIndex];
                          dynamic node = proxies?[key];
                          return NodeButton(
                              name: node["name"],
                              delay: 500,
                              backgroudColor:
                                  const Color.fromARGB(255, 245, 245, 245),
                              type: node["type"],
                              udp: node["udp"],
                              borderColor: node["name"] == selector["now"]
                                  ? Colors.green
                                  : Colors.grey,
                              onTap: () => setState(() {}));
                        },
                      ),
                    ],
                  );
                });
            return pageCache!;
          } else {
            return const Text("Woops");
          }
        });
  }
}
