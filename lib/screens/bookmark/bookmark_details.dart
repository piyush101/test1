import 'package:FinXpress/components/enlarge_image/enlarge_image.dart';
import 'package:FinXpress/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkDetails extends StatefulWidget {
  Map snapshot;

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
          child: Wrap(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(),
                child: _getTopRow(context),
              ),
              _getImage(context, size),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                child: Row(
                  children: [
                    Text(
                      widget.snapshot['tag'],
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
                          child:
                              Text(Constants.getdate(widget.snapshot['time']))),
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
                    style: {
                      "body": Style(
                          fontFamily: "SourceSansPro",
                          fontSize: FontSize(16),
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
      ),
    ));
  }

  GestureDetector _getImage(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return EnlargeImage(widget.snapshot['imageurl']);
        }));
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        height: size.height * 0.3,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(widget.snapshot['imageurl']))),
      ),
    );
  }

  Row _getTopRow(BuildContext context) {
    return Row(children: <Widget>[
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
          widget.snapshot['title'],
          style: GoogleFonts.sourceSansPro(
              fontSize: 21, fontWeight: FontWeight.w600),
        ),
      )
    ]);
  }
}
