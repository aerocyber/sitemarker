import 'package:flutter/material.dart';
import 'package:sitemarker/ui/components/card_bookmark.dart';

class SitemarkerPageView extends StatelessWidget {
  const SitemarkerPageView({super.key});

  @override
  Widget build(BuildContext context) {
    //? TODO: implement build

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: CardBookmark(
              name: index.toString(),
              url: 'URL for $index is ${"x" * 100 * index}',
              tags: List.generate(
                index + 1,
                (int index) => index.toString(),
              ).toString(),
            ),
          ),
        ),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          width: 10,
          height: 25,
        ),
        itemCount: 5,
      ),
    );
  }
}
