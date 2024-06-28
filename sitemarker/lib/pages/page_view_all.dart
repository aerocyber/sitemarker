import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/data/database/database.dart';
import 'package:sitemarker/data/db_provider.dart';
import 'package:sitemarker/pages/page_add.dart';
import 'package:sitemarker/pages/page_view_detail.dart';

class PageViewAll extends StatefulWidget {
  const PageViewAll({super.key});

  @override
  State<PageViewAll> createState() => _PageViewAllState();
}

class _PageViewAllState extends State<PageViewAll> {
  List<String> recordNames = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5.0,
        title: const Text('Sitemarker'),
        shape: const RoundedRectangleBorder(),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<DBRecordProvider>(
            builder: (context, value, child) {
              for (int i = 0; i < value.records.length; i++) {
                recordNames.add(value.records[i].name);
              }
              return IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SitemarkerSearchDelegate(
                      records: value.records,
                      recordNames: recordNames,
                    ),
                  );
                },
                icon: const Icon(Icons.search),
              );
            },
          ),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
      body: Consumer<DBRecordProvider>(
        builder: (context, value, child) {
          return value.records.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    // Get domain url
                    String domainUrl = value.records[index].url.split(
                        "//")[value.records[index].url.split("//").length - 1];
                    // Get domain
                    String domain = domainUrl.split('/')[0];
                    return ListTile(
                      isThreeLine: false,
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: Text(
                          domain.characters.first.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      title: Text(value.records[index].name),
                      subtitle: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(domainUrl),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(value.records[index].tags),
                        ],
                      ),
                      trailing: const Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 25,
                    );
                  },
                  itemCount: value.records.length,
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.info),
                        SizedBox(
                          width: 25,
                        ),
                        Text("No records found"),
                      ],
                    ),
                  ],
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const    PageAdd()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SitemarkerSearchDelegate extends SearchDelegate {
  final List<SitemarkerRecord> records;
  final List<String> recordNames;

  SitemarkerSearchDelegate({
    super.searchFieldLabel,
    super.searchFieldStyle,
    super.searchFieldDecorationTheme,
    super.keyboardType,
    super.textInputAction,
    required this.records,
    required this.recordNames,
  });
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
      const SizedBox(
        width: 25,
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matches = [];
    for (String name in recordNames) {
      if (name.toLowerCase().contains(query.toLowerCase())) {
        matches.add(name);
      }
    }

    return ListView.separated(
        itemBuilder: (context, index) {
          var result = matches[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageViewDetail(
                          record: records[index],
                        )),
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 25,
          );
        },
        itemCount: matches.length);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matches = [];
    for (String name in recordNames) {
      if (name.toLowerCase().contains(query.toLowerCase())) {
        matches.add(name);
      }
    }

    return ListView.separated(
        itemBuilder: (context, index) {
          var result = matches[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageViewDetail(
                          record: records[index],
                        )),
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 25,
          );
        },
        itemCount: matches.length);
  }
}
