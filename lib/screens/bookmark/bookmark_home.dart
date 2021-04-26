import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/screens/news/news.dart';
import 'package:intl/intl.dart';

class BookmarkHome extends StatelessWidget {
  static const String bookmark_home = '/bookmarkHome';
  var _currentUser = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "Finbox",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: Padding(
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
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black)));
                      default:
                        if (snapshot.data.get('bookmarks').length != 0) {
                          return SafeArea(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Your Bookmarks",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      snapshot.data.get('bookmarks').length,
                                  itemBuilder: (context, index) {
                                    return SingleChildScrollView(
                                        child: GestureDetector(
                                            child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFFcaedd7),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        height: 110,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                            snapshot.data.get(
                                                                    'bookmarks')[
                                                                index]['Image'])))),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        snapshot.data.get(
                                                                'bookmarks')[
                                                            index]['Title'],
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(timeStampConversion(
                                                            snapshot.data.get(
                                                                    'bookmarks')[
                                                                index]['Time'])),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )));
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          return buildWheBookmarkEmpty(context);
                        }
                    }
                  })),
        ),
      ),
    );
  }

  Column buildWheBookmarkEmpty(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Image.asset(
            "assets/images/image.jpg",
            width: double.infinity,
            height: 350,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => News()));
          },
          child: Text(
            "Start Exploring",
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }

  String timeStampConversion(Timestamp t) {
    DateTime dateTime = t.toDate();
    String formatDate = DateFormat.yMMMMd('en_US').format(dateTime);
    return formatDate;
  }
}
