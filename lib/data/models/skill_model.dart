class SkillModel {
  final String icon;
  final String name;
  final String description;
  final int proficiency; // 1-100
  final List<String> technologies;
  final String experience;

  const SkillModel({
    required this.icon,
    required this.name,
    required this.description,
    required this.proficiency,
    required this.technologies,
    required this.experience,
  });
}