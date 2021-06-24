import 'dart:convert';

import 'package:FinXpress/constants.dart';
import 'package:FinXpress/models/insights_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class InsightsService {
  static var logger = Logger();

  static Future<List<InsightsModel>> getInsights() async {
    try {
      http.Response response =
          await http.get(Uri.parse(Constants.apiUrl + "/insights/all"));
      String body = response.body;
      List<dynamic> collection = json.decode(body)['data']['insights'];
      List<InsightsModel> insights =
          collection.map((val) => InsightsModel.fromJson(val)).toList();
      logger.i(response.body);
      return insights;
    } catch (error) {
      logger.e(error);
    }
  }
}
