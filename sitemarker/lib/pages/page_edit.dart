import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/data/database/database.dart';
import 'package:sitemarker/data/db_provider.dart';
import 'package:validators/validators.dart' as validators;

class PageEdit extends StatefulWidget {
  const PageEdit({super.key, required this.record});
  final SitemarkerRecord record;

  @override
  State<PageEdit> createState() => _PageEditState();
}

class _PageEditState extends State<PageEdit> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String recName = '';
    String recUrl = '';
    List<String> recTags = [];
    List<String> nameList = [];
    List<String> urlList = [];
    late List<SitemarkerRecord> dbRec;
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                SitemarkerRecord rec = SitemarkerRecord(
                  id: widget.record.id,
                  name: recName,
                  url: recUrl,
                  tags: recTags.join(','),
                  isDeleted: false,
                );
                Provider.of<DBRecordProvider>(
                  context,
                  listen: false,
                ).updateRecord(rec);
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Consumer<DBRecordProvider>(
            builder: (context, value, child) {
              dbRec = value.records;
              for (int i = 0; i < dbRec.length; i++) {
                nameList.add(dbRec[i].name);
                urlList.add(dbRec[i].url);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    initialValue: widget.record.name,
                    maxLength: 100,
                    autofocus: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.subject),
                      hintText: 'Enter name of the record',
                      labelText: 'Name *',
                    ),
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'Enter a name';
                      } else if (nameList.contains(name) &&
                          name != widget.record.name) {
                        return '$name has been associated with a different record';
                      }
                      return null;
                    },
                    onSaved: (name) => recName = name!,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    initialValue: widget.record.url,
                    maxLength: 250,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.link),
                      hintText: 'Enter URL of the record',
                      labelText: 'URL *',
                    ),
                    validator: (url) {
                      if (url == null || url.isEmpty) {
                        return 'Enter a URL';
                      } else if (!validators.isURL(url)) {
                        return 'Enter a valid URL';
                      } else if (urlList.contains(url) &&
                          url != widget.record.url) {
                        return '$url has been associated with a different record';
                      }
                      return null;
                    },
                    onSaved: (url) => recUrl = url!,
                  ),
                  TextFormField(
                    initialValue: widget.record.tags,
                    textInputAction: TextInputAction.done,
                    maxLength: 250,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.tag),
                      hintText: 'Enter tags of the record',
                      labelText: 'Tag (Separate tags by comma)',
                    ),
                    validator: (name) {
                      return null;
                    },
                    onSaved: (tags) {
                      if (tags != null && tags.isNotEmpty) {
                        recTags = tags.split(',');
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
