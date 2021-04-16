import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Advice extends StatefulWidget {
  @override
  _AdviceState createState() => _AdviceState();
}

class _AdviceState extends State<Advice> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Advice").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black)));
            default:
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2.4),
                      crossAxisCount: 2),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 150,
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: backgroundColor(
                            snapshot.data.docs[index]['Advice']),
                        borderRadius: BorderRadiusDirectional.circular(15),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data.docs[index]['Advice'],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor(
                                      snapshot.data.docs[index]['Advice'])),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              snapshot.data.docs[index]["Company"],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
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
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "By: " + snapshot.data.docs[index]['AdviceBy'],
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
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
                  });
          }
        });
  }

  String timeStampConversion(Timestamp t) {
    DateTime dateTime = t.toDate();
    String formatDate = DateFormat.yMMMd().add_jm().format(dateTime);
    return formatDate;
  }

  Color textColor(String val) {
    switch (val) {
      case "Buy":
        return Color(0xFF41c47a);
      case "Sell":
        return Color(0xFFc92634);
      case "Hold":
        return Color(0xFF8a6d6d);
      default:
        return Colors.grey;
    }
  }

  Color backgroundColor(String val) {
    switch (val) {
      case "Buy":
        return Color(0xFFbadebf);
      case "Sell":
        return Color(0xFFeda8a8);
      case "Hold":
        return Color(0xFFd9cccc);
      default:
        return Colors.grey;
    }
  }
}
