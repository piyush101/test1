import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/components/enlarge_image/enlarge_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkDetails extends StatefulWidget {
  DocumentSnapshot snapshot;

  BookmarkDetails(this.snapshot);

  @override
  _BookmarkDetailsState createState() => _BookmarkDetailsState();
}

class _BookmarkDetailsState extends State<BookmarkDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(color: Color(0xFFedfcf8)),
          child: Wrap(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(),
                child: Row(children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  Flexible(
                    child: Text(
                      widget.snapshot.get('bookmarks')[0]['Title'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                ]),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return EnlargeImage(
                        widget.snapshot.get("bookmarks")[0]['Image']);
                  }));
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              widget.snapshot.get("bookmarks")[0]['Image']))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                child: Row(
                  children: [
                    Text(
                      widget.snapshot.get("bookmarks")[0]['Tag'],
                      style: TextStyle(
                          fontSize: 16,
                          background: Paint()
                            ..strokeWidth = 22
                            ..color = Color(0xFFdff5ef)
                            ..style = PaintingStyle.stroke
                            ..strokeJoin = StrokeJoin.round),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: Text(timeStampConversion(
                              widget.snapshot.get('bookmarks')[0]['Time']))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    width: size.width * .6,
                    child: Divider(
                      color: Colors.grey,
                    )),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(
                    data: widget.snapshot.get("bookmarks")[0]['Content'],
                    onLinkTap: (url) {
                      launch(Uri.parse(url).toString());
                    },
                  ))
            ],
          ),
        ),
      ),
    ));
  }

  String timeStampConversion(Timestamp t) {
    DateTime dateTime = t.toDate();
    String formatDate = DateFormat.yMMMMd('en_US').format(dateTime);
    return formatDate;
  }
}
