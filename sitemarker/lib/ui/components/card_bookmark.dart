import 'package:flutter/material.dart';

class CardBookmark extends StatelessWidget {
  final String name;
  final String url;
  final String tags;

  const CardBookmark(
      {super.key, required this.name, required this.url, required this.tags});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 25.0,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
              children: [
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Name"),
                    Text(name),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("URL"),
                    Text(url),
                  ],
                ),
                const SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
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
              children: [
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
