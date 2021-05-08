import 'package:FinXpress/components/shared/shared.dart';
import 'package:FinXpress/screens/insights/insights_post_details/insights_post_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InsightsHome extends StatefulWidget {
  @override
  _InsightsHomeState createState() => _InsightsHomeState();
}

class _InsightsHomeState extends State<InsightsHome> {
  Shared _shared = Shared();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Insights")
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.black)));
                  break;
                default:
                  return RefreshIndicator(
                    onRefresh: () async {
                      await Future<void>.delayed(Duration(seconds: 1));
                    },
                    child: ListView.builder(
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
                                  borderRadius:
                                  BorderRadiusDirectional.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                        Color(0xFFecedea).withOpacity(0.4)),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    _shared.getImage(snapshot, index, size),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          _shared.getTimeRow(snapshot, index),
                                          Row(
                                            children: [
                                              _shared.getTag(snapshot, index),
                                              Spacer(),
                                              _shared.getBookMark(
                                                  snapshot, index),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              _shared.getShareButton(
                                                  2,
                                                  snapshot.data.docs[index]
                                                  ['title'])
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            snapshot.data.docs[index]['title'],
                                            style: GoogleFonts.sourceSansPro(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
              }
            }),
      ),
    );
  }
}
