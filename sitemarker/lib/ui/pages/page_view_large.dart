import 'package:flutter/material.dart';

class PageViewLarge extends StatelessWidget {
  const PageViewLarge({super.key});

  @override
  Widget build(BuildContext context) {
    //? TODO: implement build
    return Scaffold(bottomNavigationBar: LayoutBuilder(
      builder: (context, constraints) {
        print(constraints.maxWidth); //! FIXME: Replace with logger
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
                          //? TODO Home screen
                        },
                        icon: const Icon(Icons.home),
                      ),
                      IconButton(
                        onPressed: () {
                          //? TODO Settings screen
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
    ));
  }
}
