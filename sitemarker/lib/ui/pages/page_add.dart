import 'package:flutter/material.dart';
import 'package:sitemarker/ui/pages/home_screen.dart';
import 'package:validators/validators.dart' as validator;

class PageAdd extends StatelessWidget {
  const PageAdd({super.key, required this.receivingData});

  final String? receivingData;

  @override
  Widget build(BuildContext context) {
    if (receivingData != null &&
        receivingData!.isNotEmpty &&
        !validator.isURL(receivingData)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Invalid URL: $receivingData"),
            const SizedBox(height: 20),
            TextButton(
              child: const Text('Go back'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SMHomeScreen(url: null),
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else if (receivingData != null && receivingData!.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Valid URL: $receivingData"),
            const SizedBox(height: 20),
            TextButton(
              child: const Text('Go back'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SMHomeScreen(url: null),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
    return Center(
      child: Text(
        'No URL received',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
