import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/db/smdb_provider.dart';
import 'package:sitemarker/ui/pages/home_screen.dart';
import 'package:validators/validators.dart' as validator;
import 'package:sitemarker/core/data_types/size_config.dart';
import 'package:sitemarker/core/data_helper.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';

class PageAdd extends StatefulWidget {
  const PageAdd({super.key, required this.receivingData});

  final String? receivingData;

  @override
  State<PageAdd> createState() => _PageAddState();
}

class _PageAddState extends State<PageAdd> {
  final GlobalKey<FormState> _addItemKey = GlobalKey<FormState>();
  bool isErr = false;
  List<SmRecord> records = [];
  List<String> nameList = [];
  List<String> urlList = [];
  String? recName;
  String? recTag;
  String? recUrl;
  bool changed = false;
  bool fromIntent = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName().then(
      (val) {
        recName = val;
        if (val != null) {
          nameController.text = val;
          changed = true;
          fromIntent = true;
        }
      },
    );

    if (widget.receivingData != null) {
      recUrl = widget.receivingData;
      urlController.text = widget.receivingData!;
      changed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().initSizes(context);

    if (isErr) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(
            Icons.warning,
            size: SizeConfig.blockSizeVertical * 3,
          ),
          actions: [],
          content: Text("Error"),
        ),
      );
    }

    return Consumer<SmdbProvider>(
      builder: (context, value, child) {
        records = value.getAllRecords();
        for (int i = 0; i < records.length; i++) {
          nameList.add(records[i].name);
          urlList.add(records[i].url);
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Record'),
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
                    if (changed) {
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
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                            TextButton(
                              child: const Text('No, stay here'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                          ],
                        ),
                      );
                    }
                    if (goBack == true) {
                      if (context.mounted) {
                        if (fromIntent) {
                          // Navigator.of(context).pushAndRemoveUntil(
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           const SMHomeScreen(url: null)),
                          //   (Route<dynamic> route) => false,
                          // );
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SMHomeScreen(url: null)));
                        }

                        // Navigator.of(context).pop();
                        else {
                          Navigator.of(context).pop();
                        }
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
                        name: recName!,
                        url: recUrl!,
                        tags: recTag ?? '',
                        dt: DateTime.now(),
                      );
                      value.insertRecord(rec);

                      if (fromIntent) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => SMHomeScreen(url: null),
                          ),
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
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
                              onChanged: (newval) {
                                changed = true;
                              },
                              maxLines: 1,
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                              autofocus: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 25,
                                  horizontal: 15,
                                ),
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
                            child: SizedBox(
                              child: TextFormField(
                                controller: urlController,
                                onChanged: (newval) {
                                  changed = true;
                                },
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
                                autofocus: true,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 25,
                                    horizontal: 15,
                                  ),
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
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              onChanged: (newval) {
                                changed = true;
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 25,
                                  horizontal: 15,
                                ),
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

  Future<String?> getName() async {
    final data = widget.receivingData;
    if (data == null) return null;
    if (!validator.isURL(data)) {
      isErr = true;
      return null;
    }
    try {
      return await DataHelper.getPageTitleFromURL(data);
    } catch (e) {
      debugPrint("Error fetching page title: $e");
      return null;
    }
  }
}
