import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
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

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("User created with UID: ${credential.user!.uid}");

      // Store additional user data
      await storeAdditionalUserData(
        uid: credential.user!.uid,
        email: email,
        fname: '', // Placeholder, will be updated later
        lname: '', // Placeholder, will be updated later
        campus: '', // Placeholder, will be updated later
        gradeLevel: '', // Placeholder, will be updated later
      );

      return "Success"; // Return success message
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists.';
      } else {
        return 'An error occurred during signup. Please try again.';
      }
    } on FirebaseException catch (e) {
      return "FirebaseException: ${e.message}";
    } catch (e) {
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
    if (fname.isNotEmpty &&
        lname.isNotEmpty &&
        campus.isNotEmpty &&
        gradeLevel.isNotEmpty) {
      await _fireStore.collection("users").doc(uid).set({
        "email": email,
        "firstName": fname,
        "lastName": lname,
        "campus": campus,
        "gradeLevel": gradeLevel,
      });
      print('User data stored successfully.');
    } else {
      print('All fields must be filled out.');
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return "Please fill out all fields!";
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }
}
