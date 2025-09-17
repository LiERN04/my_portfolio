import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/personal_data.dart';
import '../../data/models/skill_model.dart';
import '../skill_icon_widget.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _gridController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _gridController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _gridController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _gridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animated header with enhanced styling
          FadeTransition(
            opacity: _headerAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-0.3, 0),
                end: Offset.zero,
              ).animate(_headerController),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.05),
                      colorScheme.secondary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.code,
                            color: colorScheme.secondary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                colorScheme.secondary,
                                colorScheme.tertiary,
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'My Skills',
                              style: textTheme.headlineMedium?.copyWith(
                                fontFamily: 'monospace',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '// Building tomorrow\'s solutions with today\'s technologies',
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
          ),

          const SizedBox(height: 32),

          // Enhanced skills grid
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(_gridController),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildSkillsLayout(context, colorScheme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsLayout(BuildContext context, ColorScheme colorScheme) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      // Mobile: Use a simple ListView with cards
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: PersonalData.skills.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final skill = PersonalData.skills[index];
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 600 + (index * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: _buildMobileSkillCard(skill, index, context),
                ),
              );
            },
          );
        },
      );
    } else {
      // Tablet and Desktop: Use horizontal scrolling
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scroll hint
            Row(
              children: [
                Icon(
                  Icons.swipe,
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Scroll horizontally to explore skills',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Horizontal scrollable skills with fade effect
            SizedBox(
              height: 220, // Reduced height to fit better
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                      Colors.black,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.05, 0.95, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: PersonalData.skills.asMap().entries.map((entry) {
                      final index = entry.key;
                      final skill = entry.value;
                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 600 + (index * 100)),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: Container(
                                width:
                                    240, // Slightly smaller width for better fit
                                margin: EdgeInsets.only(
                                  right: index < PersonalData.skills.length - 1
                                      ? 16
                                      : 0,
                                  left: index == 0
                                      ? 8
                                      : 0, // Add left margin for first item
                                  top: 8, // Add top margin for hover expansion
                                  bottom:
                                      8, // Add bottom margin for hover expansion
                                ),
                                child: _buildClickableSkillCard(
                                  skill,
                                  index,
                                  context,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildMobileSkillCard(
    SkillModel skill,
    int index,
    BuildContext context,
  ) {
    return _buildClickableSkillCard(skill, index, context);
  }

  Widget _buildClickableSkillCard(
    SkillModel skill,
    int index,
    BuildContext context,
  ) {
    return _HoverableSkillCard(skill: skill, index: index);
  }
}

class _HoverableSkillCard extends StatefulWidget {
  final SkillModel skill;
  final int index;

  const _HoverableSkillCard({required this.skill, required this.index});

  @override
  State<_HoverableSkillCard> createState() => _HoverableSkillCardState();
}

class _HoverableSkillCardState extends State<_HoverableSkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        width: 240, // Fixed width for consistency
        height: 200, // Fixed height for consistency
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.push('/skill/${widget.index}');
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovered
                      ? colorScheme.primary.withValues(alpha: 0.3)
                      : colorScheme.outline.withValues(alpha: 0.2),
                  width: _isHovered ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(
                      alpha: _isHovered ? 0.15 : 0.08,
                    ),
                    blurRadius: _isHovered ? 12 : 8,
                    spreadRadius: _isHovered ? 2 : 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Skill Icon
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(
                        alpha: _isHovered ? 0.3 : 0.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.primary.withValues(
                          alpha: _isHovered ? 0.4 : 0.2,
                        ),
                        width: _isHovered ? 2 : 1,
                      ),
                    ),
                    child: SkillIconWidget(
                      skill: widget.skill,
                      size: 30,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Skill Name
                  Text(
                    widget.skill.name,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isHovered
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Experience
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.skill.experience,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  // Hover indicator
                  if (_isHovered) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Click to view details',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
