import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:sitemarker/core/data_types/sm_record.dart';

class RecordContainer extends StatefulWidget {
  final SmRecord record;
  const RecordContainer({super.key, required this.record});

  @override
  State<RecordContainer> createState() => _RecordContainerState();
}

class _RecordContainerState extends State<RecordContainer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      elevation: 0, // M3 flat style
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Softer, modern corners
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
            Icons.public,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          widget.record.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          widget.record.url,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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
      isScrollControlled: true, // Allows it to size correctly
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.0),
        ), // M3 curve
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content tightly
            children: [
              // 1. The M3 Drag Handle
              const SizedBox(height: 16.0),
              Container(
                width: 32.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(height: 16.0),

              // 2. Centered Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  widget.record.name, // Hooked up to actual data
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 24.0),

              // 3. Card-ified Actions Block
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.link),
                      title: const Text("Open link in browser"),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Trigger open in url routine
                      },
                    ),
                    Divider(
                      height: 1,
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                    ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      title: const Text('Edit'),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Trigger edit routine
                      },
                    ),
                    Divider(
                      height: 1,
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      title: Text(
                        'Delete',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Trigger delete routine
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // 4. Dynamic Tags Block (Only renders if tags exist)
              if (widget.record.tags.isNotEmpty) ...[
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.label_outline,
                              size: 20,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Tags',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: widget.record.tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              side: BorderSide(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outlineVariant,
                              ),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],

              // 5. Card-ified Dynamic Metadata Block
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _buildMetadataTile(
                      context,
                      icon: Icons.info_outline,
                      title: 'Date Added',
                      subtitle: _formatDate(widget.record.dateAdded),
                    ),
                    _buildMetadataTile(
                      context,
                      icon: Icons.update_outlined,
                      title: 'Last modified',
                      subtitle: _formatDate(widget.record.dateModified),
                    ),
                    _buildMetadataTile(
                      context,
                      icon: Icons.sync,
                      title: 'Last sync at',
                      subtitle: _formatDate(widget.record.lastSynced),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetadataTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      dense: true, // Shrinks the vertical padding slightly
      visualDensity: VisualDensity.compact,
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 20, // Slightly smaller icons for metadata
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'Never';
    return DateFormat('MMM d, yyyy • h:mm a').format(date);
  }
}
