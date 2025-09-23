import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/data/project_data.dart';
import 'package:portfolio/data/constants/project_titles.dart';
import 'package:portfolio/data/personal_data.dart';
import 'package:portfolio/screens/experience_detail_screen.dart';

class ClickableDescriptionText extends StatelessWidget {
  final String description;
  final TextStyle? textStyle;

  const ClickableDescriptionText({
    super.key,
    required this.description,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Check for clickable patterns
    final hasNutriCoach = description.contains('(NutriCoach)');
    final hasAntInternational = description.contains('Ant International');

    // If no clickable content, return normal text
    if (!hasNutriCoach && !hasAntInternational) {
      return Text(description, style: textStyle);
    }

    // Build rich text with clickable elements
    return _buildClickableRichText(context, colorScheme);
  }

  Widget _buildClickableRichText(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    List<TextSpan> spans = [];
    String remainingText = description;

    while (remainingText.isNotEmpty) {
      int nutriCoachIndex = remainingText.indexOf('(NutriCoach)');
      int antInternationalIndex = remainingText.indexOf('Ant International');

      // Find which pattern comes first
      int nextPatternIndex = -1;
      String? pattern;

      if (nutriCoachIndex != -1 &&
          (antInternationalIndex == -1 ||
              nutriCoachIndex < antInternationalIndex)) {
        nextPatternIndex = nutriCoachIndex;
        pattern = '(NutriCoach)';
      } else if (antInternationalIndex != -1) {
        nextPatternIndex = antInternationalIndex;
        pattern = 'Ant International';
      }

      if (nextPatternIndex == -1) {
        // No more patterns, add remaining text
        spans.add(TextSpan(text: remainingText, style: textStyle));
        break;
      }

      // Add text before the pattern
      if (nextPatternIndex > 0) {
        String beforeText = remainingText.substring(0, nextPatternIndex);
        if (pattern == '(NutriCoach)') {
          spans.add(TextSpan(text: beforeText + '(', style: textStyle));
        } else {
          spans.add(TextSpan(text: beforeText, style: textStyle));
        }
      } else if (pattern == '(NutriCoach)') {
        spans.add(TextSpan(text: '(', style: textStyle));
      }

      // Add the clickable pattern
      if (pattern == '(NutriCoach)') {
        spans.add(_buildNutriCoachSpan(context, colorScheme));
        remainingText = remainingText.substring(
          nextPatternIndex + pattern!.length,
        );
        spans.add(TextSpan(text: ')', style: textStyle));
      } else if (pattern == 'Ant International') {
        spans.add(_buildAntInternationalSpan(context, colorScheme));
        remainingText = remainingText.substring(
          nextPatternIndex + pattern!.length,
        );
      }
    }

    return RichText(
      text: TextSpan(style: textStyle, children: spans),
    );
  }

  TextSpan _buildNutriCoachSpan(BuildContext context, ColorScheme colorScheme) {
    // Find NutriCoach project index
    final allProjects = ProjectData.categories
        .expand((category) => category.projects)
        .toList();
    final nutricoachIndex = allProjects.indexWhere(
      (project) => project.title == ProjectTitles.nutricoachHealthApp,
    );

    return TextSpan(
      text: 'NutriCoach',
      style: (textStyle ?? const TextStyle()).copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        decorationColor: colorScheme.primary.withValues(alpha: 0.6),
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          if (nutricoachIndex != -1) {
            context.push('/project/$nutricoachIndex');
          }
        },
    );
  }

  TextSpan _buildAntInternationalSpan(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return TextSpan(
      text: 'Ant International',
      style: (textStyle ?? const TextStyle()).copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        decorationColor: colorScheme.primary.withValues(alpha: 0.6),
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          _navigateToAntExperience(context);
        },
    );
  }

  void _navigateToAntExperience(BuildContext context) {
    try {
      // Find Ant International experience
      final antExperience = PersonalData.experiences.firstWhere(
        (exp) => exp.company == 'Ant International',
      );

      // Navigate to experience detail screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ExperienceDetailScreen(experience: antExperience),
        ),
      );
    } catch (e) {
      // Fallback: Show snackbar if experience not found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ant International experience details coming soon!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
