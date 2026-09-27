import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/core/providers/folders_provider.dart';
import 'package:sitemarker/core/providers/records_provider.dart';
import 'package:sitemarker/router.dart';
import 'package:sitemarker/ui/components/collapsable_section.dart';
import 'package:sitemarker/ui/folders/folder_container.dart';
import 'package:sitemarker/ui/records/record_container.dart';

class RecordUnion extends StatefulWidget {
  final int folderId;
  const RecordUnion({super.key, required this.folderId});

  @override
  State<RecordUnion> createState() => _RecordUnionState();
}

class _RecordUnionState extends State<RecordUnion> with RouteAware {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _fetchData();
  }

  void _fetchData() {
    final foldersProvider = context.read<FoldersProvider>();
    final recordsProvider = context.read<RecordsProvider>();

    if (widget.folderId == 1) {
      foldersProvider.loadRootFolders();
    } else {
      foldersProvider.loadSubFolders(widget.folderId);
    }
    recordsProvider.loadRecordsByFolder(widget.folderId);
  }

  @override
  Widget build(BuildContext context) {
    final foldersProvider = context.watch<FoldersProvider>();
    final recordsProvider = context.watch<RecordsProvider>();

    // Show a loading spinner if either provider is fetching data
    if (foldersProvider.isLoading || recordsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Pull from the correct getter based on your provider logic
    final List<SmFolder> subfolders = widget.folderId == 1
        ? foldersProvider.rootFolders
        : foldersProvider.getSubDirs(widget.folderId);

    final List<SmRecord> records = recordsProvider.getRecordsForFolder(
      widget.folderId,
    );

    final bool isFetching =
        foldersProvider.isLoading || recordsProvider.isLoading;

    if (isFetching && subfolders.isEmpty && records.isEmpty) {
      return Center(child: const CircularProgressIndicator());
    }

    // Handle empty state gracefully
    if (subfolders.isEmpty && records.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'This folder is empty.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        if (subfolders.isNotEmpty)
          CollapsibleSection(
            title: 'Folders',
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => FolderContainer(folder: subfolders[index]),
                childCount: subfolders.length,
              ),
            ),
          ),

        if (subfolders.isNotEmpty && records.isNotEmpty)
          const SliverToBoxAdapter(child: SizedBox(height: 25)),

        if (records.isNotEmpty)
          CollapsibleSection(
            title: 'Bookmarks',
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => RecordContainer(record: records[index]),
                childCount: records.length,
              ),
            ),
          ),

        SliverToBoxAdapter(child: SizedBox(height: 88.0)),
      ],
    );
  }
}
