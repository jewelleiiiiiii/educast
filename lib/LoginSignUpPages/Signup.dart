import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/LoginSignUpPages/LoginSignupPage.dart';
import 'package:myapp/services/authentication.dart';
import 'package:myapp/services/snackbar.dart';

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

    String result = await AuthServices().signUpUser(
      email: email,
      password: _passwordController.text,
    );

    if (result == "Success") {
      // Store additional user data after successful signup
      await AuthServices().storeAdditionalUserData(
        uid: FirebaseAuth.instance.currentUser!.uid,
        email: email,
        fname: '', // Will be updated later in CreateAccountPage
        lname: '', // Will be updated later in CreateAccountPage
        campus: '', // Will be updated later in CreateAccountPage
        gradeLevel: '', // Will be updated later in CreateAccountPage
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CreateAccountPage(
            uid: FirebaseAuth.instance.currentUser!.uid,
            email: email, // Pass the email here
          ),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, result); // Use the dynamic error message here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 159, 41, 33),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: SizedBox(
            width: 20,
            height: 20,
            child: Image.asset('assets/back.png'),
          ),
          onPressed: () {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const LoginSignupPage()),
            // );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20.0, top: 0.0),
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
            Material(
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
                    const SizedBox(height: 10.0),
                    _buildEmailTextField(),
                    const SizedBox(height: 20.0),
                    PasswordField(
                      controller: _passwordController,
                      labelText: 'Password',
                      isPass: true,
                    ),
                    const SizedBox(height: 20.0),
                    PasswordField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      isPass: true,
                    ),
                    const SizedBox(height: 25.0),
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
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                              horizontal: 80.0,
                              vertical: 15.0,
                            ),
                          ),
                        ),
                        child: const Text('SIGN UP'),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                    const SizedBox(height: 5.0),
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
          ],
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Container(
      height: 40.0, // Match the height of the password field
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
            borderSide: BorderSide.none, // Remove border
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
      height: 40.0,
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

//--------------------- CREATE ACCOUNT PAGE ---------------------//

class CreateAccountPage extends StatefulWidget {
  final String uid;
  final String email;

  const CreateAccountPage({super.key, required this.uid, required this.email});

  @override
  _CreateAccountScreenState1 createState() => _CreateAccountScreenState1();
}

class _CreateAccountScreenState1 extends State<CreateAccountPage> {
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
      await AuthServices().storeAdditionalUserData(
        uid: widget.uid,
        fname: _firstnameController.text,
        lname: _lastnameController.text,
        campus: _selectedCampus!,
        gradeLevel: _selectedGradeLevel!,
        email: widget.email,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BlankPage(),
        ),
      );
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
            builder: (context) => const CreateAccountScreen2(),
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
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 45.0,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 158, 39, 39),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 5.0),
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        'Create account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 253, 248, 248),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 70.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFieldWithShadow(
                    controller: _firstnameController,
                    labelText: 'Firstname',
                    height: 40.0,
                  ),
                  const SizedBox(height: 15.0),
                  _buildTextFieldWithShadow(
                    controller: _lastnameController,
                    labelText: 'Lastname',
                    height: 40.0,
                  ),
                  const SizedBox(height: 15.0),
                  _buildDropdownButtonFormField(
                    value: _selectedCampus,
                    labelText: 'Campus',
                    items: [
                      'Alangilan',
                      'JPLPC-Malvar',
                      'Lemery',
                      'Lipa',
                      'Pablo Borbon'
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCampus = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 15.0),
                  _buildDropdownButtonFormField(
                    value: _selectedGradeLevel,
                    labelText: 'Grade Level',
                    items: ['Grade 10', 'Grade 12', 'Fourth-year College'],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGradeLevel = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 5.0),
                  Center(
                    child: Image.asset(
                      'assets/logo2.png',
                      height: 70.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
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
    double height = 40.0,
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
      height: 40.0,
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
