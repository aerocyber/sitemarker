import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/core/providers/folders_provider.dart';
import 'package:sitemarker/core/providers/records_provider.dart';
import 'package:sitemarker/ui/components/collapsable_section.dart';
import 'package:sitemarker/ui/folders/folder_container.dart';
import 'package:sitemarker/ui/records/record_container.dart';

class TrashScreen extends StatefulWidget {
  final int? folderId;
  final String? folderName;

  const TrashScreen({super.key, this.folderId, this.folderName});

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch trash data when screen mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoldersProvider>().loadTrash();
      context.read<RecordsProvider>().loadTrash();
    });
  }

  @override
  Widget build(BuildContext context) {
    final foldersProvider = context.watch<FoldersProvider>();
    final recordsProvider = context.watch<RecordsProvider>();

    final trashFolders = foldersProvider.trashFolders;
    final trashRecords = recordsProvider.trashRecords;
    final isFetching = foldersProvider.isLoading || recordsProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName ?? 'Recycle Bin'),
        centerTitle: true,
      ),
      body: _buildBody(context, trashFolders, trashRecords, isFetching),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<SmFolder> trashFolders,
    List<SmRecord> trashRecords,
    bool isFetching,
  ) {
    if (isFetching && trashFolders.isEmpty && trashRecords.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final Set<int> deletedFolderIds = trashFolders.map((f) => f.id!).toSet();

    late final List<SmFolder> displayFolders;
    late final List<SmRecord> displayRecords;

    if (widget.folderId == null) {
      // ROOT TRASH: Hide children if their parent is also in the trash
      displayFolders = trashFolders.where((f) {
        return f.parentId == null || !deletedFolderIds.contains(f.parentId);
      }).toList();

      displayRecords = trashRecords.where((r) {
        return !deletedFolderIds.contains(r.folderId);
      }).toList();
    } else {
      // NESTED TRASH: Show only items that belong to the current deleted folder
      displayFolders = trashFolders
          .where((f) => f.parentId == widget.folderId)
          .toList();
      displayRecords = trashRecords
          .where((r) => r.folderId == widget.folderId)
          .toList();
    }

    if (displayFolders.isEmpty && displayRecords.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_outline,
                size: 64,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              const SizedBox(height: 16),
              Text(
                widget.folderId == null
                    ? 'Recycle Bin is empty'
                    : 'Folder is empty',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                widget.folderId == null
                    ? 'Items you delete will appear here before they are permanently removed.'
                    : 'No items were deleted directly inside this folder.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        if (displayFolders.isNotEmpty)
          CollapsibleSection(
            title: 'Folders',
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => FolderContainer(
                  key: ValueKey('trash_folder_${displayFolders[index].id}'),
                  folder: displayFolders[index],
                  // If we are in a nested deleted folder, disable the individual restore button
                  disableRestore: widget.folderId != null,
                ),
                childCount: displayFolders.length,
              ),
            ),
          ),

        if (displayFolders.isNotEmpty && displayRecords.isNotEmpty)
          const SliverToBoxAdapter(child: SizedBox(height: 25)),

        if (displayRecords.isNotEmpty)
          CollapsibleSection(
            title: 'Bookmarks',
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => RecordContainer(
                  key: ValueKey('trash_record_${displayRecords[index].id}'),
                  record: displayRecords[index],
                  // If we are in a nested deleted folder, disable the individual restore button
                  disableRestore: widget.folderId != null,
                ),
                childCount: displayRecords.length,
              ),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 88.0)),
      ],
    );
  }
}
