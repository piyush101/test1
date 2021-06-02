import 'package:FinXpress/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'learnings_home_details.dart';

class LearningsHome extends StatefulWidget {
  @override
  _LearningsHomeState createState() => _LearningsHomeState();
}

class _LearningsHomeState extends State<LearningsHome> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFf1f3f4),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("Learnings").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                    child: Constants.getCircularProgressBarIndicator());
              default:
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
                                        image: CachedNetworkImageProvider(
                                            "https://firebasestorage.googleapis.com/v0/b/finbox-55d7a.appspot.com/o/learnings%2Flearnings-Recoveredpng%20file%20pagal%20ke%20liye-min.png?alt=media&token=b6bd4fd1-ca86-4c27-8135-ff70a8b57891"))),
                              )
                            ],
                          ),
                        ),
                      ),
                      GridView.builder(
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              2.1),
                                  crossAxisCount: 2),
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LearningsHomeDetails(
                                        snapshot.data.docs[index]['data'])));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(
                                            snapshot.data.docs[index]['color'])
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFFb1c5c5).withOpacity(0.2),
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
                                                          snapshot.data
                                                                  .docs[index]
                                                              ['imageurl'])))),
                                      Text(
                                          snapshot
                                              .data.docs[index].reference.id,
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

class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();

  static Future<dynamic> loadImage(BuildContext context, String Image) async {
    return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
  }
}
