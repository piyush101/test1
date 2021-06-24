import 'dart:convert';

LearningsModel learningsModelFromJson(String str) =>
    LearningsModel.fromJson(json.decode(str));

String learningsModelToJson(LearningsModel data) => json.encode(data.toJson());

class LearningsModel {
  LearningsModel({
    this.id,
    this.color,
    this.imageUrl,
    this.category,
    this.data,
  });

  String id;
  int color;
  String imageUrl;
  String category;
  List<Datum> data;

  factory LearningsModel.fromJson(Map<String, dynamic> json) => LearningsModel(
        id: json["_id"],
        color: json["color"],
        imageUrl: json["imageUrl"],
        category: json["category"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "color": color,
        "imageUrl": imageUrl,
        "category": category,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.color,
    this.imageUrl,
    this.content,
    this.articleNumber,
    this.title,
  });

  int color;
  String imageUrl;
  String content;
  int articleNumber;
  String title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        color: json["color"],
        imageUrl: json["imageUrl"],
        content: json["content"],
        articleNumber: json["articleNumber"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "imageUrl": imageUrl,
        "content": content,
        "articleNumber": articleNumber,
        "title": title,
      };
}
