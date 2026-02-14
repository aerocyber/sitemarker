import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sitemarker/pages/settings_page.dart';
import 'package:sitemarker/ui_desktop/home_screen.dart';
import 'package:sitemarker/ui_desktop/main_wrapper.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final List<GoRoute> routes = [
  GoRoute(
    path: '/home',
    builder: (context, state) => const SitemarkerHomeScreen(),
  ),
  GoRoute(
    path: '/settings',
    builder: (context, state) => const SettingsPage(),
  )
];

final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainWrapper(
            location: state.uri.toString(),
            child: child,
          );
        },
        routes: routes,
      )
    ]);
