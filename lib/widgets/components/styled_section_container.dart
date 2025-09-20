import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum SectionStyle { normal, hero, alternate, elevated, gradient }

class StyledSectionContainer extends StatelessWidget {
  final Widget child;
  final SectionStyle style;
  final bool addTopDivider;
  final bool addBottomDivider;

  const StyledSectionContainer({
    super.key,
    required this.child,
    this.style = SectionStyle.normal,
    this.addTopDivider = false,
    this.addBottomDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final stylingData = _getStylingData(context, colorScheme, style);

    Widget section = Container(
      width: double.infinity,
      padding: stylingData.padding,
      decoration: stylingData.decoration,
      child: child,
    );

    // Add dividers if requested
    if (addTopDivider || addBottomDivider) {
      List<Widget> children = [];

      if (addTopDivider) {
        children.add(_buildSectionDivider(colorScheme));
      }

      children.add(section);

      if (addBottomDivider) {
        children.add(_buildSectionDivider(colorScheme));
      }

      section = Column(children: children);
    }

    return section;
  }

  _SectionStyling _getStylingData(
    BuildContext context,
    ColorScheme colorScheme,
    SectionStyle style,
  ) {
    switch (style) {
      case SectionStyle.hero:
        return _SectionStyling(
          decoration: BoxDecoration(
            boxShadow: [
              // Hero section ambient glow
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.08),
                blurRadius: 60,
                spreadRadius: 10,
                offset: const Offset(0, 10),
              ),
              // Subtle secondary glow
              BoxShadow(
                color: colorScheme.secondary.withValues(alpha: 0.05),
                blurRadius: 100,
                spreadRadius: -20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveValue(
              context,
              conditionalValues: [
                const Condition.smallerThan(name: TABLET, value: 16.0),
              ],
              defaultValue: 32.0,
            ).value,
            vertical: 40,
          ),
        );

      case SectionStyle.alternate:
        return _SectionStyling(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            border: Border.symmetric(
              horizontal: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            boxShadow: [
              // Subtle glow effect
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.08),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
              // Additional inner glow
              BoxShadow(
                color: colorScheme.secondary.withValues(alpha: 0.04),
                blurRadius: 40,
                spreadRadius: -5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveValue(
              context,
              conditionalValues: [
                const Condition.smallerThan(name: TABLET, value: 16.0),
              ],
              defaultValue: 32.0,
            ).value,
            vertical: 48,
          ),
        );

      case SectionStyle.elevated:
        return _SectionStyling(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              // Enhanced shadow for better depth in light mode
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
              // Enhanced glow effect
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 30,
                spreadRadius: 3,
                offset: const Offset(0, 0),
              ),
              // Secondary glow layer
              BoxShadow(
                color: colorScheme.tertiary.withValues(alpha: 0.06),
                blurRadius: 50,
                spreadRadius: -10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveValue(
              context,
              conditionalValues: [
                const Condition.smallerThan(name: TABLET, value: 20.0),
              ],
              defaultValue: 40.0,
            ).value,
            vertical: 48,
          ),
        );

      case SectionStyle.gradient:
        return _SectionStyling(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary.withValues(alpha: 0.03),
                colorScheme.secondary.withValues(alpha: 0.03),
                colorScheme.tertiary.withValues(alpha: 0.03),
              ],
            ),
            border: Border.symmetric(
              horizontal: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            boxShadow: [
              // Gradient-themed glow
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.12),
                blurRadius: 25,
                spreadRadius: 1,
                offset: const Offset(-2, -2),
              ),
              BoxShadow(
                color: colorScheme.secondary.withValues(alpha: 0.10),
                blurRadius: 35,
                spreadRadius: 1,
                offset: const Offset(2, 2),
              ),
              // Central soft glow
              BoxShadow(
                color: colorScheme.tertiary.withValues(alpha: 0.08),
                blurRadius: 45,
                spreadRadius: -5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveValue(
              context,
              conditionalValues: [
                const Condition.smallerThan(name: TABLET, value: 16.0),
              ],
              defaultValue: 32.0,
            ).value,
            vertical: 48,
          ),
        );

      case SectionStyle.normal:
        return _SectionStyling(
          decoration: BoxDecoration(
            boxShadow: [
              // Gentle glow for normal sections
              BoxShadow(
                color: colorScheme.outline.withValues(alpha: 0.05),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
              // Very subtle ambient light
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.03),
                blurRadius: 30,
                spreadRadius: -10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveValue(
              context,
              conditionalValues: [
                const Condition.smallerThan(name: TABLET, value: 16.0),
              ],
              defaultValue: 32.0,
            ).value,
            vertical: 32,
          ),
        );
    }
  }

  Widget _buildSectionDivider(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.outline.withValues(alpha: 0.0),
                    colorScheme.outline.withValues(alpha: 0.3),
                    colorScheme.outline.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.code,
              size: 16,
              color: colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.outline.withValues(alpha: 0.0),
                    colorScheme.outline.withValues(alpha: 0.3),
                    colorScheme.outline.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionStyling {
  final BoxDecoration decoration;
  final EdgeInsets padding;

  const _SectionStyling({required this.decoration, required this.padding});
}
