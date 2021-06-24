import 'package:FinXpress/models/article_model.dart';
import 'package:FinXpress/screens/news/news_card.dart';
import 'package:FinXpress/services/article_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class NewsBody extends StatefulWidget {
  @override
  _NewsBodyState createState() => _NewsBodyState();
}

class _NewsBodyState extends State<NewsBody> {
  Future<List<ArticleModel>> currentArticleFuture;

  @override
  void initState() {
    super.initState();
    currentArticleFuture = ArticleService.getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder(
          future: currentArticleFuture,
          builder: (context, AsyncSnapshot<List<ArticleModel>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Constants.getCircularProgressBarIndicator());
            } else {
              return SafeArea(
                  child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return NewsCard(snapshot.data[index]);
                      }));
            }
          }),
    ));
  }
}
