import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/screens/insights/insights_post_details/insights_post_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class InsightsHome extends StatefulWidget {
  @override
  _InsightsHomeState createState() => _InsightsHomeState();
}

class _InsightsHomeState extends State<InsightsHome> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Insights")
            .orderBy("Time", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black)));
            default:
              return ListView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InsightsPostDetails(
                                  snapshot.data.docs[index])));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusDirectional.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: Offset(0, 1)),
                                    ],
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(snapshot
                                            .data.docs[index]['Image']))),
                                height: size.height * 0.15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5, top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.watch_later_sharp,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          timeStampConversion(snapshot
                                              .data.docs[index]['Time']),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          snapshot.data.docs[index]['Tag'],
                                          style: GoogleFonts.cabin(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              backgroundColor:
                                                  Color(0xFFc5e0da)),
                                        ),
                                        Spacer(),
                                        IconButton(
                                            icon: Icon(
                                              Icons.bookmark,
                                              size: 30,
                                            ),
                                            onPressed: () {}),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.share_rounded,
                                              size: 30,
                                            ),
                                            onPressed: () {}),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 5, 8, 25),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data.docs[index]['Title'],
                                        style: GoogleFonts.robotoSlab(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        snapshot.data.docs[index]
                                            ['Description'],
                                        style: GoogleFonts.robotoSlab(
                                            fontSize: 18),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
          }
        });
  }

  String timeStampConversion(Timestamp t) {
    DateTime dateTime = t.toDate();
    String formatDate = DateFormat('dd-MM-yyyy, hh:mm a').format(dateTime);
    return formatDate;
  }
}
