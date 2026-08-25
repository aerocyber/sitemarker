import 'package:material_ui/material_ui.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/ui/folders/folder_container.dart';
import 'package:sitemarker/ui/url/record_container.dart';

class RecordUnion extends StatelessWidget {
  final int folderId;
  const RecordUnion({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch sub folders from provider
    final List<SmFolder> subfolders = [];

    // TODO: Fetch records in folder from provider
    final List<SmRecord> records = [];

    return CustomScrollView(
      slivers: [
        if (subfolders.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Folders',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => FolderContainer(folder: subfolders[index]),
              childCount: subfolders.length,
            ),
          ),
        ],

        if (subfolders.isNotEmpty && records.isNotEmpty)
          const SliverToBoxAdapter(child: Divider()),

        if (records.isNotEmpty) ...[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Bookmarks',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => RecordContainer(record: records[index]),
              childCount: records.length,
            ),
          ),
        ],
      ],
    );
  }
}
