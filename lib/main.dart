import 'package:flutter/material.dart';

void main() => runApp(MyApp());

const double smallIconSize = 24.0;
const double largeIconSize = 196.0;

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
  AnimationController _slideAnimation;

  Animation<double> _scaleCurve;
  Animation<Offset> _slideCurve;

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

    _scaleCurve = CurvedAnimation(
      parent: _scaleAnimation,
      curve: Curves.easeIn,
    );

    _scaleAnimation.forward();

    _slideAnimation = AnimationController(
      duration: const Duration(milliseconds: 3600),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _slideAnimation.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _slideAnimation.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    _slideCurve = Tween<Offset>(
      begin: Offset(-2, 2),
      end: Offset(
          deviceWidth / smallIconSize, -1 * deviceHeight / smallIconSize),
    ).animate(_slideAnimation);

    Animation<Offset> _reverseSlide = Tween<Offset>(
      begin: Offset(deviceWidth / smallIconSize, 2),
      end: Offset(-2, -1 * deviceHeight / smallIconSize),
    ).animate(_slideAnimation);

    _slideAnimation.forward();

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
                      size: largeIconSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: SlideTransition(
                  position: _slideCurve,
                  child: RotationTransition(
                    turns: _rotationAnimation,
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: smallIconSize,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: SlideTransition(
                  position: _reverseSlide,
                  child: RotationTransition(
                    turns: _rotationAnimation,
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: smallIconSize,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
