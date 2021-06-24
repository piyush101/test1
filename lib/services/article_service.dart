import 'dart:convert';

import 'package:FinXpress/constants.dart';
import 'package:FinXpress/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ArticleService {
  static var logger = Logger();

  static Future<List<ArticleModel>> getArticles() async {
    try {
      http.Response response =
          await http.get(Uri.parse(Constants.apiUrl + "/article/all"));
      String body = response.body;
      List<dynamic> collection = json.decode(body)['data']['articles'];
      List<ArticleModel> articles =
          collection.map((val) => ArticleModel.fromJson(val)).toList();
      logger.i(response.body);
      return articles;
    } catch (error) {
      logger.e(error);
    }
  }
}
