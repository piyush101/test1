import 'package:FinXpress/components/shared/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class NewsBody extends StatefulWidget {
  @override
  _NewsBodyState createState() => _NewsBodyState();
}

class _NewsBodyState extends State<NewsBody> {
  int index = 0;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  Shared _shared = Shared();

  @override
  void initState() {
    setupLastIndex();
    super.initState();
  }

  void updateIndex(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void setupLastIndex() async {
    final QuerySnapshot qSnap =
    await FirebaseFirestore.instance.collection('News').get();
    final int documents = qSnap.size;

    int lastIndex = 0;
    if (lastIndex != null && lastIndex < documents - 1) {
      updateIndex(lastIndex);
    }
  }

  Future<void> updateContent(direction) async {
    final QuerySnapshot qSnap =
    await FirebaseFirestore.instance.collection('News').get();
    final int documents = qSnap.size;

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
    Size size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
        child: Scaffold(
        body: StreamBuilder(
        stream: FirebaseFirestore.instance
        .collection("News")
        .orderBy("time", descending: true)
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    switch (snapshot.connectionState) {
    case ConnectionState.waiting:
    return Center(
    child: Constants.getCircularProgressBarIndicator());
    default:
    return RefreshIndicator(
    onRefresh: () async {
    await Future<void>.delayed(Duration(seconds: 1));
    },
    child: SafeArea(
    child: Dismissible(
    resizeDuration: Duration(milliseconds: 1),
    key: Key(index.toString()),
    direction: index > 0
    ? DismissDirection.vertical
        : DismissDirection.up,
    onDismissed: (direction) {
    updateContent(direction);
    },
    child: Column(
    children: [
    Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    fit: BoxFit.cover,
    image: NetworkImage(snapshot
        .data.docs[index]['imageurl']))),
    height: size.height * 0.25,
    // margin: EdgeInsets.all(10),
    ),
    Padding(
    padding:
    const EdgeInsets.fromLTRB(15, 10, 15, 10),
    child: Column(
    children: [
    _shared.getTimeRow(snapshot, index),
    Row(
    children: [
    _shared.getTag(snapshot, index),
    Spacer(),
    _shared.getBookMark(snapshot, index),
    SizedBox(
    width: size.width * .01,
    ),
    // getShareButton(),
    _shared.getShareButton(0,
    snapshot.data.docs[index]['title']),
    ],
    ),
    ],
    ),
    ),
    Container(
    child: Align(
    alignment: Alignment.centerLeft,
    child: Column(
    children: [
    Padding(
    padding: const EdgeInsets.fromLTRB(
    15, 2, 15, 2),
    child: Container(
    child: Text(
    snapshot.data.docs[index]['title'],
    style: GoogleFonts.sourceSansPro(
    fontSize: 18,
    fontWeight: FontWeight.w600)),
    ),
    ),
    Padding(
    padding: const EdgeInsets.only(
    left: 10, right: 15),
    child: Container(
    child: Html(
    style: {
    "body": Style(
    textAlign: TextAlign.left,
    fontFamily: "SourceSansPro",
    fontSize: FontSize(17),
    fontWeight: FontWeight.w500),
    "a": Style(
    color: Colors.blueGrey,
    fontFamily: "SourceSansPro",
    fontSize: FontSize(17),
    fontWeight: FontWeight.w600),
    },
    data: snapshot.data.docs[index]
    ['content'],
    onLinkTap: (String url,
    RenderContext context,
    Map<String, String> attributes,
    element) {
    launch(Uri.parse(url).toString());
    }),
    ),
    ),
    Padding(
    padding:
    const EdgeInsets.only(left: 15.0),
    child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
    "Swipe up for more news",
    style: GoogleFonts.sourceSansPro(
    fontWeight: FontWeight.w300),
    )),
    )
    ],
    ),
    ),
    )
    ],
    ),
    ),
    ));
    }
    })
    ,
    );
  }
}
