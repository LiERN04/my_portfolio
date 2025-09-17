class ExperienceModel {
  final String position;
  final String company;
  final String companyLogo; // Path to company logo/image
  final String duration;
  final String location;
  final String employmentType; // e.g., "Full-time", "Internship", "Contract"
  final String description;
  final List<String> keyResponsibilities;
  final List<String> achievements;
  final List<String> technologiesUsed;
  final String? companyWebsite; // Optional company website URL

  const ExperienceModel({
    required this.position,
    required this.company,
    required this.companyLogo,
    required this.duration,
    required this.location,
    required this.employmentType,
    required this.description,
    required this.keyResponsibilities,
    required this.achievements,
    required this.technologiesUsed,
    this.companyWebsite,
  });
}
