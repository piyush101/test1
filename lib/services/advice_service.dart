import 'dart:convert';
import 'package:FinXpress/constants.dart';
import 'package:FinXpress/models/advice_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AdviceService {
  static var logger = Logger();

  static Future<List<AdviceModel>> getAdvices() async {
    try {
      http.Response response =
          await http.get(Uri.parse(Constants.apiUrl + "/advices/all"));
      String body = response.body;
      List<dynamic> collection = json.decode(body)['data']['advices'];
      List<AdviceModel> advices =
          collection.map((val) => AdviceModel.fromJson(val)).toList();
      logger.i(response.body);
      return advices;
    } catch (error) {
      logger.e(error);
    }
  }
}
