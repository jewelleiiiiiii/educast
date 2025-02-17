import 'package:educast/Assessment/Rules/4thIntro.dart';
import 'package:educast/Assessment/assess24th.dart';
import 'package:educast/Assessment/assess34th.dart';
import 'package:educast/Home/Home4th.dart';
import 'package:educast/Result/result4th.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Questionnaire14th extends StatefulWidget {
  const Questionnaire14th({super.key});

  @override
  _Questionnaire14th createState() => _Questionnaire14th();
}

class _Questionnaire14th extends State<Questionnaire14th> {
  List<String> _questions = List.generate(10, (index) => '');
  List<int?> _selectedOptions = List.generate(10, (index) => null);

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    print('Fetching questions for user: $uid');
    if (uid != null) {
      try {
        final userDocument =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDocument.exists) {
          final userData = userDocument.data();
          final course = userData?['course'] ?? 'Unknown Course';
          print('User course: $course');

          final questionDocument = await FirebaseFirestore.instance
              .collection('questions4th')
              .doc(course)
              .get();

          if (questionDocument.exists) {
            final questionData = questionDocument.data();
            if (questionData != null) {
              setState(() {
                _questions = List.generate(
                  10,
                  (index) =>
                      questionData[(index + 1).toString()] ?? 'No Question',
                );
              });
            }
          } else {
            print('Questions document for course "$course" does not exist');
          }

          final answerDocument = await FirebaseFirestore.instance
              .collection('userAnswer4th')
              .doc(uid)
              .get();

          if (answerDocument.exists) {
            final answerData = answerDocument.data();
            if (answerData != null) {
              setState(() {
                _selectedOptions = List.generate(
                  10,
                  (index) => answerData[(index + 1).toString()] as int?,
                );
              });
            }
          } else {
            print('User answers document does not exist');
          }
        } else {
          print('User document does not exist');
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
    }
  }

  Future<void> _updateAnswer(int index, int? value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance
            .collection('userAnswer4th')
            .doc(uid)
            .set({
          (index + 1).toString(): value,
        }, SetOptions(merge: true));
      } catch (e) {
        print('Error updating answer: $e');
      }
    }
  }

  Future<void> _submitAnswers() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      if (_selectedOptions.contains(null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please answer all questions'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final userAnswers = <String, int>{};
      for (int i = 0; i < _selectedOptions.length; i++) {
        userAnswers[(i + 1).toString()] = _selectedOptions[i] ?? -1;
      }

      try {
        await FirebaseFirestore.instance
            .collection('userAnswer4th')
            .doc(uid)
            .set(userAnswers, SetOptions(merge: true));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Questionnaire24th()),
        );
      } catch (e) {
        print('Error submitting answers: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;
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
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
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
                  'Skills Assessment',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: screenWidth - 80,
                                  child: Center(
                                    child: Text(
                                      'QUESTIONS',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                              ],
                            ),
                            SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._questions.asMap().entries.map((entry) {
                      int index = entry.key;
                      String question = entry.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question,
                              style: TextStyle(
                                fontSize: 14.0,

                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust spacing
                              children: [
                                for (int i = 5; i >= 1; i--) // Loop for each option
                                  Column(
                                    children: [
                                      Text(
                                        i.toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Radio<int>(
                                        value: i,
                                        groupValue: _selectedOptions[index],
                                        onChanged: (int? value) {
                                          setState(() {
                                            _selectedOptions[index] = value;
                                          });
                                          _updateAnswer(index, value); // Firestore update
                                        },
                                        activeColor: Colors.red,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                              height: 1.0,
                              width: MediaQuery.of(context).size.width - .20,// Line thickness
                              color: Colors.grey , // Test with a visible color
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),

                ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '10 out of 25 questions',
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _submitAnswers,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 158, 39, 39),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
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
                              const Home4th(gradeLevel: "4th")),
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => SearchG10()),
                    // );
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
                      MaterialPageRoute(builder: (context) => Result4th()),
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
                          .collection('userResult4th')
                          .doc(user.uid);

                      final docSnapshot = await userResultDoc.get();

                      if (docSnapshot.exists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlreadyAnswered4th()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FourthIntro()),
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
}
