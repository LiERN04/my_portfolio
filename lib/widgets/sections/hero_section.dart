import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../services/url_launcher_service.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _typewriterController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _typewriterAnimation;

  final List<String> _techTitles = [
    'FullStack Developer',
    'Flutter Enthusiast',
    'Mobile App Creator',
    'Web Developer',
    'Tech Innovator',
  ];

  int _currentTitleIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _typewriterController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(-0.5, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _typewriterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _typewriterController, curve: Curves.easeInOut),
    );

    // _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
    //   CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    // );

    // Start animations
    _startAnimations();

    // // Start floating animation loop
    // _floatingController.repeat(reverse: true);

    // Start title cycling
    _startTitleCycling();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _typewriterController.forward();
  }

  void _startTitleCycling() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (mounted) {
        setState(() {
          _currentTitleIndex = (_currentTitleIndex + 1) % _techTitles.length;
        });
        _typewriterController.reset();
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          _typewriterController.forward();
        }
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Main name with gradient effect
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                      colorScheme.tertiary,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'Hi, I\'m Samuel Leong',
                    style: ResponsiveValue(
                      context,
                      conditionalValues: [
                        Condition.smallerThan(
                          name: TABLET,
                          value: textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      defaultValue: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).value,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 8),

                // Animated typewriter title
                AnimatedBuilder(
                  animation: _typewriterAnimation,
                  builder: (context, child) {
                    final currentTitle = _techTitles[_currentTitleIndex];
                    final visibleLength =
                        (_typewriterAnimation.value * currentTitle.length)
                            .round();
                    final visibleText = currentTitle.substring(
                      0,
                      visibleLength,
                    );

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '> $visibleText',
                          style: ResponsiveValue(
                            context,
                            conditionalValues: [
                              Condition.smallerThan(
                                name: TABLET,
                                value: textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                            defaultValue: textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                              fontFamily: 'monospace',
                            ),
                          ).value,
                        ),
                        // Blinking cursor
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 500),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: (value * 2) % 2 > 1 ? 0.0 : 1.0,
                              child: Text(
                                '|',
                                style: ResponsiveValue(
                                  context,
                                  conditionalValues: [
                                    Condition.smallerThan(
                                      name: TABLET,
                                      value: textTheme.headlineMedium?.copyWith(
                                        color: colorScheme.primary,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                  defaultValue: textTheme.headlineLarge
                                      ?.copyWith(
                                        color: colorScheme.primary,
                                        fontFamily: 'monospace',
                                      ),
                                ).value,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Tech-savvy description with code snippets
                SizedBox(
                  width: ResponsiveValue(
                    context,
                    conditionalValues: [
                      const Condition.smallerThan(
                        name: TABLET,
                        value: double.infinity,
                      ),
                    ],
                    defaultValue: 600.0,
                  ).value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'if (passion === "coding") {',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.85),
                          fontFamily: 'monospace',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'return "Building beautiful, performant applications";',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        '}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.85),
                          fontFamily: 'monospace',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '// 3+ years crafting cross-platform magic',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.secondary,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'monospace',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Animated buttons with hover effects
                Center(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildAnimatedButton(
                        context: context,
                        onPressed: () => UrlLauncherService.openUrl(
                          'mailto:jane@example.com',
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.rocket_launch, size: 18),
                            SizedBox(width: 8),
                            Text('Launch Contact'),
                          ],
                        ),
                        isPrimary: true,
                      ),
                      _buildAnimatedButton(
                        context: context,
                        onPressed: () => UrlLauncherService.openUrl(
                          'https://github.com/janedoe',
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.code, size: 18),
                            SizedBox(width: 8),
                            Text('GitHub.explore()'),
                          ],
                        ),
                        isPrimary: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required Widget child,
    required bool isPrimary,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 1.0, end: 1.0),
      builder: (context, scale, _) {
        return Transform.scale(
          scale: scale,
          child: isPrimary
              ? FilledButton(
                  onPressed: onPressed,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: child,
                )
              : OutlinedButton(
                  onPressed: onPressed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: child,
                ),
        );
      },
    );
  }
}
