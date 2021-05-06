import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/constants.dart';
import 'package:flutter_app_news/screens/bookmark/bookmark_details.dart';
import 'package:flutter_app_news/screens/home/home.dart';

class BookmarkHome extends StatefulWidget {
  static const String bookmark_home = '/bookmarkHome';

  @override
  _BookmarkHomeState createState() => _BookmarkHomeState();
}

class _BookmarkHomeState extends State<BookmarkHome> {
  var _currentUser = FirebaseAuth.instance.currentUser.uid;
  CollectionReference _users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _getAppBar(),
        body: SafeArea(
          child: _getBookmarkStream(),
        ),
      ),
    );
  }

  Padding _getBookmarkStream() {
    return Padding(
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
                    return _buildWheBookmarkEmpty(context);
                  }
              }
            }));
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
                color: Color(0xFFcaedd7),
                borderRadius: BorderRadius.circular(5)),
            height: 140,
            width: double.infinity,
            child: Row(
              children: [
                _getBookmarkImage(snapshot, index),
                Expanded(
                  child: _getBookmarkData(snapshot, index),
                )
              ],
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
            Text(
              snapshot.data.get('bookmarks')[index]['title'],
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
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

  Container _getBookmarkImage(
      AsyncSnapshot<DocumentSnapshot> snapshot, int index) {
    return Container(
        width: 125,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    snapshot.data.get('bookmarks')[index]['imageurl']))));
  }

  Padding _getTapHeading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
      child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Tap and hold to delete",
            style: TextStyle(
                fontFamily: 'SourceSansPro',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey),
          )),
    );
  }

  Padding _getBookMarkTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text("Your Bookmarks",
            style: TextStyle(
                fontFamily: 'SourceSansPro',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey)),
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Color(0xFFb1c5c5),
      title: Text(
        "FinXpress",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  AlertDialog _alertBoxOnLongPress(AsyncSnapshot<DocumentSnapshot> snapshot,
      int index, BuildContext context) {
    return AlertDialog(
      title: Text("Finbox"),
      content: Text("Do you want to remove article from bookmark?"),
      actions: [
        dialogYesButton(snapshot, index, context),
        dialogNoButton(context)
      ],
    );
  }

  ElevatedButton dialogNoButton(BuildContext context) {
    return ElevatedButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  ElevatedButton dialogYesButton(AsyncSnapshot<DocumentSnapshot> snapshot,
      int index, BuildContext context) {
    return ElevatedButton(
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

  Column _buildWheBookmarkEmpty(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Home()));
            },
            child: Image.asset(
              "assets/images/image.jpg",
              width: double.infinity,
              height: 350,
            ),
          ),
        ),
      ],
    );
  }
}
