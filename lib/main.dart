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
      home: Scaffold(
        body: Container(
          color: Colors.black,
          child: Center(
            child: TimeMachine(),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
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
  AnimationController _loopingAnimationShort;
  AnimationController _loopingAnimationLong;

  Animatable<double> _scaleCurve;
  Animatable<Offset> _slideCurve;
  Animatable<Offset> _reverseSlide;
  Animatable<double> _scaleCurveSlow;

  @override
  void initState() {
    super.initState();

    _repeatingAnimationShort = AnimationController(
      duration: const Duration(milliseconds: 3600),
      vsync: this,
    )..repeat();

    _repeatingAnimationLong = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _loopingAnimationShort = AnimationController(
      duration: const Duration(milliseconds: 3600),
      vsync: this,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _loopingAnimationShort.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _loopingAnimationShort.forward();
        }
      })
      ..forward();

    _loopingAnimationLong = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _loopingAnimationLong.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _loopingAnimationLong.forward();
        }
      })
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    setAnimatables();

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: RotationTransition(
            turns: _repeatingAnimationLong,
            child: GalaxyFitz(),
          ),
        ),

        /*** Spinning Hourglaas ***/
        Align(
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: _loopingAnimationShort.drive(_scaleCurve),
            child: RotationTransition(
              turns: _repeatingAnimationShort,
              child: Icon(
                Icons.hourglass_empty,
                size: largeIconSize,
                color: Colors.white,
              ),
            ),
          ),
        ),

        /*** Flying home ***/
        Align(
          alignment: Alignment.bottomLeft,
          child: SlideTransition(
            position: _loopingAnimationShort.drive(_slideCurve),
            child: RotationTransition(
              turns: _repeatingAnimationShort,
              child: Icon(
                Icons.home,
                color: Colors.white,
                size: smallIconSize,
              ),
            ),
          ),
        ),

        /*** Flying Rocket ***/
        Align(
          alignment: Alignment.bottomLeft,
          child: SlideTransition(
            position: _loopingAnimationShort.drive(_reverseSlide),
            child: RotationTransition(
              turns: _repeatingAnimationShort,
              child: Text(
                "🚀",
                style: TextStyle(fontSize: smallIconSize),
              ),
            ),
          ),
        ),

        /*** Revolving Rocket ***/
        Align(
          alignment: Alignment(0.75, 0),
          child: RotationTransition(
            turns: _repeatingAnimationLong,
            alignment: Alignment(-10, 0),
            child: RotationTransition(
              turns: _repeatingAnimationShort,
              child: Text(
                "🚀",
                style: TextStyle(fontSize: smallIconSize),
              ),
            ),
          ),
        ),

        /*** Hidden Button -- Stops time. ***/
        Align(
          alignment: Alignment.bottomLeft,
          child: TimeStopper(
            controllers: [
              _repeatingAnimationLong,
              _repeatingAnimationShort,
              _loopingAnimationShort,
              _loopingAnimationLong,
            ],
          ),
        ),

        /*** Hidden Button -- Flings. ***/
        Align(
          alignment: Alignment.bottomRight,
          child: FlingButton(
            controllers: [
              _loopingAnimationShort,
            ],
          ),
        ),
      ],
    );
  }

  /// Some of our tweens and curves (e.g., Offset) are based on the device
  /// dimensions. Since we don't know that until build time, postpone creating
  /// those constants until then.
  void setAnimatables() {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    _scaleCurve = CurveTween(
      curve: Curves.easeIn,
    );

    _scaleCurveSlow = Tween<double>(
      begin: 0,
      end: 5,
    );

    _slideCurve = Tween<Offset>(
      begin: Offset(-2, 2),
      end: Offset(
          deviceWidth / smallIconSize, -1 * deviceHeight / smallIconSize),
    );

    _reverseSlide = Tween<Offset>(
      begin: Offset(deviceWidth / smallIconSize, 2),
      end: Offset(-2, -1 * deviceHeight / smallIconSize),
    );
  }
}

/// Hidden button that stops all the given animations, or restart them if not running.
///
/// TODO: This does not differentiate between "looping" vs. "repeating" animations.
class TimeStopper extends StatelessWidget {
  final List<AnimationController> controllers;

  const TimeStopper({Key key, this.controllers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controllers.forEach((controller) {
          if (controller.isAnimating) {
            controller.stop();
          } else {
            controller.repeat();
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        width: 100,
        height: 100,
      ),
    );
  }
}

/// Takes the given controllers, and flings them forward.
class FlingButton extends StatelessWidget {
  final List<AnimationController> controllers;

  const FlingButton({Key key, this.controllers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controllers.forEach((controller) {
          controller.fling();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        width: 100,
        height: 100,
      ),
    );
  }
}

/// The galaxy fits, so we'll just put it here...
class GalaxyFitz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset('galaxy_transparent.png');
  }
}
