import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/ui/pages/page_details.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/db/smdb_provider.dart';
import 'package:toastification/toastification.dart';

class CardDeleteBookmark extends StatelessWidget {
  final SmRecord record;

  const CardDeleteBookmark({required this.record, super.key});

  @override
  Widget build(BuildContext context) {
    // return Card(
    //   elevation: 25.0,
    //   color: Theme.of(context).colorScheme.inversePrimary,
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: <Widget>[
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    // IconButton(
    //   onPressed: () {
    //     launchUrl(Uri.parse(record.url).scheme.isEmpty
    //         ? Uri.parse('https://${record.url}')
    //         : Uri.parse(record.url));
    //     toastification.show(
    //       context: context,
    //       icon: Icon(Icons.check),
    //       type: ToastificationType.success,
    //       style: ToastificationStyle.flatColored,
    //       title: Text("Copied successfully!"),
    //       description:
    //           Text("${record.url} has been copied to clipboard!"),
    //       alignment: Alignment.bottomCenter,
    //       autoCloseDuration: const Duration(seconds: 3),
    //       animationBuilder: (
    //         context,
    //         animation,
    //         alignment,
    //         child,
    //       ) {
    //         return ScaleTransition(
    //           scale: animation,
    //           child: child,
    //         );
    //       },
    //       borderRadius: BorderRadius.circular(12.0),
    //       boxShadow: highModeShadow,
    //       showProgressBar: true,
    //       closeButtonShowType: CloseButtonShowType.onHover,
    //       dragToClose: true,
    //       applyBlurEffect: true,
    //     );
    //   },
    //   icon: const Icon(
    //     Icons.open_in_new,
    //   ),
    // ),
    // IconButton(
    //   icon: const Icon(
    //     Icons.copy,
    //   ),
    //   onPressed: () {
    //     // TODO: Toast
    //     Clipboard.setData(ClipboardData(text: record.url));
    //     toastification.show(
    //       context: context,
    //       icon: Icon(Icons.check),
    //       type: ToastificationType.success,
    //       style: ToastificationStyle.flatColored,
    //       title: Text("Copied successfully!"),
    //       description:
    //           Text("${record.url} has been copied to clipboard!"),
    //       alignment: Alignment.bottomCenter,
    //       autoCloseDuration: const Duration(seconds: 3),
    //       animationBuilder: (
    //         context,
    //         animation,
    //         alignment,
    //         child,
    //       ) {
    //         return ScaleTransition(
    //           scale: animation,
    //           child: child,
    //         );
    //       },
    //       borderRadius: BorderRadius.circular(12.0),
    //       boxShadow: highModeShadow,
    //       showProgressBar: true,
    //       closeButtonShowType: CloseButtonShowType.onHover,
    //       dragToClose: true,
    //       applyBlurEffect: true,
    //     );
    //   },
    // ),
    //           ],
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    // CircleAvatar(
    //   radius: 50,
    // child: Text(
    //   record.name[0].toUpperCase(),
    //   style: const TextStyle(
    //     fontSize: 45,
    //   ),
    // ),
    // ),
    //           ],
    //         ), // CircleAvatar
    //         const SizedBox(height: 20),
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: <Widget>[
    //                 const Text('Name'),
    //                 SizedBox(
    //                   width: SizeConfig.blockSizeHorizontal * 15,
    //                 ),
    //                 Flexible(
    //                   child: SingleChildScrollView(
    //                     scrollDirection: Axis.horizontal,
    //                     child: Text(record.name),
    //                   ),
    //                 ),
    //                 // Text(name),
    //               ],
    //             ),
    //             const SizedBox(height: 5),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: <Widget>[
    //                 const Text('URL'),
    //                 SizedBox(
    //                   width: SizeConfig.blockSizeHorizontal * 15,
    //                 ),
    //                 Flexible(
    //                   child: SingleChildScrollView(
    //                     scrollDirection: Axis.horizontal,
    //                     child: Text(record.url),
    //                   ),
    //                 ),
    //                 // Text(url),
    //               ],
    //             ),
    //             const SizedBox(height: 5),
    //             record.tags.isNotEmpty
    //                 ? SingleChildScrollView(
    //                     scrollDirection: Axis.horizontal,
    //                     child: Row(
    //                       children: <Widget>[
    //                         for (int i = 0;
    //                             i < record.tags.split(',').length;
    //                             i++)
    //                           record.tags.split(',')[i].trim().isNotEmpty
    //                               ? Padding(
    //                                   padding: const EdgeInsets.all(8.0),
    //                                   child: Chip(
    //                                     label: Text(
    //                                       record.tags.split(',')[i].trim(),
    //                                     ),
    //                                   ),
    //                                 )
    //                               : Container(),
    //                       ],
    //                     ),
    //                   )
    //                 : const Text(
    //                     'Not tagged',
    //                     style: TextStyle(
    //                       fontStyle: FontStyle.italic,
    //                       fontSize: 15,
    //                     ),
    //                   ),
    //           ],
    //         ), // Details
    //         const SizedBox(height: 10),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: <Widget>[
    // IconButton(
    //   icon: const Icon(Icons.edit),
    //   onPressed: () {
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (context) => PageEdit(record: record),
    //       ),
    //     );
    //   }, // TODO: Implement button
    // ),
    // IconButton(
    //   icon: const Icon(Icons.delete),
    //   onPressed: () {
    //     Provider.of<SmdbProvider>(context, listen: false)
    //         .deleteRecord(record);
    //     toastification.show(
    //       context: context,
    //       icon: Icon(Icons.close),
    //       type: ToastificationType.error,
    //       style: ToastificationStyle.flatColored,
    //       title: Text("Moved to trash"),
    //       description: Text(
    //           "The record with name ${record.name} has been moved to the trash"),
    //       alignment: Alignment.bottomCenter,
    //       autoCloseDuration: const Duration(seconds: 3),
    //       animationBuilder: (
    //         context,
    //         animation,
    //         alignment,
    //         child,
    //       ) {
    //         return ScaleTransition(
    //           scale: animation,
    //           child: child,
    //         );
    //       },
    //       borderRadius: BorderRadius.circular(12.0),
    //       boxShadow: highModeShadow,
    //       showProgressBar: true,
    //       closeButtonShowType: CloseButtonShowType.onHover,
    //       dragToClose: true,
    //       applyBlurEffect: true,
    //     );
    //   },
    // ),
    // IconButton(
    //   icon: const Icon(Icons.info),
    //   onPressed: () {
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (context) => PageDetails(
    //           record: record,
    //         ),
    //       ),
    //     );
    //   }, // TODO: Implement button
    // ),
    //           ],
    //         ), // actions
    //       ],
    //     ),
    //   ),
    // );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minTileHeight: 75,
        titleAlignment: ListTileTitleAlignment.center,
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
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        record.name,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        record.url,
                      ),
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
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                Provider.of<SmdbProvider>(context, listen: false)
                    .deleteRecordPermanently(record);
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
              },
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
    );
  }
}
