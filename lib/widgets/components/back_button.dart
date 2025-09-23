import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A reusable back button component that provides consistent styling and behavior
/// across all detail screens in the application.
///
/// Example usage:
/// ```dart
/// // Basic usage with defaults
/// CustomBackButton()
///
/// // Custom label and icon
/// CustomBackButton(
///   label: 'Go Back',
///   icon: Icons.arrow_back_ios,
/// )
///
/// // Custom navigation behavior
/// CustomBackButton(
///   onPressed: () => context.go('/custom-route'),
/// )
/// ```
class CustomBackButton extends StatelessWidget {
  /// The text to display on the button. Defaults to 'Back'.
  final String? label;

  /// Custom onPressed callback. If not provided, uses default navigation behavior.
  final VoidCallback? onPressed;

  /// The icon to display. Defaults to Icons.arrow_back.
  final IconData? icon;

  /// Additional padding for the button. If not provided, uses default padding.
  final EdgeInsetsGeometry? padding;

  const CustomBackButton({
    super.key,
    this.label,
    this.onPressed,
    this.icon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: onPressed ?? () => context.pop(),
        icon: Icon(icon ?? Icons.arrow_back),
        label: Text(label ?? 'Back'),
        style: OutlinedButton.styleFrom(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
