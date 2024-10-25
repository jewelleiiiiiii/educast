import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot?> getUserData(String uid) async {
    try {
      var userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        return userSnapshot;
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }

  Future<String> loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return 'Google sign-in was canceled.';
      }

      // Check if the Google user's email belongs to the required domain
      if (!googleUser.email.endsWith('@g.batstate-u.edu.ph')) {
        return 'Please use your G-Suite account (@g.batstate-u.edu.ph).';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      return 'Success';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          return 'An account already exists with a different credential.';
        case 'invalid-credential':
          return 'The Google credential is invalid or has expired.';
        case 'operation-not-allowed':
          return 'Google sign-in is not enabled.';
        case 'user-disabled':
          return 'This user has been disabled.';
        case 'user-not-found':
          return 'No user found with this credential.';
        case 'wrong-password':
          return 'Wrong password provided for this user.';
        default:
          return 'An unknown error occurred.';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return 'Email and password must not be empty.';
      }

      // Validate the email format
      if (!email.contains('@g.batstate-u.edu.ph')) {
        return 'Please use your G-Suite account';
      }

      // Validate password
      String? passwordValidationResult = _validatePassword(password);
      if (passwordValidationResult != null) {
        return passwordValidationResult;
      }

      try {
        // Check if account already exists
        final signInMethods = await _auth.fetchSignInMethodsForEmail(email);
        if (signInMethods.isNotEmpty) {
          _showSnackbar(context, "Account already exists.");
          return 'Account already exists.';
        }
      } catch (e) {
        _showSnackbar(context, "An error occurred during email verification.");
        return 'An error occurred during email verification.';
      }

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("User created with UID: ${credential.user!.uid}");
      _showSnackbar(context, "Account created successfully.");
      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _showSnackbar(context, "Account already exists.");
        return 'The account already exists.';
      } else {
        _showSnackbar(
            context, "An error occurred during signup. Please try again.");
        return 'An error occurred during signup. Please try again.';
      }
    } on FirebaseException catch (e) {
      _showSnackbar(context, "FirebaseException: ${e.message}");
      return "FirebaseException: ${e.message}";
    } catch (e) {
      _showSnackbar(context, "Exception: $e");
      return "Exception: $e";
    }
  }

  String? _validatePassword(String password) {
    if (password.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[a-z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password) ||
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character.';
    }

    return null; // Password is valid
  }

  Future<void> storeAdditionalUserData({
    required String uid,
    required String email,
    required String fname,
    required String lname,
    required String campus,
    required String gradeLevel,
  }) async {
    try {
      await _fireStore.collection("users").doc(uid).set({
        "email": email,
        "firstName": fname,
        "lastName": lname,
        "campus": campus,
        "gradeLevel": gradeLevel,
      });
      print('User data stored successfully.');
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return 'Success';
      } else {
        return 'Please fill up all fields.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.message ==
          'The supplied auth credential is incorrect, malformed or has expired.') {
        return 'Email or Password is incorrect.';
      } else {
        return e.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> checkEmailExists(String email) async {
    print(email);
    print(" ");
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('Email is registered: ${querySnapshot.docs.first['email']}');
        return true;
      } else {
        print('Email is not registered.');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      return false;
    }
  }

  bool checkIfUserIsSignedIn() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print('User is already signed in: ${user.email}');
      return true;
      // Handle user already signed in
    } else {
      print('No user is signed in.');
      return false;
      // Handle no user signed in
    }
  }
}
