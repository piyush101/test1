import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/components/drawer/follow_us_images.dart';
import 'package:flutter_app_news/constants.dart';
import 'package:flutter_app_news/service/authentication/authentication_sign_out.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../components/provider/dark_theme_provider.dart';
import '../../constants.dart';

class NewsDrawer extends StatefulWidget {
  @override
  _NewsDrawerState createState() => _NewsDrawerState();
}

class _NewsDrawerState extends State<NewsDrawer> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    DarkThemeProvider darkThemeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);

    return Column(
      children: [
        Container(
          width: double.infinity,
          child: ListView(
            shrinkWrap: true,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  user.displayName,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                accountEmail: null,
                decoration: BoxDecoration(color: Color(0xFFccced2)),
              ),
              Center(
                child: _getDayNightSwitcherButton(darkThemeProvider, context),
              ),
              // _getListTileObject(
              //     "Share us with Friends", Icons.share, _signOut()),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListTile(
                  title: Text("Share us with Friends",
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                  leading: Icon(
                    Icons.share_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListTile(
                    title: Text(
                      "Rate us on Play Store",
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                    leading: SvgPicture.asset("assets/icons/play_store.svg",
                        height: 23, width: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListTile(
                  title: InkWell(
                    onTap: () {
                      _signOut();
                      // Navigator.of(context).popAndPushNamed(Login.login);
                    },
                    child: Text("Log Out",
                        style: TextStyle(
                            fontFamily: 'SourceSansPro',
                            fontSize: 17,
                            fontWeight: FontWeight.w600)),
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Follow us on",
                  style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3c4d47)),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    FollowUsImages(
                      Image_Path: 'assets/icons/facebook.svg',
                    ),
                    SizedBox(
                      width: 33,
                    ),
                    FollowUsImages(
                      Image_Path: "assets/icons/linkedin.svg",
                    ),
                    SizedBox(
                      width: 33,
                    ),
                    FollowUsImages(
                      Image_Path: "assets/icons/instagram.svg",
                    ),
                    SizedBox(
                      width: 33,
                    ),
                    FollowUsImages(
                      Image_Path: "assets/icons/telegram.svg",
                    ),
                    SizedBox(
                      width: 33,
                    ),
                    FollowUsImages(
                      Image_Path: "assets/icons/twitter.svg",
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Finbox v1.0.1")
              ],
            ),
          ),
        ))
      ],
    );
  }

  DayNightSwitcher _getDayNightSwitcherButton(
      DarkThemeProvider darkThemeProvider, BuildContext context) {
    return DayNightSwitcher(
      dayBackgroundColor: Constants.primaryLightColor,
      isDarkModeEnabled: isSwitched,
      onStateChanged: (value) {
        setState(() {
          isSwitched = value;
          print(isSwitched);
        });
        darkThemeProvider.swapTheme();
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _signOut() async {
    await AuthenticationSignOut().signOut();
  }
}
