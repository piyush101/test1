import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/screens/home/home.dart';
import 'package:flutter_app_news/screens/login/login.dart';
import 'package:flutter_app_news/screens/signup/body/signup_body.dart';
import 'package:flutter_app_news/screens/signup/signup.dart';
import 'package:flutter_app_news/screens/welcome_page/welcome_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // case '/':
      //   return MaterialPageRoute(builder: (_) => WelcomePage());
      case Login.routeLogin:
        return MaterialPageRoute(builder: (_) => Login());
      case Signup.routeSignup:
        return MaterialPageRoute(builder: (_) => SignupBody());
      case '/':
        return MaterialPageRoute(builder: (_) => WelcomePage());
    }
  }
}
