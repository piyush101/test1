import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/screens/login/login.dart';
import 'package:flutter_app_news/screens/news/news.dart';
import 'package:provider/provider.dart';

class WidgetTree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    User user=Provider.of<User>(context);

    if(user==null)
      {
        return Login();
      }
    return News();
  }
}
