import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _resetPassword() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _errorMessage = "User is not logged in.";
      });
      return;
    }

    String email = user.email!;
    String currentPassword = _currentPasswordController.text.trim();

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      // Re-authenticate the user with the current password
      await user.reauthenticateWithCredential(credential);

      String newPassword = _newPasswordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (newPassword != confirmPassword) {
        setState(() {
          _errorMessage = "New password and confirm password do not match.";
        });
        return;
      }

      // Update password after re-authentication
      await user.updatePassword(newPassword);
      setState(() {
        _errorMessage = null;
      });

      // Display the SnackBar at the top using an overlay
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password reset successful."),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back after showing the SnackBar
      Navigator.of(context).pop();

    } on FirebaseAuthException catch (e) {
      setState(() {
        // Check if the error is due to an incorrect current password
        if (e.code == 'wrong-password') {
          _errorMessage = "The current password entered is incorrect.";
        } else {
          _errorMessage = e.message; // For other types of FirebaseAuth exceptions
        }
      });
    }
  }


  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password.';
    }

    // Check if password length is at least 8 characters.
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    // Check if password contains at least one uppercase letter.
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Check if password contains at least one number.
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number.';
    }

    // Check if password contains at least one special character.
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_]').hasMatch(value)) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 16),
              ],
              // Current Password Field
              TextFormField(
                controller: _currentPasswordController,
                obscureText: !_currentPasswordVisible,  // Toggle visibility
                decoration: InputDecoration(
                  labelText: "Current Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _currentPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentPasswordVisible = !_currentPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password.';
                  }
                  return null;
                },
              ),
              // New Password Field
              TextFormField(
                controller: _newPasswordController,
                obscureText: !_newPasswordVisible,  // Toggle visibility
                decoration: InputDecoration(
                  labelText: "New Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _newPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _newPasswordVisible = !_newPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: _validatePassword,
              ),
              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_confirmPasswordVisible,  // Toggle visibility
                decoration: InputDecoration(
                  labelText: "Confirm New Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password.';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _resetPassword();
                  }
                },
                child: Text("Reset Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
