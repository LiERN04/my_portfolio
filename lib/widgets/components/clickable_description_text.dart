import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/data/project_data.dart';

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

    // Find NutriCoach project index
    final allProjects = ProjectData.categories
        .expand((category) => category.projects)
        .toList();
    final nutricoachIndex = allProjects.indexWhere(
      (project) => project.title.contains('NutriCoach'),
    );

    // Split text to make NutriCoach clickable
    final parts = description.split('(NutriCoach)');

    if (parts.length != 2 || nutricoachIndex == -1) {
      // If NutriCoach not found, return normal text
      return Text(description, style: textStyle);
    }

    return RichText(
      text: TextSpan(
        style: textStyle,
        children: [
          TextSpan(text: parts[0] + '('),
          TextSpan(
            text: 'NutriCoach',
            style: (textStyle ?? const TextStyle()).copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: colorScheme.primary.withValues(alpha: 0.6),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.push('/project/$nutricoachIndex');
              },
          ),
          TextSpan(text: ')' + parts[1]),
        ],
      ),
    );
  }
}
