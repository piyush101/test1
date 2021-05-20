import 'package:FinXpress/constants.dart';
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
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("Learnings").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                    child: Constants.getCircularProgressBarIndicator());
              default:
                return RefreshIndicator(
                  onRefresh: () async {
                    await Future<void>.delayed(Duration(seconds: 1));
                  },
                  child: GridView.builder(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 2.1),
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
                                color: Color(0xFFb1c5c5).withOpacity(0.2),
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
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                              image: NetworkImage(snapshot.data
                                                  .docs[index]['imageurl'])))),
                                  Text(snapshot.data.docs[index].reference.id,
                                      style: GoogleFonts.sourceSansPro(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
            }
          }),
    );
  }

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    Image image;
    await FirebaseStorageService.loadImage(context, imageName).then((value) {
      image = Image.network(value.toString(), fit: BoxFit.cover);
      return image;
    });
  }
}

class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();

  static Future<dynamic> loadImage(BuildContext context, String Image) async {
    return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
  }
}
