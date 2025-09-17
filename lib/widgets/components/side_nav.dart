import 'package:flutter/material.dart';

class SideNavigation extends StatefulWidget {
  final Function(String) onSectionTap;
  final String currentSection;

  const SideNavigation({
    super.key,
    required this.onSectionTap,
    required this.currentSection,
  });

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> menuItems = const [
    {
      'id': 'about',
      'title': 'Get to Know Me',
      'icon': 'person',
      'hasSubsections': true,
      'subsections': [
        {'id': 'about-me', 'title': 'About Me'},
        {'id': 'experience', 'title': 'Experience'},
        {'id': 'academics', 'title': 'Academics'},
      ],
    },
    {
      'id': 'skills',
      'title': 'I Specialize In',
      'icon': 'code',
      'hasSubsections': false,
    },
    {
      'id': 'projects',
      'title': 'Projects',
      'icon': 'work',
      'hasSubsections': true,
      'subsections': [
        {'id': 'web-projects', 'title': 'Web Projects'},
        {'id': 'mobile-projects', 'title': 'Mobile Projects'},
        {'id': 'other-projects', 'title': 'Other Projects'},
      ],
    },
    {
      'id': 'contact',
      'title': 'Get In Touch',
      'icon': 'email',
      'hasSubsections': false,
    },
  ];

  // Track expanded sections
  Set<String> expandedSections = {};

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start the slide-in animation
    _slideController.forward();
  }

  @override
  void didUpdateWidget(SideNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger pulse animation when section changes
    if (oldWidget.currentSection != widget.currentSection) {
      _pulseController.forward().then((_) {
        _pulseController.reverse();
      });

      // Auto-expand parent section if a subsection is selected
      for (final item in menuItems) {
        if (item['hasSubsections'] == true) {
          final subsections = item['subsections'] as List<Map<String, dynamic>>;
          if (subsections.any(
            (subsection) => subsection['id'] == widget.currentSection,
          )) {
            setState(() {
              expandedSections.add(item['id']);
            });
            break;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: 250,
        height: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Navigation',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _getTotalItemCount(),
                itemBuilder: (context, index) {
                  return _buildMenuItem(index, colorScheme, textTheme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getTotalItemCount() {
    return menuItems
        .length; // Only count main items since subsections are embedded
  }

  Widget _buildMenuItem(
    int index,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (index < menuItems.length) {
      return _buildMainMenuItem(menuItems[index], colorScheme, textTheme);
    }
    return const SizedBox.shrink();
  }

  bool _isSubsectionSelected(Map<String, dynamic> item) {
    if (item['hasSubsections'] != true) return false;

    final subsections = item['subsections'] as List<Map<String, dynamic>>;
    return subsections.any(
      (subsection) => subsection['id'] == widget.currentSection,
    );
  }

  Widget _buildMainMenuItem(
    Map<String, dynamic> item,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isSelected =
        widget.currentSection == item['id'] || _isSubsectionSelected(item);
    final hasSubsections = item['hasSubsections'] == true;
    final isExpanded =
        expandedSections.contains(item['id']) || _isSubsectionSelected(item);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                // Main clickable area for navigation
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => widget.onSectionTap(item['id']!),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.identity()
                                ..scale(isSelected ? 1.1 : 1.0),
                              child: AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: isSelected
                                        ? _pulseAnimation.value
                                        : 1.0,
                                    child: Icon(
                                      _getIconData(item['icon']!),
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.onSurface.withValues(
                                              alpha: 0.85,
                                            ),
                                      size: 20,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: textTheme.bodyMedium!.copyWith(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                                child: Text(item['title']!),
                              ),
                            ),
                            if (isSelected && !hasSubsections)
                              AnimatedScale(
                                duration: const Duration(milliseconds: 200),
                                scale: 1.0,
                                child: Container(
                                  width: 4,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Separate clickable area for expand/collapse
                if (hasSubsections)
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            expandedSections.remove(item['id']);
                          } else {
                            expandedSections.add(item['id']);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.expand_more,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Animated subsections container
          if (hasSubsections)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Column(
                      children:
                          (item['subsections'] as List<Map<String, dynamic>>)
                              .asMap()
                              .entries
                              .map((entry) {
                                final index = entry.key;
                                final subsection = entry.value;
                                return TweenAnimationBuilder<double>(
                                  duration: Duration(
                                    milliseconds: 200 + (index * 100),
                                  ),
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  builder: (context, value, child) {
                                    return Transform.translate(
                                      offset: Offset(30 * (1 - value), 0),
                                      child: Opacity(
                                        opacity: value,
                                        child: _buildSubMenuItemStatic(
                                          subsection,
                                          colorScheme,
                                          textTheme,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              })
                              .toList(),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }

  Widget _buildSubMenuItemStatic(
    Map<String, dynamic> subsection,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isSelected = widget.currentSection == subsection['id'];

    return Padding(
      padding: const EdgeInsets.only(left: 32, bottom: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => widget.onSectionTap(subsection['id']!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: textTheme.bodySmall!.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    child: Text(subsection['title']!),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 3,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'person':
        return Icons.person_outline;
      case 'info':
        return Icons.info_outline;
      case 'code':
        return Icons.code;
      case 'work':
        return Icons.work_outline;
      case 'email':
        return Icons.email_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}
