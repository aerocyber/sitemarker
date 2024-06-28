import 'package:flutter/material.dart';
import 'package:sitemarker/data/database/database.dart';

class PageViewDetail extends StatelessWidget {
  const PageViewDetail({super.key, required this.record});

  final SitemarkerRecord record;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(record.name),
    );
  }
}
