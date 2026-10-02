import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/data_types/sm_tag.dart';
import 'package:toastification/toastification.dart';
import 'package:validators/validators.dart' as validators;

import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/core/providers/records_provider.dart';
import 'package:sitemarker/core/providers/tags_provider.dart';
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

  final List<SmTag> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.record.name);
    _urlController = TextEditingController(text: widget.record.url);
    _notesController = TextEditingController(text: widget.record.notes ?? '');
    _selectedTags.addAll(widget.record.tags);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _showNewTagDialog() async {
    final tagController = TextEditingController();

    final String? newTag = await showDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (ctx) => AlertDialog(
        title: const Text('New Tag'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        content: TextField(
          controller: tagController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Tag Name',
            hintText: 'e.g. flutter',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.pop(ctx, tagController.text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, tagController.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      tagController.dispose();
    });

    if (newTag != null && newTag.trim().isNotEmpty) {
      await _addNewTag(newTag.trim());
    }
  }

  Future<void> _addNewTag(String tagText) async {
    final cleanedTag = tagText.trim();
    if (cleanedTag.isEmpty) return;

    final tagsProvider = context.read<TagsProvider>();

    SmTag? existingTag;
    try {
      existingTag = tagsProvider.allTags.firstWhere(
        (t) => t.name.toLowerCase() == cleanedTag.toLowerCase(),
      );
    } catch (_) {}

    if (existingTag == null) {
      final newId = await tagsProvider.createTag(cleanedTag);
      existingTag = SmTag(id: newId, name: cleanedTag);
    }

    setState(() {
      if (!_selectedTags.any((t) => t.id == existingTag!.id)) {
        _selectedTags.add(existingTag!);
      }
    });
  }

  Future<void> _handleSaveRecord() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final recordName = _nameController.text.trim();
    final urlText = _urlController.text.trim();

    final recordsProvider = context.read<RecordsProvider>();
    final tagsProvider = context.read<TagsProvider>();

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

    try {
      final addedTags = _selectedTags
          .where(
            (selected) => !widget.record.tags.any(
              (original) => original.id == selected.id,
            ),
          )
          .toList();

      final removedTags = widget.record.tags
          .where(
            (original) =>
                !_selectedTags.any((selected) => selected.id == original.id),
          )
          .toList();

      final updatedRecord = SmRecord(
        id: widget.record.id,
        name: recordName,
        url: urlText,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        tags: _selectedTags,
        folderId: widget.record.folderId,
        isDeleted: widget.record.isDeleted,
        dateAdded: widget.record.dateAdded,
        dateModified: DateTime.now(),
        lastSynced: widget.record.lastSynced,
      );

      await recordsProvider.updateRecord(updatedRecord);

      for (final tag in addedTags) {
        await tagsProvider.attachTag(tag.id, updatedRecord.id!);
      }

      for (final tag in removedTags) {
        await tagsProvider.removeMapping(tag.id);
      }

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
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to update bookmark. Please try again.'),
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
    final tagsProvider = context.watch<TagsProvider>();

    final dropdownTags = tagsProvider.allTags
        .where((tag) => !_selectedTags.any((selected) => selected.id == tag.id))
        .toList();

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
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: const OutlineInputBorder(),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _nameController,
                      builder: (context, value, child) {
                        final canUndo = value.text != widget.record.name;
                        return IconButton(
                          icon: const Icon(Icons.undo),
                          tooltip: 'Restore original title',
                          color: canUndo
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.3),
                          onPressed: canUndo
                              ? () => _nameController.text = widget.record.name
                              : null,
                        );
                      },
                    ),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a title'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: 'URL',
                    border: const OutlineInputBorder(),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _urlController,
                      builder: (context, value, child) {
                        final canUndo = value.text != widget.record.url;
                        return IconButton(
                          icon: const Icon(Icons.undo),
                          tooltip: 'Restore original URL',
                          color: canUndo
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.3),
                          onPressed: canUndo
                              ? () => _urlController.text = widget.record.url
                              : null,
                        );
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a URL';
                    }

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

                    if (!validators.isURL(input, requireProtocol: true)) {
                      return 'Enter a valid URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.auto_awesome, size: 20),
                  label: const Text('Fetch title from URL'),
                  onPressed: () {
                    // TODO: Implement title fetch from URL
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownMenu<SmTag>(
                        expandedInsets: EdgeInsets.zero,
                        label: const Text('Select Tag'),
                        dropdownMenuEntries: dropdownTags.map((tag) {
                          return DropdownMenuEntry<SmTag>(
                            value: tag,
                            label: tag.name,
                          );
                        }).toList(),
                        onSelected: (SmTag? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedTags.add(newValue);
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: FilledButton.tonalIcon(
                        icon: const Icon(Icons.add),
                        label: const Text('New'),
                        onPressed: _showNewTagDialog,
                      ),
                    ),
                  ],
                ),
                if (_selectedTags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _selectedTags.map((tag) {
                        return Chip(
                          label: Text(tag.name),
                          onDeleted: () {
                            setState(() {
                              _selectedTags.remove(tag);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: const OutlineInputBorder(),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _notesController,
                      builder: (context, value, child) {
                        final canUndo =
                            value.text != (widget.record.notes ?? '');
                        return IconButton(
                          icon: const Icon(Icons.undo),
                          tooltip: 'Restore original notes',
                          color: canUndo
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.3),
                          onPressed: canUndo
                              ? () => _notesController.text =
                                    (widget.record.notes ?? '')
                              : null,
                        );
                      },
                    ),
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
