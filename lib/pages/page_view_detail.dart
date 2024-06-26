import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sitemarker/data/data_model.dart';
import 'package:sitemarker/operations/errors.dart';
import 'package:sitemarker/pages/page_edit.dart';
import 'package:url_launcher/url_launcher.dart';

class PageViewDetail extends StatelessWidget {
  final SitemarkerRecord record;

  const PageViewDetail({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final List<String> entryTypes = [
      'Name:',
      'URL:',
      'Tags:',
    ];
    final List<String> entries = [
      record.name,
      record.url,
      record.tags,
    ];
    final List<Icon> icons = [
      const Icon(Icons.info),
      const Icon(Icons.link),
      const Icon(Icons.tag),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          record.name,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: record.url));
              const snackBar = SnackBar(
                content: Text("URL copied to clipboard..."),
                duration: Duration(milliseconds: 1500),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: const Icon(Icons.copy),
          ),
          IconButton(
            onPressed: () => launchURL(record.url),
            icon: const Icon(Icons.link),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PageEdit(record: record),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            height: 100,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                icons[index],
                const SizedBox(
                  width: 20,
                ),
                Text(
                  entryTypes[index],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  entries[index],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 25,
          );
        },
        itemCount: entries.length,
      ),
    );
  }

  Future<void> launchURL(String url) async {
    Uri url_ = Uri.parse(url);
    if (!await launchUrl(url_)) {
      throw CouldNotLaunchBrowserException(url);
    }
  }
}
