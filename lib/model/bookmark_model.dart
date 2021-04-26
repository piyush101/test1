import 'package:cloud_firestore/cloud_firestore.dart';

class Bookmark_Model {
  final String Title;
  final String Content;
  final String Tag;
  final String Image;
  final Timestamp Time;

  Bookmark_Model(this.Title, this.Content, this.Tag, this.Image, this.Time);
}
