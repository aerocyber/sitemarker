import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/db/smdb_provider.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/ui/components/card_bookmark.dart';

class RecycleBin extends StatelessWidget {
  const RecycleBin({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SmdbProvider>(
      builder: (context, value, child) {
        List<SmRecord> deletedRecords = value.getAllDeletedRecords();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Recycle Bin'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(deletedRecords[index].id.toString()),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: const Icon(Icons.restore, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      // Restore
                      deletedRecords[index].isDeleted = false;
                      value.updateRecord(deletedRecords[index]);
                      return true;
                    } else if (direction == DismissDirection.endToStart) { // TODO: CHeck this?
                      // Permanently Delete
                      bool deleteConfirmation = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm Permanent Deletion"),
                            content: const Text(
                                "Are you sure you want to permanently delete this record? This action cannot be undone."),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Cancel")),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text("Delete",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                      if (deleteConfirmation == true) {
                        value.deleteRecordPermanently(deletedRecords[index]);
                        return true;
                      } else {
                        return false;
                      }
                    }
                    return false;
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Record Restored')),
                      );
                    } else if (direction == DismissDirection.endToStart) { // TODO: Check this?
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Record Permanently Deleted')),
                      );
                    }
                  },
                  child: CardBookmark(record: deletedRecords[index]),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
              itemCount: deletedRecords.length,
            ),
          ),
        );
      },
    );
  }
}