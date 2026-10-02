import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:validators/validators.dart' as validators;

import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/core/providers/records_provider.dart';
import 'package:sitemarker/helpers/helpers_data_integrity.dart';

Future<void> showEditRecordDialog(
  BuildContext context, {
  required SmRecord record,
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
      child: EditRecordSheet(record: record),
    ),
  );
}

class EditRecordSheet extends StatefulWidget {
  final SmRecord record;

  const EditRecordSheet({super.key, required this.record});

  @override
  State<EditRecordSheet> createState() => _EditRecordSheetState();
}

class _EditRecordSheetState extends State<EditRecordSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _urlController;
  late final TextEditingController _notesController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.record.name);
    _urlController = TextEditingController(text: widget.record.url);
    _notesController = TextEditingController(text: widget.record.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveRecord() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final recordName = _nameController.text.trim();
    final urlText = _urlController.text.trim();
    final recordsProvider = context.read<RecordsProvider>();

    // Duplicate Name Check (Only if changed)
    if (recordName != widget.record.name &&
        DataIntegrityHelpers.isRecordNameDuplicate(
          recordName,
          widget.record.folderId,
          recordsProvider,
        )) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Duplicate Bookmark'),
            content: Text(
              'A bookmark named "$recordName" already exists here.',
            ),
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

    // Duplicate URL Check (Only if changed)
    if (urlText != widget.record.url &&
        DataIntegrityHelpers.isRecordUrlDuplicate(
          urlText,
          widget.record.folderId,
          recordsProvider,
        )) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Duplicate URL'),
            content: Text(
              'The URL "$urlText" is already saved in this folder.',
            ),
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

    final updatedRecord = SmRecord(
      id: widget.record.id,
      name: recordName,
      url: urlText,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      tags: widget.record.tags, // Keep existing tags untouched
      folderId: widget.record.folderId,
      isDeleted: widget.record.isDeleted,
      dateAdded: widget.record.dateAdded, // Keep original creation date
      dateModified: DateTime.now(), // Bump the modified date
      lastSynced: widget.record.lastSynced,
    );

    await recordsProvider.updateRecord(updatedRecord);

    if (mounted) {
      Navigator.pop(context);
      toastification.show(
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        title: const Text('Bookmark updated'),
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit Bookmark',
                  style: parentTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a title'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Enter a URL';

                    String input = value.trim();
                    final uri = Uri.tryParse(input);

                    if (uri == null || !uri.hasScheme || uri.scheme.isEmpty) {
                      return 'URL must include a scheme (e.g., https://)';
                    }

                    if (input.startsWith('mailto:')) {
                      final email = input.substring(7);
                      if (validators.isEmail(email)) return null;
                      return 'Invalid email address';
                    }

                    if (input.contains('.onion')) {
                      final onionRegex = RegExp(
                        r'^([a-zA-Z]+:\/\/)([a-z2-7]{56})\.onion(\/.*)?$',
                      );
                      if (onionRegex.hasMatch(input)) return null;
                      return 'Invalid TOR V3 onion link';
                    }

                    if (!validators.isURL(input, requireProtocol: true))
                      return 'Enter a valid URL';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Show existing tags as read-only chips so the user knows they are preserved
                if (widget.record.tags.isNotEmpty) ...[
                  Text(
                    'Tags (Editing coming soon)',
                    style: parentTheme.textTheme.labelMedium?.copyWith(
                      color: parentTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: widget.record.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        visualDensity: VisualDensity.compact,
                        backgroundColor:
                            parentTheme.colorScheme.surfaceContainerHighest,
                        side: BorderSide(
                          color: parentTheme.colorScheme.outlineVariant,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],

                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(),
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
                      onPressed: _handleSaveRecord,
                      child: const Text('Save'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
