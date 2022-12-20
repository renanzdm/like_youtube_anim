import 'dart:math';

import 'package:flutter/material.dart';
import 'package:like_button_anim/serpentine_widget.dart';

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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;
  List<Offset> offsets = [];
  late final Animation<double> sizeTweenButtonLike;
  late final Animation<double> rotateTweenButtonLike;
  late final Animation<Color?> colorTweenButton;
  late final Animation<double> firesAnimation;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    animation = CurvedAnimation(parent: animationController, curve: Curves.decelerate);
    colorTweenButton = TweenSequence<Color?>([
      TweenSequenceItem<Color?>(
        tween: ColorTween(begin: Colors.white, end: Colors.green).chain(CurveTween(curve: Curves.easeIn)),
        weight: 33,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(begin: Colors.purple, end: Colors.yellow).chain(CurveTween(curve: Curves.easeIn)),
        weight: 33,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(begin: Colors.red, end: Colors.white).chain(CurveTween(curve: Curves.easeIn)),
        weight: 34,
      ),
    ]).animate(animationController);
    sizeTweenButtonLike = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween(begin: 30.0, end: 25.0),
        weight: 10,
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: 20.0, end: 35.0),
        weight: 80,
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: 35.0, end: 30.0),
        weight: 10,
      ),
    ]).animate(animationController);
    rotateTweenButtonLike = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween(begin: 0.0, end: -0.3),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: -0.3, end: 0.0),
        weight: 50,
      ),
    ]).animate(animationController);
    firesAnimation = Tween(begin: 50.0, end: 0.0)
        .chain(CurveTween(
          curve: Curves.easeIn,
        ))
        .animate(animationController);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        offsets.clear();
      }
    });

    super.initState();
  }

  void configureAnimation(double value) {
    var amplitude = 5.0;
    var degreeToRadians = (value * 700.0) * (pi / 180);
    var cosX = (cos(degreeToRadians) + degreeToRadians / 2) * amplitude;
    var senY = sin(degreeToRadians) * amplitude;
    offsets.add(Offset(25 + cosX, 25 + senY));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AnimatedBuilder(
        animation: animationController,
        builder: (context, snapshot) {
          configureAnimation(animation.value);
          return Container(
            color: Colors.red,
            height: 200,
            width: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                    angle: -pi * .3,
                    child: firesAnimation.isCompleted ? ExplodesWidget(animation: firesAnimation.value) : FiresWidget(animation: firesAnimation.value)),
                Positioned(
                  left: 70,
                  top: 50,
                  child: Transform.rotate(
                    angle: 3 * pi / 2 + 0.4,
                    child: SerpentineWidget(
                      offsets: offsets,
                    ),
                  ),
                ),
                Positioned(
                  left: 70,
                  top: 95,
                  child: Transform.rotate(
                    angle: pi / 2 + 0.4,
                    child: SerpentineWidget(
                      offsets: offsets,
                    ),
                  ),
                ),
                Transform.rotate(
                  origin: const Offset(-20.0, 10.0),
                  angle: rotateTweenButtonLike.value,
                  child: IconButton(
                    onPressed: () {
                      offsets.clear();
                      animationController.forward(from: 0.0);
                    },
                    icon: Icon(
                      Icons.thumb_up,
                      color: colorTweenButton.value,
                      size: sizeTweenButtonLike.value,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FiresWidget extends StatelessWidget {
  const FiresWidget({super.key, required this.animation});
  final double animation;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100.0, 100.0),
      painter: FireArtificts(animation),
    );
  }
}

class FireArtificts extends CustomPainter {
  const FireArtificts(this.animation);
  final double animation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset((size.width / 2), size.height / 2), Offset(size.width / 2, animation), paint);

    canvas.drawLine(Offset(size.width / 2, size.height / 2), Offset(animation, size.height / 2), paint);

    canvas.drawLine(Offset(size.width / 2, size.height / 2), Offset(100 - animation, size.height / 2), paint);

    canvas.drawLine(Offset(size.width / 2, size.height / 2), Offset(size.width / 2, 100 - animation), paint);

    // for (var i = 0; i <= 300; i += 60) {
    //   var degreeToRadians = i * (pi / 180);
    //   canvas.drawLine(Offset((cos(degreeToRadians) * 50) + 50, (sin(degreeToRadians) * 50) + 50),
    //       Offset((cos(degreeToRadians) * (100 * animation)) + 50, (sin(degreeToRadians) * (100 * animation)) + 50), paint);
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ExplodesWidget extends StatelessWidget {
  const ExplodesWidget({super.key, required this.animation});
  final double animation;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100.0, 100.0),
      painter: ExplodesArtificts(animation),
    );
  }
}

class ExplodesArtificts extends CustomPainter {
  const ExplodesArtificts(this.animation);
  final double animation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var i = 0; i <= 300; i += 60) {
      var degreeToRadians = i * (pi / 180);
      canvas.drawLine(Offset((cos(degreeToRadians) * 50) + 50, (sin(degreeToRadians) * 50) + 50),
          Offset((cos(degreeToRadians) * (100 * animation)) + 50, (sin(degreeToRadians) * (100 * animation)) + 50), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
