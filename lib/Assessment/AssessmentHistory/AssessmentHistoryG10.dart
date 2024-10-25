import 'package:educast/Assessment/Rules/G10Intro.dart';
import 'package:educast/Assessment/assess4g10.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:educast/Home/homeg10.dart';
import 'package:educast/Result/resultg10.dart';
import 'package:educast/Search/searchg10.dart';

class AssessmentHistoryG10 extends StatefulWidget {
  const AssessmentHistoryG10({super.key});

  @override
  _AssessmentHistoryG10 createState() => _AssessmentHistoryG10();
}

class _AssessmentHistoryG10 extends State<AssessmentHistoryG10> {
  List<String> _questions = List.generate(42, (index) => '');
  List<int?> _selectedOptions = List.generate(42, (index) => null);

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        // Fetch questions
        final questionDocument = await FirebaseFirestore.instance
            .collection('questions')
            .doc('grade10')
            .get();
        if (questionDocument.exists) {
          final questionData = questionDocument.data();
          if (questionData != null) {
            setState(() {
              _questions = List.generate(
                42,
                (index) =>
                    questionData[(index + 1).toString()] ?? 'No Question',
              );
            });
          }
        } else {
          print('Questions document does not exist');
        }

        // Fetch user answers
        final answerDocument = await FirebaseFirestore.instance
            .collection('userAnswerG10')
            .doc(uid)
            .get();
        if (answerDocument.exists) {
          final answerData = answerDocument.data();
          if (answerData != null) {
            setState(() {
              _selectedOptions = List.generate(
                42,
                (index) => answerData[(index + 1).toString()] as int?,
              );
            });
          }
        } else {
          print('User answers document does not exist');
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;
    final paddingHorizontal = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 158, 39, 39),
          elevation: 0,
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
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 158, 39, 39),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Center(
                child: Text(
                  'Interest Assessment Details',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            // Sticky header section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'QUESTIONS',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (String label in ['AGREE', 'DISAGREE'])
                          Expanded(
                            child: Center(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuestionRange(0, 10),
                    SizedBox(height: 20.0),
                    _buildQuestionRange(10, 20),
                    SizedBox(height: 20.0),
                    _buildQuestionRange(20, 30),
                    SizedBox(height: 20.0),
                    _buildQuestionRange(30, 42),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomeG10(gradeLevel: "10")),
                    );
                  },
                  icon: Image.asset(
                    'assets/home.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchG10()),
                    );
                  },
                  icon: Image.asset(
                    'assets/search.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                SizedBox(width: iconSize),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/notif.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultG10()),
                    );
                  },
                  icon: Image.asset(
                    'assets/stats.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
              ],
            ),
            Positioned(
              top: -iconSize * 0.75,
              left: MediaQuery.of(context).size.width / 2 - iconSize,
              child: Container(
                width: iconSize * 2,
                height: iconSize * 2,
                decoration: BoxDecoration(
                  color: Color(0xFFF08080),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 10,
                  ),
                ),
                child: IconButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final userResultDoc = FirebaseFirestore.instance
                          .collection('userResultG10')
                          .doc(user.uid);

                      final docSnapshot = await userResultDoc.get();

                      if (docSnapshot.exists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlreadyAnswered()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => G10Intro()),
                        );
                      }
                    } else {}
                  },
                  icon: Image.asset(
                    'assets/main.png',
                    width: iconSize * 1.3,
                    height: iconSize * 1.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionRange(int start, int end) {
    end = end > _questions.length ? _questions.length : end;

    return Container(
      color: Colors.transparent,
      child: Column(
        children: List.generate(end - start, (index) {
          final questionIndex = start + index;
          if (questionIndex < _questions.length) {
            final question = _questions[questionIndex];
            final selectedOption = _selectedOptions[questionIndex] ?? -1;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1, // Flex factor to adjust the space ratio
                    child: Text(
                      question,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 20.0), // Adjust this spacing as needed
                  Expanded(
                    flex: 1, // Flex factor for the radio buttons
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Radio<int>(
                            value: 0, // Corresponds to the first option
                            groupValue: selectedOption,
                            onChanged: null, // Disable the radio button
                            activeColor: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Radio<int>(
                            value: 1, // Corresponds to the second option
                            groupValue: selectedOption,
                            onChanged: null, // Disable the radio button
                            activeColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        }),
      ),
    );
  }
}
