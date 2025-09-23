import 'package:flutter/material.dart';

/// Model class for About Me content data
/// This separates the content from the UI presentation
class AboutMeModel {
  final String title;
  final String subtitle;
  final String description;
  final List<StatModel> stats;
  final List<AboutMeSkillModel> languages;
  final List<AboutMeSkillModel> frameworks;
  final String profileImagePath;

  const AboutMeModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.stats,
    required this.languages,
    required this.frameworks,
    required this.profileImagePath,
  });
}

/// Model for statistics displayed in cards
class StatModel {
  final String value;
  final String label;

  const StatModel({required this.value, required this.label});
}

/// Model for skills (languages and frameworks)
class AboutMeSkillModel {
  final String name;
  final IconData icon;

  const AboutMeSkillModel({required this.name, required this.icon});
}

/// Data class containing all About Me content
class AboutMeData {
  static const AboutMeModel data = AboutMeModel(
    title: 'Full Stack Developer',
    subtitle: 'Passionate Developer',
    description:
        'I am a dedicated full-stack developer with a passion for creating innovative solutions. '
        'My journey in technology started 3 years ago, and since then, I\'ve been committed to '
        'building applications that make a difference.',
    stats: [
      StatModel(value: '3+', label: 'Years Experience'),
      StatModel(value: '10+', label: 'Projects Built'),
      StatModel(value: '5+', label: 'Technologies'),
    ],
    languages: [
      AboutMeSkillModel(name: 'JavaScript', icon: Icons.javascript),
      AboutMeSkillModel(name: 'Java', icon: Icons.code),
      AboutMeSkillModel(name: 'Python', icon: Icons.code),
      AboutMeSkillModel(name: 'Dart', icon: Icons.flutter_dash),
      AboutMeSkillModel(name: 'Kotlin', icon: Icons.android),
    ],
    frameworks: [
      AboutMeSkillModel(name: 'React', icon: Icons.web),
      AboutMeSkillModel(name: 'Flutter', icon: Icons.flutter_dash),
      AboutMeSkillModel(name: 'Spring Boot', icon: Icons.settings),
      AboutMeSkillModel(name: 'Flask', icon: Icons.api),
      AboutMeSkillModel(name: 'Jetpack Compose', icon: Icons.android),
    ],
    profileImagePath: 'images/portrait.jpg',
  );
}
