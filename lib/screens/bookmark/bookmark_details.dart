import 'package:flutter/material.dart';
import 'package:flutter_app_news/components/enlarge_image/enlarge_image.dart';
import 'package:flutter_app_news/constants.dart';
import 'package:flutter_html/flutter_html.dart';
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
                    defaultTextStyle:
                        TextStyle(fontSize: 17, fontFamily: "SourceSansPro"),
                    linkStyle: TextStyle(
                        fontSize: 17,
                        fontFamily: "SourceSansPro",
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline),
                    data: widget.snapshot['content'],
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
          style: TextStyle(
            fontFamily: 'SourceSansPro',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
    ]);
  }
}
