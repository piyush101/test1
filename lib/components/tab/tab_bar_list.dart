import 'package:flutter/material.dart';

class TabBarList extends StatelessWidget {
  final int tabLength;
  final List<Text> tabNameList;

  const TabBarList({
    Key key,
    @required TabController tabController,
    this.tabLength,
    this.tabNameList,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 20, top: 15),
        alignment: Alignment.centerLeft,
        child: TabBar(
          labelPadding: EdgeInsets.only(right: 15),
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          isScrollable: true,
          indicator: UnderlineTabIndicator(),
          labelColor: Colors.black,
          labelStyle: TextStyle(
              fontFamily: "Avenir", fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelColor: Colors.black38,
          unselectedLabelStyle: TextStyle(
              fontFamily: "Avenir",
              fontWeight: FontWeight.normal,
              fontSize: 15),
          tabs: tabNameList,
        ),
      ),
    );
  }
}
