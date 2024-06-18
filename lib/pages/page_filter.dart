import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sitemarker/data/data_model.dart';
import 'package:sitemarker/pages/page_view_detail.dart';

class PageFilter extends StatefulWidget {
  const PageFilter({super.key, required this.filters, required this.records});
  final Map<String, dynamic> filters;
  final List<SitemarkerRecord> records;

  @override
  State<PageFilter> createState() => _PageFilterState();
}

class _PageFilterState extends State<PageFilter> {
  @override
  Widget build(BuildContext context) {
    final resultset = getWidgetItems();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sitemarker"),
      ),
      body: Center(
        child: resultset.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: resultset.length,
                itemBuilder: (context, index) {
                  String domainUrl = resultset[index]
                      .url
                      .split("//")[resultset[index].url.split('//').length - 1];
                  String domain = domainUrl.split('/')[0];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PageViewDetail(
                                      record: resultset[index],
                                    )));
                      },
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: Text(
                          domain.characters.first.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ),
                      title: Center(
                        child: Text(
                          resultset[index].name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: resultset[index].url));
                              const snackBar = SnackBar(
                                content: Text("URL copied to clipboard..."),
                                duration: Duration(milliseconds: 1500),
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: Text(
                              resultset[index].url.length > 20
                                  ? resultset[index].url.substring(0, 21)
                                  : resultset[index].url,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                          Text(
                            resultset[index].tags,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: 10,
                ),
              )
            : const Center(
                child: Text("No result matches the filter applied."),
              ),
      ),
    );
  }

  List<SitemarkerRecord> getWidgetItems() {
    Map<String, dynamic> filters = widget.filters;
    List<SitemarkerRecord> resultSet = [];
    Iterable<SitemarkerRecord> results;

    results = widget.records.where((record) {
      if (filters["Name"]["Starts with"] != "") {
        return record.name.startsWith(filters["Name"]["Starts with"]);
      }
      return false;
    });

    results = results.where((record) {
      if (filters["Name"]["Ends with"] != "") {
        return record.name.endsWith(filters["Name"]["Ends with"]);
      }
      return false;
    });

    results = results.where((record) {
      if (filters["Name"]["Has text"] != "") {
        return record.name.contains(filters["Name"]["Has text"]);
      }
      return false;
    });

    results = results.where((record) {
      if (filters["URL"]["Starts with"]) {
        return record.url.startsWith(filters["URL"]["Starts with"]);
      }
      return false;
    });

    results = results.where((record) {
      if (filters["URL"]["Ends with"]) {
        return record.url.endsWith(filters["URL"]["Ends with"]);
      }
      return false;
    });

    results = results.where((record) {
      if (filters["URL"]["Has text"]) {
        return record.url.contains(filters["URL"]["Has text"]);
      }
      return false;
    });

    results = results.where((record) {
      if (filters["Tags"]["Has tag"]) {
        return record.tags.contains(filters["Tags"]["Has tag"]);
      }
      return false;
    });

    for (int i = 0; i < results.length; i++) {
      resultSet.add(results.elementAt(i));
    }

    print(resultSet);
    print(results);
    return resultSet;
  }
}
