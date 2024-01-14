import 'package:flutter/material.dart';

class CardAdd extends StatelessWidget {
  const CardAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.add),
                Container(
                  width: 15,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 5,
                    ),
                    const Text(
                      "Add Record",
                    ),
                    Container(
                      height: 5,
                    ),
                  ],
                )),
                Container(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
