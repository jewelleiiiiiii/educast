// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:myapp/services/authentication.dart';
import 'package:myapp/snackbar.dart';

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
  static const List<String> buttonTitles = [
    'Login',
    'Signup',
  ];

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        // Navigate to SignupPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      } else if (_selectedIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Stack(
        children: <Widget>[
          // Top Center: Logo Image
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Image.asset(
                '../lib/assets/logo.png', // Adjust path as per your project structure
                width: 150,
                height: 150,
              ),
            ),
          ),
          // Center: Text
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
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
            ),
          ),
          // Center Bottom: Toggle Buttons
          Padding(
            padding:
                const EdgeInsets.only(bottom: 50.0), // Adjust padding as needed
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ToggleButtons(
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: LoginSignupPage(),
  ));
}

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

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
            child: Image.asset('../lib/assets/back.png'),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginSignupPage()),
            );
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
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
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
                    _buildTextFieldWithShadow(
                      controller: _emailController,
                      labelText: 'Email',
                    ),
                    const SizedBox(height: 20.0),
                    PasswordField(
                      controller: _passwordController,
                      labelText: 'Password',
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
                      // Center the login button
                      child: ElevatedButton(
                        onPressed: () {
                          //   Navigator.pushReplacement(
                          //  context,
                          //   MaterialPageRoute(builder: (context) => homeg10()),
                          //  );
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
                      // Center the Google button
                      child: OutlinedButton(
                        onPressed: () {
                          // Implement Google login logic
                        },
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
                              '../lib/assets/google.png',
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

  Widget _buildTextFieldWithShadow({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
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
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16.0),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
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

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const PasswordField(
      {super.key, required this.controller, required this.labelText});

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

  // In your SignupPage
  void signUpUser() async {
    String res = await AuthServicews().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (res == "Success") {
      setState(() {
        isLoading = true;
      });
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 159, 41, 33),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: SizedBox(
            width: 20,
            height: 20,
            child: Image.asset('../lib/assets/back.png'),
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
                    _buildTextFieldWithShadow(
                      controller: _emailController,
                      labelText: 'Email',
                    ),
                    const SizedBox(height: 20.0),
                    PasswordField(
                      controller: _passwordController,
                      labelText: 'Password',
                    ),
                    const SizedBox(height: 20.0),
                    PasswordField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
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
                        onPressed: () {
                          // Implement Google login logic
                        },
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide.none),
                        ),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset('../lib/assets/google.png'),
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
          ),
        ),
      ),
    );
  }
}

class BlankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blank Page'),
      ),
      body: Center(
        child: Text('This is a blank page.'),
      ),
    );
  }
}

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountScreenState1 createState() => _CreateAccountScreenState1();
}

