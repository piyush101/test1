import 'package:FinXpress/screens/learnings/learnings_post_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LearningsHomeDetails extends StatefulWidget {
  List snapshot;

  LearningsHomeDetails(this.snapshot);

  @override
  _LearningsHomeDetailsState createState() => _LearningsHomeDetailsState();
}

class _LearningsHomeDetailsState extends State<LearningsHomeDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _getAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 2.1),
                  crossAxisCount: 2),
              shrinkWrap: true,
              itemCount: widget.snapshot.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            LearningsPostDetails(widget.snapshot[index])));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFb1c5c5).withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(4, 8),
                            )
                          ]),
                      child: Column(
                        children: [
                          Stack(children: [
                            Container(
                              height: 90,
                              color: Color(widget.snapshot[index]['color'])
                                  .withOpacity(0.5),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    color:
                                        Color(widget.snapshot[index]['color']),
                                    child: Text(
                                      widget.snapshot[index]['number'],
                                      style: GoogleFonts.sahitya(fontSize: 25),
                                    ),
                                  ),
                                ))
                          ]),
                          Text(
                            widget.snapshot[index]['title'],
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

AppBar _getAppBar() {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.black),
    backgroundColor: Color(0xFFb1c5c5),
    title: Text(
      "FinXpress",
      style: TextStyle(color: Colors.black),
    ),
  );
}
