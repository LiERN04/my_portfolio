import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AboutMeTab extends StatelessWidget {
  const AboutMeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isTablet = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Column(
      children: [
        // Scroll indicator for mobile
        if (isMobile)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.swipe_vertical,
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  'Scroll to explore',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

        // Content with fade effect
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: isMobile ? 4 : 16),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.05, 0.95, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ResponsiveRowColumn(
                  layout: isTablet
                      ? ResponsiveRowColumnType.COLUMN
                      : ResponsiveRowColumnType.ROW,
                  rowCrossAxisAlignment: CrossAxisAlignment.start,
                  columnMainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ResponsiveRowColumnItem(
                      rowFlex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Passionate Developer',
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'I am a dedicated full-stack developer with a passion for creating innovative solutions. '
                            'My journey in technology started 3 years ago, and since then, I\'ve been committed to '
                            'building applications that make a difference.',
                            style: textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 48),
                          Text(
                            'What programming language I EXCELLS at',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const [
                              Chip(label: Text('JavaScript')),
                              Chip(label: Text('Java')),
                              Chip(label: Text('Python')),
                              Chip(label: Text('Dart')),
                              Chip(label: Text('Kotlin')),
                            ],
                          ),
                          const SizedBox(height: 8,),

                          Text(
                            'What frameworks I LOVE',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8,),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const [
                              Chip(label: Text('ReactJS')),
                              Chip(label: Text('Flutter')),
                              Chip(label: Text('SprintBoot')),
                              Chip(label: Text('Flask')),
                              Chip(label: Text('Jetpack Compose')),
                            ],
                          )
                        ],
                        
                      ),
                    ),
                    ResponsiveRowColumnItem(
                      rowFlex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: isTablet ? 0 : 24,
                          top: isTablet ? 24 : 0,
                        ),
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 300,
                              maxHeight: 400,
                            ),
                            child: AspectRatio(
                              aspectRatio: 3 / 4, // Portrait aspect ratio
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 8),
                                    ),
                                    // Additional glow effect
                                    BoxShadow(
                                      color: colorScheme.primary.withOpacity(
                                        0.15,
                                      ),
                                      blurRadius: 40,
                                      spreadRadius: 5,
                                      offset: const Offset(0, 4),
                                    ),
                                    // Subtle secondary glow
                                    BoxShadow(
                                      color: colorScheme.secondary.withOpacity(
                                        0.1,
                                      ),
                                      blurRadius: 60,
                                      spreadRadius: -5,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'images/portrait.jpg',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              colorScheme.primary.withOpacity(
                                                0.3,
                                              ),
                                              colorScheme.secondary.withOpacity(
                                                0.3,
                                              ),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 80,
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.6),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'Profile Image',
                                                style: textTheme.titleMedium
                                                    ?.copyWith(
                                                      color: colorScheme
                                                          .onSurface
                                                          .withOpacity(0.6),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