class _CreateAccountScreenState1 extends State<CreateAccountPage> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _campusController = TextEditingController();
  String _selectedGradeLevel = 'GRADE 10';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 39, 39),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            '../lib/assets/back.png',
            width: 24.0,
            height: 24.0,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignupPage()),
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
                  _buildTextFieldWithShadow(
                    controller: _campusController,
                    labelText: 'Campus',
                    height: 40.0,
                  ),
                  const SizedBox(height: 15.0),
                  DropdownButtonFormField<String>(
                    value: _selectedGradeLevel,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGradeLevel = newValue!;
                      });
                    },
                    items: <String>['GRADE 10', 'GRADE 12', '4th Year College']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Grade Level',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Center(
                    child: Image.asset(
                      '../lib/assets/logo2.png',
                      height: 70.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Handle Next button press
                          if (_selectedGradeLevel == 'GRADE 10') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateAccountScreen(),
                              ),
                            );
                          } else if (_selectedGradeLevel == 'GRADE 12') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateAccountScreen2(),
                              ),
                            );
                          } else if (_selectedGradeLevel ==
                              '4th Year College') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateAccountScreen3(),
                              ),
                            );
                          }
                        },
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
          ),
        ),
      ),
    );
  }
}

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _academicInterests = [
    'Writing',
    'Reading',
    'Research',
    'Poetry',
    'Socialization',
    'Problem-solving',
    'Public-speaking'
  ];
  final _sportsInterests = [
    'Competition',
    'Athletics',
    'Scouting',
    'Thrill',
    'Fitness',
    'Outdoor',
    'Physical challenges'
  ];
  final _artsInterests = ['Painting', 'Editing'];

  final List<String> _selectedAcademicInterests = [];
  final List<String> _selectedSportsInterests = [];
  final List<String> _selectedArtsInterests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 155, 15, 15),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            '../lib/assets/back.png',
            width: 24.0,
            height: 24.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: const BoxDecoration(
                color:
                    Color.fromARGB(255, 229, 228, 228), // Slightly transparent
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Interest',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 155, 15, 15),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: const Center(
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                  height: 110), // Space for the overlapping containers
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      _buildInterestSection('Academic', _academicInterests,
                          _selectedAcademicInterests),
                      const SizedBox(height: 16),
                      Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      _buildInterestSection(
                          'Sports', _sportsInterests, _selectedSportsInterests),
                      const SizedBox(height: 16),
                      Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      _buildInterestSection('Arts and Design', _artsInterests,
                          _selectedArtsInterests),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                  child: TextButton(
                    onPressed: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const ConfirmAccountScreen()),
                      //   );
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestSection(
      String title, List<String> interests, List<String> selectedInterests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          color: Colors.black,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: interests.map((interest) {
            final isSelected = selectedInterests.contains(interest);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedInterests.remove(interest);
                  } else {
                    selectedInterests.add(interest);
                  }
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromARGB(255, 155, 15, 15)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  interest,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CreateAccountScreen2 extends StatefulWidget {
  const CreateAccountScreen2({super.key});

  @override
  _CreateAccountScreenState2 createState() => _CreateAccountScreenState2();
}

class _CreateAccountScreenState2 extends State<CreateAccountScreen2> {
  final _academicInterests = ['STEM', 'ABM', 'HUMSS', 'GAS'];
  final _technicalInterests = ['ICT', 'Cookery', 'Tourism'];
  final _artsInterests = ['Media and Visual Arts', 'Performing Arts'];

  String? _selectedInterest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 155, 15, 15),
        centerTitle: true,
        leading: IconButton(
          icon: SizedBox(
            width: 20,
            height: 20,
            child: Image.asset('../lib/assets/back.png'),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 229, 228, 228),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Track',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 155, 15, 15),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: const Center(
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 110),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      _buildInterestSection('Academic', _academicInterests),
                      const SizedBox(height: 16),
                      Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      _buildInterestSection('Technical', _technicalInterests),
                      const SizedBox(height: 16),
                      Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      _buildInterestSection('Arts and Design', _artsInterests),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                  child: TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           const ConfirmAccountScreen2()),
                      // ); // Handle Ok button press
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestSection(String title, List<String> interests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          color: Colors.black,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: interests.map((interest) {
            final isSelected = _selectedInterest == interest;
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedInterest = null;
                  } else {
                    _selectedInterest = interest;
                  }
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromARGB(255, 155, 15, 15)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  interest,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CreateAccountScreen3(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CreateAccountScreen3 extends StatefulWidget {
  const CreateAccountScreen3({super.key});

  @override
  _CreateAccountScreenState3 createState() => _CreateAccountScreenState3();
}

class _CreateAccountScreenState3 extends State<CreateAccountScreen3> {
  final _coeInterests = [
    'BS Mechatronics Engineering',
    'BS Industrial Engineering'
  ];
  final _cicsInterests = [
    'BS Computer Science',
    'BS Information Technology major in BA',
    'BS Information Technology major in SM',
    'BS Information Technology major in NI'
  ];
  final _cetInterests = ['Bachelor of Computer Engineering...'];

  String? _selectedInterest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 155, 15, 15),
        centerTitle: true,
        leading: IconButton(
          icon: SizedBox(
            width: 24,
            height: 24,
            child: Image.asset('../lib/assets/back.png'),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 229, 228, 228),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'School Department',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 155, 15, 15),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: const Text(
                'Create Account', // Your desired text here
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 110),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      _buildInterestSection('CoE', _coeInterests),
                      const SizedBox(height: 16),
                      Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      _buildInterestSection('CICS', _cicsInterests),
                      const SizedBox(height: 16),
                      Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      _buildInterestSection('CET', _cetInterests),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                  child: TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           const ConfirmAccountScreen3()),
                      // );
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestSection(String title, List<String> interests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          color: Colors.black,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: interests.map((interest) {
            final isSelected = _selectedInterest == interest;
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedInterest = null;
                  } else {
                    _selectedInterest = interest;
                  }
                });
              },
              child: Container(
                width: double.infinity, // Occupy full width
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromARGB(255, 155, 15, 15)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    interest,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
