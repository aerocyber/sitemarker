import 'package:material_ui/material_ui.dart';
import 'package:sitemarker/ui/components/create_folder_sheet.dart';
import 'package:sitemarker/ui/components/create_record_sheet.dart';

/// Helper launcher to display the options sheet
Future<void> showAddOptionsDialog(
  BuildContext context, {
  int currentFolderId = 1,
}) async {
  final parentTheme = Theme.of(context);

  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: false,
    backgroundColor: parentTheme.colorScheme.surface,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (modalContext) => Theme(
      data: parentTheme,
      child: AddOptionsSheet(currentFolderId: currentFolderId),
    ),
  );
}

class AddOptionsSheet extends StatelessWidget {
  final int currentFolderId;

  const AddOptionsSheet({super.key, this.currentFolderId = 1});

  @override
  Widget build(BuildContext context) {
    final parentTheme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 0,
              color: parentTheme.colorScheme.surfaceContainerHighest,
              margin: const EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                leading: const Icon(Icons.create_new_folder_outlined),
                title: const Text('New Folder'),
                subtitle: const Text('Create a folder to group bookmarks'),
                onTap: () {
                  Navigator.pop(context);
                  showCreateFolderDialog(context, parentId: currentFolderId);
                },
              ),
            ),
            Card(
              elevation: 0,
              color: parentTheme.colorScheme.surfaceContainerHighest,
              child: ListTile(
                leading: const Icon(Icons.bookmark_add_outlined),
                title: const Text('New Bookmark'),
                subtitle: const Text('Save a URL with custom tags and notes'),
                onTap: () {
                  Navigator.pop(context);
                  showCreateRecordDialog(context, folderId: currentFolderId);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
