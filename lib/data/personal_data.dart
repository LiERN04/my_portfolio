import 'package:flutter/material.dart';
import 'package:portfolio/data/models/skill_model.dart';
import 'package:portfolio/data/models/experience_model.dart';
import 'package:portfolio/data/models/academic_model.dart';
import 'package:portfolio/data/constants/project_titles.dart';

class PersonalData {
  static const List<ExperienceModel> experiences = [
    ExperienceModel(
      position: 'Backend Engineer Intern',
      company: 'Ant International',
      companyLogo: 'images/ant-logo.png',
      duration: 'Nov 2024 - Feb 2025',
      location: 'Singapore',
      employmentType: 'Internship',
      description:
          'Gained hands-on experience in enterprise-level software development, working on '
          'large-scale web platforms that serve millions of users globally.',
      keyResponsibilities: [
        'Full-Stack Development - Designed and implemented new features for web-based platform',
        'Backend Development - Developed business logic and backend services for seamless data flow',
        'API Integration - Integrated frontend components with backend using RESTful APIs',
        'Database Management - Designed efficient database interaction patterns',
        'Version Control - Managed code changes in large-scale enterprise environment',
        'Release Pipeline - Participated in deployment processes across multiple environments',
      ],
      achievements: [
        'Successfully delivered 5+ new features that improved user experience',
        'Reduced API response time by 20% through optimization',
        'Contributed to zero-downtime deployment processes',
        'Mentored by senior engineers in enterprise development practices',
      ],
      technologiesUsed: [
        'Java',
        'Spring Boot',
        'RESTful APIs',
        'MySQL',
        'Git',
        'Jenkins',
        'Docker',
        'React',
        'JavaScript',
      ],
      companyWebsite: 'https://www.antgroup.com',
    ),
  ];

  static const List<AcademicModel> academics = [
    AcademicModel(
      degree: 'Bachelor of Computer Science',
      institution: 'Monah University Malaysia',
      major: 'Advanced Computer Science',
      year: '2022 - 2025',
      gpa: 'GPA: 3.3/4.0',
    ),
    AcademicModel(
      degree: 'Cambridge International AS & A Levels',
      institution: 'Sunway College',
      major: 'N/A',
      year: '2021 - 2022',
      gpa: 'GPA: N/A',
    ),
  ];

  static const List<SkillModel> skills = [
    SkillModel.withImage(
      imagePath: 'images/react.png',
      name: 'Frontend UI/UX Development',
      description:
          'Modern responsive web interfaces with great user experience',
      proficiency: 85,
      technologies: [
        'ReactJS',
        'Flutter',
        'TypeScript',
        'JavaScript',
        'CSS3',
        'TailwindCSS',
        'Reactive UI',
      ],
      experience: '1+ years',
      relatedProjectTitles: [
        ProjectTitles.portfolioWebsite,
        ProjectTitles.nutricoachHealthApp,
        ProjectTitles.finalYearProject,
      ],
    ),
    SkillModel.withMaterialIcon(
      iconData: Icons.mobile_friendly_rounded,
      name: 'Mobile Development',
      description:
          'Mobile app development utilizing practices such as MVVM, state management, '
          'app lifecycle management and navigation in a FullStack architecture. '
          'This involves data storing and manipulation, data retrieving and API endpoint development. '
          'I have experience developing functional mobile applications as an individual assessment (NutriCoach) '
          'in the Mobile Application course provided by Monash University, '
          'which achieved a High Distinction in the overall unit grade.',
      proficiency: 90,
      technologies: [
        'Flutter',
        'Dart',
        'Jetpack Compse',
        'Reactive UI',
        'State Management',
      ],
      experience: '1+ years',
      relatedProjectTitles: [
        ProjectTitles.nutricoachHealthApp,
        ProjectTitles.portfolioWebsite,
      ],
    ),
    SkillModel.withMaterialIcon(
      iconData: Icons.api_rounded,
      name: 'Backend API Development',
      description: 'Scalable backend services and RESTful API development',
      proficiency: 80,
      technologies: ['Flask', 'SpringBoot', 'PostgreSQL', 'API Development'],
      experience: '3+ years',
      relatedProjectTitles: [
        ProjectTitles.finalYearProject,
        ProjectTitles.nutricoachHealthApp,
      ],
    ),
    SkillModel.withMaterialIcon(
      iconData: Icons.layers_rounded,
      name: 'FullStack Development',
      description:
          'End-to-end application development from concept to deployment',
      proficiency: 88,
      technologies: ['NodeJS', 'Flask', 'AWS', 'Supabase', 'Unit Testing'],
      experience: '1+ years',
      relatedProjectTitles: [
        ProjectTitles.finalYearProject,
        ProjectTitles.portfolioWebsite,
      ],
    ),
  ];
}
