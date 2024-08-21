import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/LoginSignUpPages/LoginSignupPage.dart';
import 'package:myapp/services/snackbar.dart';
import 'package:myapp/Home/homeg10.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });

    // Ensure the passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Passwords do not match.");
      return;
    }

    // Append the domain to the email
    String email = '${_emailController.text.trim()}@g.batstate-u.edu.ph';

    // Navigate to the create account page with the captured data
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateAccountPage(
          email: email,
          password: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 159, 41, 33),
      resizeToAvoidBottomInset: false, // Prevents content from moving when the keyboard appears
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20.0, top: 20.0),
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
          const SizedBox(height: 20.0),
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
                    const Spacer(),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          signUpUser();
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
                        child: const Text('SIGN UP'),
                      ),
                    ),
                    const Spacer(),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('OR CONTINUE WITH'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const Spacer(flex: 1),
                    Center(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide.none),
                        ),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/google.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
        style: const TextStyle(fontSize: 15.0),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          labelText: 'Email',
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          hintText: 'XX-XXXXX', // Main part of the hint text
          hintStyle:
              const TextStyle(color: Colors.grey), // Style for the main part
          suffixText: '@g.batstate-u.edu.ph', // Domain part
          suffixStyle:
              const TextStyle(color: Colors.grey), // Style for the domain part
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

  const CreateAccountPage(
      {super.key, required this.email, required this.password});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountPage> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  String? _selectedCampus;
  String? _selectedGradeLevel;

  @override
  void dispose() {
    super.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
  }

  void storeUserData() async {
    if (_validateInput()) {
      try {
        // Create user in Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: widget.email, password: widget.password);

        // Store additional information in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'firstName': _firstnameController.text,
          'lastName': _lastnameController.text,
          'campus': _selectedCampus!,
          'gradeLevel': _selectedGradeLevel!,
          'email': widget.email,
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BlankPage(),
          ),
        );
        showSnackBar(context, "Account Created Successfully");
      } catch (e) {
        // Handle errors (e.g., email already in use)
        showSnackBar(context, e.toString());
      }
    }
  }

  bool _validateInput() {
    if (_firstnameController.text.isEmpty ||
        _lastnameController.text.isEmpty ||
        _selectedCampus == null ||
        _selectedGradeLevel == null) {
      showSnackBar(context, "Please fill out all fields.");
      return false;
    }
    return true;
  }

  void _proceedToNextPage() {
    if (_validateInput()) {
      storeUserData();
      if (_selectedGradeLevel == 'Grade 10') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const homeg10(),
          ),
        );
      } else if (_selectedGradeLevel == 'Grade 12') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateAccountScreen2(),
          ),
        );
      } else if (_selectedGradeLevel == 'Fourth-year College') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateAccountScreen3(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> campusOptions = _selectedGradeLevel == 'Fourth-year College'
        ? [
      'Alangilan',
      'JPLPC-Malvar',
      'Lemery',
      'Lipa',
      'Pablo Borbon'
    ]
        : ['Pablo Borbon'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 39, 39),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/back.png',
            width: 24.0,
            height: 24.0,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: false, // Prevents content from moving when the keyboard appears
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 60.0,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 158, 39, 39),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: const Center(
                child: Text(
                  'CREATE ACCOUNT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 253, 248, 248),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: _buildTextFieldWithShadow(
                      controller: _firstnameController,
                      labelText: 'Firstname',
                      height: 50.0,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: _buildTextFieldWithShadow(
                      controller: _lastnameController,
                      labelText: 'Lastname',
                      height: 50.0,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: _buildDropdownButtonFormField(
                      value: _selectedGradeLevel,
                      labelText: 'Grade Level',
                      items: ['Grade 10', 'Grade 12', 'Fourth-year College'],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGradeLevel = newValue;
                          // Update campus based on grade level
                          if (_selectedGradeLevel == 'Grade 10' ||
                              _selectedGradeLevel == 'Grade 12') {
                            _selectedCampus = 'Pablo Borbon';
                          } else {
                            _selectedCampus = null;
                          }
                        });
                      },
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: _buildDropdownButtonFormField(
                      value: _selectedCampus,
                      labelText: 'Campus',
                      items: campusOptions,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCampus = newValue;
                        });
                      },
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Image.asset(
                      'assets/logo2.png',
                      height: 70.0,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _proceedToNextPage,
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5.0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithShadow({
    required TextEditingController controller,
    required String labelText,
    double height = 50.0,
  }) {
    return Container(
      height: height,
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
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 15.0),
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          labelText: labelText,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButtonFormField({
    required String? value,
    required String labelText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
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
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        hint: Text(labelText), // Show the label inside the input box
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

//---------------------------------------------------------------------
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const PasswordField(
      {super.key,
      required this.controller,
      required this.labelText,
      required bool isPass});

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
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        style: const TextStyle(fontSize: 16.0),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only numbers
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Ensure the length of the text matches the pattern
    if (newText.length > 8) {
      newText = newText.substring(0, 8);
    }

    // Insert hyphen at the right place
    if (newText.length > 2) {
      newText = '${newText.substring(0, 2)}-${newText.substring(2)}';
    }

    // Maintain the format before @ symbol
    String formattedText;
    if (newText.length > 8) {
      formattedText = '${newText.substring(0, 8)}';
    } else {
      formattedText =
          '$newText'; // Do not add the suffix if the length is less than 8
    }

    // Calculate cursor position
    int cursorPosition = newText.length;
    if (cursorPosition > 8) {
      cursorPosition = 8;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
