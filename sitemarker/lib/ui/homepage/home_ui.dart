import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final isSettings = navigationShell.currentIndex == 1;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leadingWidth: 75,
        leading: IconButton(
          icon: const Icon(Icons.account_circle_outlined, size: 30),
          onPressed: () {},
        ),
        title: const Text('Sitemarker'),
        centerTitle: true,
        actions: [
          // TODO: Add a new record.
          IconButton(icon: const Icon(Icons.add, size: 30), onPressed: () {}),
          SizedBox(width: 50),
        ],
      ),
      body: navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedScale(
        scale: isSettings ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        child: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () => context.go('/search'),
          elevation: 2,
          child: const Icon(Icons.search),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: isSettings ? null : const CircularNotchedRectangle(),
        notchMargin: 8.0,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmarks_outlined),
              activeIcon: Icon(Icons.bookmarks),
              label: 'Records',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
