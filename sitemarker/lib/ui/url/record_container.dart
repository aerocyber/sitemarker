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
    return ListTile(
      leading: Icon(Icons.public, color: Theme.of(context).colorScheme.primary),
      title: Text(widget.record.name),
      subtitle: Text(widget.record.url),
      // TODO: Navigation to folder
      onTap: () => print("Navigate to URL with url: ${widget.record.url}"),
      trailing: IconButton(
        // TODO: Bottom sheet for folder item
        onPressed: () => _showBottomSheet(context),
        icon: const Icon(Icons.more_vert),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  widget.record.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              if (widget.record.tags.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      for (var tag in widget.record.tags)
                        Chip(
                          label: Text(tag),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                    ],
                  ),
                ),
              ],

              if (widget.record.notes != null)
                ListTile(
                  leading: const Icon(Icons.note),
                  title: const Text('Notes'),
                  subtitle: Text(widget.record.notes!),
                ),

              const Divider(),

              // TODO: Edit record
              const ListTile(leading: Icon(Icons.edit), title: Text('Edit')),

              if (widget.record.isDeleted) ...[
                ListTile(
                  leading: const Icon(Icons.restore, color: Colors.green),
                  title: const Text(
                    'Restore',
                    style: TextStyle(color: Colors.green),
                  ),
                  onTap: () {
                    // TODO: Restore record
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    'Delete Permanently',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    // TODO: Perma delete the record
                    Navigator.pop(context);
                  },
                ),
              ] else
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.redAccent),
                  title: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () {
                    // TODO: Soft delete the record
                    Navigator.pop(context);
                  },
                ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Date Added'),
                subtitle: Text(formatDate(widget.record.dateAdded)),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Last modified'),
                subtitle: Text(formatDate(widget.record.dateModified)),
              ),
              ListTile(
                leading: const Icon(Icons.sync),
                title: const Text('Last sync at'),
                subtitle: Text(formatDate(widget.record.lastSynced)),
              ),

              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Never';
    return DateFormat('MMM d, yyyy • h:mm a').format(date);
  }
}
