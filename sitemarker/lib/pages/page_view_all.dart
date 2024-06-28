import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/data/database/database.dart';
import 'package:sitemarker/data/database/record_data_model.dart';
import 'package:sitemarker/data/db_provider.dart';
import 'package:sitemarker/pages/page_add.dart';
import 'package:sitemarker/pages/page_view_detail.dart';
import 'package:sitemarker/settings/themes/themes.dart';
import 'package:toastification/toastification.dart';

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
      body: Consumer<ThemesProvider>(
        builder: (context, value, child) {
          bool enableShadow = value.shadows;
          return Consumer<DBRecordProvider>(
            builder: (context, value, child) {
              return value.records.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder: (context, index) {
                        // Get domain url
                        String domainUrl = value.records[index].url.split("//")[
                            value.records[index].url.split("//").length - 1];
                        // Get domain
                        String domain = domainUrl.split('/')[0];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Theme.of(context).colorScheme.inversePrimary,
                            boxShadow: enableShadow
                                ? [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary
                                          .withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
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
                              child: Text(value.records[index].name),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await Clipboard.setData(
                                      ClipboardData(
                                          text: value.records[index].url),
                                    );
                                    if (context.mounted) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.success,
                                        style: ToastificationStyle.flatColored,
                                        title: const Text('Success'),
                                        description: const Text(
                                            'URL copied to Clipboard!'),
                                        alignment: Alignment.bottomCenter,
                                        autoCloseDuration:
                                            const Duration(seconds: 5),
                                        animationBuilder: (
                                          context,
                                          animation,
                                          alignment,
                                          child,
                                        ) {
                                          return ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          );
                                        },
                                        icon: const Icon(Icons.task_alt),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        boxShadow: highModeShadow,
                                        dragToClose: true,
                                        applyBlurEffect: true,
                                      );
                                    }
                                  },
                                  child: Text(
                                    value.records[index].url.length > 20
                                        ? domainUrl
                                        : value.records[index].url,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: getTags(value.records[index].tags),
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Consumer<DBRecordProvider>(
                                  builder: (context, value, child) {
                                return IconButton(
                                  onPressed: () {
                                    RecordDataModel rec = RecordDataModel(
                                      name: value.records[index].name,
                                      url: value.records[index].url,
                                      tags:
                                          value.records[index].tags.split(','),
                                    );
                                    onDeleteShowAlertDialog(context, rec);
                                  },
                                  icon: const Icon(Icons.delete),
                                );
                              }),
                            ),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PageAdd()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  onDeleteShowAlertDialog(BuildContext context, RecordDataModel rec) {
    String alertText =
        'Do you really want to delete record with name ${rec.name}? This is permanent and cannot be undone.';

    AlertDialog ad = AlertDialog(
      title: const Text('Confirm deletion?'),
      content: Text(alertText),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Provider.of<DBRecordProvider>(context, listen: false)
                .deleteRecord(rec);
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => ad);
  }

  List<Widget> getTags(String tags) {
    List<Widget> tagWidget = [];
    List<String> tagList = tags.split(',');

    if (tagList.length > 1) {
      for (int i = 0; i < tagList.length; i++) {
        tagWidget.add(Row(
          children: [
            const Icon(Icons.tag),
            Text(tagList[i]),
            const SizedBox(
              width: 5,
            ),
          ],
        ));
      }
      return tagWidget;
    }
    return tagWidget;
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
                  ),
                ),
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
