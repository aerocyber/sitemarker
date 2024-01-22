import 'package:flutter/material.dart';
import 'package:sitemarker/operations/data_model.dart';
import 'package:sitemarker/operations/errors.dart';
import 'package:url_launcher/url_launcher.dart';

class RecordItem extends StatelessWidget {
  final DBRecord record;

  const RecordItem({super.key, required this.record});

  showAlertDialog(BuildContext context, String url) {
    String alertText =
        'Could not launch $url. Please open a browser and type in the URL';

    AlertDialog ad = AlertDialog(
      title: const Text('Error attempting to open URL'),
      content: Text(alertText),
      actions: [TextButton(onPressed: () {}, child: const Text('OK'))],
    );

    showDialog(context: context, builder: (BuildContext context) => ad);
  }

  Future<void> launchURL(String url) async {
    Uri url_ = Uri.parse(url);
    if (!await launchUrl(url_)) {
      throw CouldNotLaunchBrowserException(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    String domainUrl =
        record.url.split('//')[record.url.split('//').length - 1].split('/')[0];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: ImageIcon(
            NetworkImage('https://icons.duckduckgo.com/ip3/$domainUrl.ico')),
      ),
    );
  }
}
