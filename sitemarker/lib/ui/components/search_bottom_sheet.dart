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
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Modern filled search input
              TextField(
                controller: _queryController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search keywords...',
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                ),
                onSubmitted: (_) => _submitSearch(),
              ),
              const SizedBox(height: 16),

              // Cardified Search Scope Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search In',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilterChip(
                            label: const Center(child: Text('Name')),
                            selected: _searchName,
                            onSelected: (val) =>
                                setState(() => _searchName = val),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilterChip(
                            label: const Center(child: Text('URL')),
                            selected: _searchUrl,
                            onSelected: (val) =>
                                setState(() => _searchUrl = val),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Cardified Tag Filter Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter by Tag',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownMenu<String>(
                      expandedInsets: EdgeInsets.zero,
                      hintText: 'Select a tag...',
                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,
                        fillColor: colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      dropdownMenuEntries: availableTags.map((tag) {
                        return DropdownMenuEntry<String>(
                          value: tag,
                          label: tag,
                        );
                      }).toList(),
                      onSelected: (String? newTag) {
                        if (newTag != null && !_selectedTags.contains(newTag)) {
                          setState(() => _selectedTags.add(newTag));
                        }
                      },
                    ),
                    if (_selectedTags.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _selectedTags.map((tag) {
                          return InputChip(
                            label: Text(tag),
                            onDeleted: () =>
                                setState(() => _selectedTags.remove(tag)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: colorScheme.secondaryContainer,
                            deleteIconColor: colorScheme.onSecondaryContainer,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Prominent Action Button
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _submitSearch,
                icon: const Icon(Icons.search),
                label: const Text(
                  'Show Results',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
