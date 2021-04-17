import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn().catchError((onError){print("google user error $onError");});

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken)).catchError((onError){print("credential error $onError");});
        return userCredential.user;
      }
      else
      {
        throw FirebaseAuthException(code: "ERROR_ABORDED_BY_USER",message: "Sign in aborded by user");
      }
    }
  }

  Future<void> signOut() async
  {
    final googleSignIn=GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

}
