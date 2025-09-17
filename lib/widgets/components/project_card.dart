import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/project_model.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final int index; // Add index to navigate to correct project

  const ProjectCard({super.key, required this.project, required this.index});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<Color?> _titleColorAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    _elevationAnimation = Tween<double>(begin: 2.0, end: 12.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    _shadowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Initialize title color animation here to access colorScheme
    _titleColorAnimation =
        ColorTween(
          begin: textTheme.titleLarge?.color ?? colorScheme.onSurface,
          end: colorScheme.primary,
        ).animate(
          CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
        );

    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: GestureDetector(
        onTap: () {
          context.push('/project/${widget.index}');
        },
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    // Main shadow
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.1 + (0.15 * _shadowAnimation.value),
                      ),
                      blurRadius: 8 + (12 * _shadowAnimation.value),
                      offset: Offset(0, 4 + (8 * _shadowAnimation.value)),
                      spreadRadius: 1 + (2 * _shadowAnimation.value),
                    ),
                    // Colored glow effect
                    BoxShadow(
                      color: colorScheme.primary.withValues(
                        alpha: 0.2 * _shadowAnimation.value,
                      ),
                      blurRadius: 20 * _shadowAnimation.value,
                      offset: const Offset(0, 0),
                      spreadRadius: 2 * _shadowAnimation.value,
                    ),
                  ],
                ),
                child: Card(
                  elevation: _elevationAnimation.value,
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Image - Fixed height
                      if (widget.project.imageUrl != null)
                        SizedBox(
                          height: 180, // Fixed height instead of Expanded
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.asset(
                              widget.project.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: colorScheme.primaryContainer,
                                  child: Icon(
                                    Icons.web,
                                    size: 40,
                                    color: colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                      // Content - Fixed height
                      SizedBox(
                        height: 220, // Fixed height for content area
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title with hover color animation
                              AnimatedBuilder(
                                animation: _titleColorAnimation,
                                builder: (context, child) {
                                  return Text(
                                    widget.project.title,
                                    style: textTheme.titleLarge?.copyWith(
                                      color: _titleColorAnimation.value,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              ),
                              const SizedBox(height: 16),

                              // Description
                              Expanded(
                                child: Text(
                                  widget.project.description,
                                  style: textTheme.bodyMedium,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Technologies
                              Text(
                                'Technologies: ${widget.project.technologies}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
