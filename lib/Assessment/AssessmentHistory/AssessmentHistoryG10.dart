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
    return Scaffold(
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResultG10()),
              );
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
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Center(
                child: Text(
                  'Interest Assessment Details',
                  style: TextStyle(
                    fontSize: 24.0,
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
                          fontSize: 16.0,
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
                                  fontSize: 16.0,
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
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: .2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeG10()),
                );
              },
              icon: Image.asset(
                'assets/home.png',
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.height * 0.10,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchG10()),
                );
              },
              icon: Image.asset(
                'assets/search.png',
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.height * 0.10,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchG10()),
                );
              },
              icon: Image.asset(
                'assets/main.png',
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.height * 0.10,
              ),
            ),
            IconButton(
              onPressed: () {
                // Handle action
              },
              icon: Image.asset(
                'assets/notif.png',
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.height * 0.10,
              ),
            ),
            IconButton(
              onPressed: () {
                // Handle action
              },
              icon: Image.asset(
                'assets/stats.png',
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.height * 0.10,
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
