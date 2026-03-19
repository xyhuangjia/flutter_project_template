/// Typing indicator widget for AI responses.
library;

import 'package:flutter/material.dart';

/// Animated typing indicator with three dots.
class TypingIndicator extends StatefulWidget {
  /// Creates a typing indicator.
  const TypingIndicator({
    super.key,
    this.dotColor,
    this.dotSize = 8,
    this.animationDuration = const Duration(milliseconds: 1200),
  });

  /// Color of the dots.
  final Color? dotColor;

  /// Size of each dot.
  final double dotSize;

  /// Duration of the animation cycle.
  final Duration animationDuration;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();

    // ignore: prefer_int_literals
    _animations = List.generate(
      3,
      (index) => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Curves.easeInOut),
          ),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0).chain(
            CurveTween(curve: Curves.easeInOut),
          ),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: ConstantTween(0.0),
          weight: 50,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.15,
            0.5 + index * 0.15,
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dotColor = widget.dotColor ??
        (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Transform.translate(
              offset: Offset(0, -_animations[index].value * 8),
              child: Container(
                width: widget.dotSize,
                height: widget.dotSize,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
