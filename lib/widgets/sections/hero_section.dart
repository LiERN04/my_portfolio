import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late AnimationController _colorController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _typewriterAnimation;
  late Animation<double> _colorAnimation;

  final List<String> _techTitles = [
    'FullStack_Developer_',
    'Mobile_App_Creator_',
    'Web_Developer_',
  ];

  final List<String> _skills = [
    'Flutter',
    'ReactJS',
    'Dart',
    'JavaScript',
    'Python',
    'Firebase',
    'NodeJS',
    'MongoDB',
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

    _colorController = AnimationController(
      duration: const Duration(seconds: 4), // Slow 4-second cycle
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

    _colorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _colorController, curve: Curves.easeInOut),
    );

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

    // Start the color animation loop after other animations complete
    await Future.delayed(const Duration(milliseconds: 1000));
    _colorController.repeat(reverse: true);
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
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Main name with mixed static and animated text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Static "Hi, I'm" - theme aware
                    Text(
                      'Hi, I\'m ',
                      style: ResponsiveValue(
                        context,
                        conditionalValues: [
                          Condition.smallerThan(
                            name: TABLET,
                            value: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              fontSize: 48.0,
                            ),
                          ),
                        ],
                        defaultValue: textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          fontSize: 64.0,
                        ),
                      ).value,
                    ),
                    // Animated "Samuel Leong" with color animation
                    AnimatedBuilder(
                      animation: _colorAnimation,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (bounds) {
                            final progress = _colorAnimation.value;

                            // Create smooth color transitions between theme colors
                            final color1 = Color.lerp(
                              colorScheme.primary,
                              colorScheme.secondary,
                              progress,
                            )!;
                            final color2 = Color.lerp(
                              colorScheme.secondary,
                              colorScheme.tertiary,
                              progress,
                            )!;
                            final color3 = Color.lerp(
                              colorScheme.tertiary,
                              colorScheme.primary,
                              progress,
                            )!;

                            return LinearGradient(
                              colors: [color1, color2, color3],
                            ).createShader(bounds);
                          },
                          child: Text(
                            'Samuel Leong',
                            style: ResponsiveValue(
                              context,
                              conditionalValues: [
                                Condition.smallerThan(
                                  name: TABLET,
                                  value: textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 48.0,
                                  ),
                                ),
                              ],
                              defaultValue: textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 64.0,
                              ),
                            ).value,
                          ),
                        );
                      },
                    ),
                  ],
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
                                value: GoogleFonts.sourceCodePro(
                                  fontWeight: FontWeight.w400,
                                  color: colorScheme.onSurface,
                                  fontSize: 36.0,
                                ),
                              ),
                            ],
                            defaultValue: GoogleFonts.sourceCodePro(
                              fontWeight: FontWeight.w400,
                              color: colorScheme.onSurface,
                              fontSize: 42.0,
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
                                      value: GoogleFonts.sourceCodePro(
                                        color: colorScheme.onSurface,
                                        fontSize: 36.0,
                                      ),
                                    ),
                                  ],
                                  defaultValue: GoogleFonts.sourceCodePro(
                                    color: colorScheme.onSurface,
                                    fontSize: 52.0,
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
                    defaultValue: 900.0,
                  ).value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Code block - seamless with background
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'if (passion === "coding") {',
                            style: GoogleFonts.sourceCodePro(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              'return "Building beautiful, performant applications";',
                              style: GoogleFonts.sourceCodePro(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '}',
                            style: GoogleFonts.sourceCodePro(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildSkillBubbles(context, colorScheme),
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
                          'mailto:likernleong8@gmail.com',
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.rocket_launch, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Launch Contact',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        isPrimary: true,
                      ),
                      _buildAnimatedButton(
                        context: context,
                        onPressed: () => UrlLauncherService.openUrl(
                          'https://github.com/LiERN04',
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.code, size: 20),
                            SizedBox(width: 10),
                            Text(
                              ' View GitHub',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
    return _AnimatedHoverButton(
      onPressed: onPressed,
      isPrimary: isPrimary,
      child: child,
    );
  }

  Widget _buildSkillBubbles(BuildContext context, ColorScheme colorScheme) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: _skills.map((skill) {
        return _SkillBubble(
          skill: skill,
          colorScheme: colorScheme,
          animationValue: 1.0,
        );
      }).toList(),
    );
  }
}

