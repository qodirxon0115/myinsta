import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../pages/signIn_page.dart';

class AuthService {
  static final auth = FirebaseAuth.instance;

  static bool isLoggedIn() {
    final User? firebaseUser = auth.currentUser;
    return firebaseUser != null;
  }

  static String currentUserId() {
    final User? firebaseUser = auth.currentUser;
    return firebaseUser!.uid;
  }

  static Future<User?> signInUser(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    final User firebaseUser = auth.currentUser!;
    return firebaseUser;
  }

  static Future<User?> signUpUser(
      String fullName, String email, String password) async {
    var authResult = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = authResult.user;
    return user;
  }

  static void signOutUser(BuildContext context) {
    auth.signOut();
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }
}