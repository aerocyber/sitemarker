import 'package:flutter/material.dart';
import 'package:sitemarker/sitemarker_record.dart';

class PageAdd extends StatelessWidget {
  final SitemarkerRecord smr = SitemarkerRecord();
  final _formkey = GlobalKey<FormState>();

  PageAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Record"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                  decoration: const InputDecoration(
                    icon: Icon(Icons.subject),
                    hintText: 'Enter the name to be associated with the URL',
                    labelText: 'Name *',
                  ),
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      return "Please enter a name";
                    }
                    smr.name = name;
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
                    smr.url = url;
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
                    smr.tags = tagList;
                    return null;
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 250, vertical: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, SitemarkerRecord());
                        },
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, smr);
                        },
                        child: const Text("Submit"),
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
