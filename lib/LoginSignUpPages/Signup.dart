import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:educast/Home/homeg10.dart';
import 'package:educast/LoginSignUpPages/CourseSelection.dart';
import 'package:educast/LoginSignUpPages/Login.dart';
import 'package:educast/LoginSignUpPages/LoginSignupPage.dart';
import 'package:educast/LoginSignUpPages/StrandSelection.dart';
import 'package:educast/services/snackbar.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Ensure this import is correct\
// import 'package:logger/logger.dart';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthServices _auth = AuthServices();
  bool isLoading = false;
  String _verificationCode = '';

  String generateCode() {
    var rng = Random();
    String code = (100000 + rng.nextInt(900000)).toString(); // Generates a 6-digit code
    return code;
  }

  Future<void> sendVerificationEmail(String email, String code) async {
    final smtpServer = gmail('batstateu.tneu.educast@gmail.com', 'cfop qmzk ckxu ngln');

    final message = Message()
      ..from = Address('batstateu.tneu.educast@gmail.com', 'EduCAST')
      ..recipients.add(email)
      ..subject = 'Email Verification Code'
      ..text = 'Your verification code is: $code';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. ${e.toString()}');
    }
  }

  bool _isPasswordValid(String password) {
    // Minimum 8 characters, at least 1 uppercase, 1 lowercase, 1 number, and 1 special character
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_]'));
  }

  bool _isEmailValid(String email) {
    // Extract the number part of the email
    String numericPart = email.split('-').join();
    return numericPart.length == 7 && RegExp(r'^\d{2}-\d{5}$').hasMatch(email);
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });

    String email = _emailController.text.trim().toLowerCase();
    String fullemail = '$email@g.batstate-u.edu.ph';

    if (!_isEmailValid(email)) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "INVALID EMAIL");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Passwords do not match.");
      return;
    }

    if (!_isPasswordValid(_passwordController.text)) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Password must be valid.");
      return;
    }

    try {
      // Query Firestore to check if email already exists
      var existingUser = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: fullemail)
          .get();

      if (existingUser.docs.isNotEmpty) {
        // Email already exists
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, "This email is already in use.");
        return;
      }

      // Proceed with verification and signup if the email is not registered
      _verificationCode = generateCode();
      await sendVerificationEmail(fullemail, _verificationCode);
      print('Verification email sent to: $fullemail');

      // Navigate to the verification page after sending the code
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CodeVerificationPage(
            email: fullemail,
            verificationCode: _verificationCode,
            password: _passwordController.text,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Error: ${e}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }




  Future<void> _handledGoogleSignIn() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      var googleData = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleSignInAuthentication =
          await googleData?.authentication;

      if (googleData != null) {
        AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication?.accessToken,
          idToken: googleSignInAuthentication?.idToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(authCredential);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreateAccountPage(
              email: googleData.email,
              password: "",
              userCredential: userCredential,
            ),
          ),
        );
      }
    } on Exception catch (e) {
      print(e);
      // throw Exception("Failed to sign in google account");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 159, 41, 33),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: SizedBox(
            width: 20,
            height: 20,
            child: Image.asset('assets/back.png'),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginSignupPage()),
            );
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 20.0,
                  top: 10.0,
                  bottom: 10,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LET\'S GET',
                      style: TextStyle(fontSize: 24.0, color: Colors.white),
                    ),
                    Text(
                      'STARTED!',
                      style: TextStyle(fontSize: 24.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: Material(
                  elevation: 5.0,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              _buildEmailTextField(),
                              const Spacer(),
                              PasswordField(
                                controller: _passwordController,
                                labelText: 'Password',
                                isPass: true,
                              ),
                              const Spacer(),
                              PasswordField(
                                controller: _confirmPasswordController,
                                labelText: 'Confirm Password',
                                isPass: true,
                              ),
                              const SizedBox(height: 20.0),
                              const Spacer(),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    signUpUser();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color.fromARGB(255, 159, 41, 33),
                                    ),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      const EdgeInsets.symmetric(
                                        horizontal: 80.0,
                                        vertical: 15.0,
                                      ),
                                    ),
                                  ),
                                  child: const Text('SIGN UP'),
                                ),
                              ),
                              const Spacer(),
                              const Row(
                                children: [
                                  Expanded(child: Divider()),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text('OR CONTINUE WITH'),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                              const Spacer(),
                              Center(
                                child: OutlinedButton(
                                  onPressed: _handledGoogleSignIn,
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                        BorderSide.none),
                                  ),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Image.asset(
                                        'assets/google.png',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextFormField(
        controller: _emailController,
        style: const TextStyle(
          fontSize: 15.0,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          labelText: 'Email',
          labelStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontSize: 15.0,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          hintText: 'XX-XXXXX',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Inter',
            fontSize: 15.0,
          ),
          suffixText: '@g.batstate-u.edu.ph',
          suffixStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Inter',
            fontSize: 15.0,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [EmailInputFormatter()],
      ),
    );
  }
}

//--------------------- CREATE ACCOUNT PAGE ---------------------//

class CreateAccountPage extends StatefulWidget {
  final String email;
  final String password;
  final UserCredential? userCredential;

  const CreateAccountPage(
      {super.key,
      required this.email,
      required this.password,
      this.userCredential});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountPage> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  String? _selectedCampus;
  String? _selectedGradeLevel;
  late UserCredential userCredential;

