import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';

class FolderContainer extends StatefulWidget {
  final SmFolder folder;
  const FolderContainer({super.key, required this.folder});

  @override
  State<FolderContainer> createState() => _FolderContainerState();
}

class _FolderContainerState extends State<FolderContainer> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.folder, color: Theme.of(context).colorScheme.primary),
      title: Text(widget.folder.name),
      // TODO: Navigation to folder
      onTap: () => print("Navigate to folder with id: ${widget.folder.id}"),
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
                  widget.folder.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          
              // TODO: Edit folder
              const ListTile(leading: Icon(Icons.edit), title: Text('Edit')),
          
              if (widget.folder.isDeleted) ...[
                ListTile(
                  leading: const Icon(Icons.restore, color: Colors.green),
                  title: const Text(
                    'Restore',
                    style: TextStyle(color: Colors.green),
                  ),
                  onTap: () {
                    // TODO: Restore folder
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    'Delete Permanently',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text(
                    'This will delete all contents inside.',
                    style: TextStyle(fontSize: 12, color: Colors.redAccent),
                  ),
                  onTap: () {
                    // TODO: Perma delete the folder
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
                    // TODO: Soft delete the folder
                    Navigator.pop(context);
                  },
                ),
          
              const Divider(),
          
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Date Added'),
                subtitle: Text(formatDate(widget.folder.dateAdded)),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Last modified'),
                subtitle: Text(formatDate(widget.folder.dateModified)),
              ),
              ListTile(
                leading: const Icon(Icons.sync),
                title: const Text('Last sync at'),
                subtitle: Text(formatDate(widget.folder.lastSynced)),
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
