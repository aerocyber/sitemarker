import 'package:material_ui/material_ui.dart';
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
  late Future<List<SmRecord>> _searchResults;

  @override
  void initState() {
    super.initState();

    // Default to both if somehow neither is passed
    final searchN = (!widget.searchName && !widget.searchUrl)
        ? true
        : widget.searchName;
    final searchU = (!widget.searchName && !widget.searchUrl)
        ? true
        : widget.searchUrl;

    // Fire the request immediately on load
    _searchResults = context.read<RecordsProvider>().searchAdvanced(
      nameQuery: searchN ? widget.query : null,
      urlQuery: searchU ? widget.query : null,
      tags: widget.tags.isNotEmpty ? widget.tags : null,
      folderId: -1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        scrolledUnderElevation: 3.0,
      ),
      body: FutureBuilder<List<SmRecord>>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Search error: ${snapshot.error}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final results = snapshot.data ?? [];

          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No bookmarks found.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: results.length,
            padding: const EdgeInsets.only(
              bottom: 80.0,
            ), // Padding for scroll clearance
            itemBuilder: (context, index) {
              return RecordContainer(record: results[index]);
            },
          );
        },
      ),
    );
  }
}
