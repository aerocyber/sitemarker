import 'package:flutter/material.dart';

class CardEdit extends StatelessWidget {
  const CardEdit({super.key});

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
                const Icon(Icons.edit),
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
                      "Edit Record",
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
