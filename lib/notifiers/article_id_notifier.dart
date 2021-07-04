import 'package:flutter/material.dart';

class ArticleIdNotifier extends ChangeNotifier {
  String _id = "This is mock title";

  String get id => _id;

  void updateId(String id) {
    _id = id;
    notifyListeners();
  }
}
