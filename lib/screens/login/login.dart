import 'package:FinXpress/constants.dart';
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

  Center getLoginPageBody(Size size) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * .1,
            ),
            Image.asset(
              "assets/images/logo_transparent.png",
              width: double.infinity,
              height: 300,
            ),
            SizedBox(height: size.height * .1),
            googleElevatedButton(size),
            SizedBox(
              height: 15,
            ),
            facebookElevatedButton(size)
          ],
        ),
      ),
    );
  }

  Container googleElevatedButton(Size size) {
    return Container(
      width: size.width * .9,
      height: size.height * .05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Color(0xFFEBD1D1)),
        onPressed: () {
          _signInWithGoogle().then((value) => this.setState(() {
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
                  color: Color(0xFF4D5054),
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  Container facebookElevatedButton(Size size) {
    return Container(
      width: size.width * .9,
      height: size.height * .05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Color(0xFFD1E2EB)),
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
                  color: Color(0xFF4D5054),
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            )
          ],
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
        break;
    }
  }

  Future _signInWithFacebook(FacebookLoginResult _result) async {
    FacebookAccessToken _facebookAccessToken = _result.accessToken;
    AuthCredential _authCredential =
        FacebookAuthProvider.credential(_facebookAccessToken.token);
    var _facebookUser =
        await _firebaseAuth.signInWithCredential(_authCredential);
    // setState(() {
    //   isLoading = true;
    // });
    createCurrentUserDocument();
    return _facebookUser.user;
  }

  Future<void> _signInWithGoogle() async {
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
