import 'package:educast/Assessment/Rules/G12Intro.dart';
import 'package:educast/Assessment/assess2g12.dart';
import 'package:educast/Home/homeg12.dart';
import 'package:educast/Result/resultG12.dart';
import 'package:educast/Search/searchg12.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssessmentHistoryG12 extends StatefulWidget {
  const AssessmentHistoryG12({super.key});

  @override
  _AssessmentHistoryG12 createState() => _AssessmentHistoryG12();
}

class _AssessmentHistoryG12 extends State<AssessmentHistoryG12> {
  List<String> _questions = List.generate(75, (index) => '');
  List<int?> _selectedOptions = List.generate(75, (index) => null);
  List<int?> _correctAnswers = List.generate(75, (index) => null);

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
            .doc('grade12')
            .get();
        if (questionDocument.exists) {
          final questionData = questionDocument.data();
          if (questionData != null) {
            setState(() {
              _questions = List.generate(
                75,
                    (index) => questionData[(index + 1).toString()] ?? 'No Question',
              );
            });
          }
        } else {
          print('Questions document does not exist');
        }

        // Fetch answer key
        final answerKeyDocument = await FirebaseFirestore.instance
            .collection('questions')
            .doc('grade12Key')
            .get();
        if (answerKeyDocument.exists) {
          final answerKeyData = answerKeyDocument.data();
          if (answerKeyData != null) {
            setState(() {
              _correctAnswers = List.generate(
                75,
                    (index) => answerKeyData[(index + 1).toString()] as int?,
              );
            });
          }
        } else {
          print('Answer key document does not exist');
        }

        // Fetch user answers
        final answerDocument = await FirebaseFirestore.instance
            .collection('userAnswerG12')
            .doc(uid)
            .get();
        if (answerDocument.exists) {
          final answerData = answerDocument.data();
          if (answerData != null) {
            setState(() {
              _selectedOptions = List.generate(
                75,
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
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Center(
                child: Text(
                  'IQ Assessment Details',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'NO.',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "QUESTION",
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "ANSWER",
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "KEY",
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "REMARKS",
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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
                    _buildQuestionRange(30, 75),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.10,
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
                          const HomeG12(gradeLevel: "12")),
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
                      MaterialPageRoute(builder: (context) => SearchG12()),
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
                      MaterialPageRoute(builder: (context) => ResultG12()),
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
              left: MediaQuery
                  .of(context)
                  .size
                  .width / 2 - iconSize,
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
                          .collection('userResultG12')
                          .doc(user.uid);

                      final docSnapshot = await userResultDoc.get();

                      if (docSnapshot.exists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlreadyAnsweredG12()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => G12Intro()),
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

  String _mapAnswerToLetter(int? answer) {
    switch (answer) {
      case 1:
        return 'A';
      case 2:
        return 'B';
      case 3:
        return 'C';
      case 4:
        return 'D';
      default:
        return 'No Answer';
    }
  }

  Widget _buildQuestionRange(int start, int end) {
    end = end > _questions.length ? _questions.length : end;

    return Container(
      color: Colors.transparent,
      child: Column(
        children: List.generate(end - start, (index) {
          final questionIndex = start + index;
          if (questionIndex < _questions.length) {
            final questionNumber = questionIndex + 1;
            final questionText = _questions[questionIndex];
            final userAnswer = _mapAnswerToLetter(_selectedOptions[questionIndex]);
            final correctAnswer = _mapAnswerToLetter(_correctAnswers[questionIndex]);
            final remark = _selectedOptions[questionIndex] == _correctAnswers[questionIndex]
                ? "Correct"
                : "Wrong";

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('$questionNumber')),
                  Expanded(flex: 2, child: Text(questionText, textAlign: TextAlign.justify,),),
                  SizedBox(width: 50),
                  Expanded(flex: 1, child: Text(userAnswer)),
                  Expanded(flex: 1, child: Text(correctAnswer)),
                  Expanded(
                    flex: 1,
                    child: Text(
                      remark,
                      style: TextStyle(
                        color: remark == "Correct" ? Colors.green : Colors.red,
                        fontSize: 12,
                      ),
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