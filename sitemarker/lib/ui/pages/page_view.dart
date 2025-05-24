import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/size_config.dart';
import 'package:sitemarker/ui/components/card_bookmark.dart';
import 'package:sitemarker/ui/pages/page_add.dart';
import 'package:sitemarker/ui/components/sitemarker_search_delegate.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/db/smdb_provider.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';

class SitemarkerPageView extends StatefulWidget {
  const SitemarkerPageView({super.key});

  @override
  State<SitemarkerPageView> createState() => _SitemarkerPageViewState();
}

class _SitemarkerPageViewState extends State<SitemarkerPageView> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().initSizes(context);

    return Consumer<SmdbProvider>(
      builder: (context, value, child) {
        List<SmRecord> recordsInDB = value.getAllUndeletedRecords();

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 10,
              floating: false,
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
                      recordsInDB = value.getAllRecords();
                    });
                  },
                ),
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
                const SizedBox(width: 20),
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CardBookmark(
                          record: recordsInDB[index],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
                childCount: recordsInDB.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
