import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/size_config.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/ui/pages/page_details.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:sitemarker/ui/pages/page_edit.dart';

class CardBookmark extends StatelessWidget {
  final SmRecord record;

  const CardBookmark({required this.record, super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().initSizes(context);

    return Card(
      elevation: 25.0,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.open_in_new,
                  ),
                  onPressed: () {
                    try {
                       launchUrl(Uri.parse(record.url), mode: LaunchMode.externalApplication);
                    } on Exception catch(err) {
                      // log this later
                      print(err);
                      // TODO
                    }
                  }, // TODO: Implement click
                ),
                IconButton(
                  icon: const Icon(
                    Icons.copy,
                  ),
                  onPressed: () {
                    // TODO: Toast
                    Clipboard.setData(ClipboardData(text: record.url));
                  }, // TODO: Implement click
                ),
              ],
            ), // open in browser and copy
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  child: Text(
                    record.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 45,
                    ),
                  ),
                ),
              ],
            ), // CircleAvatar
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Name'),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 15,
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(record.name),
                      ),
                    ),
                    // Text(name),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('URL'),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 15,
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(record.url),
                      ),
                    ),
                    // Text(url),
                  ],
                ),
                const SizedBox(height: 5),
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
            ), // Details
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
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
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {}, // TODO: Implement button
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
            ), // actions
          ],
        ),
      ),
    );
  }
}
