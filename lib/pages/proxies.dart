import 'package:flash/common/net.dart';
import 'package:flash/widgets/dialog.dart';
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
  Map<String, int> delays = {};
  Future<List<Map<String, dynamic>>?> _getProxies() async {
    proxies = await Query.getProxies();
    if (proxies == null || proxies!.isEmpty) {
      return null;
    }
    List<Map<String, dynamic>> selectors = [];
    proxies!.forEach((_, node) => proxies = node);
    proxies?.forEach((_, node) {
      node.addAll({"delay": delays[node["name"]]});
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
        future: _getProxies(),
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
            pageCache = Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  final Map<String, String?>? res = await showDialog(
                      context: context,
                      builder: (context) => const InputDialog(
                            title: "Proxies Page Setting",
                            items: {
                              "Delay Url":
                                  "https://www.gstatic.com/generate_204"
                            },
                          ));
                  Query.delayUrl = (res?["Delay Url"]) ?? Query.delayUrl;
                  // print(Query.delayUrl);
                  // setState(() {});
                },
                child: const Icon(Icons.settings),
              ),
              body: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: selectors.length,
                  itemBuilder: (ctx, idx) {
                    final selector = selectors[idx];
                    return ExpansionTile(
                      title: Row(
                        children: [
                          Text(
                            "${selector["name"]} | ${selector["now"]}=>",
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            "${delays[selector["name"]] ?? 0}ms",
                            style: TextStyle(
                                color: (delays[selector["name"]] ?? 0) < 0
                                    ? Colors.red
                                    : (delays[selector["name"]] ?? 0) > 400
                                        ? Colors.orange
                                        : Colors.green),
                          )
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.speed),
                        onPressed: () async {
                          final newDelays =
                              (await Query.getDelay(selector["name"], "group"))
                                  ?.entries;
                          final gDelay = (await Query.getDelay(
                              selector["name"], "proxies"));
                          delays.addEntries(newDelays ?? {});
                          delays.addAll(
                              {selector["name"]: gDelay?["delay"] ?? -1});
                          setState(() {});
                        },
                      ),
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 4.3),
                          itemCount: selector["all"].length,
                          itemBuilder: (context, subIndex) {
                            String key = selector["all"][subIndex];
                            dynamic node = proxies?[key];
                            return NodeButton(
                              name: node["name"],
                              delay: delays[node["name"]] ?? 0,
                              backgroudColor:
                                  const Color.fromARGB(255, 245, 245, 245),
                              type: node["type"],
                              udp: node["udp"],
                              borderColor: node["name"] == selector["now"]
                                  ? Colors.green
                                  : Colors.grey,
                              onTap: () async {
                                await Query.toggleProxy(
                                    selector["name"], node["name"]);
                                setState(() {});
                              },
                              onPressed: () async {
                                final res = await Query.getDelay(
                                    node["name"], "proxies");
                                if (res != null) {
                                  delays.addAll(
                                      {node["name"]: res["delay"] ?? -1});
                                }
                                setState(() {});
                              },
                              btnIcon: const Icon(Icons.speed),
                            );
                          },
                        ),
                      ],
                    );
                  }),
            );
            return pageCache!;
          } else {
            return const Text("Woops");
          }
        });
  }
}
