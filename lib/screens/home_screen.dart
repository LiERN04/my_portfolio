import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/widgets/components/mobile_nav.dart';
import 'package:portfolio/widgets/components/navigation_hint.dart';
import 'package:portfolio/widgets/components/scroll_indicator.dart';
import 'package:portfolio/widgets/components/portfolio_app_bar.dart';
import 'package:portfolio/widgets/components/section_list.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:portfolio/providers/scroll_provider.dart';

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
  bool _showNavigationHint = false; // Show navigation hint notification

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

      // Show navigation hint after a delay for desktop users
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && ResponsiveBreakpoints.of(context).largerThan(TABLET)) {
          setState(() {
            _showNavigationHint = true;
          });
          // Auto-hide after 8 seconds
          Future.delayed(const Duration(milliseconds: 8000), () {
            if (mounted) {
              setState(() {
                _showNavigationHint = false;
              });
            }
          });
        }
      });
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
          // For contact section, be more lenient to ensure it triggers
          final isInView = entry.key == 'contact'
              ? position.dy < screenHeight * 0.9 &&
                    position.dy + sectionHeight > 0
              : position.dy < screenHeight * 0.7 &&
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      floatingActionButton: !isDesktop
          ? MobileNavigation(onSectionTap: _scrollToSection)
          : null,
      appBar: const PortfolioAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: SectionList(
              aboutKey: _aboutKey,
              skillsKey: _skillsKey,
              projectsKey: _projectsKey,
              contactKey: _contactKey,
              sectionAnimationStates: _sectionAnimationStates,
              aboutTabIndex: _aboutTabIndex,
              onAboutTabControllerReady: (switcher) {
                _aboutTabSwitcher = switcher;
              },
            ),
          ),

          // Floating scroll progress indicator
          if (isDesktop)
            Positioned(
              right: 20,
              top: MediaQuery.of(context).size.height * 0.4,
              child: ScrollIndicator(
                scrollController: _scrollController,
                colorScheme: colorScheme,
                currentSection: _currentSection,
                onSectionTap: _scrollToSection,
              ),
            ),

          // Navigation hint notification
          if (isDesktop && _showNavigationHint)
            Positioned(
              right: 60,
              top: MediaQuery.of(context).size.height * 0.40,
              child: NavigationHint(
                onDismiss: () => setState(() => _showNavigationHint = false),
              ),
            ),
        ],
      ),
    );
  }
}
