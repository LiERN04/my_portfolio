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
        Row(
          children: [
            Icon(Icons.work, color: colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [colorScheme.tertiary, colorScheme.primary],
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
          ],
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
