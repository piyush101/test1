import 'package:FinXpress/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Color(0xFFf1f3f4),
        body: Stack(children: [
          _getStockRecommendationTitle(),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Advices")
                    .orderBy("time", descending: true)
                    .snapshots(),
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
                                    childAspectRatio: 1.2, crossAxisCount: 2),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Color(0xFF5555aa), width: 0.4),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data.docs[index]['advice'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: _gettextColor(snapshot
                                                .data.docs[index]['advice'])),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        child: Text(
                                          snapshot.data.docs[index]
                                              ["advicefor"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        'Target: ' +
                                            '\u{20B9}' +
                                            ' ' +
                                            snapshot.data.docs[index]['target'],
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
                                                ['adviceby'],
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        timeStampConversion(
                                            snapshot.data.docs[index]['time']),
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
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5555aa)),
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
}
