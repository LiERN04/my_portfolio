// Enhanced project content types for rich project details
enum ProjectContentType { text, image, codeSnippet, video, gallery }

class ProjectContent {
  final ProjectContentType type;
  final String? title;
  final String? content;
  final String? imageUrl;
  final List<String>? imageUrls; // For gallery type
  final List<String>? imageCaptions; // Individual captions for gallery images
  final String? language; // For code snippets
  final String? caption;

  const ProjectContent({
    required this.type,
    this.title,
    this.content,
    this.imageUrl,
    this.imageUrls,
    this.imageCaptions,
    this.language,
    this.caption,
  });
}

class ProjectFeature {
  final String title;
  final String description;
  final String? icon;

  const ProjectFeature({
    required this.title,
    required this.description,
    this.icon,
  });
}

class ProjectModel {
  final String title;
  final String description;
  final String technologies;
  final String? demoUrl;
  final String? sourceUrl;
  final String? imageUrl; // Main project image
  final List<ProjectContent>? detailedContent; // Rich content sections
  final List<ProjectFeature>? features; // Key features
  final String? challenges; // Development challenges
  final String? solutions; // How challenges were solved
  final List<String>? techStack; // Detailed tech stack
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status; // "Completed", "In Progress", "Planned"

  const ProjectModel({
    required this.title,
    required this.description,
    required this.technologies,
    this.demoUrl,
    this.sourceUrl,
    this.imageUrl,
    this.detailedContent,
    this.features,
    this.challenges,
    this.solutions,
    this.techStack,
    this.startDate,
    this.endDate,
    this.status,
  });
}

class ProjectCategory {
  final String title;
  final List<ProjectModel> projects;

  const ProjectCategory({required this.title, required this.projects});
}
