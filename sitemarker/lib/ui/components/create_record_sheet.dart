import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/data_types/sm_tag.dart';
import 'package:validators/validators.dart' as validators;

import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/core/providers/records_provider.dart';
import 'package:sitemarker/core/providers/tags_provider.dart';
import 'package:sitemarker/helpers/helpers_data_integrity.dart';

/// Helper launcher to display the create record sheet
Future<void> showCreateRecordDialog(
  BuildContext context, {
  int folderId = 1,
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
      child: CreateRecordSheet(folderId: folderId),
    ),
  );
}

class CreateRecordSheet extends StatefulWidget {
  final int folderId;

  const CreateRecordSheet({super.key, this.folderId = 1});

  @override
  State<CreateRecordSheet> createState() => _CreateRecordSheetState();
}

class _CreateRecordSheetState extends State<CreateRecordSheet> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<SmTag> _selectedTags = [];

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _showNewTagDialog() async {
    final tagController = TextEditingController();

    // 1. Await the dialog to return a String (or null if cancelled)
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
            onPressed: () => Navigator.pop(ctx), // Pops with null
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, tagController.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    // 2. Safely delay disposal so the dialog animation can finish
    Future.delayed(const Duration(milliseconds: 300), () {
      tagController.dispose();
    });

    // 3. Handle the DB insertion cleanly outside the dialog's lifecycle
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
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final recordName = _nameController.text.trim();
    final urlText = _urlController.text.trim();
    final recordsProvider = context.read<RecordsProvider>();
    final tagsProvider = context.read<TagsProvider>();

    final isNameDuplicate = DataIntegrityHelpers.isRecordNameDuplicate(
      recordName,
      widget.folderId,
      recordsProvider,
    );

    if (isNameDuplicate) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Duplicate Bookmark'),
            content: Text(
              'A bookmark named "$recordName" already exists in this folder.',
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

    final isUrlDuplicate = DataIntegrityHelpers.isRecordUrlDuplicate(
      urlText,
      widget.folderId,
      recordsProvider,
    );

    if (isUrlDuplicate) {
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
      final now = DateTime.now();

      final record = SmRecord(
        id: null,
        name: recordName,
        url: urlText,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        tags: _selectedTags,
        folderId: widget.folderId,
        isDeleted: false,
        dateAdded: now,
        dateModified: now,
        lastSynced: null,
      );

      await recordsProvider.addRecord(record);

      int recordId = recordsProvider.creationId;
      if (recordId != -1) {
        for (final tag in _selectedTags) {
          await tagsProvider.attachTag(tag.id, recordId);
        }
      }

      if (mounted) {
        recordsProvider.loadRecordsByFolder(widget.folderId);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to save bookmark. Please try again.'),
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
        .where(
          (tags) => !_selectedTags.any((selected) => selected.id == tags.id),
        )
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
                  'New Bookmark',
                  style: parentTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'e.g. GitHub Repository',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    hintText: 'https://...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a URL';
                    }

                    String input = value.trim();

                    // 1. Enforce that the user provided a scheme
                    final uri = Uri.tryParse(input);
                    if (uri == null || !uri.hasScheme || uri.scheme.isEmpty) {
                      return 'URL must include a scheme (e.g., https://)';
                    }

                    // 2. Email validation
                    if (input.startsWith('mailto:')) {
                      final email = input.substring(7);
                      if (validators.isEmail(email)) {
                        return null;
                      }
                      return 'Invalid email address';
                    }

                    // 3. Strict TOR Onion validation (V3 Spec)
                    if (input.contains('.onion')) {
                      // Requires scheme://, exactly 56 base32 chars, .onion, optional path
                      final onionRegex = RegExp(
                        r'^([a-zA-Z]+:\/\/)([a-z2-7]{56})\.onion(\/.*)?$',
                      );
                      if (onionRegex.hasMatch(input)) {
                        return null;
                      }
                      return 'Invalid TOR V3 onion link';
                    }

                    // 4. Standard Web URL validation (enforce protocol)
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
                              _selectedTags.removeWhere((t) => t.id == tag.id);
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
