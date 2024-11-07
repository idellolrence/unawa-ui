import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // Sign out if previously signed in
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      if (gUser == null) return; // If user cancels

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-in Error: $e");
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }
}

/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  // Google Sign In
  Future<void> signInWithGoogle() async {
    try {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      // the user cancelled the sign-in
      return;
    }

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // sign in
    await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-in Error: $e");
    }
  }
}
*/