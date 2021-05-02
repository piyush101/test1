import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationSignOut {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    final _googleSignIn = GoogleSignIn();
    final _faceBookSignIn = FacebookLogin();
    await _googleSignIn.signOut();
    await _faceBookSignIn.logOut();
  }
}
