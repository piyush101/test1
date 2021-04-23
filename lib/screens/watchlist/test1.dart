import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test1 extends StatefulWidget {
  @override
  _Test1State createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  List<String> list = ["piyush", 'iyush', 'yush', 'ush', 'sh', 'hor', 'shy'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Text("Your Watchlist"),
          TextField(
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
          ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.green,
                  child: Text(list[index]),
                );
              }),
          ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(list[index]),
                  onTap: () {
                    Navigator.pop(context);
                  },
                );
              }),
        ],
      ),
    );
  }
}
