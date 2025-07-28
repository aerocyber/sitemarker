import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/ui/pages/page_details.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:sitemarker/ui/pages/page_edit.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/db/smdb_provider.dart';
import 'package:toastification/toastification.dart';

class CardBookmark extends StatelessWidget {
  final SmRecord record;
  final VoidCallback? onDelete;

  const CardBookmark({required this.record, this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minTileHeight: 75,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                child: Text(
                  record.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 45,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        record.name,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        record.url,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    record.tags.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                for (int i = 0;
                                    i < record.tags.split(',').length;
                                    i++)
                                  record.tags.split(',')[i].trim().isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Chip(
                                            label: Text(
                                              record.tags.split(',')[i].trim(),
                                            ),
                                          ),
                                        )
                                      : Container(),
                              ],
                            ),
                          )
                        : const Text(
                            'Not tagged',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  launchUrl(Uri.parse(record.url).scheme.isEmpty
                      ? Uri.parse('https://${record.url}')
                      : Uri.parse(record.url));
                  toastification.show(
                    context: context,
                    icon: Icon(Icons.check),
                    type: ToastificationType.success,
                    style: ToastificationStyle.flatColored,
                    title: Text("Opened successfully!"),
                    description:
                        Text("${record.url} has been opened in the default browser!"),
                    alignment: Alignment.bottomCenter,
                    autoCloseDuration: const Duration(seconds: 3),
                    animationBuilder: (
                      context,
                      animation,
                      alignment,
                      child,
                    ) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: highModeShadow,
                    showProgressBar: true,
                    closeButtonShowType: CloseButtonShowType.onHover,
                    dragToClose: true,
                    applyBlurEffect: true,
                  );
                },
                icon: const Icon(
                  Icons.open_in_new,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                icon: const Icon(
                  Icons.copy,
                ),
                onPressed: () {
                  // TODO: Toast
                  Clipboard.setData(ClipboardData(text: record.url));
                  toastification.show(
                    context: context,
                    icon: Icon(Icons.check),
                    type: ToastificationType.success,
                    style: ToastificationStyle.flatColored,
                    title: Text("Copied successfully!"),
                    description:
                        Text("${record.url} has been copied to clipboard!"),
                    alignment: Alignment.bottomCenter,
                    autoCloseDuration: const Duration(seconds: 3),
                    animationBuilder: (
                      context,
                      animation,
                      alignment,
                      child,
                    ) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: highModeShadow,
                    showProgressBar: true,
                    closeButtonShowType: CloseButtonShowType.onHover,
                    dragToClose: true,
                    applyBlurEffect: true,
                  );
                },
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PageEdit(record: record),
                    ),
                  );
                }, // TODO: Implement button
              ),
              SizedBox(
                width: 10,
              ),
              Consumer<SmdbProvider>(
                builder: (context, value, child) => IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    value.softDeleteRecord(record);
          
                    toastification.show(
                      context: context,
                      icon: Icon(Icons.close),
                      type: ToastificationType.error,
                      style: ToastificationStyle.flatColored,
                      title: Text("Moved to trash"),
                      description: Text(
                          "The record with name ${record.name} has been moved to the trash"),
                      alignment: Alignment.bottomCenter,
                      autoCloseDuration: const Duration(seconds: 3),
                      animationBuilder: (
                        context,
                        animation,
                        alignment,
                        child,
                      ) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: highModeShadow,
                      showProgressBar: true,
                      closeButtonShowType: CloseButtonShowType.onHover,
                      dragToClose: true,
                      applyBlurEffect: true,
                    );
          
                    if (onDelete != null) {
                      onDelete!();
                    }
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PageDetails(
                        record: record,
                      ),
                    ),
                  );
                }, // TODO: Implement button
              ),
            ],
          ),
        ),
      ),
    );
  }
}
