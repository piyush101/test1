import 'package:FinXpress/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LearningsHome extends StatelessWidget {
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 2.1),
                          crossAxisCount: 2),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                          image: NetworkImage(snapshot
                                              .data.docs[index]['imageurl'])))),
                              Text(snapshot.data.docs[index].reference.id)
                            ],
                          ),
                        );
                      }),
                );
            }
          }),
    );
  }
}
