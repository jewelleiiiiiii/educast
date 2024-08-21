import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';
<<<<<<< HEAD
import 'LoginSignUpPages/LoginSignupPage.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() async {
  // Ensure that widget binding is initialized before calling Firebase.initializeApp
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the default options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set the status bar to transparent
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Run the application
  runApp(EduCAST());
}

class EduCAST extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduCAST',
      home: SplashScreen(),
=======
//import 'package:myapp/login_signup.dart';
import 'LoginSignUpPages/LoginSignupPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Container Application',
      home: HomeScreen(),
>>>>>>> 228c91baaff5cdfefcdb6719f26514113ee61cc2
    );
  }
}

<<<<<<< HEAD
class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginSignupPage()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,  // Set the background to white
        child: Center(       // Center the content
          child: Image.asset(
            "assets/logo.png",
            height: 300.0,
            width: 300.0,
          ),
=======
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginSignupPage()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: 120,
              width: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
          ],
>>>>>>> 228c91baaff5cdfefcdb6719f26514113ee61cc2
        ),
      ),
    );
  }
}
