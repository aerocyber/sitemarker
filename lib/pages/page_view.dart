import 'package:flutter/material.dart';
import 'package:sitemarker/pages/page_add.dart';
import 'package:sitemarker/pages/page_view_detail.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/data/dbrecord_provider.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  List<String> recordNames = [];

  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0))),
        centerTitle: true,
        elevation: 2.0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Sitemarker',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Consumer<DBRecordProvider>(
              builder: (context, value, child) {
                recordNames = [];
                for (int i = 0; i < value.records.length; i++) {
                  recordNames.add(value.records[i].name);
                }
                return IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate:
                          SitemarkerSearchDelegate(recordNames: recordNames),
                    );
                  },
                  icon: const Icon(Icons.search),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        alignment: Alignment.center,
        child: Consumer<DBRecordProvider>(
          builder: (context, value, child) {
            // ignore: prefer_is_empty
            return value.records.length > 0
                ? ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: value.records.length,
                    itemBuilder: (context, index) {
                      String domainUrl = value.records[index].url.split("//")[
                          value.records[index].url.split('//').length - 1];
                      String domain = domainUrl.split('/')[0];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PageViewDetail(
                                        record: value.records[index],
                                      )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          child: ListTile(
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            ),
                            title: Center(
                              child: Text(
                                value.records[index].name,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  value.records[index].url,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                Text(
                                  value.records[index].tags,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                Provider.of<DBRecordProvider>(context,
                                        listen: false)
                                    .deleteRecord(value.records[index]);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 10,
                    ),
                  )
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'No records in database',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )
                      ],
                    ),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PageAdd()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  showAlertDialog(BuildContext context, String url) {
    String alertText =
        'Could not launch $url. Please open a browser and type in the URL';

    AlertDialog ad = AlertDialog(
      title: const Text('Error attempting to open URL'),
      content: Text(alertText),
      actions: [TextButton(onPressed: () {}, child: const Text('OK'))],
    );

    showDialog(context: context, builder: (BuildContext context) => ad);
  }
}

class SitemarkerSearchDelegate extends SearchDelegate {
  List<String> recordNames;

  SitemarkerSearchDelegate(
      {super.searchFieldLabel,
      super.searchFieldStyle,
      super.searchFieldDecorationTheme,
      super.keyboardType,
      super.textInputAction,
      required this.recordNames});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (String name in recordNames) {
      if (name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(name);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var record in recordNames) {
      if (record.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(record);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
