import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_back_button.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/financial_controller.dart';

class FinancialView extends GetView<FinancialController> {
  const FinancialView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
          child: CustomBackButton(
            onPressed: () => Get.back(),
          ),
        ),
        leadingWidth: 60,
        title: const Text(
          'Financial',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('Total Fees', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              const SizedBox(height: 20),
              _buildTotalFeesChart(context),
              const SizedBox(height: 20),
              _buildWeekSelector(context),
              const SizedBox(height: 20),
              _buildJobsCompleted(),
              const SizedBox(height: 20),
              _buildJobList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalFeesChart(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color primary_100 = Theme.of(context).colorScheme.primary_100;
    final Color primary_50 = Theme.of(context).colorScheme.primary_50;
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: GradientCircularProgressPainter(
                progress: 0.70,
                strokeWidth: 25,
                gradientColors: [
                  primary_100,
                  primary_300,
                ],
                backgroundColor: primary_50,
              ),
              size: const Size(200, 200),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('RM', style: TextStyle(fontSize: 20)),
                Obx(() => Text(
                  controller.totalFees.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSelector(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildWeekButton('Week 1', 0, primary_300, borderInput_01),
        _buildWeekButton('Week 2', 1, primary_300, borderInput_01),
        _buildWeekButton('Week 3', 2, primary_300, borderInput_01),
      ],
    );
  }

  Widget _buildWeekButton(String text, int index, Color color, Color borderColor) {
    return Obx(() => ElevatedButton(
      onPressed: () => controller.selectWeek(index),
      style: ElevatedButton.styleFrom(
        foregroundColor: controller.selectedWeek.value == index ? Colors.white : Colors.black, 
        backgroundColor: controller.selectedWeek.value == index ? color : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: controller.selectedWeek.value == index ? BorderSide.none : BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Text(text),
    ));
  }

  Widget _buildJobsCompleted() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Jobs Completed', style: TextStyle(fontSize: 16)),
        Obx(() => Text('${controller.jobsCompleted}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildJobList() {
    return Obx(() => Column(
      children: controller.jobs.map((job) => _buildJobItem(job)).toList(),
    ));
  }

  Widget _buildJobItem(Job job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey[100]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.id, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(job.date),
                    const SizedBox(width: 8),
                    const Icon(Icons.access_time, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(job.time),
                  ],
                ),
              ],
            ),
            Text('RM${job.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Color backgroundColor;

  GradientCircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradientColors,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi,
      false,
      backgroundPaint,
    );

    // Draw progress with gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradientPaint = Paint()
      ..shader = SweepGradient(
        colors: gradientColors,
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        tileMode: TileMode.clamp,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * progress,
      false,
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}