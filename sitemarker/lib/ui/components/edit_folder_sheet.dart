import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/providers/folders_provider.dart';
import 'package:sitemarker/helpers/helpers_data_integrity.dart';

Future<void> showEditFolderDialog(
  BuildContext context, {
  required SmFolder folder,
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
      child: EditFolderSheet(folder: folder),
    ),
  );
}

class EditFolderSheet extends StatefulWidget {
  final SmFolder folder;

  const EditFolderSheet({super.key, required this.folder});

  @override
  State<EditFolderSheet> createState() => _EditFolderSheetState();
}

class _EditFolderSheetState extends State<EditFolderSheet> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.folder.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final newName = _nameController.text.trim();
    final foldersProvider = context.read<FoldersProvider>();

    if (newName != widget.folder.name) {
      final isDuplicate = DataIntegrityHelpers.isFolderNameDuplicate(
        newName,
        widget.folder.parentId ?? 1,
        foldersProvider,
      );

      if (isDuplicate) {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Duplicate Folder'),
              content: Text('A folder named "$newName" already exists here.'),
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

      await foldersProvider.renameFolder(widget.folder, newName);
    }

    if (mounted) {
      Navigator.pop(context);
      toastification.show(
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        title: const Text('Folder updated'),
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.bottomCenter,
      );
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
                'Edit Folder',
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
                  decoration: InputDecoration(
                    labelText: 'Folder Name',
                    border: const OutlineInputBorder(),
                    // Inline Undo Button
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _nameController,
                      builder: (context, value, child) {
                        final canUndo = value.text != widget.folder.name;
                        return IconButton(
                          icon: const Icon(Icons.undo),
                          tooltip: 'Restore original name',
                          color: canUndo
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.3),
                          onPressed: canUndo
                              ? () => _nameController.text = widget.folder.name
                              : null,
                        );
                      },
                    ),
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
                    onPressed: _handleSave,
                    child: const Text('Save'),
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
