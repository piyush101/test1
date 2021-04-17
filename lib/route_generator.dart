import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/screens/news/news.dart';
import 'package:flutter_app_news/screens/signup/signup.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Signup());
      // case Home.routeHomePage:
      //   return MaterialPageRoute(builder: (_) => Home());
    }
  }
}
