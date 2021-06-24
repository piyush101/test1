// import 'package:FinXpress/service/search_service/search_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';
//
// import '../../constants.dart';
//
// class Watchlist extends StatefulWidget {
//   @override
//   _WatchlistState createState() => new _WatchlistState();
// }
//
// class _WatchlistState extends State<Watchlist> {
//   SearchService _searchService = SearchService();
//   static const bool kReleaseMode =
//       bool.fromEnvironment('dart.vm.product', defaultValue: false);
//
//   var tempSearchStore = [];
//   var queryResult = [];
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   CollectionReference users = FirebaseFirestore.instance.collection('Users');
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SafeArea(
//       child: new Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Text("Your Watchlist",
//                   style: GoogleFonts.sourceSansPro(
//                       fontSize: 21,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.blueGrey)),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8, 35, 8, 5),
//               child: Text(
//                 "Tap and Hold to delete stock",
//                 style: GoogleFonts.sourceSansPro(
//                     color: Colors.blueGrey,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//             _buildStreamBuilder(),
//             _floatingSearchBar()
//           ],
//         ),
//       ),
//     );
//   }
//
//   Padding _buildStreamBuilder() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(8, 50, 8, 8),
//       child: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection("Users")
//               .doc(_firebaseAuth.currentUser.uid)
//               .snapshots(),
//           builder:
//               (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 return Center(
//                     child: Constants.getCircularProgressBarIndicator());
//               default:
//                 return Column(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 80),
//                         child: GridView.builder(
//                             shrinkWrap: true,
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                     childAspectRatio: MediaQuery.of(context)
//                                             .size
//                                             .width /
//                                         (MediaQuery.of(context).size.height /
//                                             5),
//                                     crossAxisCount: 2),
//                             itemCount:
//                                 snapshot.data.get('subscribetopic').length,
//                             itemBuilder: (context, index) {
//                               return _getCompanyContainer(
//                                   context, snapshot, index);
//                             }),
//                       ),
//                     ),
//                   ],
//                 );
//             }
//           }),
//     );
//   }
//
//   GestureDetector _getCompanyContainer(BuildContext context,
//       AsyncSnapshot<DocumentSnapshot> snapshot, int index) {
//     return GestureDetector(
//       onLongPress: () {
//         _showAlertDialog(context, snapshot.data.get('subscribetopic')[index]);
//       },
//       child: Container(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(snapshot.data.get('subscribetopic')[index].toString(),
//               style: GoogleFonts.sourceSansPro(
//                   fontSize: 18, fontWeight: FontWeight.w500)),
//         ),
//         margin: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           color: Colors.blueGrey.withOpacity(0.2),
//         ),
//       ),
//     );
//   }
//
//   _showAlertDialog(BuildContext context, value) {
//     // set up the buttons
//     Widget _yesButton = ElevatedButton(
//       style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
//       child: Text("Yes"),
//       onPressed: () async {
//         // if (kReleaseMode) {
//         await FirebaseMessaging.instance
//             .unsubscribeFromTopic(value.toString().split(" ")[0]);
//         // }
//         users.doc(_firebaseAuth.currentUser.uid).update({
//           "subscribetopic": FieldValue.arrayRemove([value])
//         });
//         Navigator.maybePop(context);
//       },
//     );
//     Widget _noButton = ElevatedButton(
//       style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
//       child: Text("No"),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );
//
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text("FinXpress"),
//       content: Text("Do you like to unsubscribe for " + value + " ?"),
//       actions: [
//         _yesButton,
//         _noButton,
//       ],
//     );
//
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//   _floatingSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 60),
//       child: FloatingSearchBar(
//           hint: "Search Stock",
//           physics: BouncingScrollPhysics(),
//           openAxisAlignment: 0.0,
//           axisAlignment: 0.0,
//           scrollPadding: EdgeInsets.only(top: 16, bottom: 20),
//           elevation: 4.0,
//           onQueryChanged: (value) {
//             initiateSearch(value);
//           },
//           automaticallyImplyDrawerHamburger: false,
//           transition: CircularFloatingSearchBarTransition(),
//           builder: (context, transition) {
//             return ClipRRect(
//               child: Container(
//                 color: Colors.white,
//                 child: Column(
//                     children: tempSearchStore.map((element) {
//                   return _buildResultCard(element);
//                 }).toList()),
//               ),
//             );
//           }),
//     );
//   }
//
//   initiateSearch(value) {
//     if (value.length == 0) {
//       setState(() {
//         queryResult = [];
//         tempSearchStore = [];
//       });
//     }
//
//     if (queryResult.length == 0 && value.length == 1) {
//       _searchService.searchByName(value).then((QuerySnapshot snapshot) {
//         for (int i = 0; i < snapshot.docs.length; i++) {
//           queryResult.add(snapshot.docs[i].data());
//           setState(() {
//             tempSearchStore.add(queryResult[i]);
//           });
//         }
//       });
//     } else {
//       tempSearchStore = [];
//       queryResult.forEach((element) {
//         if (element['name'].toString().startsWith(value)) {
//           setState(() {
//             tempSearchStore.add(element);
//           });
//         }
//       });
//     }
//     ;
//     if (tempSearchStore.length == 0 && value.length > 1) {
//       setState(() {});
//     }
//   }
//
//   Widget _buildResultCard(data) {
//     return GestureDetector(
//       onTap: () async {
//         users.doc(_firebaseAuth.currentUser.uid).update({
//           "subscribetopic": FieldValue.arrayUnion([data['symbol'].toString()])
//         });
//         // if (kReleaseMode) {
//         // print(data['name'].toString().split(" ")[0]);
//         await FirebaseMessaging.instance.subscribeToTopic(data['symbol']);
//         // }
//         Navigator.maybePop(context);
//       },
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text(data['name'],
//               style: GoogleFonts.sourceSansPro(
//                   fontSize: 18, fontWeight: FontWeight.w500)),
//         ),
//       ),
//     );
//   }
// }
