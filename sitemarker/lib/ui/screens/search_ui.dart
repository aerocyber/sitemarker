import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final String query;
  final List<String> tags;
  final bool searchName;
  final bool searchUrl;

  const SearchScreen({
    super.key,
    required this.query,
    required this.tags,
    required this.searchName,
    required this.searchUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.manage_search, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Query: ${query.isEmpty ? "None" : query}'),
            Text('Tags: ${tags.isEmpty ? "None" : tags.join(", ")}'),
            Text('Search in Name: $searchName'),
            Text('Search in URL: $searchUrl'),
            const SizedBox(height: 32),
            const Text(
              'Search Results will appear here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
