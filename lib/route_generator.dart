import 'package:FinXpress/screens/bookmark/bookmark_home.dart';
import 'package:FinXpress/screens/home/home.dart';
import 'package:FinXpress/screens/intro/intro_screen.dart';
import 'package:FinXpress/screens/login/login.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => Home(
                  pageIndex: 0,
                ));
      case 'Intro':
        return MaterialPageRoute(
            builder: (_) => IntroScreen(),
            settings: RouteSettings(name: "Intro"));
      // case BookmarkHome.bookmark_home:
      //   return MaterialPageRoute(builder: (_) => BookmarkHome());
      case "MarketWatch":
        return MaterialPageRoute(
            builder: (_) => Home(
                  pageIndex: 4,
                ));
      case Login.login:
        return MaterialPageRoute(
            builder: (_) => Login(), settings: RouteSettings(name: "Login"));
      case Home.home:
        return MaterialPageRoute(builder: (_) => Home());
    }
  }
}
