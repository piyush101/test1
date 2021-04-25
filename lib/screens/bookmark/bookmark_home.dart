import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/screens/news/news.dart';

class BookmarkHome extends StatelessWidget {
  static const String bookmark_home = '/bookmarkHome';
  var _currentUser = FirebaseAuth.instance.currentUser.uid;
  List<String> _listBookMark = FirebaseFirestore.instance.collection("Users")
      .doc(_currentUser)
      .get('bookmarks')

      .;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
              child: bool isBookMarkEmpty()
              ? buildWheBookmarkEmpty()
              : buildWheBookmarkIsNotEmpty(),
        ),
      ),
    ),);
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

  bool isBookMarkEmpty() {
    if (_collectionReference.)
  }
}
