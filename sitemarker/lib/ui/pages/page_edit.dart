import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/db/smdb_provider.dart';
import 'package:validators/validators.dart' as validator;
import 'package:sitemarker/core/data_types/size_config.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';

class PageEdit extends StatefulWidget {
  const PageEdit({super.key, required this.record});

  final SmRecord record;

  @override
  State<PageEdit> createState() => _PageEditState();
}

class _PageEditState extends State<PageEdit> {
  final GlobalKey<FormState> _addItemKey = GlobalKey<FormState>();
  bool isErr = false;
  List<SmRecord> records = [];
  List<String> nameList = [];
  List<String> urlList = [];
  String? recName;
  String? recTag;
  String? recUrl;

  TextEditingController nameController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().initSizes(context);
    nameController.text = widget.record.name;
    urlController.text = widget.record.url;

    return Consumer<SmdbProvider>(
      builder: (context, value, child) {
        records = value.getAllRecords();
        for (int i = 0; i < records.length; i++) {
          nameList.add(records[i].name);
          urlList.add(records[i].url);
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Record'),
            centerTitle: true,
            elevation: 10,
            leading: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 25,
                  ),
                  onPressed: () async {
                    bool goBack = true;
                    goBack = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Record not saved'),
                            content: const Text(
                                'Changes will be lost if you go back now. Do you want to go back without saving the record?'),
                            actions: [
                              TextButton(
                                child: const Text(
                                    'Yes, go back discarding the record'),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                              ),
                              TextButton(
                                child: const Text('No, stay here'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                            ],
                          ),
                        ) ??
                        false;
                    if (goBack == true) {
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
              ],
            ),
            actions: [
              Consumer<SmdbProvider>(
                builder: (context, value, child) => IconButton(
                  icon: Icon(
                    Icons.save,
                    size: 25,
                  ),
                  onPressed: () {
                    // TODO: Implement the saving stuff
                    if (_addItemKey.currentState!.validate()) {
                      _addItemKey.currentState!.save();
                      SmRecord rec = SmRecord(
                        id: widget.record.id,
                        name: recName ?? widget.record.name,
                        url: recUrl ?? widget.record.url,
                        tags: recTag ?? widget.record.tags,
                        dt: DateTime.now(),
                        isDeleted: widget.record.isDeleted ?? false,
                      );
                      value.updateRecord(rec);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Consumer<SmdbProvider>(
                builder: (context, value, child) {
                  return Center(
                    child: Form(
                      key: _addItemKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              maxLines: 1,
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                              autofocus: true,
                              decoration: InputDecoration(
                                icon: Icon(Icons.subject),
                                hintText: 'Enter the name of the record',
                                labelText: 'Name *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                              validator: (name) {
                                if (name == null || name.isEmpty) {
                                  return "Please enter a name.";
                                } else if (nameList.contains(name)) {
                                  if (name == widget.record.name) {
                                    return null; // Allow editing the same name
                                  }
                                  return 'The name entered has been associated with a different record.';
                                }
                                return null;
                              },
                              onSaved: (name) {
                                recName = name!;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: urlController,
                              maxLines: 1,
                              textInputAction: TextInputAction.next,
                              autofocus: true,
                              decoration: InputDecoration(
                                icon: Icon(Icons.link),
                                hintText:
                                    'Enter the URL to be associated with the URL',
                                labelText: 'URL *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                              validator: (url) {
                                if (url == null || url.isEmpty) {
                                  return "Please enter a url.";
                                } else if (urlList.contains(url)) {
                                  if (url == widget.record.url) {
                                    return null; // Allow editing the same URL
                                  }
                                  return 'The url entered has been associated with a different record.';
                                } else if (!validator.isURL(url)) {
                                  return 'Enter a valid URL';
                                }
                                return null;
                              },
                              onSaved: (url) {
                                recUrl = url!;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              initialValue: widget.record.tags,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.tag),
                                hintText:
                                    'Enter the tags to be associated with the URL separated by comma',
                                labelText: 'Tags (separated by ,)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                              validator: (tags) {
                                return null;
                              },
                              onSaved: (tags) {
                                if (tags != null && tags.isNotEmpty) {
                                  recTag = tags;
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
