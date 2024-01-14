import 'package:flutter/material.dart';

class CardDelete extends StatelessWidget {
  const CardDelete({super.key});

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
                const Icon(Icons.delete),
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
                      "Delete Record",
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
