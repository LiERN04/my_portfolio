import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SectionDivider extends StatelessWidget {
  final double? height;
  final Color? color;

  const SectionDivider({super.key, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Container(
      height: height ?? (isMobile ? 60 : 80),
      width: double.infinity,
      color: color ?? colorScheme.surface.withValues(alpha: 0.02),
    );
  }
}