  // Initial list of campuses
  final List<String> _allCampuses = [
    'Alangilan',
    'Balayan',
    'Lemery',
    'Lipa',
    'Lobo',
    'Malvar',
    'Nasugbu',
    'Pablo Borbon (Main)',
    'Rosario',
    'San Juan'
  ];
  List<String> _filteredCampuses = []; // Filtered campuses based on grade level

  @override
  void initState() {
    super.initState();
    // Initially, display all campuses
    _filteredCampuses = List.from(_allCampuses);
  }

  @override
  void dispose() {
    super.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
  }

  void storeUserData() async {
    if (_validateInput()) {
      try {
        // Get the current user's UID
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Update additional information in Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'firstName': _firstnameController.text,
            'lastName': _lastnameController.text,
            'campus': _selectedCampus!,
            'gradeLevel': _selectedGradeLevel!,
            'email': widget.email,
          });

          // Navigate based on selected grade level
          if (_selectedGradeLevel == 'Grade 10') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeG10(),
              ),
            );
          } else if (_selectedGradeLevel == 'Grade 12') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const StrandSelection(),
              ),
            );
          } else if (_selectedGradeLevel == 'Fourth-year College') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CourseSelection(),
              ),
            );
          }
        }
      } catch (e) {
        showSnackBar(context, "An error occurred. Please try again.");
      }
    }
  }

  bool _validateInput() {
    if (_firstnameController.text.isEmpty) {
      showSnackBar(context, "First Name is required.");
      return false;
    }
    if (_lastnameController.text.isEmpty) {
      showSnackBar(context, "Last Name is required.");
      return false;
    }
    if (_selectedGradeLevel == null) {
      showSnackBar(context, "Grade Level is required.");
      return false;
    }
    if (_selectedCampus == null) {
      showSnackBar(context, "Campus is required.");
      return false;
    }

    return true;
  }

  void _onGradeLevelChanged(String? newValue) {
    setState(() {
      _selectedGradeLevel = newValue;
      _selectedCampus = null; // Reset campus selection

      if (newValue == 'Grade 10' || newValue == 'Grade 12') {
        _filteredCampuses = ['Pablo Borbon (Main)'];
      } else if (newValue == 'Fourth-year College') {
        _filteredCampuses = List.from(_allCampuses); // Show all campuses
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 159, 41, 33),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20.0,
              top: 10.0,
              bottom: 10,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TELL US MORE',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
                Text(
                  'ABOUT YOURSELF',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: Material(
              elevation: 5.0,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    _buildNameTextField(_firstnameController, 'First Name'),
                    const Spacer(),
                    _buildNameTextField(_lastnameController, 'Last Name'),
                    const Spacer(),
                    _buildDropdownField(
                      label: 'Grade Level',
                      value: _selectedGradeLevel,
                      items: ['Grade 10', 'Grade 12', 'Fourth-year College'],
                      onChanged: _onGradeLevelChanged,
                    ),
                    const Spacer(),
                    _buildDropdownField(
                      label: 'Campus',
                      value: _selectedCampus,
                      items: _filteredCampuses,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCampus = newValue;
                        });
                      },
                    ),
                    const Spacer(),
                    Center(
                      child: _selectedGradeLevel == 'Grade 12' ||
                              _selectedGradeLevel == 'Fourth-year College'
                          ? _buildNextButton()
                          : _buildCreateAccountButton(),
                    ),
                    const Spacer(),
                    Center(
                      child: Image.asset(
                        'assets/logo2.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return ElevatedButton(
      onPressed: () {
        storeUserData();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 159, 41, 33),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          Colors.white,
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: 80.0,
            vertical: 15.0,
          ),
        ),
      ),
      child: const Text('CREATE ACCOUNT'),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        storeUserData();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 159, 41, 33),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          Colors.white,
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: 80.0,
            vertical: 15.0,
          ),
        ),
      ),
      child: const Text('NEXT'),
    );
  }

  Widget _buildNameTextField(
      TextEditingController controller, String labelText) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          fontSize: 15.0,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontSize: 15.0,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (value == null)
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Inter',
                fontSize: 15.0,
              ),
            ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: onChanged,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.0,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPass;

  const PasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.isPass,
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        style: const TextStyle(
          fontSize: 15.0,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontSize: 15.0,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: const Color.fromARGB(255, 3, 3, 3),
            ),
          ),
        ),
      ),
    );
  }
}

class CodeVerificationPage extends StatefulWidget {
  final String email;
  final String verificationCode;
  final String password;

  CodeVerificationPage({required this.email, required this.verificationCode, required this.password});

  @override
  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  bool isLoading = false;

  // Create Firestore entry after verification
  Future<void> createFirestoreUser(String uid) async {
    try {
      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': widget.email,
        // Add other necessary user data here
      });

      // Navigate to the CreateAccountPage to update user info
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccountPage(email: widget.email, password: widget.password),
        ),
      );
    } catch (e) {
      showSnackBar(context, "Failed to create Firestore document.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void verifyCode() {
    if (_codeController.text == widget.verificationCode) {
      setState(() {
        isLoading = true;
      });
      // Use an empty call to create a user in Firebase Auth without password
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      ).then((userCredential) {
        createFirestoreUser(userCredential.user!.uid);
      }).catchError((e) {
        showSnackBar(context, e.message ?? "Failed to create user.");
        setState(() {
          isLoading = false;
        });
      });
    } else {
      // Code is incorrect, show an error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect verification code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Verification Code')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A verification code has been sent to your email.'),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Enter Code',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : verifyCode,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Verify Code'),
            ),
          ],
        ),
      ),
    );
  }
}
