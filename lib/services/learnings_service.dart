import 'dart:convert';

import 'package:FinXpress/constants.dart';
import 'package:FinXpress/models/learnings_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class LearningsService {
  static var logger = Logger();

  static Future<List<LearningsModel>> getLearnings() async {
    try {
      http.Response response =
          await http.get(Uri.parse(Constants.apiUrl + "/learnings/all"));
      String body = response.body;
      List<dynamic> collection = json.decode(body)['data']['learnings'];
      List<LearningsModel> learnings =
          collection.map((val) => LearningsModel.fromJson(val)).toList();
      logger.i(response.body);
      return learnings;
    } catch (error) {
      logger.e(error);
    }
  }
}
