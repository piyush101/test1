import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/constants.dart';
import 'package:flutter_app_news/service/search_service/search_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class Watchlist extends StatefulWidget {
  @override
  _WatchlistState createState() => new _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  var tempSearchStore = [];
  var queryResult = [];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference _users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.passthrough,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Your Watchlist",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 35, 8, 5),
              child: Text(
                "Tap and Hold to delete stock",
                style: TextStyle(color: Color(0xFF788079)),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            _buildStreamBuilder(),
            _floatingSearchBar()
          ],
        ),
      ),
    );
  }

  Padding _buildStreamBuilder() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 50, 8, 8),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(_firebaseAuth.currentUser.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                    child: Constants.getCircularProgressBarIndicator());
              default:
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 4),
                            crossAxisCount: 2),
                        itemCount: snapshot.data.get('subscribeTopic').length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {
                              showAlertDialog(context,
                                  snapshot.data.get('subscribeTopic')[index]);
                              print(snapshot.data.get('subscribeTopic')[index]);
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data.get('subscribeTopic')[index],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              margin: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                color: Color(0xFF92f7bb),
                              ),
                            ),
                          );
                        }),
                  ),
                );
            }
          }),
    );
  }

  showAlertDialog(BuildContext context, value) {
    // set up the buttons
    Widget yesButton = ElevatedButton(
      child: Text("Yes"),
      onPressed: () async {
        // await FirebaseMessaging.instance.unsubscribeFromTopic(value);
        _users.doc(_firebaseAuth.currentUser.uid).update({
          "subscribeTopic": FieldValue.arrayRemove([value])
        });
        Navigator.maybePop(context);
      },
    );
    Widget noButton = ElevatedButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Finbox"),
      content: Text("Do you like to unsubscribe for " + value + " ?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Padding _floatingSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: FloatingSearchBar(
          hint: "Search Stock",
          physics: BouncingScrollPhysics(),
          scrollPadding: EdgeInsets.only(top: 16, bottom: 20),
          elevation: 4.0,
          onQueryChanged: (value) {
            initiateSearch(value);
          },
          automaticallyImplyDrawerHamburger: false,
          transition: CircularFloatingSearchBarTransition(),
          builder: (context, transition) {
            return Container(
              color: Colors.white,
              child: Column(
                  children: tempSearchStore.map((element) {
                return buildResultCard(element);
              }).toList()),
            );
          }),
    );
  }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResult = [];
        tempSearchStore = [];
      });
    }

    if (queryResult.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot snapshot) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          queryResult.add(snapshot.docs[i].data());
          setState(() {
            tempSearchStore.add(queryResult[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResult.forEach((element) {
        if (element['name'].toString().startsWith(value)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
    ;
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        _users.doc(_firebaseAuth.currentUser.uid).update({
          "subscribeTopic": FieldValue.arrayUnion([data['name']])
        });
        await FirebaseMessaging.instance
            .subscribeToTopic(tempSearchStore[data['name']]);
        Navigator.maybePop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            data['name'],
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
