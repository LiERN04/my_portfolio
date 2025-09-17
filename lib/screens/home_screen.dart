import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/widgets/components/mobile_nav.dart';
import 'package:portfolio/widgets/components/side_nav.dart';
import 'package:portfolio/widgets/components/scroll_fade_in.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:portfolio/providers/theme_provider.dart';
import 'package:portfolio/providers/scroll_provider.dart';
import 'package:portfolio/widgets/sections/hero_section.dart';
import 'package:portfolio/widgets/sections/about_section.dart';
import 'package:portfolio/widgets/sections/skills_section.dart';
import 'package:portfolio/widgets/sections/projects_section.dart';
import 'package:portfolio/widgets/sections/get_in_touch_section.dart';

enum SectionStyle { normal, hero, alternate, elevated, gradient }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  String _currentSection = 'hero';
  int _aboutTabIndex = 0; // Track current About tab index
  Function(int)? _aboutTabSwitcher; // Callback to switch About tabs
  bool _showSideNav = true; // Toggle for side navigation visibility

  // Global keys for each section
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // Map section IDs to their global keys
  late final Map<String, GlobalKey> _sectionKeys = {
    'about': _aboutKey,
    'skills': _skillsKey,
    'projects': _projectsKey,
    'contact': _contactKey,
  };

  // Animation states for each section - initialized with defaults
  Map<String, bool> _sectionAnimationStates = {
    'hero': true,
    'about': true,
    'skills': false,
    'projects': false,
    'contact': false,
  };

  @override
  void initState() {
    super.initState();

    // Initialize animation states from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scrollState = ref.read(scrollProvider);
      setState(() {
        _sectionAnimationStates = Map<String, bool>.from(
          scrollState.sectionAnimationStates,
        );
        _currentSection = scrollState.currentSection;
      });

      // Restore scroll position if it was saved
      if (scrollState.scrollPosition > 0) {
        _scrollController.animateTo(
          scrollState.scrollPosition,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;

    // Save current scroll position to provider
    ref
        .read(scrollProvider.notifier)
        .updateScrollPosition(_scrollController.position.pixels);

    String newSection = 'hero';
    double closestDistance = double.infinity;

    // Check each section and find the one closest to the top of the viewport
    for (final entry in _sectionKeys.entries) {
      final context = entry.value.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          final sectionHeight = box.size.height;
          final screenHeight = MediaQuery.of(this.context).size.height;

          // Distance from top of viewport (accounting for app bar)
          final distance = (position.dy - 150).abs();

          // Check if section is in view (at least 30% visible)
          final isInView =
              position.dy < screenHeight * 0.7 &&
              position.dy + sectionHeight > screenHeight * 0.3;

          // Update animation state if section becomes visible
          if (isInView && !(_sectionAnimationStates[entry.key] ?? false)) {
            setState(() {
              _sectionAnimationStates[entry.key] = true;
            });
            // Save animation state to provider
            ref
                .read(scrollProvider.notifier)
                .updateSectionAnimationState(entry.key, true);
          }

          // If this section is in view and closer to the top than previous sections
          if (position.dy <= 300 && distance < closestDistance) {
            closestDistance = distance;
            newSection = entry.key;
          }
        }
      }
    }

    // Special handling for contact section at the bottom
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      // If we're near the bottom (within 300 pixels), highlight contact
      if (maxScroll - currentScroll < 300) {
        newSection = 'contact';
      }
    }

    if (newSection != _currentSection) {
      setState(() {
        _currentSection = newSection;
      });
      // Save current section to provider
      ref.read(scrollProvider.notifier).updateCurrentSection(newSection);
    }
  }

  void _scrollToSection(String sectionId) {
    // Handle subsections for About section
    if (sectionId == 'about-me' ||
        sectionId == 'experience' ||
        sectionId == 'academics') {
      final key = _sectionKeys['about'];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );

        // Switch to appropriate tab
        if (sectionId == 'about-me') {
          _switchAboutTab(0);
        } else if (sectionId == 'experience') {
          _switchAboutTab(1);
        } else if (sectionId == 'academics') {
          _switchAboutTab(2);
        }
      }
      return;
    }

    // Handle subsections for Projects section
    if (sectionId.contains('projects')) {
      final key = _sectionKeys['projects'];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        // You can add project filtering logic here later
        // For now, just scroll to the projects section
      }
      return;
    }

    // Handle main sections
    final key = _sectionKeys[sectionId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  void _switchAboutTab(int tabIndex) {
    // Use the callback to switch tabs
    _aboutTabSwitcher?.call(tabIndex);

    setState(() {
      _aboutTabIndex = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      floatingActionButton: !isDesktop
          ? MobileNavigation(onSectionTap: _scrollToSection)
          : null,
      appBar: AppBar(
        leading: isDesktop
            ? TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          _showSideNav ? Icons.menu_open : Icons.menu,
                          key: ValueKey(_showSideNav),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _showSideNav = !_showSideNav;
                        });
                      },
                      tooltip: _showSideNav
                          ? 'Hide Navigation'
                          : 'Show Navigation',
                    ),
                  );
                },
              )
            : null,
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
                  onPressed: () =>
                      ref.read(themeProvider.notifier).toggleTheme(),
                  tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                ),
              );
            },
          ),
        ],
        elevation: 2,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              // Animated side navigation
              if (isDesktop)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: _showSideNav ? 250 : 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _showSideNav ? 1.0 : 0.0,
                    child: _showSideNav
                        ? SideNavigation(
                            onSectionTap: _scrollToSection,
                            currentSection: _currentSection,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),

              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveValue(
                        context,
                        conditionalValues: [
                          const Condition.smallerThan(
                            name: TABLET,
                            value: 16.0,
                          ),
                        ],
                        defaultValue: 24.0,
                      ).value,
                      vertical: 24,
                    ),
                    child: Column(
                      children: [
                        // Hero section with custom styling (always visible initially)
                        _buildSectionContainer(
                          style: SectionStyle.hero,
                          colorScheme: colorScheme,
                          child: const HeroSection(),
                        ),

                        _buildSectionDivider(colorScheme),

                        // About section with scroll-triggered animation
                        ScrollFadeIn(
                          isVisible: _sectionAnimationStates['about'] ?? true,
                          duration: const Duration(milliseconds: 1000),
                          slideOffset: const Offset(0, 60),
                          child: _buildSectionContainer(
                            style: SectionStyle.normal,
                            colorScheme: colorScheme,
                            child: AboutSection(
                              key: _aboutKey,
                              initialTabIndex: _aboutTabIndex,
                              onTabControllerReady: (switcher) {
                                _aboutTabSwitcher = switcher;
                              },
                            ),
                          ),
                        ),

                        _buildSectionDivider(colorScheme),

                        // Skills section with scroll-triggered animation
                        ScrollFadeIn(
                          isVisible: _sectionAnimationStates['skills'] ?? false,
                          duration: const Duration(milliseconds: 1200),
                          slideOffset: const Offset(0, 60),
                          child: _buildSectionContainer(
                            style: SectionStyle.normal,
                            colorScheme: colorScheme,
                            child: SkillsSection(key: _skillsKey),
                          ),
                        ),

                        _buildSectionDivider(colorScheme),

                        // Projects section with scroll-triggered animation
                        ScrollFadeIn(
                          isVisible:
                              _sectionAnimationStates['projects'] ?? false,
                          duration: const Duration(milliseconds: 1400),
                          slideOffset: const Offset(0, 60),
                          child: _buildSectionContainer(
                            style: SectionStyle.normal,
                            colorScheme: colorScheme,
                            child: ProjectsSection(key: _projectsKey),
                          ),
                        ),

                        _buildSectionDivider(colorScheme),

                        // Contact section with scroll-triggered animation
                        ScrollFadeIn(
                          isVisible:
                              _sectionAnimationStates['contact'] ?? false,
                          duration: const Duration(milliseconds: 1600),
                          slideOffset: const Offset(0, 60),
                          child: _buildSectionContainer(
                            style: SectionStyle.elevated,
                            colorScheme: colorScheme,
                            child: GetInTouchSection(key: _contactKey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Floating scroll progress indicator
          if (isDesktop)
            Positioned(
              right: 20,
              top: MediaQuery.of(context).size.height * 0.4,
              child: _buildScrollIndicator(colorScheme),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({
    required Widget child,
    required ColorScheme colorScheme,
    SectionStyle style = SectionStyle.normal,
    bool addTopDivider = false,
    bool addBottomDivider = false,
  }) {
    Color? backgroundColor;
    EdgeInsets? padding;
    BoxDecoration? decoration;

    switch (style) {
      case SectionStyle.hero:
        // Hero section - no background, full width, but with hero glow
        backgroundColor = null;
        decoration = BoxDecoration(
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
        );
        padding = EdgeInsets.symmetric(
          horizontal: ResponsiveValue(
            context,
            conditionalValues: [
              const Condition.smallerThan(name: TABLET, value: 16.0),
            ],
            defaultValue: 32.0,
          ).value,
          vertical: 40,
        );
        break;
      case SectionStyle.alternate:
        // Alternate sections with subtle background and glow
        backgroundColor = colorScheme.surfaceContainerLowest;
        decoration = BoxDecoration(
          color: backgroundColor,
          border: Border.symmetric(
            horizontal: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          boxShadow: [
            // Subtle glow effect
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 0),
            ),
            // Additional inner glow
            BoxShadow(
              color: colorScheme.secondary.withValues(alpha: 0.05),
              blurRadius: 40,
              spreadRadius: -5,
              offset: const Offset(0, 0),
            ),
          ],
        );
        padding = EdgeInsets.symmetric(
          horizontal: ResponsiveValue(
            context,
            conditionalValues: [
              const Condition.smallerThan(name: TABLET, value: 16.0),
            ],
            defaultValue: 32.0,
          ).value,
          vertical: 48,
        );
        break;
      case SectionStyle.elevated:
        // Elevated sections with card-like appearance and enhanced glow
        decoration = BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            // Original shadow
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
            // Enhanced glow effect
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.15),
              blurRadius: 30,
              spreadRadius: 3,
              offset: const Offset(0, 0),
            ),
            // Secondary glow layer
            BoxShadow(
              color: colorScheme.tertiary.withValues(alpha: 0.08),
              blurRadius: 50,
              spreadRadius: -10,
              offset: const Offset(0, 2),
            ),
          ],
        );
        padding = EdgeInsets.symmetric(
          horizontal: ResponsiveValue(
            context,
            conditionalValues: [
              const Condition.smallerThan(name: TABLET, value: 20.0),
            ],
            defaultValue: 40.0,
          ).value,
          vertical: 48,
        );
        break;
      case SectionStyle.gradient:
        // Gradient background sections with dynamic glow
        decoration = BoxDecoration(
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
        );
        padding = EdgeInsets.symmetric(
          horizontal: ResponsiveValue(
            context,
            conditionalValues: [
              const Condition.smallerThan(name: TABLET, value: 16.0),
            ],
            defaultValue: 32.0,
          ).value,
          vertical: 48,
        );
        break;
      case SectionStyle.normal:
        // Normal sections with standard padding and subtle glow
        decoration = BoxDecoration(
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
        );
        padding = EdgeInsets.symmetric(
          horizontal: ResponsiveValue(
            context,
            conditionalValues: [
              const Condition.smallerThan(name: TABLET, value: 16.0),
            ],
            defaultValue: 32.0,
          ).value,
          vertical: 32,
        );
        break;
    }

    Widget section = Container(
      width: double.infinity,
      padding: padding,
      decoration: decoration,
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

  Widget _buildScrollIndicator(ColorScheme colorScheme) {
    return _ScrollIndicatorWidget(
      scrollController: _scrollController,
      colorScheme: colorScheme,
      currentSection: _currentSection,
      onSectionTap: _scrollToSection,
    );
  }
}

class _ScrollIndicatorWidget extends StatefulWidget {
  final ScrollController scrollController;
  final ColorScheme colorScheme;
  final String currentSection;
  final void Function(String) onSectionTap;

  const _ScrollIndicatorWidget({
    required this.scrollController,
    required this.colorScheme,
    required this.currentSection,
    required this.onSectionTap,
  });

  @override
  State<_ScrollIndicatorWidget> createState() => _ScrollIndicatorWidgetState();
}

class _ScrollIndicatorWidgetState extends State<_ScrollIndicatorWidget>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, String>> sections = [
    {'id': 'hero', 'name': 'Home'},
    {'id': 'about', 'name': 'About'},
    {'id': 'skills', 'name': 'Skills'},
    {'id': 'projects', 'name': 'Projects'},
    {'id': 'contact', 'name': 'Contact'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          widget.scrollController,
          _pulseController,
        ]),
        builder: (context, child) {
          double progress = 0.0;
          if (widget.scrollController.hasClients) {
            progress =
                (widget.scrollController.offset /
                        widget.scrollController.position.maxScrollExtent)
                    .clamp(0.0, 1.0);
          }

          return Container(
            width: 100, // Give enough width for labels + bar
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                // Section labels (positioned absolutely to not affect bar position)
                Positioned(
                  right: 12, // Position just to the left of the bar
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    curve: _isHovered
                        ? Curves.easeOutCubic
                        : Curves.easeInCubic,
                    tween: Tween(begin: 0.0, end: _isHovered ? 1.0 : 0.0),
                    builder: (context, value, child) {
                      return AnimatedOpacity(
                        opacity: value,
                        duration: const Duration(milliseconds: 300),
                        child: value > 0.01
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Transform.translate(
                                  offset: Offset(30 * (1 - value), 0),
                                  child: Opacity(
                                    opacity: value,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: sections.map((section) {
                                        bool isActive =
                                            section['id'] ==
                                            widget.currentSection;
                                        return _HoverableSection(
                                          section: section,
                                          isActive: isActive,
                                          onTap: () => widget.onSectionTap(
                                            section['id']!,
                                          ),
                                          colorScheme: widget.colorScheme,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                ),

                // Progress bar (positioned at the right edge)
                GestureDetector(
                  onTapDown: (details) => _handleTap(details, progress),
                  child: Container(
                    width: 4,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: widget.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                    child: Stack(
                      children: [
                        // Progress indicator
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 100),
                          top: progress * (120 - 30),
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            child: Container(
                              width: 4,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                gradient: LinearGradient(
                                  colors: [
                                    widget.colorScheme.primary,
                                    widget.colorScheme.secondary,
                                  ],
                                ),
                              ),
                            ),
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _isHovered ? _pulseAnimation.value : 1.0,
                                child: child,
                              );
                            },
                          ),
                        ),

                        // Section markers
                        ...sections.asMap().entries.map((entry) {
                          int index = entry.key;
                          String sectionId = entry.value['id']!;
                          bool isActive = sectionId == widget.currentSection;
                          double position =
                              (index / (sections.length - 1)) * 120;

                          return Positioned(
                            top: position - 2,
                            child: Container(
                              width: isActive ? 8 : 6,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? widget.colorScheme.primary
                                    : widget.colorScheme.outline.withValues(
                                        alpha: 0.4,
                                      ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  void _handleTap(TapDownDetails details, double currentProgress) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    // Calculate which section was tapped based on position
    final barHeight = 120.0;
    final tappedProgress = (localPosition.dy - 4) / barHeight;
    final clampedProgress = tappedProgress.clamp(0.0, 1.0);

    // Find closest section
    int targetIndex = (clampedProgress * (sections.length - 1)).round();
    targetIndex = targetIndex.clamp(0, sections.length - 1);

    widget.onSectionTap(sections[targetIndex]['id']!);
  }
}

class _HoverableSection extends StatefulWidget {
  final Map<String, String> section;
  final bool isActive;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _HoverableSection({
    required this.section,
    required this.isActive,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  State<_HoverableSection> createState() => _HoverableSectionState();
}

class _HoverableSectionState extends State<_HoverableSection>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 1),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? widget.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: widget.isActive
                  ? Border.all(
                      color: widget.colorScheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: widget.isActive
                    ? widget.colorScheme.primary
                    : widget.colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: _isHovered ? 12 : 11,
                fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
              ),
              child: Text(widget.section['name']!, textAlign: TextAlign.right),
            ),
          ),
        ),
      ),
    );
  }
}
