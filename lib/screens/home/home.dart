import 'package:FinXpress/screens/advice/advice.dart';
import 'package:FinXpress/screens/bookmark/bookmark_home.dart';
import 'package:FinXpress/screens/drawer/news_drawer.dart';
import 'package:FinXpress/screens/insights/insights_home/insights_home.dart';
import 'package:FinXpress/screens/news/news_body.dart';
import 'package:FinXpress/screens/watchlist/watchlist.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  int pageIndex;

  Home({this.pageIndex = 0});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime backbuttonpressedTime;

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
          backgroundColor: Color(0xFFb1c5c5),
          title: Text("FinXpress",
              style: GoogleFonts.sourceSansPro(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return BookmarkHome();
                  }));
                },
                icon: Icon(
                  Icons.bookmark,
                  color: Color(0xFF3c4d47),
                ))
          ],
        ),
        drawer: Drawer(child: NewsDrawer()),
        body: DoubleBackToCloseApp(
          child: _getPage(widget.pageIndex),
          snackBar: const SnackBar(
            content: Text('Tap back again to Leave'),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Color(0xFFDCDCDC),
          selectedItemColor: Colors.black87,
          unselectedItemColor: Color(0xFF6C7180),
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
              label: "News",
            ),
            // BottomNavigationBarItem(
            //     icon: (Icon(CupertinoIcons.book)),
            //     label: "Learnings",
            //     backgroundColor: Colors.grey),
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
      // case 1:
      //   return LearningsHomepage();
      case 1:
        return InsightsHome();
      case 2:
        return Advice();
      case 3:
        return Watchlist();
      default:
        return NewsBody();
    }
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);
    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Tap to exit FinXpress",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    return true;
  }
}
