import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/components/enlarge_image/enlarge_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class InsightsPostDetails extends StatefulWidget {
  DocumentSnapshot snapshot;

  InsightsPostDetails(this.snapshot);

  @override
  _InsightsPostDetailsState createState() => _InsightsPostDetailsState();
}

class _InsightsPostDetailsState extends State<InsightsPostDetails> {
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
                      widget.snapshot['Title'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                ]),
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return EnlargeImage(widget.snapshot['Image']);
                      }));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      height: size.height * 0.3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.snapshot['Image']))),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.bookmark,
                              size: 30,
                            ),
                            onPressed: () {}),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.share_rounded,
                              size: 30,
                            ),
                            onPressed: () {}),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      timeStampConversion(widget.snapshot['Time']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Text(widget.snapshot['ReadTime'] + " Min Read")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                child: Text(
                  widget.snapshot['Tag'],
                  style: TextStyle(
                      fontSize: 16,
                      background: Paint()
                        ..strokeWidth = 22
                        ..color = Color(0xFFdff5ef)
                        ..style = PaintingStyle.stroke
                        ..strokeJoin = StrokeJoin.round),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: Text(
                  widget.snapshot['PostDescription'],
                  style: TextStyle(fontSize: 18),
                )),
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
                child: Column(
                  children: [
                    Text(
                      "The Conclusion",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    Html(data: widget.snapshot['Content'],onLinkTap: (url){launch(Uri.parse(url).toString());},)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  String timeStampConversion(Timestamp t) {
    DateTime dateTime = t.toDate();
    String formatDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formatDate;
  }
}
