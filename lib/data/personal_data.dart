import 'package:portfolio/data/models/skill_model.dart';
import 'package:portfolio/data/models/experience_model.dart';
import 'package:portfolio/data/models/academic_model.dart';

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
    // ExperienceModel(
    //   position: 'Flutter Developer',
    //   company: 'Personal Projects',
    //   companyLogo: 'svgs/flutter.svg',
    //   duration: 'January 2023 - Present',
    //   location: 'Remote',
    //   employmentType: 'Freelance',
    //   description:
    //       'Developed multiple cross-platform mobile applications using Flutter, '
    //       'focusing on beautiful UI/UX design and performant solutions.',
    //   keyResponsibilities: [
    //     'Mobile App Development - Created responsive cross-platform applications',
    //     'UI/UX Design - Implemented modern and intuitive user interfaces',
    //     'State Management - Utilized various state management solutions (Riverpod, Bloc)',
    //     'Firebase Integration - Implemented authentication, storage, and real-time features',
    //     'Performance Optimization - Ensured smooth animations and fast load times',
    //     'Code Quality - Maintained clean, documented, and testable code',
    //   ],
    //   achievements: [
    //     'Built 3+ production-ready mobile applications',
    //     'Achieved 4.5+ star ratings on app stores',
    //     'Implemented complex animations and custom widgets',
    //     'Successfully integrated multiple third-party services',
    //   ],
    //   technologiesUsed: [
    //     'Flutter',
    //     'Dart',
    //     'Firebase',
    //     'Riverpod',
    //     'Bloc',
    //     'HTTP',
    //     'SQLite',
    //     'Git',
    //   ],
    //   companyWebsite: null,
    // ),
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
    SkillModel(
      icon: 'svgs/flutter.svg',
      name: 'Mobile Development',
      description:
          'Mobile app development utilizing practices such as MVVM, state management, app lifecycle mangement and navigaton',
      proficiency: 90,
      technologies: ['Flutter', 'Dart', 'Firebase', 'State Management'],
      experience: '1+ years',
    ),
    SkillModel(
      icon: 'svgs/dart.svg',
      name: 'Frontend UI/UX Development',
      description:
          'Modern responsive web interfaces with great user experience',
      proficiency: 85,
      technologies: ['React', 'Vue.js', 'TypeScript', 'CSS3', 'Figma'],
      experience: '4+ years',
    ),
    SkillModel(
      icon: 'images/react.png',
      name: 'Backend API Development',
      description: 'Scalable backend services and RESTful API development',
      proficiency: 80,
      technologies: ['Node.js', 'Express', 'MongoDB', 'PostgreSQL'],
      experience: '3+ years',
    ),
    SkillModel(
      icon: 'svgs/git.svg',
      name: 'FullStack Development',
      description:
          'End-to-end application development from concept to deployment',
      proficiency: 88,
      technologies: ['Git', 'Docker', 'AWS', 'CI/CD', 'Testing'],
      experience: '5+ years',
    ),
  ];
}