class _AnimatedHoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isPrimary;
  final Widget child;

  const _AnimatedHoverButton({
    required this.onPressed,
    required this.isPrimary,
    required this.child,
  });

  @override
  State<_AnimatedHoverButton> createState() => _AnimatedHoverButtonState();
}

class _AnimatedHoverButtonState extends State<_AnimatedHoverButton>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late AnimationController _glowController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _glowAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutBack),
    );

    _elevationAnimation = Tween<double>(begin: 3.0, end: 12.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _hoverController.forward();
      _glowController.repeat(reverse: true);
    } else {
      _hoverController.reverse();
      _glowController.stop();
      _glowController.reset();
    }
  }

  void _onTapDown() {
    setState(() {
      _isPressed = true;
    });
    _pressController.forward();
  }

  void _onTapUp() {
    setState(() {
      _isPressed = false;
    });
    _pressController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTapDown: (_) => _onTapDown(),
        onTapUp: (_) => _onTapUp(),
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _hoverController,
            _pressController,
            _glowController,
          ]),
          builder: (context, child) {
            final scale = _isPressed
                ? _scaleAnimation.value * 0.95
                : _scaleAnimation.value;

            return Transform.scale(
              scale: scale,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    // Main shadow
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: _elevationAnimation.value * 1.5,
                      offset: Offset(0, _elevationAnimation.value * 0.8),
                      spreadRadius: 1,
                    ),
                    // Secondary shadow for depth
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: _elevationAnimation.value * 2.5,
                      offset: Offset(0, _elevationAnimation.value * 1.2),
                      spreadRadius: 2,
                    ),
                    // Glow effect when hovered
                    if (_isHovered) ...[
                      BoxShadow(
                        color:
                            (widget.isPrimary
                                    ? colorScheme.primary
                                    : colorScheme.secondary)
                                .withValues(alpha: 0.4 * _glowAnimation.value),
                        blurRadius: 25,
                        spreadRadius: 3,
                      ),
                      // Inner glow
                      BoxShadow(
                        color:
                            (widget.isPrimary
                                    ? colorScheme.primary
                                    : colorScheme.secondary)
                                .withValues(alpha: 0.2 * _glowAnimation.value),
                        blurRadius: 15,
                        spreadRadius: -1,
                      ),
                    ],
                  ],
                ),
                child: widget.isPrimary
                    ? Container(
                        decoration: BoxDecoration(
                          gradient: _isHovered
                              ? LinearGradient(
                                  colors: [
                                    colorScheme.primary,
                                    colorScheme.primary.withValues(alpha: 0.8),
                                    colorScheme.secondary.withValues(
                                      alpha: 0.6,
                                    ),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    colorScheme.primary.withValues(alpha: 0.9),
                                    colorScheme.primary,
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: FilledButton(
                          onPressed: widget.onPressed,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: _isHovered
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                            child: widget.child,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: _isHovered
                              ? LinearGradient(
                                  colors: [
                                    colorScheme.primary.withValues(alpha: 0.1),
                                    colorScheme.secondary.withValues(
                                      alpha: 0.05,
                                    ),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          border: Border.all(
                            color: _isHovered
                                ? colorScheme.primary
                                : colorScheme.outline.withValues(alpha: 0.6),
                            width: _isHovered ? 2.5 : 1.5,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: OutlinedButton(
                          onPressed: widget.onPressed,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            backgroundColor: Colors.transparent,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: _isHovered
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                              fontWeight: _isHovered
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                            child: widget.child,
                          ),
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SkillBubble extends StatefulWidget {
  final String skill;
  final ColorScheme colorScheme;
  final double animationValue;

  const _SkillBubble({
    required this.skill,
    required this.colorScheme,
    required this.animationValue,
  });

  @override
  State<_SkillBubble> createState() => _SkillBubbleState();
}

class _SkillBubbleState extends State<_SkillBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutBack),
    );

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 80,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.colorScheme.primary.withValues(alpha: 0.2),
                    widget.colorScheme.secondary.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.colorScheme.primary.withValues(
                      alpha: _isHovered ? 0.3 : 0.1,
                    ),
                    blurRadius: _glowAnimation.value,
                    spreadRadius: _glowAnimation.value * 0.3,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.skill,
                  style: TextStyle(
                    color: widget.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
