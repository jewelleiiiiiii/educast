import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/LoginSignUpPages/Login.dart';
import 'package:myapp/LoginSignUpPages/LoginSignupPage.dart';
import 'package:myapp/services/snackbar.dart'; // Ensure this import is correct

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  bool _isPasswordValid(String password) {
    // Minimum 8 characters, at least 1 uppercase, 1 lowercase, 1 number, and 1 special character
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
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

    String email = _emailController.text.trim();

    // Ensure the email number is exactly 7 digits
    if (!_isEmailValid(email)) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "INVALID EMAIL");
      return;
    }

    // Ensure the passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Passwords do not match.");
      return;
    }

    // Check if the password meets the validation criteria
    if (!_isPasswordValid(_passwordController.text)) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context,
          "Password must be at least 8 characters long, and include 1 uppercase letter, 1 lowercase letter, 1 digit, and 1 special character.");
      return;
    }

    String fullEmail = '$email@g.batstate-u.edu.ph';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateAccountPage(
          email: fullEmail,
          password: _passwordController.text,
        ),
      ),
    );
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
                margin: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10,),
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
                              const Spacer(),
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
            horizontal: 16.0, vertical: 10.0,
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

  const CreateAccountPage({super.key, required this.email, required this.password});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountPage> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  String? _selectedCampus;
  String? _selectedGradeLevel;

  // Initial list of campuses
  final List<String> _allCampuses = [
    'Alangilan', 'Balayan', 'Lemery', 'Lipa', 'Lobo', 'Malvar',
    'Nasugbu', 'Pablo Borbon (Main)', 'Rosario', 'San Juan'
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
        // Create user in Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );

        // Store additional information in Firestore
        await FirebaseFirestore.instance.collection('users').doc(
            userCredential.user!.uid).set({
          'firstName': _firstnameController.text,
          'lastName': _lastnameController.text,
          'campus': _selectedCampus!,
          'gradeLevel': _selectedGradeLevel!,
          'email': widget.email,
        });

        // Navigate to different pages based on selected grade level
        if (_selectedGradeLevel == 'Grade 10') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const BlankPage(), // Replace with the actual target page for Grade 10
            ),
          );
        } else if (_selectedGradeLevel == 'Grade 12') {
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => Grade12Page(), // Replace with the actual target page for Grade 12
          //   ),
          // );
        } else if (_selectedGradeLevel == 'Fourth-year College') {
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => FourthYearCollegePage(), // Replace with the actual target page for Fourth-year College
          //   ),
          // );
        }

        showSnackBar(context, "Account Created Successfully");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          showSnackBar(context, "This email is already in use.");
        } else {
          showSnackBar(context, "An error occurred. Please try again.");
        }
      } catch (e) {
        // Handle other exceptions
        showSnackBar(context, "An unexpected error occurred. Please try again.");
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: SizedBox(
            width: 20,
            height: 20,
            child: Image.asset('assets/back.png'),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10,),
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
                      child: _selectedGradeLevel == 'Grade 12' || _selectedGradeLevel == 'Fourth-year College'
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


  Widget _buildNameTextField(TextEditingController controller, String labelText) {
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
            horizontal: 16.0, vertical: 10.0,
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
            horizontal: 16.0, vertical: 10.0,
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
