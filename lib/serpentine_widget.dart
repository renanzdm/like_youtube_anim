import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class SerpentineWidget extends StatelessWidget {
  const SerpentineWidget({super.key, required this.offsets});

  final List<Offset> offsets;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        foregroundPainter: CurveSerpentine(listOffsets: offsets),
        size: const Size(50, 50),
      ),
    );
  }
}

class CurveSerpentine extends CustomPainter {
  final List<Offset> listOffsets;
  CurveSerpentine({required this.listOffsets});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;
    canvas.drawPoints(ui.PointMode.polygon, listOffsets, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
