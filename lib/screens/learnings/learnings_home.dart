import 'package:FinXpress/constants.dart';
import 'package:FinXpress/models/learnings_model.dart';
import 'package:FinXpress/services/learnings_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'learnings_home_details.dart';

class LearningsHome extends StatefulWidget {
  LearningsHome({Key key}) : super(key: key);

  @override
  _LearningsHomeState createState() => _LearningsHomeState();
}

class _LearningsHomeState extends State<LearningsHome> {
  Future<List<LearningsModel>> currentLearningsFuture;

  @override
  void initState() {
    currentLearningsFuture = LearningsService.getLearnings();
    Constants.analytics.setCurrentScreen(screenName: "Learnings");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFf1f3f4),
      body: FutureBuilder(
          future: currentLearningsFuture,
          builder: (context, AsyncSnapshot<List<LearningsModel>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Constants.getCircularProgressBarIndicator());
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 65, 7, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                child: Text(
                                  "Knowledge \nis power",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.sourceSansPro(
                                      color: Color(0xFF5f5463),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * .3,
                              width: size.width * .5,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image:
                                          AssetImage("assets/images/kip.jpg"))),
                            )
                          ],
                        ),
                      ),
                    ),
                    GridView.builder(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 2.1),
                            crossAxisCount: 2),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LearningsHomeDetails(
                                      snapshot.data[index].data)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(snapshot.data[index].color)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFb1c5c5).withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: Offset(4, 8),
                                    ),
                                  ]),
                              margin: EdgeInsets.all(8),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        snapshot.data[index]
                                                            .imageUrl)))),
                                    Text(snapshot.data[index].category,
                                        style: GoogleFonts.sourceSansPro(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              );
            }
          }),
    );
  }
}
