import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/LoginSignUpPages/LoginSignupPage.dart';
import 'package:myapp/services/authentication.dart';
import 'package:myapp/services/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  void loginUsers() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthServices().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == "Success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BlankPage()),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res); // Display the error message
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            // Implement back navigation
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20.0, top: 5.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WELCOME',
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                  Text(
                    'BACK!',
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
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            // Implement forgot password logic
                          },
                          child: const MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color.fromARGB(255, 3, 3, 3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: loginUsers,
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
                        child: const Text('LOGIN'),
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
                          side: MaterialStateProperty.all(
                            BorderSide.none,
                          ),
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
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Colors.black),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
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
