import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/size_config.dart';

class CardBookmark extends StatelessWidget {
  final String name;
  final String url;
  final String tags;

  const CardBookmark(
      {required this.name, required this.url, required this.tags, super.key});

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Name'),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 15,
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(name),
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
                        child: Text(url),
                      ),
                    ),
                    // Text(url),
                  ],
                ),
                const SizedBox(height: 5),
                tags.isNotEmpty ? SingleChildScrollView(
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
                ) : const Text(
                  'Not tagged',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15,),
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
