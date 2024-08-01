// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    // required String fname,
    // required String lname,
    // required String campus,
    /* required String glevel*/
  }) async {
    String res = "Some Error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        print("User created with UID: ${credential.user!.uid}");

        // Store user data in Firestore
        await _fireStore.collection("users").doc(credential.user!.uid).set({
          // "firstName": fname,
          // "lastName": lname,
          // "campus": campus,
          // "gradeLevel": glevel,
          "email": email,
          "uid": credential.user!.uid,
        });

        res = "Success";

        print("User data added to Firestore");
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Authentication errors
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      } else {
        res = 'An error occurred during signup. Please try again.';
      }
      print("FirebaseAuthException: ${e.message}");
    } on FirebaseException catch (e) {
      // Handle general Firebase errors
      res = 'An error occurred during signup. Please try again.';
      print("FirebaseException: ${e.message}");
    } catch (e) {
      // Handle other potential errors
      res = 'An error occurred during signup. Please try again.';
      print("Exception: $e");
    }
    return res;
  }

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3836826425.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3503184812.
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some Error Occured";
    try {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2901174477.
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Please fill out all fields!";
      }
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2160383381.
    } catch (e) {
      return e.toString();
    }
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2875102889.
    return res;
  }
}
