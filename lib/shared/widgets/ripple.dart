import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/constants/app_colors.dart';

class Ripple extends StatelessWidget {
  const Ripple({
    required this.onTap,
    super.key,
    this.child,
    this.rippleColor = AppColors.defaultRippleColor,
    this.rippleRadius = 8,
  });
  final VoidCallback onTap;
  final Widget? child;
  final Color rippleColor;
  final double rippleRadius;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(rippleRadius),
          highlightColor: rippleColor,
          onTap: onTap,
          child: child,
        ),
      );
}
