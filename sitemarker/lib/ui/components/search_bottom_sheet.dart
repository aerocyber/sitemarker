import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/providers/tags_provider.dart';

Future<void> showSearchBottomSheet(BuildContext context) async {
  final parentTheme = Theme.of(context);

  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: parentTheme.colorScheme.surface,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) =>
        Theme(data: parentTheme, child: const SearchBottomSheet()),
  );
}

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final _queryController = TextEditingController();
  bool _searchName = true;
  bool _searchUrl = true;
  final List<String> _selectedTags = [];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    // 1. Validation Check: If no filters are active and no tags are selected
    if (!_searchName && !_searchUrl && _selectedTags.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded),
          title: const Text('Invalid Search'),
          content: const Text(
            'Please select at least one search field (Name or URL) or choose a Tag to filter by.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; // Halt execution so the sheet stays open
    }

    final queryText = _queryController.text.trim();

    // 2. If everything is valid but completely empty, just close the sheet quietly
    if (queryText.isEmpty && _selectedTags.isEmpty) {
      Navigator.pop(context);
      return;
    }

    // 3. Compile the URL parameters
    final queryParams = <String, String>{};
    if (queryText.isNotEmpty) queryParams['q'] = queryText;
    if (_selectedTags.isNotEmpty) queryParams['tags'] = _selectedTags.join(',');
    if (_searchName) queryParams['name'] = 'true';
    if (_searchUrl) queryParams['url'] = 'true';

    // 4. Close the sheet and navigate
    Navigator.pop(context);

    context.push(Uri(path: '/search', queryParameters: queryParams).toString());
  }

  @override
  Widget build(BuildContext context) {
    final tagsProvider = context.watch<TagsProvider>();
    final availableTags = tagsProvider.allTags.expand((m) => m.values).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.0,
        right: 20.0,
        top: 8.0,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Advanced Search',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Query Input
              TextField(
                controller: _queryController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Search keywords...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (_) => _submitSearch(),
              ),
              const SizedBox(height: 16),

              // Filter Toggles
              Row(
                children: [
                  FilterChip(
                    label: const Text('Name'),
                    selected: _searchName,
                    onSelected: (val) => setState(() => _searchName = val),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('URL'),
                    selected: _searchUrl,
                    onSelected: (val) => setState(() => _searchUrl = val),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tag Dropdown
              DropdownMenu<String>(
                expandedInsets: EdgeInsets.zero,
                label: const Text('Filter by Tag'),
                dropdownMenuEntries: availableTags.map((tag) {
                  return DropdownMenuEntry<String>(value: tag, label: tag);
                }).toList(),
                onSelected: (String? newTag) {
                  if (newTag != null && !_selectedTags.contains(newTag)) {
                    setState(() => _selectedTags.add(newTag));
                  }
                },
              ),

              // Active Tag Chips
              if (_selectedTags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: _selectedTags.map((tag) {
                      return InputChip(
                        label: Text(tag),
                        onDeleted: () =>
                            setState(() => _selectedTags.remove(tag)),
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submitSearch,
                icon: const Icon(Icons.search),
                label: const Text('Show Results'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
