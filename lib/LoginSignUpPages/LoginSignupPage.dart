// ignore_for_file: deprecated_member_use, prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
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
  static const List<String> buttonTitles = [
    'Login',
    'Signup',
  ];

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        
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
      backgroundColor: Colors.white, 
      body: Stack(
        children: <Widget>[
          
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Image.asset(
                '../lib/assets/logo.png',  
                width: 150,
                height: 150,
              ),
            ),
          ),
         
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
         
          Padding(
            padding:
                const EdgeInsets.only(bottom: 50.0), 
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
                    Color.fromARGB(255, 229, 228, 228),
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
                  height: 110),
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
