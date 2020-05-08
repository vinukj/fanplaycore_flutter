import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

const kBodyStyle = TextStyle(fontSize: 19.0);
const kInactiveColor = Color(0xFF284BA0);
const kActiveColor = Color(0xFFF37421);

const kPageDecoration = const PageDecoration(
  titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
  bodyTextStyle: kBodyStyle,
  descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
  pageColor: Colors.white,
  imagePadding: EdgeInsets.zero,
);

const kDotsDecorator = const DotsDecorator(
  size: Size(10.0, 10.0),
  color: Color(0xFFBDBDBD),
  activeSize: Size(22.0, 10.0),
  activeShape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(25.0)),
  ),
);
