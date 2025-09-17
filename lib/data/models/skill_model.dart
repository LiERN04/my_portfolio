import 'package:flutter/material.dart';

enum IconType { image, svg, materialIcon }

class SkillModel {
  final dynamic
  icon; // Can be String (for images/SVGs) or IconData (for Material Icons)
  final IconType iconType;
  final String name;
  final String description;
  final int proficiency; // 1-100
  final List<String> technologies;
  final String experience;

  const SkillModel({
    required this.icon,
    required this.iconType,
    required this.name,
    required this.description,
    required this.proficiency,
    required this.technologies,
    required this.experience,
  });

  // Helper constructors for different icon types
  const SkillModel.withImage({
    required String imagePath,
    required this.name,
    required this.description,
    required this.proficiency,
    required this.technologies,
    required this.experience,
  }) : icon = imagePath,
       iconType = IconType.image;

  const SkillModel.withSvg({
    required String svgPath,
    required this.name,
    required this.description,
    required this.proficiency,
    required this.technologies,
    required this.experience,
  }) : icon = svgPath,
       iconType = IconType.svg;

  const SkillModel.withMaterialIcon({
    required IconData iconData,
    required this.name,
    required this.description,
    required this.proficiency,
    required this.technologies,
    required this.experience,
  }) : icon = iconData,
       iconType = IconType.materialIcon;
}
