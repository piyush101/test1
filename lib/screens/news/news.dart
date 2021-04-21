import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/screens/advice/advice.dart';
import 'package:flutter_app_news/screens/drawer/news_drawer.dart';
import 'package:flutter_app_news/screens/insights/insights_home/insights_home.dart';
import 'package:flutter_app_news/screens/news/news_body/news_body.dart';
import 'package:flutter_app_news/screens/watchlist/watchlist.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Finbox",
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: Drawer(child: NewsDrawer()),
      body: [
        NewsBody(),
        Container(),
        InsightsHome(),
        Advice(),
        Watchlist()
      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: (Icon(
                CupertinoIcons.news_solid,
              )),
              label: "News",
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: (Icon(Icons.book_outlined)),
              label: "Learnings",
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: (Icon(Icons.vpn_key)), label: "Insights"),
          BottomNavigationBarItem(
              icon: (Icon(Icons.lightbulb)), label: "Advice"),
          BottomNavigationBarItem(
              icon: (Icon(Icons.lightbulb)), label: "WatchList"),
        ],
      ),
    );
  }
}
