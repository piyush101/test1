import 'package:FinXpress/models/learnings_model.dart';
import 'package:FinXpress/screens/learnings/learnings_post_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LearningsHomeDetails extends StatefulWidget {
  List<Datum> snapshot;
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
        backgroundColor: Color(0xFFf1f3f4),
        extendBodyBehindAppBar: true,
        appBar: _getAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: size.width / (size.height / 2),
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
                    padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                            )
                          ]),
                      child: Column(
                        children: [
                          Stack(children: [
                            Container(
                              height: 90,
                              color: Color(widget.snapshot[index].color)
                                  .withOpacity(0.5),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    color: Color(widget.snapshot[index].color),
                                    child: Text(
                                      widget.snapshot[index].articleNumber
                                          .toString(),
                                      style: GoogleFonts.sahitya(fontSize: 25),
                                    ),
                                  ),
                                ))
                          ]),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.snapshot[index].title,
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
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
    iconTheme: IconThemeData(color: Color(0xFF5f5463)),
    backgroundColor: Color(0xFFf1f3f4),
    title: Text(
      "FinXpress",
      style: GoogleFonts.sourceSansPro(
          fontWeight: FontWeight.w600, color: Color(0xFF5f5463), fontSize: 23),
    ),
  );
}
