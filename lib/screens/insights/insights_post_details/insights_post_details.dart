import 'package:FinXpress/components/enlarge_image/enlarge_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(color: Color(0xFFedfcf8)),
          child: Wrap(
            children: [
              getTitleContainer(context),
              buildImageContainer(context, size),
              getDateTimeReadRow(),
              getTagRow(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: size.width * .6,
                      child: Divider(
                        color: Colors.grey,
                      )),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Html(
                    style: {
                      "body": Style(
                          fontFamily: "SourceSansPro",
                          fontSize: FontSize(17),
                          fontWeight: FontWeight.w500),
                    },
                    data: widget.snapshot['content'],
                    onLinkTap: (String url, RenderContext context,
                        Map<String, String> attributes, element) {
                      launch(Uri.parse(url).toString());
                    }),
              )
            ],
          ),
        ),
      )),
    );
  }

  Container getTitleContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(),
      child: Row(children: <Widget>[
        backArrow(context),
        Flexible(
          child: Text(widget.snapshot['title'],
              style: GoogleFonts.sourceSansPro(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
        )
      ]),
    );
  }

  Padding getTagRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Text(
        widget.snapshot['tag'],
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            background: Paint()
              ..strokeWidth = 22
              ..color = Color(0xFF84ADAD).withOpacity(0.4)
              ..style = PaintingStyle.stroke
              ..strokeJoin = StrokeJoin.round),
      ),
    );
  }

  Padding getDateTimeReadRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            _dateConversion(widget.snapshot['time']),
            style: TextStyle(fontSize: 15),
          ),
          Spacer(),
          Text(widget.snapshot['readtime'])
        ],
      ),
    );
  }

  GestureDetector buildImageContainer(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return EnlargeImage(widget.snapshot['imageurl']);
        }));
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        height: size.height * 0.35,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.snapshot['imageurl']))),
      ),
    );
  }

  IconButton backArrow(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }

  String _dateConversion(Timestamp t) {
    DateTime dateTime = t.toDate();
    String formatDate = DateFormat.yMMMMd('en_US').format(dateTime);
    return formatDate;
  }
}
