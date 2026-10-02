import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/providers/folders_provider.dart';
import 'package:sitemarker/core/providers/records_provider.dart';
import 'package:sitemarker/ui/components/edit_folder_sheet.dart';
import 'package:toastification/toastification.dart';

class FolderContainer extends StatefulWidget {
  final SmFolder folder;
  final bool disableRestore;

  const FolderContainer({
    super.key,
    required this.folder,
    this.disableRestore = false,
  });

  @override
  State<FolderContainer> createState() => _FolderContainerState();
}

class _FolderContainerState extends State<FolderContainer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        onTap: () {
          if (widget.folder.isDeleted) {
            context.push(
              '/trash/folder/${widget.folder.id}',
              extra: widget.folder.name,
            );
          } else {
            context.push('/folder/${widget.folder.id}');
          }
        },
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 6.0,
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
                        enabled: !widget.disableRestore,
                        leading: Icon(
                          Icons.restore,
                          color: widget.disableRestore
                              ? Theme.of(
                                  bottomSheetContext,
                                ).colorScheme.onSurface.withValues(alpha: 0.38)
                              : Theme.of(
                                  bottomSheetContext,
                                ).colorScheme.primary,
                        ),
                        title: Text(
                          'Restore',
                          style: TextStyle(
                            color: widget.disableRestore
                                ? Theme.of(bottomSheetContext)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.38)
                                : Theme.of(
                                    bottomSheetContext,
                                  ).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: widget.disableRestore
                            ? const Text(
                                'Restore parent folder to recover this subfolder',
                              )
                            : null,
                        onTap: widget.disableRestore
                            ? null
                            : () async {
                                final foldersProvider = context
                                    .read<FoldersProvider>();
                                final recordsProvider = context
                                    .read<RecordsProvider>();
                                final targetFolder = widget.folder;

                                Navigator.pop(bottomSheetContext);

                                toastification.show(
                                  type: ToastificationType.info,
                                  style: ToastificationStyle.simple,
                                  title: const Text('Folder restored'),
                                  autoCloseDuration: const Duration(seconds: 3),
                                  alignment: Alignment.bottomCenter,
                                  icon: const Icon(Icons.restore),
                                );

                                await foldersProvider.restoreFolderFromTrash(
                                  targetFolder,
                                );
                                await recordsProvider.loadTrash(); // Sync cache
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
                                  onPressed: () async {
                                    final foldersProvider = context
                                        .read<FoldersProvider>();
                                    final recordsProvider = context
                                        .read<RecordsProvider>();
                                    final targetFolder = widget.folder;

                                    Navigator.pop(dialogContext);

                                    toastification.show(
                                      type: ToastificationType.success,
                                      style: ToastificationStyle.simple,
                                      title: const Text(
                                        'Folder and its contents permanently deleted',
                                      ),
                                      autoCloseDuration: const Duration(
                                        seconds: 3,
                                      ),
                                      alignment: Alignment.bottomCenter,
                                      icon: const Icon(Icons.delete_forever),
                                    );

                                    // Prevent Scaffold geometry crash during dialog pop animation
                                    await Future.delayed(
                                      const Duration(milliseconds: 250),
                                    );

                                    await foldersProvider.permaDeleteFolder(
                                      targetFolder,
                                    );

                                    recordsProvider.removeFolderFromCache(
                                      targetFolder.id!,
                                    );
                                    await recordsProvider
                                        .loadTrash(); // Sync cache
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
                          showEditFolderDialog(context, folder: widget.folder);
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

                          if (context.mounted) {
                            toastification.show(
                              type: ToastificationType.success,
                              style: ToastificationStyle.simple,
                              title: const Text('Folder moved to trash'),
                              autoCloseDuration: const Duration(seconds: 4),
                              alignment: Alignment.bottomCenter,
                              icon: const Icon(Icons.delete_outline),
                              callbacks: ToastificationCallbacks(
                                onTap: (toastItem) {
                                  // Clicking the toast acts as an undo
                                  foldersProvider.restoreFolderFromTrash(
                                    targetFolder,
                                  );

                                  toastification.dismiss(toastItem);
                                },
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
}
