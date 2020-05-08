import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PageTransitions extends PageRouteBuilder {
  final Widget widget;

  PageTransitions({this.widget})
      : super(
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut);

              return ScaleTransition(
                alignment: Alignment.center,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            });
}
