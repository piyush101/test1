import 'package:FinXpress/components/drawer/follow_us_images.dart';
import 'package:FinXpress/screens/intro/intro_screen.dart';
import 'package:FinXpress/screens/login/login.dart';
import 'package:FinXpress/utils/authentication/authentication_sign_out.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/provider/dark_theme_provider.dart';
import '../../constants.dart';

class NewsDrawer extends StatefulWidget {
  @override
  _NewsDrawerState createState() => _NewsDrawerState();
}

class _NewsDrawerState extends State<NewsDrawer> {
  bool isSwitched = false;
  var _currentUser = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser.uid
      : null;

  @override
  void initState() {
    Constants.analytics.setCurrentScreen(screenName: "Drawer");
    super.initState();
  }

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
                accountName: user != null
                    ? Text(
                        user.displayName,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => Login(),
                              ),
                              (route) => false);
                        },
                        child: Text("Sign In",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700)),
                      ),
                accountEmail: null,
                decoration:
                    BoxDecoration(color: Color(0xFFc1c0e1).withOpacity(0.5)),
              ),
              // Center(
              //   child: _getDayNightSwitcherButton(darkThemeProvider, context),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListTile(
                  title: InkWell(
                    onTap: () {
                      Share.share(
                        "https://play.google.com/store/apps/details?id=com.finexpress",
                        subject:
                            'RealTime stock news in 60 words. Download FinXpress!!',
                      );
                    },
                    child: Text(
                      "Share us with Friends",
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  leading: Icon(
                    Icons.share_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListTile(
                    title: InkWell(
                      onTap: () {
                        launch(Uri.parse("market://details?id=com.finexpress")
                            .toString());
                      },
                      child: Text(
                        "Rate us on Play Store",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    leading: SvgPicture.asset("assets/icons/play_store.svg",
                        height: 23.0, width: 20.0)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListTile(
                  title: InkWell(
                    onTap: () {
                      launch(
                          Uri.parse("https://www.finxpress.co/Privacy-policy")
                              .toString());
                    },
                    child: Text(
                      "Privacy Policy",
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  leading: Icon(
                    Icons.topic,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListTile(
                    title: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _disclaimerBox();
                            });
                      },
                      child: Text(
                        "Disclaimer",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    leading: Icon(
                      Icons.announcement,
                      color: Colors.black,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Visibility(
                  visible: _getVisibilty(),
                  child: ListTile(
                    title: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _alertBoxOnLogout(context);
                            });
                        // _signOut();
                      },
                      child: Text(
                        "Log Out",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    leading: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Text(
                  "Follow us on",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3c4d47)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FollowUsImages(
                    onTap: () {
                      launch(Uri.parse(
                              "https://www.facebook.com/FinXpress-103030591964740")
                          .toString());
                    },
                    imagePath: 'assets/icons/facebook.svg',
                  ),
                  SizedBox(
                    width: 33,
                  ),
                  FollowUsImages(
                    onTap: () {
                      launch(Uri.parse(
                              "https://www.linkedin.com/company/fin-xpress")
                          .toString());
                    },
                    imagePath: "assets/icons/linkedin.svg",
                  ),
                  SizedBox(
                    width: 33,
                  ),
                  FollowUsImages(
                    onTap: () {
                      launch(Uri.parse("https://www.instagram.com/finxpress_")
                          .toString());
                    },
                    imagePath: "assets/icons/instagram.svg",
                  ),
                  SizedBox(
                    width: 33,
                  ),
                  // FollowUsImages(
                  //   onTap: () {
                  //     launch(Uri.parse(
                  //             "https://www.facebook.com/FinXpress-103030591964740")
                  //         .toString());
                  //   },
                  //   imagePath: "assets/icons/telegram.svg",
                  // ),
                  // SizedBox(
                  //   width: 33,
                  // ),
                  FollowUsImages(
                    onTap: () {
                      launch(Uri.parse("https://twitter.com/xpress_fin")
                          .toString());
                    },
                    imagePath: "assets/icons/twitter.svg",
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "FinXpress v1.0.3",
                style: TextStyle(fontFamily: "SourceSansPro"),
              )
            ],
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

  AlertDialog _disclaimerBox() {
    return AlertDialog(
      title: Center(
        child: Text(
          "Disclaimer",
          style: TextStyle(color: Color(0xFF4f5a6b), fontSize: 25),
        ),
      ),
      content: Text(
        "We are promoting financial literacy in India. The Content posted is purely for educational"
        " purpose.We are not SEBI registered financial advisor.\n\nHence, we are not providing fiancial and investment advisory service"
        " You are and will be solely responsible for your own money and decisions you take. Please consult for any kind of "
        "investment/financial advice.\n\n Happy Investing..!!!!",
        style: TextStyle(
            fontFamily: "SourceSansPro",
            fontSize: 18,
            color: Color(0xFF5f5463)),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF8787c4))),
            child: Text(
              "Okay",
              style: TextStyle(fontFamily: "SourceSansPro", fontSize: 18),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }

  _getVisibilty() {
    if (_currentUser != null) {
      return true;
    } else {
      return false;
    }
  }
}

Future<void> _signOut(context) async {
  await AuthenticationSignOut().signOut();
  Navigator.pushAndRemoveUntil<dynamic>(
    context,
    MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => IntroScreen(),
    ),
    (route) => false, //if you want to disable back feature set to false
  );
}

AlertDialog _alertBoxOnLogout(BuildContext context) {
  return AlertDialog(
    title: Text("FinXpress"),
    content: Text("Do you want to LogOut?"),
    actions: [_dialogYesButton(context), _dialogNoButton(context)],
  );
}

ElevatedButton _dialogNoButton(BuildContext context) {
  return ElevatedButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF8787c4))),
    child: Text("No"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}

ElevatedButton _dialogYesButton(BuildContext context) {
  return ElevatedButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF8787c4))),
    child: Text("Yes"),
    onPressed: () {
      Navigator.of(context).maybePop();
      _signOut(context);
    },
  );
}
