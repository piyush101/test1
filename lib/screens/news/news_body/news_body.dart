
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsBody extends StatefulWidget {
  @override
  _NewsBodyState createState() => _NewsBodyState();
}

class _NewsBodyState extends State<NewsBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Top News")
            .orderBy("Time", descending: true)
            .limit(150)
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadiusDirectional.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3)),
                          ],
                        ),
                        // height: size.height * 0.72,
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
                                      image: NetworkImage(
                                          snapshot.data.docs[index]['Image']))),
                              height: size.height * 0.21,
                              margin: EdgeInsets.all(10),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 7, top: 5),
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
                                        timeStampConversion(
                                            snapshot.data.docs[index]['Time']),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.cover,
                                        child: Text(
                                          snapshot.data.docs[index]['Tag'],
                                          style: GoogleFonts.cabin(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              backgroundColor:
                                                  Color(0xFFc5e0da)),
                                        ),
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data.docs[index]['Title'],
                                      style: GoogleFonts.robotoSlab(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      snapshot.data.docs[index]['Content'],
                                      style:
                                          GoogleFonts.robotoSlab(fontSize: 17),
                                    ),
                                    SizedBox(height: 5),
                                    GestureDetector(
                                      child: Text(
                                        snapshot.data.docs[index]['Last'],
                                        style: GoogleFonts.robotoSlab(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 15),
                                      ),
                                      onTap: () {
                                        launch(
                                            snapshot.data.docs[index]['Link']);
                                      },
                                    ),
                                    SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                              ),
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
}
