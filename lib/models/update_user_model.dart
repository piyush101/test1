// To parse this JSON data, do
//
//     final updateUser = updateUserFromJson(jsonString);

import 'dart:convert';

UpdateUserModel updateUserModelFromJson(String str) =>
    UpdateUserModel.fromJson(json.decode(str));

String updateUserModelToJson(UpdateUserModel data) =>
    json.encode(data.toJson());

class UpdateUserModel {
  UpdateUserModel({
    this.id,
    this.email,
    this.name,
    this.emailVerified,
    this.bookmarks,
  });

  String id;
  String email;
  String name;
  bool emailVerified;
  List<dynamic> bookmarks;

  factory UpdateUserModel.fromJson(Map<String, dynamic> json) =>
      UpdateUserModel(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        emailVerified: json["emailVerified"],
        bookmarks: List<dynamic>.from(json["bookmarks"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "emailVerified": emailVerified,
        "bookmarks": List<dynamic>.from(bookmarks.map((x) => x)),
      };
}
