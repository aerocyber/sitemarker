import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/providers/folders_provider.dart';
import 'package:sitemarker/core/providers/records_provider.dart';
import 'package:sitemarker/helpers/helpers_data_integrity.dart';

class FolderContainer extends StatefulWidget {
  final SmFolder folder;
  const FolderContainer({super.key, required this.folder});

  @override
  State<FolderContainer> createState() => _FolderContainerState();
}

class _FolderContainerState extends State<FolderContainer> {
  @override
  Widget build(BuildContext context) {
    // Return the Card directly, removing the wrapping InkWell
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        // 1. Apply the matching border radius to the tile itself
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        // 2. Move the onTap logic here
        onTap: () {
          context.push("/folder/${widget.folder.id}");
          // if (context.mounted) {
          //   if (widget.folder.parentId == null || widget.folder.parentId == 1) {
          //     context.read<FoldersProvider>().loadRootFolders();
          //   } else {
          //     context.read<FoldersProvider>().loadSubFolders(
          //       widget.folder.parentId!,
          //     );
          //   }
          //   context.read<RecordsProvider>().loadRecordsByFolder(
          //     widget.folder.parentId ?? 1,
          //   );
          // }
        },
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.folder_outlined,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          widget.folder.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showBottomSheet(context),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (bottomSheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. The M3 Drag Handle
              const SizedBox(height: 16.0),
              Container(
                width: 32.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Theme.of(
                    bottomSheetContext,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(height: 16.0),

              // 2. Centered Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  widget.folder.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(bottomSheetContext).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 24.0),

              // 3. Card-ified Actions Block
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                elevation: 0,
                color: Theme.of(
                  bottomSheetContext,
                ).colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    if (widget.folder.isDeleted) ...[
                      // DELETED STATE ACTIONS
                      ListTile(
                        leading: Icon(
                          Icons.restore,
                          color: Theme.of(
                            bottomSheetContext,
                          ).colorScheme.primary,
                        ),
                        title: Text(
                          'Restore',
                          style: TextStyle(
                            color: Theme.of(
                              bottomSheetContext,
                            ).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(bottomSheetContext);
                          context.read<FoldersProvider>().restoreFromTrash(
                            widget.folder,
                          );
                        },
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(
                          bottomSheetContext,
                        ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.delete_forever,
                          color: Theme.of(bottomSheetContext).colorScheme.error,
                        ),
                        title: Text(
                          'Delete Permanently',
                          style: TextStyle(
                            color: Theme.of(
                              bottomSheetContext,
                            ).colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'This will delete all contents inside, permanently.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              bottomSheetContext,
                            ).colorScheme.error.withValues(alpha: 0.8),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(bottomSheetContext);
                          // Show confirmation dialog before permanent deletion
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Delete permanently?'),
                              content: const Text(
                                'This action cannot be undone and will destroy all contents.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onError,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    context.read<FoldersProvider>().permaDelete(
                                      widget.folder,
                                    );
                                    if (context.mounted) {
                                      context
                                          .read<RecordsProvider>()
                                          .removeFolderFromCache(
                                            widget.folder.id!,
                                          );
                                    }
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ] else ...[
                      // ACTIVE STATE ACTIONS
                      ListTile(
                        leading: const Icon(Icons.edit_outlined),
                        title: const Text('Edit'),
                        onTap: () {
                          Navigator.pop(bottomSheetContext);
                          _showEditDialog(context);
                        },
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(
                          bottomSheetContext,
                        ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.delete_outline,
                          color: Theme.of(bottomSheetContext).colorScheme.error,
                        ),
                        title: Text(
                          'Delete',
                          style: TextStyle(
                            color: Theme.of(
                              bottomSheetContext,
                            ).colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'This will delete all contents but can be recovered from Recycle bin',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        onTap: () async {
                          Navigator.pop(bottomSheetContext);

                          final foldersProvider = context
                              .read<FoldersProvider>();
                          final recordsProvider = context
                              .read<RecordsProvider>();
                          final targetFolder = widget.folder;

                          await foldersProvider.sendToTrash(targetFolder);

                          recordsProvider.removeFolderFromCache(
                            targetFolder.id!,
                          );

                          // M3 Floating SnackBar with Undo Action
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Folder moved to trash'),
                                behavior: SnackBarBehavior.floating,
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    // 4. Use the cached provider reference here, NOT context.read()
                                    foldersProvider.restoreFromTrash(
                                      targetFolder,
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16.0),

              // 4. Card-ified Metadata Block
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                elevation: 0,
                color: Theme.of(
                  bottomSheetContext,
                ).colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _buildMetadataTile(
                      bottomSheetContext,
                      icon: Icons.info_outline,
                      title: 'Date Added',
                      subtitle: formatDate(widget.folder.dateAdded),
                    ),
                    _buildMetadataTile(
                      bottomSheetContext,
                      icon: Icons.update_outlined,
                      title: 'Last modified',
                      subtitle: formatDate(widget.folder.dateModified),
                    ),
                    _buildMetadataTile(
                      bottomSheetContext,
                      icon: Icons.sync,
                      title: 'Last sync at',
                      subtitle: formatDate(widget.folder.lastSynced),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 20,
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Never';
    return DateFormat('MMM d, yyyy • h:mm a').format(date);
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
      text: widget.folder.name,
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Folder'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Folder Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              final newName = value?.trim();
              if (newName == null || newName.isEmpty) {
                return 'Name cannot be empty';
              }

              // Only check for duplicates if the name actually changed
              if (newName.toLowerCase() != widget.folder.name.toLowerCase()) {
                final isDuplicate = DataIntegrityHelpers.isFolderNameDuplicate(
                  newName,
                  widget.folder.parentId ?? 1,
                  context.read<FoldersProvider>(),
                );
                if (isDuplicate)
                  return 'A folder with this name already exists';
              }

              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final newName = nameController.text.trim();

                // Only trigger a DB update if the name actually changed
                if (newName != widget.folder.name) {
                  await context.read<FoldersProvider>().renameFolder(
                    widget.folder,
                    newName,
                  );
                }

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
