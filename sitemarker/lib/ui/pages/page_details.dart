import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/size_config.dart';
import 'package:sitemarker/ui/pages/page_edit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class PageDetails extends StatelessWidget {
  final SmRecord record;
  const PageDetails({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    SizeConfig().initSizes(context);

    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 30,
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PageEdit(
                    record: record,
                  ),
                ),
              );
              if (context.mounted) {
                Navigator.of(context).popUntil((r) => r.isFirst);
              }
              // TODO: Implement the editing stuff
            },
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: Icon(
              Icons.open_in_new,
              size: 30,
            ),
            onPressed: () {
              try{
                launchUrl(Uri.parse(record.url), mode: LaunchMode.externalApplication);
              }on Exception catch(err) {
                print(err);
              }
              // TODO: Implement the opening in new tab stuff
            },
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: Icon(
              Icons.copy,
              size: 30,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: record.url));
              // TODO: Implement the copy to clipboard stuff
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: ListTile(
                tileColor: Theme.of(context).colorScheme.primary,
                minTileHeight: 75,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                titleAlignment: ListTileTitleAlignment.center,
                leading: Text(
                  "Name",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 12,
                  ),
                ),
                title: Text(
                  record.name.length >= 20
                      ? '${record.name.substring(0, 20)}...'
                      : record.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.all(20),
              child: ListTile(
                tileColor: Theme.of(context).colorScheme.primary,
                minTileHeight: 75,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                titleAlignment: ListTileTitleAlignment.center,
                leading: Text(
                  "URL",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 12,
                  ),
                ),
                title: Text(
                  record.name.length >= 20
                      ? '${record.url.substring(0, 20)}...'
                      : record.url,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.all(20),
              child: record.tags.isNotEmpty
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
                                        style: TextStyle(fontSize: 18),
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
            ),
          ],
        ),
      ),
    );
  }
}
