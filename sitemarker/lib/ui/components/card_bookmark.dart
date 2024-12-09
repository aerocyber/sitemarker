import 'package:flutter/material.dart';

class CardBookmark extends StatelessWidget {
  final String name;
  final String url;
  final String tags;

  const CardBookmark(
      {required this.name, required this.url, required this.tags, super.key});

  @override
  Widget build(BuildContext context) {
    String domainUrl = url.split('//')[url.split('//').length - 1];
    String domain = '${domainUrl.split('/')[0]}...';
    if (domain.length > 50) {
      domain = '${domainUrl.split('/')[0][50]}...';
    }
    // TODO: implement build
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
                  onPressed: () {}, // TODO: Implement click
                ),
                IconButton(
                  icon: const Icon(
                    Icons.copy,
                  ),
                  onPressed: () {}, // TODO: Implement click
                ),
              ],
            ), // open in browser and copy
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  child: Text(
                    name[0].toUpperCase(),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const Text('Name'),
                    Text(name),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const Text('URL'),
                    Text(url.length < 50 ? url : domain),
                  ],
                ),
                const SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      for (int i = 0; i < tags.split(',').length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Chip(
                            label: Text(
                              tags.split(',')[i].trim(),
                            ),
                          ),
                        )
                    ],
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
                  onPressed: () {}, // TODO: Implement button
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {}, // TODO: Implement button
                ),
                IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {}, // TODO: Implement button
                ),
              ],
            ), // actions
          ],
        ),
      ),
    );
  }
}
