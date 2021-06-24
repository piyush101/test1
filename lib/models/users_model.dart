import 'dart:convert';

UsersModel userModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

String userModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  UsersModel({
    this.email,
    this.name,
    this.emailVerified,
    this.deviceToken,
    this.bookmarks,
  });

  String email;
  String name;
  bool emailVerified;
  String deviceToken;
  List<dynamic> bookmarks;

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        email: json["email"],
        name: json["name"],
        emailVerified: json["emailVerified"],
        deviceToken: json["deviceToken"],
        bookmarks: List<dynamic>.from(json["bookmarks"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "emailVerified": emailVerified,
        "deviceToken": deviceToken,
        "bookmarks": List<dynamic>.from(bookmarks.map((x) => x)),
      };
}
