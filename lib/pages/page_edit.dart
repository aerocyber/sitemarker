import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/data/data_model.dart';
import 'package:sitemarker/data/dbrecord_provider.dart';

// TODO: Validate for existence,
// TODO: Set initial values

class PageEdit extends StatelessWidget {
  final DBRecord record;
  final _formkey = GlobalKey<FormState>();

  PageEdit({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    String recName = '';
    String recUrl = '';
    List<String> recTags = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Record'),
        actions: [
          IconButton(
            onPressed: () {
              record.name = recName;
              record.url = recUrl;
              record.tags = recTags.toString();
              Provider.of<DBRecordProvider>(context).insertRecord(record);
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Center(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(150),
            child: Wrap(
              spacing: 100,
              children: <Widget>[
                TextFormField(
                  initialValue: record.name,
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
                  initialValue: record.url,
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
                    return null;
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 250, vertical: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        width: 100,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          record.name = recName;
                          record.url = recUrl;
                          record.tags = recTags.toString();
                          // obbx.insertRecord(record);
                          Navigator.pop(context);
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
