import 'package:FinXpress/screens/bookmark/bookmark_home.dart';
import 'package:FinXpress/screens/login/login.dart';
import 'package:FinXpress/service/widget_tree/widget_tree.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => WidgetTree());
      case BookmarkHome.bookmark_home:
        return MaterialPageRoute(builder: (_) => BookmarkHome());
      // case Watchlist.watchlist:
      //   return MaterialPageRoute(
      //       builder: (_) => Home(
      //             pageIndex: 3,
      //           ));
      case Login.login:
        return MaterialPageRoute(builder: (_) => Login());
    }
  }
}
