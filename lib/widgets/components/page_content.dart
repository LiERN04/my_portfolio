import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PageContent extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const PageContent({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isMobile
        ? Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 20.0),
            child: child,
          )
        : Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 40.0),
              child: child,
            ),
          );
  }
}
