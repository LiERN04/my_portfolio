import 'package:flutter/material.dart';
import '../components/project_card.dart';
import '../../data/project_data.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.tertiary.withValues(alpha: 0.05),
                colorScheme.primary.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.tertiary.withValues(alpha: 0.1),
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
                      color: colorScheme.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.work, color: colorScheme.tertiary, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          colorScheme.tertiary,
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'Projects',
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
                '// Showcase of applications that solve real-world problems',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.85),
                  fontStyle: FontStyle.italic,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildProjectsGrid(context),
      ],
    );
  }

  Widget _buildProjectsGrid(BuildContext context) {
    // Flatten all projects from all categories into one list
    final allProjects = ProjectData.categories
        .expand((category) => category.projects)
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Simple responsive layout without complex calculations
        final screenWidth = constraints.maxWidth;

        if (screenWidth < 600) {
          // Mobile: Single column
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allProjects.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final project = allProjects[index];
              return ProjectCard(project: project, index: index);
            },
          );
        } else {
          // Tablet and Desktop: Use Wrap for flexible layout
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: allProjects.asMap().entries.map((entry) {
              final index = entry.key;
              final project = entry.value;

              // Calculate card width based on available space
              double cardWidth;
              if (screenWidth < 1200) {
                // Tablet: 2 columns
                cardWidth =
                    (screenWidth - 32) /
                    2; // 16 spacing on each side + 16 between
              } else {
                // Desktop: 3 columns
                cardWidth = (screenWidth - 48) / 3; // 16 spacing * 3
              }

              return SizedBox(
                width: cardWidth.clamp(280, double.infinity),
                child: ProjectCard(project: project, index: index),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
