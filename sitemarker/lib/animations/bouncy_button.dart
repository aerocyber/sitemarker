import 'package:flutter/material.dart';

class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const BouncyButton({super.key, required this.child, required this.onPressed});

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // Fast response
      lowerBound: 0.0,
      upperBound: 0.15, // How much to shrink (0.15 = shrink to 85%)
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 1. Shrink on tap down
      onTapDown: (_) => _controller.forward(),
      // 2. Grow back on tap up/cancel
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),

      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Invert the value so controller 0.0 -> scale 1.0
          // controller 0.15 -> scale 0.85
          return Transform.scale(
            scale: 1.0 - _controller.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
