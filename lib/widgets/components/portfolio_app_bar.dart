import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/providers/theme_provider.dart';

class PortfolioAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PortfolioAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      automaticallyImplyLeading: false,
      title: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(-20 * (1 - value), 0),
            child: Opacity(
              opacity: value,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.code, color: colorScheme.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'samuel.portfolio',
                    style: textTheme.titleLarge?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        // Theme toggle
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    key: ValueKey(isDark),
                  ),
                ),
                onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
                tooltip: isDark ? 'Light Mode' : 'Dark Mode',
              ),
            );
          },
        ),
      ],
      elevation: 2,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
