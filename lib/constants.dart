import 'package:flutter/material.dart';

class Constants {
  static const primaryLightColor = Color(0xFFCAE0DB);
  static const primaryColor = Color(0xFFAFDED6);
  static const blackLightColor = Color(0xFF383B3B);

  static CircularProgressIndicator getCircularProgressBarIndicator() {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primaryColor));
  }
}
