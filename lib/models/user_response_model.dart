// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponseModel userResponseModelFromJson(String str) =>
    UserResponseModel.fromJson(json.decode(str));

String userResponseModelToJson(UserResponseModel data) =>
    json.encode(data.toJson());

class UserResponseModel {
  UserResponseModel({
    this.success,
    this.user,
  });

  bool success;
  User user;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        success: json["success"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "user": user.toJson(),
      };
}

class User {
  User({
    this.email,
    this.name,
    this.emailVerified,
    this.deviceToken,
    this.bookmarks,
    this.id,
    this.userId,
  });

  dynamic email;
  dynamic name;
  bool emailVerified;
  String deviceToken;
  List<dynamic> bookmarks;
  String id;
  String userId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        name: json["name"],
        emailVerified: json["emailVerified"],
        deviceToken: json["deviceToken"],
        bookmarks: List<dynamic>.from(json["bookmarks"].map((x) => x)),
        id: json["_id"],
        userId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "emailVerified": emailVerified,
        "deviceToken": deviceToken,
        "bookmarks": List<dynamic>.from(bookmarks.map((x) => x)),
        "_id": id,
        "id": userId,
      };
}
