import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarkShared {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  var _currentUser = FirebaseAuth.instance.currentUser.uid;

  bool isBookmarked(QueryDocumentSnapshot data) {
    if (data['Bookmark'].contains(_currentUser)) {
      return true;
    }
    return false;
  }

  deleteBookMarkData(DocumentSnapshot doc) {
    doc.reference.update(<String, dynamic>{
      "Bookmark": FieldValue.arrayRemove([_currentUser])
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
            .removeWhere((bookmark) => bookmark['Title'] == doc['Title']);
        users.doc(_currentUser).update({"bookmarks": _bookmarkData});
      });
    }

    _getbookmarkList();
  }

  addBookMarkData(DocumentSnapshot doc) {
    doc.reference.update(<String, dynamic>{
      'Bookmark': FieldValue.arrayUnion([_currentUser])
    });
    Map<dynamic, dynamic> dataBookmark = {
      "Content": doc['Content'],
      "Title": doc['Title'],
      "Time": doc['Time'],
      "Image": doc['Image'],
      "Tag": doc['Tag']
    };
    users.doc(_currentUser).update({
      "bookmarks": FieldValue.arrayUnion([dataBookmark])
    });
  }
}
