import 'package:flutter/material.dart';

class PageAdd extends StatelessWidget {
  const PageAdd({super.key, required this.receivingData});

  final String? receivingData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        receivingData ?? 'No data',
      ),
    );
  }
}
