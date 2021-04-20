import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("Companies")
        .where("searchIndex", isEqualTo: searchField.substring(0, 1).toLowerCase())
        .get();
  }
}