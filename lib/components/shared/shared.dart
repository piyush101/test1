import 'package:FinXpress/screens/bookmark/bookmark_shared.dart';
import 'package:FinXpress/utils/dynamic_link_service/dynamic_link_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class Shared {
  BookmarkShared _bookmarkShared = BookmarkShared();
  DynamicLinksService _dynamicLinkService = DynamicLinksService();

  IconButton getShareButton(String page, articleId) {
    return IconButton(
        icon: Icon(
          Icons.share_rounded,
          size: 30,
        ),
        color: Color(0xFF4B5557),
        onPressed: () async {
          Share.share(
              "Get realtime financial market updates in less than 60 words. Download FinXpress\n" +
                  await _dynamicLinkService.createDynamicLink(page, articleId));
        });
  }

  Container getImage(
      AsyncSnapshot<QuerySnapshot> snapshot, int index, Size size) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(15),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                  snapshot.data.docs[index]['imageurl']))),
      height: size.height * 0.21,
      // margin: EdgeInsets.all(10),
    );
  }

  IconButton getBookMark(
      AsyncSnapshot<QuerySnapshot> snapshot, int index, context) {
    return IconButton(
        icon: _bookmarkShared.isBookmarked(snapshot.data.docs[index])
            ? Icon(
                Icons.bookmark,
                color: Color(0xFF4B5557),
              )
            : Icon(
                Icons.bookmark_border_outlined,
                color: Color(0xFF4B5557),
              ),
        onPressed: () {
          _bookmarkShared.isBookmarked(snapshot.data.docs[index])
              ? _bookmarkShared.deleteBookMarkData(
                  snapshot.data.docs[index], context)
              : _bookmarkShared.addBookMarkData(
                  snapshot.data.docs[index], context);
        });
  }

  Padding getTag(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        snapshot.data.docs[index]['tag'],
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            background: Paint()
              ..strokeWidth = 22
              ..color = Color(0xFF404A35).withOpacity(.15)
              ..style = PaintingStyle.stroke
              ..strokeJoin = StrokeJoin.round),
      ),
    );
  }

  Row getTimeRow(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    return Row(
      children: [
        Icon(
          Icons.watch_later_sharp,
          color: Color(0xFF4B5557),
        ),
        Text(
          datetimeStampConversion(snapshot.data.docs[index]['time']),
          style: TextStyle(color: Color(0xFF4B5557), fontSize: 13),
        ),
      ],
    );
  }

  String datetimeStampConversion(Timestamp t) {
    DateTime dateTime = t.toDate();
    String formatDate = DateFormat.yMMMd().add_jm().format(dateTime);
    return formatDate;
  }
}
