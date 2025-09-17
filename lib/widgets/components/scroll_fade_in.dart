import 'package:flutter/material.dart';

class ScrollFadeIn extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;
  final Offset slideOffset;
  final Curve curve;

  const ScrollFadeIn({
    super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 800),
    this.slideOffset = const Offset(0, 50),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<ScrollFadeIn> createState() => _ScrollFadeInState();
}

class _ScrollFadeInState extends State<ScrollFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Start animation if initially visible
    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ScrollFadeIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.forward();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value.dx, _slideAnimation.value.dy),
          child: Opacity(opacity: _opacityAnimation.value, child: widget.child),
        );
      },
    );
  }
}
