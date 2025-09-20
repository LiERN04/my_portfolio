import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SectionContainer extends StatelessWidget {
  final String sectionId;
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool showDivider;

  const SectionContainer({
    super.key,
    required this.sectionId,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Container(
      width: double.infinity,
      color: backgroundColor,
      child: Column(
        children: [
          if (showDivider && sectionId != 'hero')
            Container(
              height: isMobile ? 60 : 80,
              width: double.infinity,
              color: colorScheme.surface.withValues(alpha: 0.02),
            ),
          Container(
            padding:
                padding ??
                EdgeInsets.symmetric(
                  vertical: isMobile ? 60 : 80,
                  horizontal: isMobile ? 20 : 40,
                ),
            child: child,
          ),
        ],
      ),
    );
  }
}
