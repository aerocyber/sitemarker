import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sitemarker/data/data_helper.dart';
import 'package:sitemarker/data/data_model.dart';
import 'package:sitemarker/pages/page_add.dart';
import 'package:sitemarker/pages/page_filter.dart';
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

  final _formkey = GlobalKey<FormState>();

  void askForFilter() {
    Map<String, dynamic> filters = {
      "Name": {
        "Has text": "",
        "Starts with": "",
        "Ends with": "",
      },
      "URL": {
        "Has text": "",
        "Starts with": "",
        "Ends with": "",
      },
      "Tags": {
        "Has tag": "",
      },
    };

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Filter data"),
            content: Center(
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      maxLength: 100,
                      autofocus: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.subject),
                        hintText: "Enter text present in Name",
                        labelText: "Name contains the word:",
                      ),
                      onSaved: (nameFilter) {
                        if (nameFilter != null) {
                          filters["Name"]["Has text"] = nameFilter;
                        }
                      },
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      maxLength: 100,
                      autofocus: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.subject),
                        hintText: "Enter the text with which Name starts with",
                        labelText: "Name starts with the word:",
                      ),
                      onSaved: (nameFilter) {
                        if (nameFilter != null) {
                          filters["Name"]["Starts with"] = nameFilter;
                        }
                      },
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      maxLength: 100,
                      autofocus: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.subject),
                        hintText: "Enter text with which Name ends with",
                        labelText: "Name ends with the word:",
                      ),
                      onSaved: (nameFilter) {
                        if (nameFilter != null) {
                          filters["Name"]["Ends with"] = nameFilter;
                        }
                      },
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      maxLength: 100,
                      autofocus: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.subject),
                        hintText: "Enter text present in uRL",
                        labelText: "URL contains the word:",
                      ),
                      onSaved: (urlFilter) {
                        if (urlFilter != null) {
                          filters["URL"]["Has text"] = urlFilter;
                        }
                      },
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      maxLength: 100,
                      autofocus: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.subject),
                        hintText: "Enter the text with which URL starts with",
                        labelText: "URL starts with the word:",
                      ),
                      onSaved: (tagFilter) {
                        if (tagFilter != null) {
                          filters["Tags"]["Has tag"] = tagFilter;
                        }
                      },
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      maxLength: 100,
                      autofocus: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.subject),
                        hintText: "Enter text with which URL ends with",
                        labelText: "URL ends with the word:",
                      ),
                      onSaved: (urlFilter) {
                        if (urlFilter != null) {
                          filters["URL"]["Ends with"] = urlFilter;
                        }
                      },
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      maxLength: 100,
                      autofocus: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.subject),
                        hintText: "Enter text with which URL ends with",
                        labelText: "URL ends with the word:",
                      ),
                      onSaved: (urlFilter) {
                        if (urlFilter != null) {
                          filters["URL"]["Ends with"] = urlFilter;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageFilter(
                              filters: filters,
                            ),
                          ));
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Apply filter")),
            ],
          );
        });
  }

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
                      delegate: SitemarkerSearchDelegate(
                          records: value.records, recordNames: recordNames),
                    );
                  },
                  icon: const Icon(Icons.search),
                );
              },
            ),
          ),
          IconButton(
              onPressed: () {
                askForFilter();
              },
              icon: const Icon(Icons.filter_alt)),
              const SizedBox(width: 25,),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
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
                                          record: value.records[index],
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
                                  await Clipboard.setData(ClipboardData(
                                      text: value.records[index].url));
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
                                  value.records[index].url.length > 20
                                      ? value.records[index].url
                                          .substring(0, 21)
                                      : value.records[index].url,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                              Text(
                                value.records[index].tags,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: IconButton(
                              onPressed: () {
                                SitemarkerRecord recordTemp =
                                    value.records[index];
                                RecordDataModel rec = RecordDataModel(
                                  name: recordTemp.name,
                                  url: recordTemp.url,
                                  tags: recordTemp.tags,
                                );
                                onDeleteShowAlertDialog(context, rec);
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

  onFailOpenURLShowAlertDialog(BuildContext context, String url) {
    String alertText =
        'Could not launch $url. Please open a browser and type in the URL';

    AlertDialog ad = AlertDialog(
      title: const Text('Error attempting to open URL'),
      content: Text(alertText),
      actions: [TextButton(onPressed: () {}, child: const Text('OK'))],
    );

    showDialog(context: context, builder: (BuildContext context) => ad);
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
}

class SitemarkerSearchDelegate extends SearchDelegate {
  List<SitemarkerRecord> records;
  List<String> recordNames;

  SitemarkerSearchDelegate(
      {super.searchFieldLabel,
      super.searchFieldStyle,
      super.searchFieldDecorationTheme,
      super.keyboardType,
      super.textInputAction,
      required this.records,
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
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageViewDetail(
                          record: records[index],
                        )));
          },
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
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageViewDetail(
                          record: records[index],
                        )));
          },
        );
      },
    );
  }
}
