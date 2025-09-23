import 'package:flutter/material.dart';

/// Model class for About Me content data
/// This separates the content from the UI presentation
class AboutMeModel {
  final List<String> titles; // Changed from String title to List<String> titles
  final String subtitle;
  final String description;
  final List<StatModel> stats;
  final List<AboutMeSkillModel> languages;
  final List<AboutMeSkillModel> frameworks;
  final String profileImagePath;

  const AboutMeModel({
    required this.titles,
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
    titles: [
      'Full Stack Developer',
      'Mobile Developer',
      'Web Developer',
      'Frontend Developer',
      'Backend Developer',
    ],
    subtitle: 'Samuel Leong Lik Ern',
    description:
        'I am a dedicated full-stack developer with a passion for creating intuitive UIs and robust systems. '
        'My journey in technology began three years ago at Monash University Malaysia, and since then I have been committed '
        'to building applications that are not only functional but also adhere to industry-leading standards in both design and code quality. '
        'Along the way, I have faced diverse challenges that helped me gain tremendous experience, including an internship at Ant International, '
        'where I learned to lead an industrial project. I have also contributed to several projects that allowed me to discover and refine my areas of expertise.',
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
    profileImagePath: 'assets/images/portrait.jpg',
  );
}
