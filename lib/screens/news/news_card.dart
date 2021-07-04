import 'package:FinXpress/constants.dart';
import 'package:FinXpress/models/article_model.dart';
import 'package:FinXpress/screens/bookmark/bookmark_shared.dart';
import 'package:FinXpress/utils/dynamic_link_service/dynamic_link_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatefulWidget {
  ArticleModel snapshot;

  NewsCard(this.snapshot);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  var unescape = HtmlUnescape();
  DynamicLinksService _dynamicLinkService = DynamicLinksService();
  BookmarkShared _bookmarkShared = BookmarkShared();
  final _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Screenshot(
      controller: _screenshotController,
      child: Stack(
        children: [
          Container(
            height: size.height * .30,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image:
                        CachedNetworkImageProvider(widget.snapshot.imageUrl))),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _getTag(widget.snapshot.tags),
                    Spacer(),
                    Row(
                      children: [
                        // _getBookMark(
                        //   widget.snapshot.sId,
                        // ),
                        _getShareButton("news", widget.snapshot.sId)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getTimeRow(widget.snapshot.time),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          parse(widget.snapshot.title)
                              .documentElement
                              .text
                              .replaceAll("#39;", "'"),
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 15),
                  child: Container(
                    child: Html(
                        style: {
                          "body": Style(
                              textAlign: TextAlign.left,
                              fontFamily: "SourceSansPro",
                              fontSize: FontSize(17),
                              fontWeight: FontWeight.w500),
                          "a": Style(
                              color: Color(0xFF161565).withOpacity(0.8),
                              fontFamily: "SourceSansPro",
                              fontSize: FontSize(17),
                              fontWeight: FontWeight.w600),
                        },
                        data: unescape.convert(
                            widget.snapshot.content.replaceAll("#39;", "'")),
                        onLinkTap: (String url, RenderContext context,
                            Map<String, String> attributes, element) {
                          launch(url.toString(),
                              forceWebView: true, enableJavaScript: true);
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
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
            margin: EdgeInsets.only(top: size.height * .275),
            decoration: BoxDecoration(
                color: Color(0xFFf1f3f4),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32))),
          )
        ],
      ),
    );
  }

  Container _getTag(String tag) {
    return Container(
      height: 35,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              tag,
              style: GoogleFonts.sourceSansPro(fontSize: 16),
            )),
      ),
      decoration: BoxDecoration(
          color: Color(0xFFf1f3f4), borderRadius: BorderRadius.circular(5)),
    );
  }

  // Container _getBookMark(DocumentSnapshot snapshot) {
  //   return Container(
  //     height: 37,
  //     decoration: BoxDecoration(
  //       color: Color(0xFFf1f3f4),
  //       shape: BoxShape.circle,
  //     ),
  //     child: IconButton(
  //       onPressed: () {
  //         _bookmarkShared.isBookmarked(widget.snapshot)
  //             ? _bookmarkShared.deleteBookMarkData(widget.snapshot, context)
  //             : _bookmarkShared.addBookMarkData(widget.snapshot, context);
  //       },
  //       icon: _bookmarkShared.isBookmarked(snapshot)
  //           ? Icon(
  //               Icons.bookmark,
  //               color: Color(0xFF4B5557),
  //               size: 20,
  //             )
  //           : Icon(
  //               Icons.bookmark_border_outlined,
  //               color: Color(0xFF4B5557),
  //               size: 20,
  //             ),
  //     ),
  //   );
  // }

  Padding _getShareButton(String page, String articleId) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Container(
        height: 37,
        decoration: BoxDecoration(
          color: Color(0xFFf1f3f4),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: IconButton(
              icon: Icon(
                Icons.share_rounded,
                size: 20,
              ),
              color: Color(0xFF4B5557),
              onPressed: () async {
                takeScreenshot(page, articleId);
              }),
        ),
      ),
    );
  }

  Padding _getTimeRow(String time) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 0, 0),
      child: Row(
        children: [
          IconButton(
              icon: Container(
            child: SvgPicture.asset(
              "assets/icons/timer.svg",
              width: 20,
              height: 25,
            ),
          )),
          Text(
            Constants.datetimeStampConversion(time),
            style: TextStyle(
                color: Color(0xFF5f5463),
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void takeScreenshot(String page, String articleId) async {
    final directory = (await getApplicationDocumentsDirectory())
        .path; //from path_provide package
    String fileName = "screenshot" +
        DateTime.now().millisecondsSinceEpoch.toString() +
        ".jpg";
    var path = '$directory';
    _screenshotController.captureAndSave(
        path, //set path where screenshot will be saved
        fileName: fileName);
    Share.shareFiles([path + "/" + fileName],
        text:
            "Get realtime financial market updates in less than 60 words. Download FinXpress\n" +
                await _dynamicLinkService.createDynamicLink(page, articleId));
  }
}
