import 'package:flutter/material.dart';
import 'package:sitemarker/operations/data_model.dart';
import 'package:sitemarker/pages/page_edit.dart';

class DetailPage extends StatelessWidget {
  final DBRecord record;
  const DetailPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final recordUrl = record.url.split('//');
    final rec = recordUrl[recordUrl.length - 1];
    final url_ = rec.split('/')[0];

    return Scaffold(
        appBar: AppBar(
          title: Text(record.name),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageEdit(
                              record: record,
                            )));
              },
              icon: const Icon(Icons.edit),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ImageIcon(NetworkImage(
                          'https://icons.duckduckgo.com$url_.ico')),
                      Container(
                        width: 20,
                      ),
                      const Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Add Record",
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                  width: 10,
                )
              ],
            ),
          ),
        ));
  }
}
