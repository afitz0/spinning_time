import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimeMachine(),
    );
  }
}

class TimeMachine extends StatefulWidget {
  @override
  _TimeMachineState createState() => _TimeMachineState();
}

class _TimeMachineState extends State<TimeMachine>
    with TickerProviderStateMixin {
  AnimationController _rotationAnimation;
  AnimationController _scaleAnimation;
  AnimationController _galaxyAnimation;

  Animation<double> _scaleCurve;

  @override
  void initState() {
    super.initState();
    _rotationAnimation = AnimationController(
      duration: const Duration(milliseconds: 3600),
      vsync: this,
    )..repeat();

    _galaxyAnimation = AnimationController(
      duration: const Duration(milliseconds: 14400),
      vsync: this,
    )..repeat();

    _scaleAnimation = AnimationController(
      duration: const Duration(milliseconds: 3600),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _scaleAnimation.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _scaleAnimation.forward();
        }
      });

    _scaleCurve =
        CurvedAnimation(parent: _scaleAnimation, curve: Curves.easeIn);

    _scaleAnimation.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: RotationTransition(
                  turns: _galaxyAnimation,
                  child: Image.asset('galaxy_transparent.png'),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ScaleTransition(
                  scale: _scaleCurve,
                  child: RotationTransition(
                    turns: _rotationAnimation,
                    child: Icon(
                      Icons.hourglass_empty,
                      size: 192,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
