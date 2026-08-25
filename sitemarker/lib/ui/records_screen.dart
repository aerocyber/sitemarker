import 'package:flutter/material.dart';
import 'package:sitemarker/ui/record_union.dart';

class RecordsScreen extends StatelessWidget {
  final int folderId;
  const RecordsScreen({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    return RecordUnion(folderId: folderId);
  }
}
