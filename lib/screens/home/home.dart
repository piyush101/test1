import 'package:FinXpress/screens/advice/advice.dart';
import 'package:FinXpress/screens/bookmark/bookmark_home.dart';
import 'package:FinXpress/screens/drawer/news_drawer.dart';
import 'package:FinXpress/screens/insights/insights_home/insights_home.dart';
import 'package:FinXpress/screens/learnings/learnings_home.dart';
import 'package:FinXpress/screens/news/news_body.dart';
import 'package:FinXpress/screens/watchlist/watchlist.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  int pageIndex;
  static const String home = '/home';

  Home({this.pageIndex = 0});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime backbuttonpressedTime;
  var _currentUser = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser.uid
      : null;

  @override
  Widget build(BuildContext context) {
    return buildScaffold();
  }

  ColorfulSafeArea buildScaffold() {
    return ColorfulSafeArea(
      color: Colors.black,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: Builder(
              builder: (context) => IconButton(
                    icon: Container(
                        decoration: BoxDecoration(color: Color(0xFFf1f3f4)),
                        child: SvgPicture.asset(
                          "assets/icons/drawer.svg",
                          width: 30,
                          height: 22,
                        )),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  )),
          backgroundColor: Color(0xFFf1f3f4),
          title: Row(
            children: [
              SizedBox(
                width: 40,
              ),
              Container(
                width: 30,
                height: 30,
                child: SvgPicture.asset(
                  "assets/icons/logo_transparent.svg",
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text("FinXpress",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5f5463))),
            ],
          ),
          actions: [
            Visibility(
              visible: _getBookmarkVisibilty(),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return BookmarkHome();
                    }));
                  },
                  icon: Icon(
                    Icons.bookmark,
                    color: Color(0xFF8787c4),
                  )),
            )
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
          selectedItemColor: Color(0xFF4d4d99),
          unselectedItemColor: Color(0xFF7777bb),
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
            BottomNavigationBarItem(
                icon: (Icon(CupertinoIcons.book)),
                label: "Learnings",
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: (Icon(Icons.vpn_key)), label: "Insights"),
            BottomNavigationBarItem(
                icon: (Icon(CupertinoIcons.lightbulb_fill)), label: "Advice"),
            // BottomNavigationBarItem(
            //     icon: (Icon(CupertinoIcons.bell_fill)), label: "WatchList"),
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
        return LearningsHome();
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

  bool _getBookmarkVisibilty() {
    if (_currentUser != null) {
      return true;
    } else {
      return false;
    }
  }
}
