import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrollState {
  final double scrollPosition;
  final Map<String, bool> sectionAnimationStates;
  final String currentSection;

  ScrollState({
    required this.scrollPosition,
    required this.sectionAnimationStates,
    required this.currentSection,
  });

  ScrollState copyWith({
    double? scrollPosition,
    Map<String, bool>? sectionAnimationStates,
    String? currentSection,
  }) {
    return ScrollState(
      scrollPosition: scrollPosition ?? this.scrollPosition,
      sectionAnimationStates:
          sectionAnimationStates ?? this.sectionAnimationStates,
      currentSection: currentSection ?? this.currentSection,
    );
  }
}

class ScrollNotifier extends StateNotifier<ScrollState> {
  ScrollNotifier()
    : super(
        ScrollState(
          scrollPosition: 0.0,
          sectionAnimationStates: {
            'hero': true,
            'about': true,
            'skills': false,
            'projects': false,
            'contact': false,
          },
          currentSection: 'hero',
        ),
      );

  void updateScrollPosition(double position) {
    state = state.copyWith(scrollPosition: position);
  }

  void updateSectionAnimationState(String section, bool isAnimated) {
    final newStates = Map<String, bool>.from(state.sectionAnimationStates);
    newStates[section] = isAnimated;
    state = state.copyWith(sectionAnimationStates: newStates);
  }

  void updateCurrentSection(String section) {
    state = state.copyWith(currentSection: section);
  }

  void resetState() {
    state = ScrollState(
      scrollPosition: 0.0,
      sectionAnimationStates: {
        'hero': true,
        'about': true,
        'skills': false,
        'projects': false,
        'contact': false,
      },
      currentSection: 'hero',
    );
  }
}

final scrollProvider = StateNotifierProvider<ScrollNotifier, ScrollState>((
  ref,
) {
  return ScrollNotifier();
});
