import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration:
                BoxDecoration(color: Color.fromARGB(255, 175, 188, 207)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Options",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 34, 34, 34),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text(
              "Report Issue",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 157, 43, 43),
              ),
            ),
            onTap: () => {}, // TODO: Implement navigation to About page
          ),
          ListTile(
            title: const Text(
              "Donate",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 74, 201, 63),
              ),
            ),
            onTap: () => {}, // TODO: Implement navigation to About page
          ),
          ListTile(
            title: const Text(
              "About",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            ),
            onTap: () => {}, // TODO: Implement navigation to About page
          ),
          ListTile(
            title: const Text(
              "Licenses",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            ),
            onTap: () => {}, // TODO: Implement navigation to licenses page
          )
        ],
      ),
    );
  }
}
