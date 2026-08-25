import 'package:go_router/go_router.dart';

import 'package:sitemarker/ui/homepage/home_ui.dart';
import 'package:sitemarker/ui/screens/search_ui.dart';
import 'package:sitemarker/ui/settings_screen.dart';
import 'package:sitemarker/ui/records_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/records',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/records',
              builder: (context, state) => const RecordsScreen(folderId: 1),
              routes: [
                GoRoute(
                  path: 'folder/:id',
                  builder: (context, state) {
                    final folderId = int.parse(
                      state.pathParameters['id'] ?? '1',
                    );
                    // Reusing the consolidated RecordsScreen!
                    return RecordsScreen(folderId: folderId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
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
