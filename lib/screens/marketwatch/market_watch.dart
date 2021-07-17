import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MarketWatch extends StatefulWidget {
  @override
  _MarketWatchState createState() => _MarketWatchState();
}

class _MarketWatchState extends State<MarketWatch> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          _getStockRecommendationTitle(),
        ],
      ),
    );
  }

  Padding _getStockRecommendationTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  WebView(
                    initialUrl:
                        'https://www.google.com/finance/quote/NIFTY_50:INDEXNSE',
                    javascriptMode: JavascriptMode.unrestricted,
                  );
                },
                child: Text(
                  "MarketWatch",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5555aa)),
                ),
              ),
            ],
          )),
    );
  }
}
