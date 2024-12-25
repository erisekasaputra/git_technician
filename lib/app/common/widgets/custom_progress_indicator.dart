import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final Color activeColor;
  final Color inactiveColor;
  final double height;
  final double spacing;

  const CustomProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.height = 3,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            child: CustomPaint(
              painter: GradientProgressPainter(
                progress: index < currentStep ? 1 : 0,
                gradient: LinearGradient(
                  colors: [activeColor.withOpacity(0.5), activeColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                backgroundColor: inactiveColor,
              ),
              size: Size(double.infinity, height),
            ),
          ),
        );
      }),
    );
  }
}

class GradientProgressPainter extends CustomPainter {
  final double progress;
  final Gradient gradient;
  final Color backgroundColor;

  GradientProgressPainter({
    required this.progress,
    required this.gradient,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    // Draw background
    paint.color = backgroundColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Offset.zero & size, Radius.circular(size.height / 2)),
      paint,
    );

    // Draw progress
    if (progress > 0) {
      paint.shader = gradient.createShader(Offset.zero & size);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Offset.zero & Size(size.width * progress, size.height),
          Radius.circular(size.height / 2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GradientProgressPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      gradient != oldDelegate.gradient ||
      backgroundColor != oldDelegate.backgroundColor;
}
