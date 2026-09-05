import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/providers/folders_provider.dart';
import 'package:sitemarker/core/providers/records_provider.dart';
import 'package:sitemarker/ui/components/add_options_sheet.dart';
import 'package:sitemarker/ui/components/search_bottom_sheet.dart';

class HomeUI extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeUI({super.key, required this.navigationShell});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Assuming 1 is your root folder ID
      context.read<FoldersProvider>().loadRootFolders();
      context.read<RecordsProvider>().loadRecordsByFolder(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    int currentFolderId = 1;

    final isSettings = widget.navigationShell.currentIndex == 1;

    // Check our current route location
    final location = GoRouterState.of(context).uri;
    // If the path starts with /folder/, we are deep in the directory tree
    final canGoBack = location.path.startsWith('/folder/');

    int activeFolderId = 1; // Default to root
    if (canGoBack && location.pathSegments.length == 2) {
      activeFolderId = int.tryParse(location.pathSegments[1]) ?? 1;
    }

    if (activeFolderId != currentFolderId) {
      currentFolderId = activeFolderId;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<RecordsProvider>().loadRecordsByFolder(activeFolderId);
        }
      });
    }

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 16.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 30, left: 30, top: 16),
            child: AppBar(
              leadingWidth: 75,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(30),
              ),
              elevation: 5,
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              actionsPadding: EdgeInsets.all(10),

              centerTitle: true,
              scrolledUnderElevation: 3.0,
              surfaceTintColor: Colors.transparent,
              shadowColor: Theme.of(context).shadowColor.withValues(alpha: 0.4),

              // Dynamically swap the leading icon!
              leading: canGoBack
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () =>
                          context.pop(), // Pop the nested folder route
                    )
                  : IconButton(
                      icon: const Icon(Icons.account_circle_outlined),
                      onPressed: () => context.push('/profile'),
                    ),

              title: const Text(
                'Sitemarker',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => showAddOptionsDialog(
                    context,
                    currentFolderId: activeFolderId,
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
        ),

        body: widget.navigationShell,

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AnimatedScale(
          scale: isSettings ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () => showSearchBottomSheet(context),
            elevation: 2,
            child: const Icon(Icons.search),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            // Using the 32.0 padding that you preferred
            padding: const EdgeInsets.only(
              left: 32.0,
              right: 32.0,
              bottom: 16.0,
            ),
            child: BottomAppBar(
              padding: EdgeInsets.zero,
              // We pass ONLY the host shape (the pill) and omit the guest (the cutout).
              // This gives you a flawless pill shape, and the FAB will hover elegantly over it!
              shape: const AutomaticNotchedShape(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: NavigationBar(
                // You can control the height here so the pill isn't too thick
                height: 60,
                selectedIndex: widget.navigationShell.currentIndex,
                onDestinationSelected: (index) =>
                    widget.navigationShell.goBranch(
                      index,
                      initialLocation:
                          index == widget.navigationShell.currentIndex,
                    ),
                elevation: 0,
                backgroundColor: Colors.transparent,

                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,

                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.bookmarks_outlined),
                    selectedIcon: Icon(Icons.bookmarks),
                    label:
                        'Records', // Still required by the widget, even if hidden
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
