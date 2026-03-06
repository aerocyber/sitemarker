import 'package:flutter/material.dart';

class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const BouncyButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // Fast, snappy response
      lowerBound: 0.0,
      upperBound: 0.05, // Shrink to 95% size
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed(); // Trigger the actual action
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior:
          HitTestBehavior.opaque, // Ensures taps inside empty spaces are caught
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - _controller.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
