// To parse this JSON data, do
//
//     final adviceModel = adviceModelFromJson(jsonString);

import 'dart:convert';

AdviceModel adviceModelFromJson(String str) =>
    AdviceModel.fromJson(json.decode(str));

String adviceModelToJson(AdviceModel data) => json.encode(data.toJson());

class AdviceModel {
  AdviceModel({
    this.id,
    this.advice,
    this.adviceby,
    this.advicefor,
    this.target,
    this.time,
  });

  String id;
  String advice;
  String adviceby;
  String advicefor;
  String target;
  String time;

  factory AdviceModel.fromJson(Map<String, dynamic> json) => AdviceModel(
        id: json["_id"],
        advice: json["advice"],
        adviceby: json["adviceby"],
        advicefor: json["advicefor"],
        target: json["target"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "advice": advice,
        "adviceby": adviceby,
        "advicefor": advicefor,
        "target": target,
        "time": time,
      };
}
