import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScannerOverlayPainter(),
      child: Container(),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final backgroundRect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    final double radius = size.width * 0.4;
    final center = Offset(size.width / 2, size.height / 2);
    final scanArea = Rect.fromCircle(center: center, radius: radius);

    final path = Path()
      ..addRect(backgroundRect)
      ..addOval(scanArea)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, backgroundPaint);

    final borderPaint = Paint()
      ..color = const Color(0xFF81C784)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
