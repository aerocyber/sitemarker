import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/core/providers/records_provider.dart';
import 'package:sitemarker/ui/records/record_container.dart';

class SearchScreen extends StatefulWidget {
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
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  Future<List<SmRecord>>? _searchResults;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
    if (widget.query.isNotEmpty) {
      _executeSearch(widget.query);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _executeSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = null);
      return;
    }

    // Sync the route for clean browser history
    context.replace(
      Uri(path: '/search', queryParameters: {'q': query}).toString(),
    );

    // Trigger the DB fetch
    setState(() {
      _searchResults = context.read<RecordsProvider>().searchRecords(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Floating Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBar(
                controller: _searchController,
                autoFocus: widget.query.isEmpty,
                hintText: 'Search bookmarks...',
                hintStyle: WidgetStateProperty.all(
                  TextStyle(color: Theme.of(context).colorScheme.surface),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                textStyle: WidgetStateProperty.all(
                  TextStyle(color: Theme.of(context).colorScheme.surface),
                ),
                trailing: [
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _executeSearch('');
                      },
                    ),
                ],
                onSubmitted: _executeSearch,
                elevation: WidgetStateProperty.all(
                  2.0,
                ), // Gives it a nice floating shadow
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),

            // 2. Search Results
            Expanded(
              child: _searchResults == null
                  ? _buildEmptyState()
                  : _buildResultsView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.manage_search,
            size: 64,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Type to search records',
            style: TextStyle(color: Theme.of(context).colorScheme.surface),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    return FutureBuilder<List<SmRecord>>(
      future: _searchResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Search error: ${snapshot.error}'));
        }

        final results = snapshot.data ?? [];

        if (results.isEmpty) {
          return const Center(child: Text('No bookmarks found.'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            // Render your newly polished M3 cards!
            return RecordContainer(record: results[index]);
          },
        );
      },
    );
  }
}
