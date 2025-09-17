import 'package:portfolio/data/models/project_model.dart';

class ProjectData {
  static const List<ProjectCategory> categories = [
    ProjectCategory(
      title: 'Mobile Apps',
      projects: [
        ProjectModel(
          title: 'NutriCoach Health App',
          description:
              'NutriCoach is a nutrition-tracking Android application that demonstrates modern mobile development practices. The project highlights my ability to build scalable, maintainable, and user-friendly mobile apps by following clean architecture principles, ensuring robust state management, and integrating persistent storage and API communication.',
          technologies: 'Kotlin, Jetpack Compose, MVVM, Room, Retrofit',
          imageUrl: 'images/nutricoach.png',
          status: 'Completed',
          demoUrl: "https://github.com/LiERN04/nutricoach",
          sourceUrl:
              'https://github.com/LiERN04/nutricoach', 
          techStack: [
            'Kotlin',
            'Jetpack Compose',
            'MVVM Architecture',
            'Room Database',
            'Retrofit',
            'StateFlow',
            'Navigation Compose',
            'SharedPreferences',
            'Gson',
            'Material Design 3',
          ],
          features: [
            ProjectFeature(
              title: 'Intuitive UI/UX',
              description:
                  'Built fully in Jetpack Compose with declarative UI design and bottom navigation',
              icon: 'palette',
            ),
            ProjectFeature(
              title: 'MVVM Architecture',
              description:
                  'Clean separation of concerns with Repository pattern and lifecycle awareness',
              icon: 'architecture',
            ),
            ProjectFeature(
              title: 'Persistent Data',
              description:
                  'Session management and database persistence for seamless user experience',
              icon: 'storage',
            ),
            ProjectFeature(
              title: 'API Integration',
              description:
                  'Retrofit integration with clean asynchronous calls and error handling',
              icon: 'api',
            ),
          ],
          detailedContent: [
            ProjectContent(
              type: ProjectContentType.gallery,
              title: 'App Screenshots Gallery',
              imageUrls: [
                'images/ntc_home.png',
                'images/ntc_settings.png',
                'images/ntc_login.png',
                'images/mockup.png',
              ],
              imageCaptions: [
                'Home Screen',
                'Settings Screen',
                'Login Screen',
                'Wireframe',
              ],
            ),
          ],
          // challenges:
          //     'The main challenges included managing complex state across multiple screens while maintaining data consistency, implementing proper session persistence that survives app restarts and device reboots, and creating a smooth user experience when transitioning between online and offline modes.',
          // solutions:
          //     'Implemented a centralized SessionManager with SharedPreferences persistence, used StateFlow for reactive state management across the app, created a Repository pattern that abstracts data sources and handles caching, and established clear navigation patterns that preserve user context.',
        ),
      ],
    ),
    ProjectCategory(
      title: 'Web Applications',
      projects: [
        ProjectModel(
          title: 'Portfolio Website',
          description:
              'Personal portfolio website built with responsive design and modern animations',
          technologies: 'Dart, Flutter Web, Responsive Framework',
          imageUrl: 'images/flutter-banner.png',
          status: 'Completed',
          sourceUrl:
              'https://github.com/LiERN04/my_portfolio',
          techStack: [
            'Flutter Web',
            'Dart',
            'Responsive Framework',
            'Riverpod',
            'Go Router',
            'Material Design 3',
          ],
          features: [
            ProjectFeature(
              title: 'Responsive Design',
              description:
                  'Seamless experience across desktop, tablet, and mobile',
              icon: 'devices',
            ),
            ProjectFeature(
              title: 'Smooth Animations',
              description:
                  'Engaging scroll-triggered animations and transitions',
              icon: 'animation',
            ),
            ProjectFeature(
              title: 'Modern UI',
              description: 'Clean, professional design with Material 3',
              icon: 'palette',
            ),
          ],
        ),
        ProjectModel(
          title: 'Final Year Project (Customizable AI Chatbot)',
          description:
              'A comprehensive web application that allows users to build custom chatbots with their own training data',
          technologies: 'React, Flask, Supabase',
          imageUrl: 'images/gasy-banner.png',
          status: 'Completed',
          sourceUrl:
              'https://github.com/yourusername/ai-chatbot-platform', // Add your actual GitHub URL
          techStack: [
            'React',
            'TypeScript',
            'Flask',
            'Python',
            'Supabase',
            'OpenAI API',
            'Material-UI',
            'Docker',
          ],
          features: [
            ProjectFeature(
              title: 'Custom Training Data',
              description:
                  'Upload and manage custom datasets for chatbot training',
              icon: 'cloud_upload',
            ),
            ProjectFeature(
              title: 'Embeddable Widget',
              description: 'Generate embeddable chat widgets for websites',
              icon: 'integration_instructions',
            ),
            ProjectFeature(
              title: 'Real-time Analytics',
              description: 'Monitor chatbot performance and user interactions',
              icon: 'analytics',
            ),
          ],
          detailedContent: [
            ProjectContent(
              type: ProjectContentType.text,
              title: 'Project Background',
              content:
                  'This final year project addresses the growing need for customizable AI chatbots in business. The platform allows users to create intelligent chatbots trained on their specific data, making AI accessible to businesses without technical expertise.',
            ),
            ProjectContent(
              type: ProjectContentType.image,
              title: 'Dashboard Interface',
              imageUrl: 'images/gasy-banner.png',
              caption:
                  'Main dashboard showing chatbot management and analytics',
            ),
          ],
          challenges:
              'Implementing efficient model training pipeline while managing large datasets and ensuring real-time chat performance',
          solutions:
              'Used containerized microservices architecture with Docker and implemented caching strategies for faster response times',
        ),
      ],
    ),
  ];
}
