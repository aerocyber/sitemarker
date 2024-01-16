import 'package:flutter/material.dart';

class DialogInfo extends StatelessWidget {
  final String alertTitle;
  final String alertBody;

  const DialogInfo({super.key, required this.alertTitle, required this.alertBody});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(alertTitle),
      content: Text(alertBody),
      actions: [
        TextButton(onPressed: () {}, child: const Text("OK")),
      ],

    );
  }
}
