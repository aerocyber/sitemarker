import 'package:go_router/go_router.dart';
import 'package:sitemarker/ui/homepage/home_ui.dart';
import 'package:sitemarker/ui/folders/folder_ui.dart';
import 'package:sitemarker/ui/screens/search_ui.dart';

final appRouter = GoRouter(
  initialLocation: '/', // The default route when the app boots
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      // The folder parameter route we discussed earlier
      path: '/folder/:id',
      builder: (context, state) {
        final folderId = int.parse(state.pathParameters['id'] ?? '1');
        return FolderScreen(folderId: folderId);
      },
    ),
    GoRoute(
      // The search route expecting query parameters like ?q=xyz&name=true
      path: '/search',
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        final tagsParam = state.uri.queryParameters['tags'] ?? '';
        final tags = tagsParam.isNotEmpty ? tagsParam.split(',') : <String>[];
        final searchName = state.uri.queryParameters['name'] == 'true';
        final searchUrl = state.uri.queryParameters['url'] == 'true';

        return SearchScreen(
          query: query,
          tags: tags,
          searchName: searchName,
          searchUrl: searchUrl,
        );
      },
    ),
  ],
);
