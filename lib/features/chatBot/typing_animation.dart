import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final double dotSize;
  final double dotSpacing;
  final Duration duration;
  final Color dotColor;

  const TypingIndicator({
    Key? key,
    this.dotSize = 10.0,
    this.dotSpacing = 6.0,
    this.duration = const Duration(milliseconds: 500),
    this.dotColor = Colors.white,
  }) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.6), weight: 50),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _getScaleForIndex(index),
              child: child,
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: widget.dotSpacing / 2),
            width: widget.dotSize,
            height: widget.dotSize,
            decoration: BoxDecoration(
              color: widget.dotColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  double _getScaleForIndex(int index) {
    final double progress = (_controller.value + (index * 0.3)) % 1.0;
    return Tween(begin: 0.6, end: 1.0).transform(
      progress.clamp(0.0, 1.0),
    );
  }
}
