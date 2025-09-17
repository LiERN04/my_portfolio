import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'screens/home_screen.dart';
import 'screens/skill_detail_screen.dart';
import 'screens/project_detail_screen.dart';
import 'providers/theme_provider.dart';
import 'data/personal_data.dart';
import 'data/project_data.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/skill/:skillIndex',
      builder: (context, state) {
        final skillIndex = int.parse(state.pathParameters['skillIndex']!);
        final skill = PersonalData.skills[skillIndex];
        return SkillDetailScreen(skill: skill);
      },
    ),
    GoRoute(
      path: '/project/:projectIndex',
      builder: (context, state) {
        final projectIndex = int.parse(state.pathParameters['projectIndex']!);
        // Flatten all projects from all categories into one list
        final allProjects = ProjectData.categories
            .expand((category) => category.projects)
            .toList();
        final project = allProjects[projectIndex];
        return ProjectDetailScreen(project: project);
      },
    ),
  ],
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);

    return MaterialApp.router(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
        ],
      ),
      routerConfig: _router,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: 'My Portfolio',
    );
  }
}

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  textTheme: GoogleFonts.poppinsTextTheme(),
);

final darkTheme = ThemeData(
  colorScheme:
      ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ).copyWith(
        // Enhanced dark mode colors for better readability
        surface: const Color(0xFF0F0F0F), // Darker background
        surfaceContainerLowest: const Color(0xFF1A1A1A), // Cards and containers
        surfaceContainerLow: const Color(
          0xFF1E1E1E,
        ), // Slightly lighter containers
        surfaceContainer: const Color(0xFF242424), // Medium containers
        surfaceContainerHigh: const Color(0xFF2A2A2A), // Higher containers
        surfaceContainerHighest: const Color(0xFF303030), // Highest containers
        onSurface: const Color(0xFFE8E8E8), // High contrast text
        onSurfaceVariant: const Color(0xFFB8B8B8), // Medium contrast text
        outline: const Color(0xFF404040), // Borders and dividers
        outlineVariant: const Color(0xFF2A2A2A), // Subtle borders
        primary: const Color(0xFF4FC3F7), // Brighter blue for better visibility
        onPrimary: const Color(0xFF0A0A0A), // High contrast on primary
        primaryContainer: const Color(0xFF1A237E), // Darker primary container
        onPrimaryContainer: const Color(
          0xFFE3F2FD,
        ), // Light text on primary container
        secondary: const Color(0xFF81C784), // Green accent for variety
        onSecondary: const Color(0xFF0A0A0A), // High contrast on secondary
        tertiary: const Color(0xFFFFB74D), // Orange accent
        onTertiary: const Color(0xFF0A0A0A), // High contrast on tertiary
        error: const Color(0xFFFF6B6B), // More visible error color
        onError: const Color(0xFF0A0A0A), // High contrast on error
        shadow: const Color(0x40000000), // Enhanced shadow for depth
      ),
  useMaterial3: true,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
    // Enhanced text styles for better readability in dark mode
    displayLarge: GoogleFonts.poppins(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: const Color(0xFFE8E8E8),
      height: 1.12,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: const Color(0xFFE8E8E8),
      height: 1.16,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: const Color(0xFFE8E8E8),
      height: 1.22,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: const Color(0xFFE8E8E8),
      height: 1.25,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: const Color(0xFFE8E8E8),
      height: 1.29,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: const Color(0xFFE8E8E8),
      height: 1.33,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: const Color(0xFFE8E8E8),
      height: 1.27,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: const Color(0xFFE8E8E8),
      height: 1.50,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: const Color(0xFFE8E8E8),
      height: 1.43,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: const Color(0xFFD0D0D0),
      height: 1.50,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: const Color(0xFFD0D0D0),
      height: 1.43,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: const Color(0xFFB8B8B8),
      height: 1.33,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: const Color(0xFFE8E8E8),
      height: 1.43,
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: const Color(0xFFE8E8E8),
      height: 1.33,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: const Color(0xFFE8E8E8),
      height: 1.45,
    ),
  ),
  // Enhanced card theme for dark mode
  cardTheme: const CardThemeData(
    color: Color(0xFF1E1E1E),
    shadowColor: Color(0x40000000),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  // Enhanced app bar theme for dark mode
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A),
    foregroundColor: Color(0xFFE8E8E8),
    elevation: 2,
    shadowColor: Color(0x40000000),
  ),
  // Enhanced input decoration theme for dark mode
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF242424),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF404040)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF4FC3F7), width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFFB8B8B8)),
    hintStyle: const TextStyle(color: Color(0xFF808080)),
  ),
);
