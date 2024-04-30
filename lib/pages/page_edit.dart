import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/data/data_model.dart';
import 'package:sitemarker/data/dbrecord_provider.dart';
import 'package:validators/validators.dart' as validators;

class PageEdit extends StatelessWidget {
  final SitemarkerRecord record;
  final _formkey = GlobalKey<FormState>();

  PageEdit({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    String recName = '';
    String recUrl = '';
    String recTagString = '';
    List<String> nameList = [];
    List<String> urlList = [];
    late List<SitemarkerRecord> dbRec;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Record",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              if (_formkey.currentState!.validate()) {
                _formkey.currentState!.save();
                SitemarkerRecord rec = SitemarkerRecord(
                  id: record.id,
                  name: recName,
                  url: recUrl,
                  tags: recTagString,
                  isDeleted: false,
                );
                Provider.of<DBRecordProvider>(context, listen: false)
                    .updateRecord(rec);
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            icon: const Icon(Icons.save),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Consumer<DBRecordProvider>(builder: (context, value, child) {
        dbRec = value.records;
        for (int i = 0; i < dbRec.length; i++) {
          nameList.add(dbRec[i].name);
          urlList.add(dbRec[i].url);
        }
        return Center(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Wrap(
                children: <Widget>[
                  TextFormField(
                    maxLength: 100,
                    autofocus: true,
                    initialValue: record.name,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.subject),
                      hintText: 'Enter the name to be associated with the URL',
                      labelText: 'Name *',
                    ),
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return "Please enter a name.";
                      } else if (nameList.contains(name)) {
                        if (name != record.name) {
                          return 'The name entered has been associated with a different record.';
                        }
                      }
                      return null;
                    },
                    onSaved: (name) {
                      recName = name!;
                    },
                  ),
                  TextFormField(
                    initialValue: record.url,
                    maxLength: 250,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.link),
                      hintText: 'Enter the URL',
                      labelText: 'URL *',
                    ),
                    validator: (url) {
                      if (url == null || url.isEmpty) {
                        return "Please enter a link";
                      }
                      if (!validators.isURL(url, requireProtocol: false)) {
                        return "Please enter a valid URL";
                      }
                      if (urlList.contains(url)) {
                        if (url != record.url) {
                          return 'The URL entered has been associated with a different record.';
                        }
                      }
                      return null;
                    },
                    onSaved: (url) {
                      recUrl = url!;
                    },
                  ),
                  TextFormField(
                    initialValue: record.tags,
                    maxLength: 250,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.tag),
                      hintText:
                          'Enter the tags to be associated with the URL separated by comma',
                      labelText: 'Tags (separated by ,)',
                    ),
                    validator: (tags) {
                      return null;
                    },
                    onSaved: (tags) {
                      if (tags != null && tags.isNotEmpty) {
                        recTagString = tags;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
