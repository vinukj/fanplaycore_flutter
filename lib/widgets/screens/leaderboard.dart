import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import '../../constants.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradient: LinearGradient(colors: [kActiveColor, kInactiveColor]),
        title: Image.asset('assets/images/FPH100W.png', fit: BoxFit.cover),
      ),
    );
  }
}
