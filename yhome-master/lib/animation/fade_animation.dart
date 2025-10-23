import 'dart:async';
import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  final double delay; // same as before
  final Widget child;

  const FadeAnimation(this.delay, this.child, {super.key});

  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation> {
  static const _animDuration = Duration(milliseconds: 500);
  static const double _fromY = -30.0; // slide up from -30px
  bool _start = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final delayMs = (500 * widget.delay).round();
    _timer = Timer(Duration(milliseconds: delayMs), () {
      if (mounted) setState(() => _start = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Opacity animates
    return AnimatedOpacity(
      duration: _animDuration,
      curve: Curves.easeOut,
      opacity: _start ? 1.0 : 0.0,
      // Translation animates
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: _fromY, end: _start ? 0.0 : _fromY),
        duration: _animDuration,
        curve: Curves.easeOut,
        child: widget.child,
        builder: (context, translateY, child) => Transform.translate(
          offset: Offset(0, translateY),
          child: child,
        ),
      ),
    );
  }
}
