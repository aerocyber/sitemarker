import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/size_config.dart';

class BottomNavBarBtn extends StatelessWidget {
  const BottomNavBarBtn({
    super.key,
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onPressed,
    required this.toolTip,
  });

  final IconData icon;
  final int index;
  final int currentIndex;
  final Function(int) onPressed;
  final String toolTip;

  @override
  Widget build(BuildContext context) {
    SizeConfig().initSizes(context);
    
    return IconButton(
      icon: AnimatedOpacity(
        opacity: (currentIndex == index) ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 500),
        child: Icon(icon),
      ),
      iconSize: 28,
      tooltip: toolTip,
      onPressed: () {
        onPressed(index);
      },
      focusColor: Theme.of(context).colorScheme.primary,
      color: Theme.of(context).colorScheme.secondary,
    );
  }
}
