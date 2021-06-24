import 'package:FinXpress/constants.dart';
import 'package:FinXpress/screens/bookmark/bookmark_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookmarkHome extends StatefulWidget {
  static const String bookmark_home = '/bookmarkHome';

  @override
  _BookmarkHomeState createState() => _BookmarkHomeState();
}

class _BookmarkHomeState extends State<BookmarkHome> {
  var _currentUser = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser.uid
      : null;

  CollectionReference _users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _getAppBar(),
        body: SafeArea(
          child: _getBookmarkStream(size),
        ),
      ),
    );
  }

  Scaffold _getBookmarkStream(Size size) {
    return Scaffold(
      backgroundColor: Color(0xFFf1f3f4),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(_currentUser)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                        child: Constants.getCircularProgressBarIndicator());
                  default:
                    if (snapshot.data.get('bookmarks').length != 0) {
                      return Stack(
                        children: [
                          _getBookMarkTitle(),
                          SizedBox(
                            height: 20,
                          ),
                          _getTapHeading(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 50, 8, 8),
                            child: Column(
                              children: [
                                Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      await Future<void>.delayed(
                                          Duration(seconds: 1));
                                    },
                                    child: ListView.builder(
                                      physics: BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      shrinkWrap: true,
                                      itemCount:
                                          snapshot.data.get('bookmarks').length,
                                      itemBuilder: (context, index) {
                                        return _getBookmarkContainer(
                                            context, snapshot, index);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return _buildWheBookmarkEmpty(context, size);
                    }
                }
              })),
    );
  }

  GestureDetector _getBookmarkContainer(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, int index) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  BookmarkDetails(snapshot.data.get('bookmarks')[index])));
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return _alertBoxOnLongPress(snapshot, index, context);
              });
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xFFbebddf).withOpacity(0.3),
                borderRadius: BorderRadius.circular(5)),
            // height: 140,
            width: double.infinity,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: _getBookmarkData(snapshot, index),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Padding _getBookmarkData(
      AsyncSnapshot<DocumentSnapshot> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                snapshot.data.get('bookmarks')[index]['title'],
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(Constants.getdate(
                  snapshot.data.get('bookmarks')[index]['time'])),
            )
          ],
        ),
      ),
    );
  }

  Padding _getTapHeading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
      child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Tap and hold to delete",
            style: GoogleFonts.sourceSansPro(
                color: Color(0xFF5555aa),
                fontSize: 16,
                fontWeight: FontWeight.w500),
          )),
    );
  }

  Padding _getBookMarkTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Your Bookmarks",
            style: GoogleFonts.sourceSansPro(
                color: Color(0xFF5555aa),
                fontSize: 20,
                fontWeight: FontWeight.w600),
          )),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Color(0xFF5f5463)),
      backgroundColor: Color(0xFFf1f3f4),
      title: Text(
        "FinXpress",
        style: GoogleFonts.sourceSansPro(
            fontWeight: FontWeight.w600,
            color: Color(0xFF5f5463),
            fontSize: 23),
      ),
    );
  }

  AlertDialog _alertBoxOnLongPress(AsyncSnapshot<DocumentSnapshot> snapshot,
      int index, BuildContext context) {
    return AlertDialog(
      title: Text("FinXpress"),
      content: Text("Do you want to remove article from bookmark?"),
      actions: [
        _dialogYesButton(snapshot, index, context),
        _dialogNoButton(context)
      ],
    );
  }

  ElevatedButton _dialogNoButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF8787c4))),
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  ElevatedButton _dialogYesButton(AsyncSnapshot<DocumentSnapshot> snapshot,
      int index, BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF8787c4))),
      child: Text("Yes"),
      onPressed: () {
        _users.doc(_currentUser).update({
          "bookmarks":
              FieldValue.arrayRemove([snapshot.data.get('bookmarks')[index]])
        });
        Navigator.maybePop(context);
      },
    );
  }

  Center _buildWheBookmarkEmpty(BuildContext context, Size size) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: size.height * .25,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "Bookmark your favourite articles",
                textAlign: TextAlign.center,
                style: GoogleFonts.sourceSansPro(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5f5463)),
              ),
            ),
          ),
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                color: Color(0xFFf1f3f4),
                image: DecorationImage(
                    image: AssetImage("assets/images/bookmark.png"))),
          ),
        ],
      ),
    );
  }
}
