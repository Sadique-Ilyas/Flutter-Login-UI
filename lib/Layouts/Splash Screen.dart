import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_fb_google/Services/Auth%20Services.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:core';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSplashScreen(
          backgroundColor: Color.fromRGBO(143, 148, 251, 1),
          nextScreen: AuthServices().handleAuth(),
          duration: 3000,
          curve: Curves.decelerate,
          splash: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Image.asset("assets/images/logo.png")
          ),
          animationDuration: Duration(seconds: 2),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.rightToLeft,
        )
    );
  }
}