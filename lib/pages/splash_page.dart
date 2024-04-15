import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:instaloader/home_page.dart';
import 'package:instaloader/utils/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rate_my_app/rate_my_app.dart';

class SplashPage extends StatelessWidget {
  final RateMyApp rateMyApp;

  const SplashPage({Key? key, required this.rateMyApp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 2500,
        splash: "assets/images/logo.png",
        nextScreen: HomePage(rateMyApp: rateMyApp),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.topToBottom,
        backgroundColor: splashBackgroundColor,
      ),
    );
  }
}
