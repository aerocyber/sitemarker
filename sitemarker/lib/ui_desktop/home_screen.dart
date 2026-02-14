import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/components/view_pane.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/core/db/sm_db.dart';
import 'package:sitemarker/core/providers/data_provider.dart';

class SitemarkerHomeScreen extends StatefulWidget {
  const SitemarkerHomeScreen({super.key});

  @override
  State<SitemarkerHomeScreen> createState() => _SitemarkerHomeScreenState();
}

class _SitemarkerHomeScreenState extends State<SitemarkerHomeScreen> {
  int selectedIndex = 0;
  final List pages = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Consumer<DataProvider>(
            builder: (context, value, child) {
              return ViewPane(
                  subfolders: value.subfolder.map((t) => t.name).toList(),
                  records: value.records);
            },
          ),
        ]),
        // TODO: Add an entry
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
