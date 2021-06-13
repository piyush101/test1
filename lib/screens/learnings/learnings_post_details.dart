import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class LearningsPostDetails extends StatefulWidget {
  Map snapshot;
  LearningsPostDetails(this.snapshot);

  @override
  _LearningsPostDetailsState createState() => _LearningsPostDetailsState();
}

class _LearningsPostDetailsState extends State<LearningsPostDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
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
                      widget.snapshot['title'],
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 21, fontWeight: FontWeight.w600),
                    ),
                  )
                ]),
              ),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: CachedNetworkImageProvider(
                            widget.snapshot['image']))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Html(
                    style: {
                      "body": Style(
                          fontFamily: "SourceSansPro",
                          fontSize: FontSize(16),
                          fontWeight: FontWeight.w500),
                      "a": Style(
                          color: Color(0xFF161565).withOpacity(0.8),
                          fontFamily: "SourceSansPro",
                          fontSize: FontSize(17),
                          fontWeight: FontWeight.w600),
                    },
                    data: widget.snapshot['content'],
                    onLinkTap: (String url, RenderContext context,
                        Map<String, String> attributes, element) {
                      launch(url.toString(),
                          forceWebView: true, enableJavaScript: true);
                    }),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
