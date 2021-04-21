import 'package:flutter/material.dart';
import 'package:flutter_app_news/screens/watchlist/watchlist.dart';
import 'package:flutter_app_news/service/widget_tree/widget_tree.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => WidgetTree());
      // case Home.routeHomePage:
      //   return MaterialPageRoute(builder: (_) => Home());
    }
  }
}
