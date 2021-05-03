import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/constants.dart';
import 'package:flutter_app_news/screens/bookmark/bookmark_details.dart';
import 'package:flutter_app_news/screens/home/home.dart';
import 'package:intl/intl.dart';

class BookmarkHome extends StatefulWidget {
  static const String bookmark_home = '/bookmarkHome';

  @override
  _BookmarkHomeState createState() => _BookmarkHomeState();
}

class _BookmarkHomeState extends State<BookmarkHome> {
  var _currentUser = FirebaseAuth.instance.currentUser.uid;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

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
            "FinXpress",
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
                            child: Constants.getCircularProgressBarIndicator());
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
                                SizedBox(
                                  height: 5,
                                ),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("Tap and hold to delete")),
                                SizedBox(height: 10),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      snapshot.data.get('bookmarks').length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookmarkDetails(
                                                          snapshot.data)));
                                        },
                                        onLongPress: () {
                                          print("tap");
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Finbox"),
                                                  content: Text(
                                                      "Do you want to remove article from bookmark?"),
                                                  actions: [
                                                    ElevatedButton(
                                                      child: Text("Yes"),
                                                      onPressed: () {
                                                        users
                                                            .doc(_currentUser)
                                                            .update({
                                                          "bookmarks":
                                                              FieldValue
                                                                  .arrayRemove([
                                                            snapshot.data.get(
                                                                    'bookmarks')[
                                                                index]
                                                          ])
                                                        });
                                                        Navigator.maybePop(
                                                            context);
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child: Text("No"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                          // showAlertDialog(
                                          //     context,
                                          //     snapshot.data
                                          //         .get('bookmarks')[index]);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFFcaedd7),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            height: 125,
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
                                                                        index][
                                                                    'Image'])))),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
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
                                                                        index]
                                                                    ['Time'])),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
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
                .push(MaterialPageRoute(builder: (context) => Home()));
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

  showAlertDialog(BuildContext context, value) {
    // set up the buttons
    Widget yesButton = ElevatedButton(
      child: Text("Yes"),
      onPressed: () {
        users.doc(_currentUser).update({
          "bookmarks": FieldValue.arrayRemove([value])
        });
        Navigator.maybePop(context);
      },
    );
    Widget noButton = ElevatedButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Finbox"),
      content: Text("Do you want to remove article from bookmark?"),
      actions: [
        yesButton,
        noButton,
      ],
    );
  }
}
