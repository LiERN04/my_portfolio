import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/models/skill_model.dart';

class SkillIconWidget extends StatelessWidget {
  final SkillModel skill;
  final double size;
  final Color? color;

  const SkillIconWidget({
    super.key,
    required this.skill,
    this.size = 30,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = color ?? colorScheme.primary;

    switch (skill.iconType) {
      case IconType.image:
        return Image.asset(
          skill.icon as String,
          width: size,
          height: size,
          fit: BoxFit.contain,
        );
      case IconType.svg:
        return SvgPicture.asset(
          skill.icon as String,
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        );
      case IconType.materialIcon:
        return Icon(skill.icon as IconData, size: size, color: iconColor);
    }
  }
}
