import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/data/data_model.dart';
import 'package:sitemarker/core/data/db_provider.dart';
import 'package:sitemarker/features/ui/pages/add_records_page.dart';
import 'package:sitemarker/features/ui/pages/view_record_detail_page.dart';
import 'package:sitemarker/features/ui/widgets/view_record_item_widget.dart';

class ViewRecordsPage extends StatefulWidget {
  const ViewRecordsPage({super.key});

  @override
  State<ViewRecordsPage> createState() => _ViewRecordsPageState();
}

class _ViewRecordsPageState extends State<ViewRecordsPage> {
  List<DBDataModel> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        title: const Text('Sitemarker'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 24,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Consumer<DbProvider>(
            builder: (context, dbValues, child) {
              data = dbValues.records;

              return IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SitemarkerSearchDelegate(records: data),
                  );
                },
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              );
            },
          ),
          const SizedBox(
            width: 50,
          ),
        ],
      ),
      body: Consumer<DbProvider>(
        builder: (context, db, child) {
          return db.records.isEmpty
              ? const Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info,
                        size: 24,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "No records in database.",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) {
                    return Dismissible(
                      background: Container(
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20,
                              ),
                            ),
                          ),
                        ),
                        child: const ColoredBox(
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (DismissDirection dir) {
                        db.deleteRecord(db.records[index]);
                      },
                      child: ViewRecordItemWidget(
                        record: db.records[index],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 10,
                  ),
                  itemCount: db.records.length,
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecordsPage(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}

class SitemarkerSearchDelegate extends SearchDelegate {
  List<DBDataModel> records;

  SitemarkerSearchDelegate({
    super.searchFieldLabel,
    super.searchFieldStyle,
    super.searchFieldDecorationTheme,
    super.keyboardType,
    super.textInputAction,
    required this.records,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
      const SizedBox(
        width: 20,
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    bool isfound = false;
    List<ListTile> matches = [];
    for (DBDataModel rec in records) {
      if (rec.name.toLowerCase().contains(query.toLowerCase())) {
        isfound = true;
        matches.add(
          ListTile(
            title: Text(rec.name),
            trailing: const Text(
              "Matches: Name",
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewRecordDetailPage(record: rec),
                ),
              );
            },
          ),
        );
      }
      if (rec.url.toLowerCase().contains(query.toLowerCase())) {
        if (isfound) continue;
        matches.add(
          ListTile(
            title: Text(rec.url),
            trailing: const Text(
              "Matches: URL",
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewRecordDetailPage(record: rec),
                ),
              );
            },
          ),
        );
      }
    }

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        return matches[index];
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    bool isfound = false;
    List<ListTile> matches = [];
    for (DBDataModel rec in records) {
      if (rec.name.toLowerCase().contains(query.toLowerCase())) {
        isfound = true;
        matches.add(
          ListTile(
            title: Text(rec.name),
            trailing: const Text(
              "Matches: Name",
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewRecordDetailPage(record: rec),
                ),
              );
            },
          ),
        );
      }
      if (rec.url.toLowerCase().contains(query.toLowerCase())) {
        if (isfound) continue;
        matches.add(
          ListTile(
            title: Text(rec.url),
            trailing: const Text(
              "Matches: URL",
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewRecordDetailPage(record: rec),
                ),
              );
            },
          ),
        );
      }
    }

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        return matches[index];
      },
    );
  }
}
