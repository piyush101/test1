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
  Stream stream;

  @override
  void initState() {
    stream = FirebaseFirestore.instance
        .collection("Advices")
        .orderBy("time", descending: true)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf1f3f4),
        body: Stack(children: [
          _getStockRecommendationTitle(),
          Padding(
            padding: const EdgeInsets.only(top: 45),
            child: StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: Constants.getCircularProgressBarIndicator());
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await Future<void>.delayed(Duration(seconds: 1));
                      },
                      child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.21, crossAxisCount: 2),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data.docs[index]['advice'],
                                      style: GoogleFonts.sourceSansPro(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: _gettextColor(snapshot
                                              .data.docs[index]['advice'])),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Text(
                                        snapshot.data.docs[index]["advicefor"],
                                        style: GoogleFonts.sourceSansPro(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      'Target: ' +
                                          '\u{20B9}' +
                                          ' ' +
                                          snapshot.data.docs[index]['target'],
                                      style: GoogleFonts.sourceSansPro(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "By: " +
                                          snapshot.data.docs[index]['adviceby'],
                                      style: GoogleFonts.sourceSansPro(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      timeStampConversion(
                                          snapshot.data.docs[index]['time']),
                                      style: GoogleFonts.sourceSansPro(
                                          fontSize: 12),
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
          child: Row(
            children: [
              Text(
                "Stock Recommendations",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5555aa)),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _disclaimerBox();
                        });
                  },
                  icon: Icon(Icons.info_outline),
                  color: Color(0xFF5555aa))
            ],
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

  AlertDialog _disclaimerBox() {
    return AlertDialog(
      title: Center(
        child: Text(
          "Stock Recommendations",
          style: GoogleFonts.sourceSansPro(
              color: Color(0xFF4f5a6b),
              fontWeight: FontWeight.w600,
              fontSize: 20),
        ),
      ),
      content: Container(
        height: 300,
        child: Column(
          children: [
            Text(
              "We are providing aggregated stock recommendations from top financial institutions in India.",
              style: TextStyle(
                  fontFamily: "SourceSansPro",
                  fontSize: 18,
                  color: Color(0xFF5f5463)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Buy/Sell/Hold: This is the action recommended by institution",
              style: TextStyle(
                  fontFamily: "SourceSansPro",
                  fontSize: 16,
                  color: Color(0xFF5f5463)),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "Target: This is price of company's stock at which action can be taken",
              style: TextStyle(
                  fontFamily: "SourceSansPro",
                  fontSize: 16,
                  color: Color(0xFF5f5463)),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "By: This is institution name which has recommended this stock",
              style: TextStyle(
                  fontFamily: "SourceSansPro",
                  fontSize: 16,
                  color: Color(0xFF5f5463)),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Happy Investing!!",
              style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xFF5f5463)),
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF8787c4))),
            child: Text(
              "Okay",
              style: TextStyle(fontFamily: "SourceSansPro", fontSize: 18),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }
}
