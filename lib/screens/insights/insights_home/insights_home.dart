import 'package:FinXpress/components/shared/shared.dart';
import 'package:FinXpress/constants.dart';
import 'package:FinXpress/models/insights_model.dart';
import 'package:FinXpress/screens/insights/insights_post_details/insights_post_details.dart';
import 'package:FinXpress/services/insights_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InsightsHome extends StatefulWidget {
  InsightsHome({Key key}) : super(key: key);

  @override
  _InsightsHomeState createState() => _InsightsHomeState();
}

class _InsightsHomeState extends State<InsightsHome> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<List<InsightsModel>> currentInsightsFuture;
  Shared _shared = Shared();

  @override
  void initState() {
    super.initState();
    currentInsightsFuture = InsightsService.getInsights();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf1f3f4),
        body: FutureBuilder(
            future: currentInsightsFuture,
            builder: (context, AsyncSnapshot<List<InsightsModel>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: Constants.getCircularProgressBarIndicator());
              } else {
                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: Color(0xFFa6b0e7),
                  onRefresh: _refreshInsightsList,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => InsightsPostDetails(
                                      snapshot.data[index])));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadiusDirectional.circular(10),
                                boxShadow: [
                                  BoxShadow(color: Color(0xFFffffff)),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _getImage(
                                      snapshot.data[index].imageUrl, size),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        _getTimeRow(snapshot.data[index].time),
                                        Row(
                                          children: [
                                            _getTag(snapshot.data[index].tag),
                                            Spacer(),
                                            // _shared.getBookMark(
                                            //     snapshot, index, context),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            _shared.getShareButton("insights",
                                                snapshot.data[index].id)
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
                                      child: Text(snapshot.data[index].title,
                                          style: GoogleFonts.sourceSansPro(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7,
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

  Future<void> _refreshInsightsList() async {
    _refreshIndicatorKey.currentState?.show();
    final Future<List<InsightsModel>> adviceList =
        InsightsService.getInsights();
    setState(() {
      currentInsightsFuture = adviceList;
    });
  }

  Row _getTimeRow(String time) {
    return Row(
      children: [
        Icon(
          Icons.watch_later_sharp,
          color: Color(0xFF4B5557),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          Constants.dateConversion(time),
          style: TextStyle(color: Color(0xFF4B5557), fontSize: 13),
        ),
      ],
    );
  }

  Container _getTag(String tag) {
    return Container(
      height: 35,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              tag,
              style: GoogleFonts.sourceSansPro(fontSize: 16),
            )),
      ),
      decoration: BoxDecoration(
          color: Color(0xFFbebddf).withOpacity(0.6),
          borderRadius: BorderRadius.circular(5)),
    );
  }

  Container _getImage(String imageUrl, Size size) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(15),
          image: DecorationImage(
              fit: BoxFit.cover, image: CachedNetworkImageProvider(imageUrl))),
      height: size.height * 0.21,
      // margin: EdgeInsets.all(10),
    );
  }
}
