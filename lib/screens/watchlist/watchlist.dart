import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/service/search_service/search_service.dart';

class Watchlist extends StatefulWidget {
  @override
  _WatchlistState createState() => new _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  var tempSearchStore = [];
  var queryResult = [];

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
    };
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text('Firestore search'),
        ),
        body: ListView(children: <Widget>[
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
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 10.0),
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 4,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element);
              }).toList())
        ]));
  }
}

Widget buildResultCard(data) {
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
          child: Center(
              child: Text(
        data['name'],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
      ))));
}
