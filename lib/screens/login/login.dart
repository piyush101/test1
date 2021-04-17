import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFc5ede1),
      body: Container(
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Text("Please wait..."),
                ],
                mainAxisSize: MainAxisSize.min,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xFF79a396)),
                    onPressed: () {
                      signInWithGoogle().then((value) => this.setState(() {
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
                          width: 5,
                        ),
                        Text("Sign In with Google")
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xFF79a396)),
                    onPressed: () {
                      _handleFacebookLogin().then((value) => this.setState(() {
                            isLoading = false;
                          }));
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/facebook.svg",
                          color: Color(0xFF34a8eb),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Sign In with Facebook")
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Future _handleFacebookLogin() async {
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
    setState(() {
      isLoading = true;
    });
    return _facebookUser.user;
  }

  Future<void> signInWithGoogle() async {
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
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: "ERROR_ABORDED_BY_USER", message: "Sign in aborded by user");
      }
    }
  }
}
