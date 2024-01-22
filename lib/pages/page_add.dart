import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/operations/data_model.dart';
import 'package:sitemarker/operations/dbrecord_provider.dart';

class PageAdd extends StatelessWidget {
  PageAdd({super.key});
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String recName = '', recUrl = '';
    List<String> recTags = [];
    String recTagString = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Record"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<DBRecordProvider>(builder: (context, value, child) {
        return Center(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(150),
              child: Wrap(
                spacing: 100,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.subject),
                      hintText: 'Enter the name to be associated with the URL',
                      labelText: 'Name *',
                    ),
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return "Please enter a name";
                      }
                      recName = name;
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.link),
                      hintText: 'Enter the URL',
                      labelText: 'URL *',
                    ),
                    validator: (url) {
                      if (url == null || url.isEmpty) {
                        return "Please enter a link";
                      }
                      if (!(Uri.parse(url).isAbsolute)) {
                        return "Please enter a valid URL";
                      }
                      recUrl = url;
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.tag),
                      hintText:
                          'Enter the tags to be associated with the URL separated by comma',
                      labelText: 'Tags (separated by ,)',
                    ),
                    validator: (tags) {
                      List<String> tagList = [];
                      if (tags != null && tags.isNotEmpty) {
                        List<String> tmp = tags.split(',');
                        for (int i = 0; i < tmp.length; i++) {
                          tagList.add(tmp[i]);
                        }
                      }
                      recTags = tagList;
                      recTagString = recTags.toString();
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 250, vertical: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            recName = '';
                            recUrl = '';
                            recTagString = '';
                            recTags = [];
                            Navigator.pop(context);
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.cancel),
                              Text("Cancel"),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            DBRecord rec = DBRecord(
                                name: recName, url: recUrl, tags: recTagString);
                            Provider.of<DBRecordProvider>(context,
                                    listen: false)
                                .insertRecord(rec);
                            Navigator.pop(context);
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.save),
                              Text("Save record"),
                            ],
                          ),
                        ),
                      ],
                    ),
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
