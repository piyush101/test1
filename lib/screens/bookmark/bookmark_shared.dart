import 'package:FinXpress/screens/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookmarkShared {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  var _currentUser = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser.uid
      : null;

  bool isBookmarked(QueryDocumentSnapshot data) {
    if (_currentUser != null) {
      if (data['bookmarkuid'].contains(_currentUser)) {
        return true;
      }
    }
    return false;
  }

  deleteBookMarkData(DocumentSnapshot doc, context) {
    if (_currentUser != null) {
      doc.reference.update(<String, dynamic>{
        "bookmarkuid": FieldValue.arrayRemove([_currentUser])
      });

      List<dynamic> _getbookmarkList() {
        List<dynamic> _bookmarkData = [];
        FirebaseFirestore.instance
            .doc("Users/${_currentUser}")
            .get()
            .then((value) {
          List<dynamic> _data = value.data()['bookmarks'];
          _data.forEach((element) {
            _bookmarkData.add(element);
          });
          _bookmarkData
              .removeWhere((bookmark) => bookmark['title'] == doc['title']);
          users.doc(_currentUser).update({"bookmarks": _bookmarkData});
        });
      }

      _getbookmarkList();
    } else {
      Fluttertoast.showToast(
        msg: "Sign In to add bookmark",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        // timeInSecForIos: 1
      );
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Login()));
    }
  }

  addBookMarkData(DocumentSnapshot doc, context) {
    if (_currentUser != null) {
      doc.reference.update(<String, dynamic>{
        'bookmarkuid': FieldValue.arrayUnion([_currentUser])
      });
      Map<dynamic, dynamic> dataBookmark = {
        "content": doc['content'],
        "title": doc['title'],
        "time": doc['time'],
        "imageurl": doc['imageurl'],
        "tag": doc['tag']
      };
      users.doc(_currentUser).update({
        "bookmarks": FieldValue.arrayUnion([dataBookmark])
      });
    } else {
      Fluttertoast.showToast(
        msg: "Sign In to add bookmark",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        // timeInSecForIos: 1
      );
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
