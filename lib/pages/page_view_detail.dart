import 'package:flutter/material.dart';
import 'package:sitemarker/data/data_model.dart';
import 'package:sitemarker/operations/errors.dart';
import 'package:sitemarker/pages/page_edit.dart';
import 'package:url_launcher/url_launcher.dart';

class PageViewDetail extends StatelessWidget {
  final DBRecord record;

  const PageViewDetail({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final List<String> entryTypes = [
      'Name',
      'URL',
      'Tags',
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
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              leading: icons[index],
              title: Center(
                child: Row(
                  children: [
                    Text(entryTypes[index]),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      entries[index],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 20,
        ),
        itemCount: 3,
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
