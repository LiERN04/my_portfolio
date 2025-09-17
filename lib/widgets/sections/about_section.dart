import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../tabs/about_me_tab.dart';
import '../tabs/experience_tab.dart';
import '../tabs/academics_tab.dart';

class AboutSection extends StatefulWidget {
  final int initialTabIndex;
  final Function(void Function(int))? onTabControllerReady;

  const AboutSection({
    super.key,
    this.initialTabIndex = 0,
    this.onTabControllerReady,
  });

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _headerController;
  late AnimationController _slideController;
  late Animation<double> _headerAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _startAnimations();

    // Notify parent that the tab controller is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTabControllerReady?.call(switchToTab);
    });
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _slideController.forward();
  }

  @override
  void didUpdateWidget(AboutSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTabIndex != widget.initialTabIndex) {
      _tabController.animateTo(widget.initialTabIndex);
    }
  }

  void switchToTab(int index) {
    if (index >= 0 && index < 3) {
      _tabController.animateTo(index);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _headerController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: _headerAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_search,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                      ).createShader(bounds),
                      child: Text(
                        'About Me',
                        style: textTheme.headlineMedium?.copyWith(
                          fontFamily: 'monospace',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '// Discover my journey through code',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.85),
                    fontStyle: FontStyle.italic,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Enhanced TabBar with animations
        AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(_slideController),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: colorScheme.primary,
                  unselectedLabelColor: colorScheme.onSurface.withValues(
                    alpha: 0.8,
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  padding: const EdgeInsets.all(4),
                  isScrollable: ResponsiveBreakpoints.of(
                    context,
                  ).smallerThan(TABLET),
                  tabs: [
                    _buildTab('About Me', Icons.account_circle_outlined),
                    _buildTab('Experience', Icons.work_outline),
                    _buildTab('Academics', Icons.school_outlined),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        // Enhanced TabBarView with smooth transitions
        SizedBox(
          height: ResponsiveValue(
            context,
            conditionalValues: [
              const Condition.smallerThan(name: TABLET, value: 350.0),
            ],
            defaultValue: 450.0,
          ).value,
          child: AnimatedBuilder(
            animation: _tabController.animation!,
            builder: (context, child) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent(const AboutMeTab()),
                  _buildTabContent(const ExperienceTab()),
                  _buildTabContent(const AcademicsTab()),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTabContent(Widget child) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
    );
  }
}
