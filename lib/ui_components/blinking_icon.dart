import 'package:flutter/material.dart';

class BlinkingIcon extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const BlinkingIcon({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 100),
  }) : super(key: key);

  @override
  _BlinkingIconState createState() => _BlinkingIconState();
}

class _BlinkingIconState extends State<BlinkingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _blinkCount = 0;
  final int _maxBlinks = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Create a tween for opacity from fully visible to invisible.
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    // Loop the animation for a specified number of times.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_blinkCount < _maxBlinks) {
          _controller.reverse();
          _blinkCount++;
        }
      } else if (status == AnimationStatus.dismissed) {
        if (_blinkCount < _maxBlinks) {
          _controller.forward();
        }
      }
    });

    _controller.forward();
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
}