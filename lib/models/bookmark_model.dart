import 'dart:convert';

// AdviceModel adviceModelFromJson(String str) =>
//     AdviceModel.fromJson(json.decode(str));
//
// String adviceModelToJson(AdviceModel data) => json.encode(data.toJson());

class BookmarkModel {
  BookmarkModel({
    this.id,
    this.imageUrl,
    this.tag,
    this.title,
    this.content,
    this.time,
  });

  String id;
  String imageUrl;
  String tag;
  String title;
  String content;
  String time;

// factory AdviceModel.fromJson(Map<String, dynamic> json) => AdviceModel(
//   id: json["_id"],
//   advice: json["advice"],
//   adviceby: json["adviceby"],
//   advicefor: json["advicefor"],
//   target: json["target"],
//   time: json["time"],
// );
//
// Map<String, dynamic> toJson() => {
//   "_id": id,
//   "advice": advice,
//   "adviceby": adviceby,
//   "advicefor": advicefor,
//   "target": target,
//   "time": time,
// };
}
