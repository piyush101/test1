import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/components/drawer/follow_us_images.dart';
import 'package:flutter_app_news/constants.dart';
import 'package:flutter_app_news/service/authentication/authentication_sign_out.dart';
import 'package:provider/provider.dart';

import '../../components/provider/dark_theme_provider.dart';
import '../../constants.dart';

class NewsDrawer extends StatelessWidget {
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
                accountName: Text(user.displayName),
                accountEmail: null,
                decoration: BoxDecoration(color: Constants.primaryLightColor),
              ),
              ListTile(
                title: Text(
                  "Dark Theme",
                  style: TextStyle(fontSize: 17),
                ),
                leading: Icon(Icons.brightness_6_rounded, color: Colors.black),
                onTap: () {
                  darkThemeProvider.swapTheme();
                  Navigator.of(context).pop();
                },
                onLongPress: () {
                  darkThemeProvider.swapTheme();
                },
              ),
              ListTile(
                title: Text(
                  "Share us with Friends",
                  style: TextStyle(fontSize: 17),
                ),
                leading: Icon(
                  Icons.share,
                  color: Colors.black,
                ),
              ),
              ListTile(
                title: Text(
                  "Any Feedback?",
                  style: TextStyle(fontSize: 17),
                ),
                leading: Icon(
                  Icons.mail,
                  color: Colors.black,
                ),
              ),
              ListTile(
                title: Text(
                  "Rate us on play store",
                  style: TextStyle(fontSize: 17),
                ),
                leading: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.black,
                ),
              ),
              ListTile(
                title: InkWell(
                  onTap: () {
                    signOut();
                  },
                  child: Text(
                    "LogOut",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                leading: Icon(
                  Icons.logout,
                  color: Colors.black,
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
                  style: TextStyle(fontSize: 18),
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

  Future<void> signOut() async {
    await AuthenticationSignOut().signOut();
  }
}
