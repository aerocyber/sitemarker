import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/providers/folders_provider.dart';
import 'package:sitemarker/helpers/helpers_data_integrity.dart';

/// Helper launcher to display the create folder sheet
Future<void> showCreateFolderDialog(
  BuildContext context, {
  int parentId = 1,
}) async {
  final parentTheme = Theme.of(context);

  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: false,
    isScrollControlled: true,
    backgroundColor: parentTheme.colorScheme.surface,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (dialogContext) => Theme(
      data: parentTheme,
      child: CreateFolderSheet(parentId: parentId),
    ),
  );
}

class CreateFolderSheet extends StatefulWidget {
  final int parentId;

  const CreateFolderSheet({super.key, this.parentId = 1});

  @override
  State<CreateFolderSheet> createState() => _CreateFolderSheetState();
}

class _CreateFolderSheetState extends State<CreateFolderSheet> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateFolder() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final folderName = _nameController.text.trim();
    final foldersProvider = context.read<FoldersProvider>();

    // --- INTEGRITY CHECK ---
    final isDuplicate = DataIntegrityHelpers.isFolderNameDuplicate(
      folderName,
      widget.parentId,
      foldersProvider,
    );

    if (isDuplicate) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Duplicate Folder'),
            content: Text('A folder named "$folderName" already exists here.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }

    // --- PROCEED WITH CREATION ---
    try {
      final now = DateTime.now();
      final folder = SmFolder(
        name: folderName,
        parentId: widget.parentId,
        isDeleted: false,
        dateAdded: now,
        dateModified: now,
        lastSynced: null,
      );

      await foldersProvider.createFolder(folder);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to create folder. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final parentTheme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.0,
        right: 20.0,
        top: 8.0,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'New Folder',
                style: parentTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Folder Name',
                    hintText: 'e.g. Work, Tech, Reading',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a folder name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _handleCreateFolder,
                    child: const Text('Create'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
