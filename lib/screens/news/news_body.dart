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
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  Shared _shared = Shared();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(15),
                              ),
                              // height: size.height * 0.72,
                              child: Column(
                                children: [
                                  _shared.getImage(snapshot, index, size),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        _shared.getTimeRow(snapshot, index),
                                        Row(
                                          children: [
                                            _shared.getTag(snapshot, index),
                                            Spacer(),
                                            _shared.getBookMark(
                                                snapshot, index),
                                            SizedBox(
                                              width: size.width * .01,
                                            ),
                                            // getShareButton(),
                                            _shared.getShareButton(
                                                0,
                                                snapshot.data.docs[index]
                                                    ['title']),
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
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                              child: Text(
                                                  snapshot.data.docs[index]
                                                      ['title'],
                                                  style:
                                                      GoogleFonts.sourceSansPro(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                            ),
                                          ),
                                          Container(
                                            child: Html(
                                                style: {
                                                  "body": Style(
                                                      textAlign: TextAlign.left,
                                                      fontFamily:
                                                          "SourceSansPro",
                                                      fontSize: FontSize(17),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  "a": Style(
                                                      color: Colors.blueGrey,
                                                      fontFamily:
                                                          "SourceSansPro",
                                                      fontSize: FontSize(17),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                },
                                                data: snapshot.data.docs[index]
                                                    ['content'],
                                                onLinkTap: (String url,
                                                    RenderContext context,
                                                    Map<String, String>
                                                        attributes,
                                                    element) {
                                                  launch(Uri.parse(url)
                                                      .toString());
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  );
              }
            }),
      ),
    );
  }
}
