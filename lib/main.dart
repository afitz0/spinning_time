import 'package:flutter/material.dart';

void main() => runApp(MyApp());

const double smallIconSize = 24.0;
const double largeIconSize = 196.0;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
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
  AnimationController _repeatingAnimationShort;
  AnimationController _repeatingAnimationLong;
  AnimationController _loopingAnimation;
  AnimationController _loopingAnimationLong;

  Animation<double> _scaleCurve;
  Animation<Offset> _slideCurve;
  Animation<Offset> _reverseSlide;
  Animation<double> _scaleCurveSlow;

  @override
  void initState() {
    super.initState();

    _repeatingAnimationShort = AnimationController(
      duration: const Duration(milliseconds: 3600),
      vsync: this,
    )..repeat();

    _repeatingAnimationLong = AnimationController(
      duration: const Duration(milliseconds: 14400),
      vsync: this,
    )..repeat();

    _loopingAnimation = AnimationController(
      duration: const Duration(milliseconds: 3600),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _loopingAnimation.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _loopingAnimation.forward();
        }
      });

    _loopingAnimationLong = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _loopingAnimationLong.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _loopingAnimationLong.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    _scaleCurve = CurvedAnimation(
      parent: _loopingAnimation,
      curve: Curves.easeIn,
    );

    _scaleCurveSlow = Tween<double>(
      begin: 0,
      end: 5,
    ).animate(_loopingAnimationLong);

    // _scaleCurveSlow = CurvedAnimation(
    //   parent: _loopingAnimationLong,
    //   curve: Curves.easeOutCirc,
    // );

    _slideCurve = Tween<Offset>(
      begin: Offset(-2, 2),
      end: Offset(
          deviceWidth / smallIconSize, -1 * deviceHeight / smallIconSize),
    ).animate(_loopingAnimation);

    _reverseSlide = Tween<Offset>(
      begin: Offset(deviceWidth / smallIconSize, 2),
      end: Offset(-2, -1 * deviceHeight / smallIconSize),
    ).animate(_loopingAnimation);

    _loopingAnimation.forward();
    _loopingAnimationLong.forward();

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: ScaleTransition(
                  scale: _scaleCurveSlow,
                  child: RotationTransition(
                    turns: _repeatingAnimationLong,
                    child: Image.asset('galaxy_transparent.png'),
                  ),
                ),
              ),

              /*** Spinning Hourglaas ***/
              // Align(
              //   alignment: Alignment.center,
              //   child: ScaleTransition(
              //     scale: _scaleCurve,
              //     child: RotationTransition(
              //       turns: _repeatingAnimationShort,
              //       child: Icon(
              //         Icons.hourglass_empty,
              //         size: largeIconSize,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),

              /*** Flying home ***/
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: SlideTransition(
              //     position: _slideCurve,
              //     child: RotationTransition(
              //       turns: _repeatingAnimationShort,
              //       child: Icon(
              //         Icons.home,
              //         color: Colors.white,
              //         size: smallIconSize,
              //       ),
              //     ),
              //   ),
              // ),

              /*** Flying Rocket ***/
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: SlideTransition(
              //     position: _reverseSlide,
              //     child: RotationTransition(
              //       turns: _repeatingAnimationShort,
              //       child: Text(
              //         "🚀",
              //         style: TextStyle(fontSize: smallIconSize),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
