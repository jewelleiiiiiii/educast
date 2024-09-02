// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/LoginSignUpPages/Login.dart';
import 'package:myapp/LoginSignUpPages/Signup.dart';

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
      statusBarColor: Colors.transparent, // Optional: to make the status bar transparent
      statusBarIconBrightness: Brightness.dark, // Set the status bar icons to black
      statusBarBrightness: Brightness.light, // For iOS: Sets status bar text to black
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}


class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blank Page'),
      ),
      body: const Center(
        child: Text('This is a blank page.'),
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
            'assets/back.png',
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
              const SizedBox(height: 110),
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
            child: Image.asset('assets/back.png'),
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
            child: Image.asset('assets/back.png'),
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
                'Create Account',
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
                width: double.infinity,
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
