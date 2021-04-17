import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;

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
                  Center(
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF79a396)),
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
                  )
                ],
              ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    this.setState(() {
      isLoading = true;
    });
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
