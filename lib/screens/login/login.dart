import 'package:FinXpress/constants.dart';
import 'package:FinXpress/screens/home/home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  static const String login = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(
                child: getWaitWidgetWhileLoading(),
              )
            : getLoginPageBody(size),
      ),
    );
  }

  Container getLoginPageBody(Size size) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: CachedNetworkImageProvider(
            "https://firebasestorage.googleapis.com/v0/b/finbox-55d7a.appspot.com/o/intro%2Fsign_in.png?alt=media&token=4799bd21-bfa1-473f-b04f-0b5182f31d74"),
        fit: BoxFit.cover,
      )),
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Sign in to",
                style: GoogleFonts.sourceSansPro(
                    color: Color(0xFF5f5463),
                    fontSize: 25,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 17),
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              "https://firebasestorage.googleapis.com/v0/b/finbox-55d7a.appspot.com/o/intro%2Ffinal_logo-removebg-preview.png?alt=media&token=d529b98f-e496-436d-8f45-f564aa9b5895"))),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "FinXpress",
                  style: GoogleFonts.sourceSansPro(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Color(0xFF5f5463)),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            googleElevatedButton(size),
            SizedBox(
              height: 15,
            ),
            facebookElevatedButton(size),
            SizedBox(
              height: 20,
            ),
            Row(children: <Widget>[
              Expanded(
                  child: Divider(
                thickness: 1.5,
              )),
              SizedBox(
                width: 2,
              ),
              Text(
                "OR",
                style: GoogleFonts.sourceSansPro(fontSize: 17),
              ),
              SizedBox(
                width: 2,
              ),
              Expanded(
                  child: Divider(
                thickness: 1.5,
              )),
            ]),
            SizedBox(height: 20),
            GestureDetector(
              child: Text(
                "Join us as Guest",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5f5463)),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => Home(),
                    ),
                    (route) => false);
              },
            )
          ],
        ),
      ),
    );
  }

  Align googleElevatedButton(Size size) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: size.width * .85,
        height: size.height * .05,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Color(0xFFb2bbf0)),
          onPressed: () {
            _signInWithGoogle(context).then((value) => this.setState(() {
                  isLoading = false;
                }));
          },
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/google.svg",
                color: Color(0xFF9e3333),
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                "Sign In with Google",
                style: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }

  Align facebookElevatedButton(Size size) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: size.width * .85,
        height: size.height * .05,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Color(0xFFb2bbf0)),
          onPressed: () {
            _handleFacebookLogin().then((value) => this.setState(() {
                  isLoading = false;
                }));
          },
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/facebook.svg",
                color: Color(0xFF286699),
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                "Sign In with Facebook",
                style: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column getWaitWidgetWhileLoading() {
    return Column(
      children: <Widget>[
        Constants.getCircularProgressBarIndicator(),
        Divider(
          height: 15,
          color: Colors.transparent,
        ),
        Text(
          "Please Wait...",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  Future _handleFacebookLogin() async {
    this.setState(() {
      isLoading = true;
    });
    FacebookLogin _facebookLogin = FacebookLogin();
    FacebookLoginResult _facebookLoginResult =
        await _facebookLogin.logIn(['email']);
    switch (_facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled by user");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        await _signInWithFacebook(_facebookLoginResult);
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => Home(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
        break;
    }
  }

  Future _signInWithFacebook(FacebookLoginResult _result) async {
    FacebookAccessToken _facebookAccessToken = _result.accessToken;
    AuthCredential _authCredential =
        FacebookAuthProvider.credential(_facebookAccessToken.token);
    var _facebookUser =
        await _firebaseAuth.signInWithCredential(_authCredential);
    createCurrentUserDocument();
    return _facebookUser.user;
  }

  Future<void> _signInWithGoogle(context) async {
    this.setState(() {
      isLoading = true;
    });

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn().catchError((onError) {
      print("google user error $onError");
    });

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken))
            .catchError((onError) {
          print("credential error $onError");
        });
        createCurrentUserDocument();
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => Home(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: "ERROR_ABORDED_BY_USER", message: "Sign in aborded by user");
      }
    }
  }

  void createCurrentUserDocument() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(_firebaseAuth.currentUser.uid)
        .set({
      "userID": _firebaseAuth.currentUser.uid,
      "subscribetopic": [],
      "bookmarks": []
    });
  }
}
