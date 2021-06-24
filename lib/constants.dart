import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constants {
  static const primaryLightColor = Color(0xFFCAE0DB);
  static const primaryColor = Color(0xFF576F7A);
  static const blackLightColor = Color(0xFF383B3B);
  static const apiUrl = "https://easyeyes.herokuapp.com";

  static CircularProgressIndicator getCircularProgressBarIndicator() {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primaryColor));
  }

  static String getdate(Timestamp t) {
    DateTime dateTime = t.toDate();
    String formatDate = DateFormat.yMMMMd('en_US').format(dateTime);
    return formatDate;
  }

  static String datetimeStampConversion(String date) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat('dd/MM/yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }
}
