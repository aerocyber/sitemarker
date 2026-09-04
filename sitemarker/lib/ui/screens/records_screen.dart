import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/providers/folders_provider.dart';
import 'package:sitemarker/core/providers/records_provider.dart';
import 'package:sitemarker/ui/components/record_union.dart';

class RecordsScreen extends StatefulWidget {
  final int folderId;
  const RecordsScreen({super.key, required this.folderId});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the data for this specific directory
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecordsProvider>().loadRecordsByFolder(widget.folderId);
      context.read<FoldersProvider>().loadSubFolders(widget.folderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RecordUnion(folderId: widget.folderId);
  }
}
