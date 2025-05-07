import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/constants/env.dart';

class TestLoadingWidget extends StatefulWidget {
  final double size;
  final Color ringColor;
  final double padding;

  const TestLoadingWidget({
    Key? key,
    this.size = 100,
    this.ringColor = Colors.blue,
    this.padding = 16.0,
  }) : super(key: key);

  @override
  _TestLoadingWidgetState createState() => _TestLoadingWidgetState();
}

class _TestLoadingWidgetState extends State<TestLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late CoOperative coOperative;

  @override
  void initState() {
    super.initState();
    // Create an animation controller that completes a full rotation in 1.5 seconds
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(); // Automatically repeat the animation

    coOperative = RepositoryProvider.of<CoOperative>(context);

    print(coOperative);
  }

  @override
  void dispose() {
    // Important: Always dispose of the AnimationController to prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The stationary image with padding
          Padding(
            padding: EdgeInsets.all(widget.padding),
            child:
                coOperative.coOperativeLogo.contains("http")
                    ? CachedNetworkImage(
                      imageUrl: coOperative.coOperativeLogo,
                      width: widget.size,
                      height: widget.size,
                      fit: BoxFit.contain,
                    )
                    : Image.asset(
                      coOperative.coOperativeLogo,
                      width: widget.size,
                      height: widget.size,
                      fit: BoxFit.contain,
                    ),
          ),

          // Rotating ring
          RotationTransition(
            turns: _controller,
            child: CustomPaint(
              painter: _LoaderRingPainter(
                ringColor: widget.ringColor,
                ringWidth: 8.0,
                outerSize: widget.size + (widget.padding * 2),
                padding: widget.padding,
              ),
              child: SizedBox(
                width: widget.size + (widget.padding * 2),
                height: widget.size + (widget.padding * 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoaderRingPainter extends CustomPainter {
  final Color ringColor;
  final double ringWidth;
  final double outerSize;
  final double padding;

  _LoaderRingPainter({
    required this.ringColor,
    required this.ringWidth,
    required this.outerSize,
    required this.padding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (padding / 2);

    // Draw background ring (semi-transparent)
    final backgroundPaint =
        Paint()
          ..color = ringColor.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = ringWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw loading arc
    final arcPaint =
        Paint()
          ..color = ringColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = ringWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14 / 2, // Start from top
      3.14 * 1.5, // Arc length
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
