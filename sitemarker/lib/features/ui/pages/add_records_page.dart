import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/data/data_model.dart';
import 'package:sitemarker/core/data/db_provider.dart';

class AddRecordsPage extends StatefulWidget {
  const AddRecordsPage({super.key});

  @override
  State<AddRecordsPage> createState() => _AddRecordsPageState();
}

class _AddRecordsPageState extends State<AddRecordsPage> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String recName = '';
    String recUrl = '';
    String recTagString = '';
    List<String> nameList = [];
    List<String> urlList = [];

    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          centerTitle: true,
          title: Text(
            "Add record",
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
                  Provider.of<DbProvider>(context).insertRecord(
                    DBDataModel(
                      id: null,
                      name: recName,
                      url: recUrl,
                      tags: recTagString,
                      isDeleted: false,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.save),
            ),
            const SizedBox(
              width: 30,
            ),
          ],
        ),
        body: Consumer<DbProvider>(
          builder: (context, dbrecords, child) {
            for (int i = 0; i < dbrecords.records.length; i++) {
              nameList.add(dbrecords.records[i].name);
              urlList.add(dbrecords.records[i].url);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      children: [
                        TextFormField(
                          autocorrect: true,
                          autofocus: true,
                          enableSuggestions: true,
                          initialValue: "",
                          maxLength: 256,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Name',
                            icon: Icon(Icons.subject),
                          ),
                          validator: (name) {
                            if (name == null || name.isEmpty) {
                              return "Please enter a name";
                            } else if (nameList.contains(name)) {
                              return "The entered name is registered with another record";
                            }
                            return null;
                          },
                          onSaved: (name) => recName = name!,
                        ),
                        TextFormField(
                          autocorrect: true,
                          autofocus: true,
                          enableSuggestions: true,
                          initialValue: "",
                          maxLength: 256,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter URL',
                            icon: Icon(Icons.add_link),
                          ),
                          validator: (url) {
                            if (url == null || url.isEmpty) {
                              return "Please enter URL";
                            } else if (urlList.contains(url)) {
                              return "The entered URL is registered with another record";
                            }
                            return null;
                          },
                          onSaved: (url) => recUrl = url!,
                        ),
                        TextFormField(
                          autocorrect: true,
                          autofocus: true,
                          enableSuggestions: true,
                          initialValue: "",
                          maxLength: 256,
                          maxLines: 5,
                          minLines: 1,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Tags',
                            icon: Icon(Icons.tag),
                          ),
                          onSaved: (tags) {
                            if (tags == null || tags.isEmpty) {
                              recTagString = "";
                            } else {
                              List<String> recTags = tags.split(',');
                              List<String> _tags = [];
                              recTagString = "";
                              for (int i = 0; i < recTags.length; i++) {
                                _tags.add(recTags[i].trim());
                              }
                              recTagString = _tags.join(',');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
