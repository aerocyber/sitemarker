import 'package:flutter/material.dart';

class CardBookmarkLarge extends StatelessWidget {
  final String name;
  final String url;
  final String tags;

  const CardBookmarkLarge(
      {super.key, required this.name, required this.url, required this.tags});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 5.0,
      child: Column(
        children: [
          Center(
            child: CircleAvatar(
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(name),
                  Text(url),
                  Wrap(
                    children: [
                      for (String tag in tags.split(','))
                        Chip(
                          label: Text(tag),
                        ),
                    ],
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              Text("Hello"),
            ],
          ),
        ],
      ),
    );
  }
}
