import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/size_config.dart';
import 'package:sitemarker/ui/components/card_bookmark.dart';
import 'package:sitemarker/ui/pages/page_add.dart';
import 'package:sitemarker/ui/components/sitemarker_search_delegate.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/db/smdb_provider.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/ui/pages/view_omio.dart';
// import 'package:sitemarker/ui/pages/recycle_bin.dart';

class SitemarkerPageView extends StatefulWidget {
  const SitemarkerPageView({super.key, this.refresh = false});
  final bool refresh;

  @override
  State<SitemarkerPageView> createState() => _SitemarkerPageViewState();
}

class _SitemarkerPageViewState extends State<SitemarkerPageView> {
  List<SmRecord> recordsInDB = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().initSizes(context);

    return Consumer<SmdbProvider>(
      builder: (context, value, child) {
        recordsInDB = value.getAllUndeletedRecords();
        if (recordsInDB.isEmpty) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                elevation: 10,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 30,
                    ),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PageAdd(
                            receivingData: null,
                          ),
                        ),
                      );
                      setState(() {
                        recordsInDB = value.getAllUndeletedRecords();
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              body: Center(
                child: Text('No records found'),
              ),
            ),
          );
        }
        if (recordsInDB.isNotEmpty) {
          recordsInDB.sort((a, b) => a.name.compareTo(b.name));
        }

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 10,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PageAdd(
                          receivingData: null,
                        ),
                      ),
                    );
                    setState(() {
                      recordsInDB = value.getAllUndeletedRecords();
                    });
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SitemarkerPageViewOmio(),
                        ),
                      );

                      setState(() {
                        recordsInDB = value.getAllUndeletedRecords();
                      });
                    },
                    icon: const Icon(Icons.grid_view_rounded, size: 30)),
                const SizedBox(width: 20),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 30,
                  ),
                  onPressed: () {
                    List<String> recNames = [];

                    for (int i = 0; i < recordsInDB.length; i++) {
                      recNames.add(recordsInDB[i].name);
                    }

                    showSearch(
                      context: context,
                      delegate: SitemarkerSearchDelegate(
                        records: recordsInDB,
                        recordNames: recNames,
                      ),
                    );
                  },
                ),
                // const SizedBox(width: 20),
                // IconButton(
                //   onPressed: () async {
                //     await Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => RecycleBin(),
                //       ),
                //     );
                //     setState(() {
                //       recordsInDB = value.getAllUndeletedRecords();
                //     });
                //   },
                //   icon: const Icon(Icons.delete, size: 30),
                // ),
                const SizedBox(width: 20),
              ],
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: ListView.builder(
                itemBuilder: (context, index) => Column(
                  children: [
                    CardBookmark(
                      record: recordsInDB[index],
                      onDelete: () {
                        setState(() {
                          recordsInDB = value.getAllUndeletedRecords();
                        });
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                itemCount: recordsInDB.length,
                itemExtent: null,
                // separatorBuilder: (context, index) => SizedBox(height: 10),
              ),
            ),
          ),
        );
      },
    );
  }
}
