import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/constants.dart';
import 'package:flutter_app_news/screens/advice/advice.dart';
import 'package:flutter_app_news/screens/bookmark/bookmark_home.dart';
import 'package:flutter_app_news/screens/drawer/news_drawer.dart';
import 'package:flutter_app_news/screens/insights/insights_home/insights_home.dart';
import 'package:flutter_app_news/screens/news/news_body.dart';
import 'package:flutter_app_news/screens/watchlist/watchlist.dart';

class Home extends StatefulWidget {
  int pageIndex;

  Home({this.pageIndex = 0});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return buildScaffold();
  }

  SafeArea buildScaffold() {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Constants.primaryLightColor,
          title: Text(
            "FinXpress",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return BookmarkHome();
                  }));
                },
                icon: Icon(Icons.bookmark))
          ],
        ),
        drawer: Drawer(child: NewsDrawer()),
        body: _getPage(widget.pageIndex),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              widget.pageIndex = index;
            });
          },
          currentIndex: widget.pageIndex,
          items: [
            BottomNavigationBarItem(
                icon: (Icon(
                  CupertinoIcons.news_solid,
                )),
                label: "Home",
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: (Icon(CupertinoIcons.book)),
                label: "Learnings",
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: (Icon(Icons.vpn_key)), label: "Insights"),
            BottomNavigationBarItem(
                icon: (Icon(CupertinoIcons.lightbulb_fill)), label: "Advice"),
            BottomNavigationBarItem(
                icon: (Icon(CupertinoIcons.bell_fill)), label: "WatchList"),
          ],
        ),
      ),
    );
  }

  _getPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return NewsBody();
      case 1:
        return Container();
      case 2:
        return InsightsHome();
      case 3:
        return Advice();
      case 4:
        return Watchlist();
      default:
        return NewsBody();
    }
  }
}
