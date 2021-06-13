import 'package:FinXpress/components/shared/shared.dart';
import 'package:FinXpress/screens/news/news_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class NewsBody extends StatefulWidget {
  @override
  _NewsBodyState createState() => _NewsBodyState();
}

class _NewsBodyState extends State<NewsBody> {
  Stream stream;
  int index = 0;
  var documents =
      FirebaseFirestore.instance.collection('News').snapshots().length;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  Shared _shared = Shared();

  @override
  void initState() {
    stream = FirebaseFirestore.instance
        .collection("News")
        .orderBy("time", descending: true)
        .limit(100)
        .snapshots();
    setupLastIndex();
    super.initState();
  }

  void updateIndex(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void setupLastIndex() async {
    int documents = _getdouments();
    int lastIndex = 0;
    if (lastIndex != null && lastIndex < documents - 1) {
      updateIndex(lastIndex);
    }
  }

  Future<void> updateContent(direction) async {
    int documents = _getdouments();

    if (index <= 0 && direction == DismissDirection.down) {
      index = documents - 1;
    } else if (index == documents - 1 && direction == DismissDirection.up) {
      index = 0;
    } else if (direction == DismissDirection.up) {
      index++;
    } else {
      index--;
    }
    updateIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    int prevIndex = index <= 0 ? 0 : index - 1;
    int nextIndex = index == _getdouments() - 1 ? 0 : index + 1;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Constants.getCircularProgressBarIndicator());
            } else {
              return SafeArea(
                child: Dismissible(
                    resizeDuration: Duration(milliseconds: 10),
                    key: Key(index.toString()),
                    direction: index > 0
                        ? DismissDirection.vertical
                        : DismissDirection.up,
                    onDismissed: (direction) {
                      updateContent(direction);
                    },
                    background: NewsCard(snapshot.data.docs[prevIndex]),
                    secondaryBackground:
                        NewsCard(snapshot.data.docs[nextIndex]),
                    child: NewsCard(snapshot.data.docs[index])),
              );
            }
          }),
    ));
  }

  int _getdouments() {
    int count = 0;
    FirebaseFirestore.instance
        .collection('News')
        .get(GetOptions(source: Source.cache))
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        count = count + 1;
        print(doc.metadata.isFromCache ? "Cache" : "Network");
      });
    });
    return count;
  }
}
