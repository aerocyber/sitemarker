import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:sitemarker/ui/screens/home_screen.dart';
import 'package:sitemarker/ui/screens/profile_screen.dart';
import 'package:sitemarker/ui/screens/search_screen.dart';
import 'package:sitemarker/ui/screens/settings_screen.dart';
import 'package:sitemarker/ui/screens/records_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final appRouter = GoRouter(
  observers: [routeObserver],
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeUI(navigationShell: navigationShell);
      },

      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const RecordsScreen(folderId: 1),
              routes: [
                GoRoute(
                  path: 'folder/:id',
                  pageBuilder: (context, state) {
                    final folderId = int.parse(
                      state.pathParameters['id'] ?? '1',
                    );

                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: RecordsScreen(folderId: folderId),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            // Define the slide direction (start off-screen to the right)
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;

                            // Use a smooth, native-feeling easing curve
                            var tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: Curves.easeOutCubic));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                    );
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
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
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
