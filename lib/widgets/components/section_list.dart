import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:portfolio/widgets/components/scroll_fade_in.dart';
import 'package:portfolio/widgets/components/styled_section_container.dart';
import 'package:portfolio/widgets/sections/hero_section.dart';
import 'package:portfolio/widgets/sections/about_section.dart';
import 'package:portfolio/widgets/sections/skills_section.dart';
import 'package:portfolio/widgets/sections/projects_section.dart';
import 'package:portfolio/widgets/sections/get_in_touch_section.dart';

class SectionList extends StatelessWidget {
  final GlobalKey aboutKey;
  final GlobalKey skillsKey;
  final GlobalKey projectsKey;
  final GlobalKey contactKey;
  final Map<String, bool> sectionAnimationStates;
  final int aboutTabIndex;
  final Function(Function(int)?)? onAboutTabControllerReady;

  const SectionList({
    super.key,
    required this.aboutKey,
    required this.skillsKey,
    required this.projectsKey,
    required this.contactKey,
    required this.sectionAnimationStates,
    required this.aboutTabIndex,
    this.onAboutTabControllerReady,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveValue(
          context,
          conditionalValues: [
            const Condition.smallerThan(name: TABLET, value: 16.0),
          ],
          defaultValue: 24.0,
        ).value,
        vertical: 24,
      ),
      child: Column(
        children: [
          // Hero section with custom styling (always visible initially)
          StyledSectionContainer(
            style: SectionStyle.hero,
            child: const HeroSection(),
          ),

          _buildDivider(),

          // About section with scroll-triggered animation
          ScrollFadeIn(
            isVisible: sectionAnimationStates['about'] ?? true,
            duration: const Duration(milliseconds: 1000),
            slideOffset: const Offset(0, 60),
            child: StyledSectionContainer(
              style: SectionStyle.normal,
              child: AboutSection(
                key: aboutKey,
                initialTabIndex: aboutTabIndex,
                onTabControllerReady: onAboutTabControllerReady,
              ),
            ),
          ),

          _buildDivider(),

          // Skills section with scroll-triggered animation
          ScrollFadeIn(
            isVisible: sectionAnimationStates['skills'] ?? false,
            duration: const Duration(milliseconds: 1200),
            slideOffset: const Offset(0, 60),
            child: StyledSectionContainer(
              style: SectionStyle.normal,
              child: SkillsSection(key: skillsKey),
            ),
          ),

          _buildDivider(),

          // Projects section with scroll-triggered animation
          ScrollFadeIn(
            isVisible: sectionAnimationStates['projects'] ?? false,
            duration: const Duration(milliseconds: 1400),
            slideOffset: const Offset(0, 60),
            child: StyledSectionContainer(
              style: SectionStyle.normal,
              child: ProjectsSection(key: projectsKey),
            ),
          ),

          _buildDivider(),

          // Contact section with scroll-triggered animation
          ScrollFadeIn(
            isVisible: sectionAnimationStates['contact'] ?? false,
            duration: const Duration(milliseconds: 1600),
            slideOffset: const Offset(0, 60),
            child: StyledSectionContainer(
              style: SectionStyle.elevated,
              child: GetInTouchSection(key: contactKey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const SizedBox(height: 24);
  }
}
