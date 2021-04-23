import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/screens/drawer/news_drawer.dart';
import 'package:flutter_app_news/service/search_service/search_service.dart';

class Watchlist extends StatefulWidget {
  @override
  _WatchlistState createState() => new _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  var tempSearchStore = [];
  var queryResult = [];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "Finbox",
            style: TextStyle(color: Colors.black),
          ),
        ),
        drawer: Drawer(child: NewsDrawer()),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Your WatchList",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(context);
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 10.0),
          ListView.builder(
              shrinkWrap: true,
              itemCount: tempSearchStore.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tempSearchStore[index]['name']),
                  onTap: () {
                    users.doc(_firebaseAuth.currentUser.uid).update({
                      "subscribeTopic": FieldValue.arrayUnion(
                          [tempSearchStore[index]['name']])
                    });
                    Navigator.pop(context);
                  },
                );
              }),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(_firebaseAuth.currentUser.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black)));
                  default:
                    return SingleChildScrollView(
                      child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: MediaQuery.of(context)
                                          .size
                                          .width /
                                      (MediaQuery.of(context).size.height / 7),
                                  crossAxisCount: 2),
                          itemCount: snapshot.data.get('subscribeTopic').length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () {
                                showAlertDialog(context,
                                    snapshot.data.get('subscribeTopic')[index]);
                                print(
                                    snapshot.data.get('subscribeTopic')[index]);
                              },
                              child: Container(
                                child: Text(
                                  snapshot.data.get('subscribeTopic')[index],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                margin: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Color(0xFF92f7bb),
                                ),
                              ),
                            );
                          }),
                    );
                }
              })
        ]));
  }

  showAlertDialog(BuildContext context, value) {
    // set up the buttons
    Widget yesButton = ElevatedButton(
      child: Text("Yes"),
      onPressed: () async {
        // await FirebaseMessaging.instance.unsubscribeFromTopic(value);
        users.doc(_firebaseAuth.currentUser.uid).update({
          "subscribeTopic": FieldValue.arrayRemove([value])
        });
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Watchlist()));
        ;
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
}
