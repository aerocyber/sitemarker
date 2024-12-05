import 'package:flutter/material.dart';
import 'package:sitemarker/ui/components/card_bookmark.dart';
import 'package:sitemarker/ui/pages/page_settings.dart';

class SitemarkerPageView extends StatelessWidget {
  const SitemarkerPageView({super.key});

  @override
  Widget build(BuildContext context) {
    //? TODO: implement build

    return Scaffold(
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.minWidth >= 880) {
            // laptops/desktops
            return Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    height: 75,
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SitemarkerPageView(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.home),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PageSettings(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 150,
                  ),
                  Container(
                    width: 175,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            //? TODO: Add entry
                          },
                          icon: const Icon(Icons.add),
                        ),
                        IconButton(
                          onPressed: () {
                            //? TODO: Search
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (constraints.maxWidth > 600) {
            //? TODO: Medium devices
            return Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    height: 75,
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            //? TODO Menu screen
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        IconButton(
                          onPressed: () {
                            //? TODO Add item
                          },
                          icon: const Icon(Icons.add),
                        ),
                        IconButton(
                          onPressed: () {
                            //? TODO Search item
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (constraints.maxWidth > 250) {
            //? TODO: Small devices
            return Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    height: 75,
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            //? TODO Menu screen
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        IconButton(
                          onPressed: () {
                            //? TODO Add item
                          },
                          icon: const Icon(Icons.add),
                        ),
                        IconButton(
                          onPressed: () {
                            //? TODO Search item
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            //? TODO: Tiny devices
            return Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    height: 75,
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            //? TODO Menu screen
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        IconButton(
                          onPressed: () {
                            //? TODO Menu screen
                          },
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1065) {
            return GridView.count(
              crossAxisCount: 3,
              children: List.generate(10, (index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CardBookmark(
                    name: "Name$index",
                    url: "URL$index",
                    tags: List.generate(index + 1, (i) {
                      return "Tags$i";
                    }).join(','),
                  ),
                );
              }),
            );
          } else {
            return ListView.separated(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: CardBookmark(
                  name: "Name$index",
                  url: "URL$index",
                  tags: List.generate(index + 1, (i) {
                    return "Tags$i";
                  }).join(','),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(
                height: 25,
                width: 25,
              ),
              itemCount: 10,
            );
          }
        },
      ),
    );
  }
}
