import 'package:FinXpress/models/article_model.dart';
import 'package:FinXpress/notifiers/article_id_notifier.dart';
import 'package:FinXpress/screens/news/news_card.dart';
import 'package:FinXpress/services/article_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class NewsBody extends StatefulWidget {
  final String title;

  NewsBody({Key key, this.title}) : super(key: key);

  @override
  _NewsBodyState createState() => _NewsBodyState();
}

class _NewsBodyState extends State<NewsBody> {
  List<ArticleModel> articleList;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<List<ArticleModel>> currentArticleFuture;

  @override
  void initState() {
    currentArticleFuture = ArticleService.getArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Color(0xFFa6b0e7),
        onRefresh: _refreshArticleList,
        child: FutureBuilder(
            future: currentArticleFuture,
            builder: (context, AsyncSnapshot<List<ArticleModel>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: Constants.getCircularProgressBarIndicator());
              } else {
                final id =
                    Provider.of<ArticleIdNotifier>(context, listen: false).id;
                final initialIndex = _getArticleIndex(snapshot.data, id);
                return SafeArea(
                    child: PageView.builder(
                        controller: PageController(
                            initialPage: initialIndex,
                            keepPage: true,
                            viewportFraction: 1),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return NewsCard(snapshot.data[index]);
                        }));
              }
            }),
      ),
    );
  }

  int _getArticleIndex(List<ArticleModel> list, String articleId) {
    var articleIndex;
    articleIndex = list.indexWhere((element) => element.sId == articleId);
    if (articleIndex == null) {
      return 0;
    }
    return articleIndex;
  }

  Future<void> _refreshArticleList() async {
    _refreshIndicatorKey.currentState?.show();
    final Future<List<ArticleModel>> adviceList = ArticleService.getArticles();
    setState(() {
      currentArticleFuture = adviceList;
    });
  }
}
