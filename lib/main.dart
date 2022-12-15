import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double animation = 0.0;
  final offsets = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Slider(
              min: 0,
              max: 1000,
              value: animation,
              onChanged: (value) {
                setState(() {
                  animation = value;
                  var amplitude = 20.0;
                  var degreeToRadians = value * (pi / 180);
                  var cosX =
                      (cos(degreeToRadians) + degreeToRadians / 2) * amplitude;
                  var senY = sin(degreeToRadians) * amplitude;
                  offsets.add(Offset(cosX, senY));
                });
              }),
          Center(
            child: CustomPaint(
              size: const Size(500.0, 500.0),
              painter: CurveSerpentine(animation: offsets),
            ),
          ),
        ],
      ),
    );
  }
}

class CurveSerpentine extends CustomPainter {
  final List<Offset> animation;

  CurveSerpentine({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;
    canvas.drawPoints(PointMode.polygon, animation, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
