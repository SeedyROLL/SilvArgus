import 'dart:math';
import 'package:flutter/material.dart';

class HealthScoreGauge extends StatelessWidget {
  final double score;

  const HealthScoreGauge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final percentage = (score * 100).toInt();
    final Color gaugeColor = score > 0.8 
        ? const Color(0xFF2E7D32) 
        : (score > 0.5 ? Colors.orange : Colors.red);
        
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: GaugePainter(score: score, activeColor: gaugeColor),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: gaugeColor,
                  ),
                ),
                Text(
                  'Confidence',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double score;
  final Color activeColor;

  GaugePainter({required this.score, required this.activeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 6;
    
    canvas.drawCircle(center, radius, backgroundPaint);

    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * score;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.score != score;
  }
}
