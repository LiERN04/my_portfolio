import 'package:portfolio/data/constants/project_titles.dart';

/// Helper class to demonstrate how easy it is to maintain project associations
/// with the new constants system.
///
/// This showcases the benefits of using static constants:
/// 1. Type safety - IDE can catch typos at compile time
/// 2. Refactoring support - Renaming a constant updates all usages
/// 3. Consistency - One source of truth for all project titles
/// 4. Discoverability - Easy to see all available projects via auto-complete
class ProjectAssociationHelper {
  /// Example of how to easily add new projects to skills
  /// Simply reference the constants instead of typing strings
  static const List<String> mobileDevProjects = [
    ProjectTitles.nutricoachHealthApp,
    ProjectTitles
        .portfolioWebsite, // Portfolio also has mobile responsive features
    // Easy to add new mobile projects here using constants
  ];

  static const List<String> webDevProjects = [
    ProjectTitles.portfolioWebsite,
    ProjectTitles.finalYearProject,
    // Easy to add new web projects here
  ];

  static const List<String> fullStackProjects = [
    ProjectTitles.finalYearProject,
    ProjectTitles.portfolioWebsite,
    ProjectTitles
        .nutricoachHealthApp, // Has both frontend and backend components
  ];

  /// Helper method to validate that a project title exists
  static bool isValidProjectTitle(String title) {
    return ProjectTitles.allMainProjects.contains(title);
  }

  /// Helper method to get all projects associated with a skill category
  static List<String> getProjectsForSkill(String skillName) {
    switch (skillName.toLowerCase()) {
      case 'mobile development':
        return mobileDevProjects;
      case 'frontend ui/ux development':
        return webDevProjects;
      case 'fullstack development':
        return fullStackProjects;
      default:
        return [];
    }
  }
}
