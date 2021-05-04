import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Advice extends StatefulWidget {
  @override
  _AdviceState createState() => _AdviceState();
}

class _AdviceState extends State<Advice> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          _getStockRecommendationTitle(),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("Advice").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                          child: Constants.getCircularProgressBarIndicator());
                    default:
                      return RefreshIndicator(
                        onRefresh: () async {
                          await Future<void>.delayed(Duration(seconds: 1));
                        },
                        child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height /
                                            2.1),
                                    crossAxisCount: 2),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: _getbackgroundColor(
                                        snapshot.data.docs[index]['Advice']),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data.docs[index]['Advice'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: _gettextColor(snapshot
                                                .data.docs[index]['Advice'])),
                                      ),
                                      SizedBox(
                                        height: size.height * .002,
                                      ),
                                      Text(
                                        snapshot.data.docs[index]["Company"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        'Target: ' +
                                            '\u{20B9}' +
                                            ' ' +
                                            snapshot.data.docs[index]['Target'],
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "By: " +
                                            snapshot.data.docs[index]
                                                ['AdviceBy'],
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        timeStampConversion(
                                            snapshot.data.docs[index]['Time']),
                                        style: TextStyle(fontSize: 11),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                  }
                }),
          ),
        ]),
      ),
    );
  }

  Padding _getStockRecommendationTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Stock Recommendations",
            style: GoogleFonts.sourceSansPro(
                fontSize: 20, fontWeight: FontWeight.w600),
          )),
    );
  }

  String timeStampConversion(Timestamp t) {
    DateTime dateTime = t.toDate();
    String formatDate = DateFormat.yMMMd().add_jm().format(dateTime);
    return formatDate;
  }

  Color _gettextColor(String val) {
    switch (val) {
      case "Buy":
        return Color(0xFF468750);
      case "Sell":
        return Color(0xFFc92634);
      case "Hold":
        return Color(0xFF8a6d6d);
      default:
        return Colors.grey;
    }
  }

  Color _getbackgroundColor(String val) {
    switch (val) {
      case "Buy":
        return Color(0xFFCADBD1);
      case "Sell":
        return Color(0xFFEF0B6B7);
      case "Hold":
        return Color(0xFFd9cccc);
      default:
        return Colors.grey;
    }
  }
}
