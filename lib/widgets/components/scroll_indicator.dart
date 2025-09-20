import 'package:flutter/material.dart';

class ScrollIndicator extends StatefulWidget {
  final ScrollController scrollController;
  final ColorScheme colorScheme;
  final String currentSection;
  final void Function(String) onSectionTap;

  const ScrollIndicator({
    super.key,
    required this.scrollController,
    required this.colorScheme,
    required this.currentSection,
    required this.onSectionTap,
  });

  @override
  State<ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<ScrollIndicator>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, String>> sections = [
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
            width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                // Section labels
                Positioned(
                  right: 12,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    tween: Tween(begin: 0.0, end: _isHovered ? 1.0 : 0.0),
                    builder: (context, value, child) {
                      return AnimatedOpacity(
                        opacity: value,
                        duration: const Duration(milliseconds: 600),
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
                                        return HoverableSection(
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

                // Progress bar
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

class HoverableSection extends StatefulWidget {
  final Map<String, String> section;
  final bool isActive;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const HoverableSection({
    super.key,
    required this.section,
    required this.isActive,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  State<HoverableSection> createState() => _HoverableSectionState();
}

class _HoverableSectionState extends State<HoverableSection>
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
                fontSize: _isHovered ? 16 : 15,
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
