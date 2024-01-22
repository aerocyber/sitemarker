import 'package:flutter/material.dart';

class CardNew extends StatelessWidget {
  const CardNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10,
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Container(
                    width: 20,
                  ),
                  const Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Add Record",
                      ),
                    ],
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
