import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarkShared {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  var _currentUser = FirebaseAuth.instance.currentUser.uid;

  bool isBookmarked(QueryDocumentSnapshot data) {
    if (data['bookmarkuid'].contains(_currentUser)) {
      return true;
    }
    return false;
  }

  deleteBookMarkData(DocumentSnapshot doc) {
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
  }

  addBookMarkData(DocumentSnapshot doc) {
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
  }
}
