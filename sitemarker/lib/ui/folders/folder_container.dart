import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/providers/folders_provider.dart';
import 'package:sitemarker/core/providers/records_provider.dart';

class FolderContainer extends StatefulWidget {
  final SmFolder folder;
  const FolderContainer({super.key, required this.folder});

  @override
  State<FolderContainer> createState() => _FolderContainerState();
}

class _FolderContainerState extends State<FolderContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // 1. Await the navigation to the subfolder
        await context.push("/folder/${widget.folder.id}");

        // 2. When the user pops back to this screen, immediately re-fetch THIS folder's data
        if (context.mounted) {
          // If we are navigating back to root (1), load root folders. Otherwise, load subfolders.
          if (widget.folder.parentId == null || widget.folder.parentId == 1) {
            context.read<FoldersProvider>().loadRootFolders();
          } else {
            context.read<FoldersProvider>().loadSubFolders(
              widget.folder.parentId!,
            );
          }
          // Reload the records for this specific folder
          context.read<RecordsProvider>().loadRecordsByFolder(
            widget.folder.parentId ?? 1,
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 4.0,
          ),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.folder_outlined, // Swapped to a folder icon
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
                  ).colorScheme.onSurfaceVariant.withOpacity(0.4),
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
                    ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      title: const Text('Edit'),
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        // TODO: Edit folder
                      },
                    ),
                    Divider(
                      height: 1,
                      color: Theme.of(
                        bottomSheetContext,
                      ).colorScheme.outlineVariant.withOpacity(0.5),
                    ),
                    if (widget.folder.isDeleted) ...[
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
                          // TODO: Restore folder
                        },
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(
                          bottomSheetContext,
                        ).colorScheme.outlineVariant.withOpacity(0.5),
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
                          'This will delete all contents inside.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              bottomSheetContext,
                            ).colorScheme.error.withOpacity(0.8),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(bottomSheetContext);
                          // TODO: Perma delete the folder
                        },
                      ),
                    ] else
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
                        onTap: () {
                          Navigator.pop(bottomSheetContext);
                          // TODO: Soft delete the folder
                        },
                      ),
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
}
