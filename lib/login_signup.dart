
import 'package:flutter/material.dart';

class LoginSignupPage extends StatelessWidget {
  const LoginSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login/Signup'),
      ),
      body: const Center(
        child: Text('This is the Login/Signup page'),
      ),
    );
  }
}
