import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sitemarker/animations/bouncy_button.dart'; // The animation file from before

class MainWrapper extends StatefulWidget {
  final Widget child;
  final String location;

  const MainWrapper({super.key, required this.child, required this.location});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  // Helper to determine active index based on URL
  int _getCurrentIndex() {
    if (widget.location.startsWith('/settings')) return 1;
    return 0; // Default to home
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _getCurrentIndex();
    // LOGIC: FAB only exists on the Home page (index 0)
    final bool showFab = selectedIndex == 0;

    return Scaffold(
      // The 'child' is the page content provided by GoRouter
      body: widget.child,

      // --- CONDITIONAL FAB ---
      floatingActionButton: showFab
          ? BouncyButton(
              onPressed: () => debugPrint("FAB Action!"),
              child: SizedBox(
                height: 75,
                width: 75,
                child: FloatingActionButton(
                  shape: CircleBorder(),
                  onPressed: () => debugPrint("FAB Action!"),
                  child: const Icon(
                    Icons.search,
                    size: 40,
                  ),
                ),
              ),
            )
          : null, // Passing null triggers the nice "scale out" exit animation

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- BOTTOM NAVIGATION ---
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // The notch
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home Button
              BouncyButton(
                onPressed: () => context.go('/home'),
                child: _buildIcon(Icons.home, selectedIndex == 0),
              ),

              const SizedBox(width: 48), // Gap for Notch

              // Settings Button
              BouncyButton(
                onPressed: () => context.go('/settings'),
                child: _buildIcon(Icons.settings, selectedIndex == 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData iconData, bool isSelected) {
    return Icon(
      iconData,
      size: 30,
      // TODO: Convert to accent colour
      color: isSelected ? Colors.black54 : Colors.grey,
    );
  }
}
