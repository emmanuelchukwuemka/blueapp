import 'package:flutter/material.dart';

class SlideTransitionWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset beginOffset;
  final Offset endOffset;
  final bool initiallyVisible;

  const SlideTransitionWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.beginOffset = const Offset(0.0, 0.5),
    this.endOffset = const Offset(0.0, 0.0),
    this.initiallyVisible = true,
  });

  @override
  State<SlideTransitionWidget> createState() => _SlideTransitionWidgetState();
}

class _SlideTransitionWidgetState extends State<SlideTransitionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: widget.initiallyVisible ? widget.endOffset : widget.beginOffset,
      end: widget.endOffset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.initiallyVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(SlideTransitionWidget oldWidget) {
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
    return SlideTransition(
      position: _animation,
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