import 'package:flutter/material.dart';

class FadeTransitionWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool initiallyVisible;

  const FadeTransitionWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.initiallyVisible = true,
  });

  @override
  State<FadeTransitionWidget> createState() => _FadeTransitionWidgetState();
}

class _FadeTransitionWidgetState extends State<FadeTransitionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: widget.initiallyVisible ? 1.0 : 0.0, end: 1.0)
        .animate(_controller);

    if (widget.initiallyVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(FadeTransitionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyVisible != widget.initiallyVisible) {
      if (widget.initiallyVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }

  void show() {
    _controller.forward();
  }

  void hide() {
    _controller.reverse();
  }
}