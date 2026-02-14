import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';

class ViewPane extends StatelessWidget {
  final List<String> subfolders;
  final List<SmRecord> records;

  const ViewPane({super.key, required this.subfolders, required this.records});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          getFolders(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              radius: BorderRadius.circular(20),
              thickness: 5.0,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          getBookmarks(),
          Spacer(),
        ],
      ),
    );
  }

  Widget getFolders() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              for (String folder in subfolders)
                buildFolderContainer(icon: Icon(Icons.folder), title: folder),
            ],
          )
        ],
      ),
    );
  }

  Widget getBookmarks() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              for (SmRecord record in records)
                // TODO: Replace with actual icon later
                buildBookmarkContainer(icon: Icon(Icons.star), record: record),
            ],
          )
        ],
      ),
    );
  }

  Widget buildFolderContainer({required Icon icon, required String title}) {
    return Row(
      children: [
        icon,
        Spacer(),
        Text(title),
      ],
    );
  }

  Widget buildBookmarkContainer(
      {required Icon icon, required SmRecord record}) {
    return Column(
      children: [
        Row(
          children: [
            icon,
            Spacer(),
            Column(
              children: [
                Text(record.name),
                Text(record.url),
                if (record.tags.isNotEmpty)
                  for (String tag in record.tags)
                    Chip(
                      label: Text("#$tag"),
                    ),
              ],
            )
          ],
        ),
        Row(
          children: [
            // Actions
            // TODO: Open in browser
            IconButton(onPressed: () {}, icon: Icon(Icons.open_in_browser)),

            // TODO: Copy URL to clipboard
            IconButton(onPressed: () {}, icon: Icon(Icons.copy)),

            // TODO: Info page
            IconButton(onPressed: () {}, icon: Icon(Icons.info)),

            // TODO: Other actions
            PopupMenuButton(
              onSelected: (value) {},
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem(
                  child: Row(
                    children: [Icon(Icons.edit), Spacer(), Text("Edit record")],
                  ),
                ),
                const PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      Spacer(),
                      Text("Delete record")
                    ],
                  ),
                ),
                const PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.notes),
                      Spacer(),
                      Text("View notes on record")
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
