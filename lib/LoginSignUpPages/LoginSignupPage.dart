// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educast/LoginSignUpPages/Login.dart';
import 'package:educast/LoginSignUpPages/Signup.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  _LoginSignupTogglePageState createState() => _LoginSignupTogglePageState();
}

class _LoginSignupTogglePageState extends State<LoginSignupPage> {
  int _selectedIndex = 0;
  static const List<Color> buttonColors = [
    Color.fromARGB(255, 159, 41, 33),
    Color.fromARGB(255, 159, 41, 33),
  ];
  static const List<String> buttonTitles = ['Login', 'Signup'];

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignupPage()),
        );
      } else if (_selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Set the status bar text color to black
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Colors.transparent, // Optional: to make the status bar transparent
      statusBarIconBrightness:
          Brightness.dark, // Set the status bar icons to black
      statusBarBrightness:
          Brightness.light, // For iOS: Sets status bar text to black
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, // Disable back button
    child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Welcome to EduCAST!\n'
                    'Your mapping pathways\n'
                    'to unlock your potential\n'
                    'and navigate your future.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 130),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ToggleButtons(
                      isSelected: [_selectedIndex == 0, _selectedIndex == 1],
                      selectedColor: Colors.white,
                      fillColor: buttonColors[_selectedIndex],
                      borderRadius: BorderRadius.circular(10),
                      onPressed: (index) => _navigateToPage(index),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            buttonTitles[0],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            buttonTitles[1],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}