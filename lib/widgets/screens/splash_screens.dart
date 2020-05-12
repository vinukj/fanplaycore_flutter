import 'package:fanplaycore/widgets/components/page_transition.dart';
import 'package:fanplaycore/widgets/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:fanplaycore/constants.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.push(context, PageTransitions(widget: Login()));
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/$assetName.png', width: 250.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Sportifying Healthcare",
          body:
              "Instead of having to buy an entire share, invest any amount you want.",
          image: _buildImage('appstore'),
          decoration: kPageDecoration,
        ),
        PageViewModel(
          title: "Connect your SmartBands",
          body:
              "If you dont yet have a FanPlay Band, no worries, you can connect your existing smart band to google fit for Android or Apple fit for ios",
          image: _buildImage('app1'),
          decoration: kPageDecoration,
        ),
        PageViewModel(
          title: "Track your Vitals",
          body: "Monitor every minute of your life",
          image: _buildImage('FPS120G'),
          decoration: kPageDecoration,
        ),
        PageViewModel(
          title: "Connect your SmartBands",
          body:
              "If you dont yet have a FanPlay Band, no worries, you can connect your existing smart band to google fit for Android or Apple fit for ios ",
          image: _buildImage('FPV120K'),
          footer: RaisedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'FooButton',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          decoration: kPageDecoration,
        ),
        PageViewModel(
          title: "Lets Get Started",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [],
          ),
          image: _buildImage('appstore'),
          decoration: kPageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: kDotsDecorator,
    );
  }
}
