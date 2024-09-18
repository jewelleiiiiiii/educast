import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/LoginSignUpPages/Login.dart';

class CourseSelection extends StatefulWidget {
  const CourseSelection({super.key});

  @override
  _CourseSelection createState() => _CourseSelection();
}

class _CourseSelection extends State<CourseSelection> {
  final _academicInterestsCAS = [
    'Bachelor of Science in Criminology',
    'Bachelor of Science in Psychology',
  ];
  final _academicInterestsCET = [
    'Bachelor of Automotive Engineering Technology',
    'Bachelor of Civil Engineering Technology',
    'Bachelor of Computer Engineering Technology',
    'Bachelor of Drafting Engineering Technology',
    'Bachelor of Electrical Engineering Technology',
    'Bachelor of Electronics Engineering Technology',
    'Bachelor of Food Engineering Technology',
    'Bachelor of Mechanical Engineering Technology',
    'Bachelor of Mechatronics Engineering Technology',
  ];
  final _academicInterestsCICS = [
    'Bachelor of Science in Information Technology',
  ];

  // Variable to hold the selected course (only one can be selected)
  String? _selectedCourse;

  final double _maxContainerWidth = _calculateTextWidth(
    'Science, Technology, Engineering, and Mathematics',
    const TextStyle(fontSize: 18),
  );

  static double _calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width + 40;
  }

  Future<void> _updateCourse() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedCourse != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'course': _selectedCourse,
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

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
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 229, 228, 228),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: const [
                  SizedBox(height: 30),
                  Text(
                    'College Programs',
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
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
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
              const SizedBox(height: 150),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      _buildInterestSection('College of Arts and Sciences', _academicInterestsCAS),
                      const SizedBox(height: 30),
                      _buildInterestSection('College of Engineering Technology', _academicInterestsCET),
                      const SizedBox(height: 30),
                      _buildInterestSection('College of Informatics and Computing Sciences', _academicInterestsCICS),

                      Container(
                        height: 2,
                        color: Colors.black,
                      ),
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
                    onPressed: () async {
                      await _updateCourse();
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
          alignment: WrapAlignment.center, // Center the containers
          spacing: 8,
          runSpacing: 8,
          children: interests.map((interest) {
            final isSelected = _selectedCourse == interest;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCourse = interest;  // Selecting only one course
                    });
                  },
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: _maxContainerWidth,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12), // Adjusted padding
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromARGB(255, 155, 15, 15)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center( // Center the text
                        child: Text(
                          interest,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16, // Increased font size
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Adjust the height for your desired spacing
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
