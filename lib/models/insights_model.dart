import 'dart:convert';

InsightsModel insightsModelFromJson(String str) =>
    InsightsModel.fromJson(json.decode(str));

String insightsModelToJson(InsightsModel data) => json.encode(data.toJson());

class InsightsModel {
  InsightsModel({
    this.id,
    this.content,
    this.title,
    this.tag,
    this.imageUrl,
    this.readtime,
    this.time,
  });

  String id;
  String content;
  String title;
  String tag;
  String imageUrl;
  String readtime;
  String time;

  factory InsightsModel.fromJson(Map<String, dynamic> json) => InsightsModel(
        id: json["_id"],
        content: json["content"],
        title: json["title"],
        tag: json["tag"],
        imageUrl: json["image_url"],
        readtime: json["readtime"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "content": content,
        "title": title,
        "tag": tag,
        "image_url": imageUrl,
        "readtime": readtime,
        "time": time,
      };
}
