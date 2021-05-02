import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/screens/bookmark/bookmark_shared.dart';
import 'package:flutter_app_news/service/dynamic_link_service/dynamic_link_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import '../../constants.dart';

class Shared {
  BookmarkShared _bookmarkShared = BookmarkShared();
  DynamicLinkService _dynamicLinkService = DynamicLinkService();

  IconButton getShareButton(pageIndex, snapShot) {
    return IconButton(
        icon: Icon(
          Icons.share_rounded,
          size: 30,
        ),
        onPressed: () async {
          Share.share(
              await _dynamicLinkService.createDynamicLink(pageIndex, snapShot));
        });
  }

  Container getImage(
      AsyncSnapshot<QuerySnapshot> snapshot, int index, Size size) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(15),
          boxShadow: [
            BoxShadow(color: Constants.primaryLightColor),
          ],
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(snapshot.data.docs[index]['Image']))),
      height: size.height * 0.21,
      margin: EdgeInsets.all(10),
    );
  }

  IconButton getBookMark(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    return IconButton(
        icon: _bookmarkShared.isBookmarked(snapshot.data.docs[index])
            ? Icon(Icons.bookmark)
            : Icon(Icons.bookmark_border_outlined),
        onPressed: () {
          _bookmarkShared.isBookmarked(snapshot.data.docs[index])
              ? _bookmarkShared.deleteBookMarkData(snapshot.data.docs[index])
              : _bookmarkShared.addBookMarkData(snapshot.data.docs[index]);
        });
  }

  FittedBox getTag(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Text(
        snapshot.data.docs[index]['Tag'],
        style: GoogleFonts.sourceSansPro(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            backgroundColor: Color(0xFFB2D9CF)),
      ),
    );
  }

  Row getTimeRow(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    return Row(
      children: [
        Icon(
          Icons.watch_later_sharp,
          color: Color(0xFF616967),
        ),
        Text(
          datetimeStampConversion(snapshot.data.docs[index]['Time']),
          style: TextStyle(color: Color(0xFF616967)),
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
