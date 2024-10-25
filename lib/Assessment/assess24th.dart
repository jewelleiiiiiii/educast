import 'package:educast/Assessment/Rules/4thIntro.dart';
import 'package:educast/Assessment/assess34th.dart';
import 'package:educast/Home/Home4th.dart';
import 'package:educast/Result/result4th.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Questionnaire24th extends StatefulWidget {
  const Questionnaire24th({super.key});

  @override
  _Questionnaire24th createState() => _Questionnaire24th();
}

class _Questionnaire24th extends State<Questionnaire24th> {
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
                      questionData[(index + 11).toString()] ??
                      'No Question', // Fetch questions 11-20
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
                  (index) => answerData[(index + 11).toString()]
                      as int?, // Fetch answers for questions 11-20
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
        // Store the answer in Firestore with keys from 11 to 20
        await FirebaseFirestore.instance
            .collection('userAnswer4th')
            .doc(uid)
            .set({
          (index + 11).toString(): value, // Storing answers as 11 to 20
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
        // Store answers in fields 11 to 20
        userAnswers[(i + 11).toString()] = _selectedOptions[i] ?? -1;
      }

      try {
        await FirebaseFirestore.instance
            .collection('userAnswer4th')
            .doc(uid)
            .set(userAnswers, SetOptions(merge: true));

        print('Successful');
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
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 200,
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
                                Container(
                                  width: 350,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      for (int i = 5;
                                          i >= 1;
                                          i--) // Loop from 5 to 1
                                        Container(
                                          width: 70.0,
                                          child: Center(
                                            child: Text(
                                              i.toString(),
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
                            SizedBox(height: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ..._questions.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  String question = entry.value;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 200,
                                          child: Text(
                                            question,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Row(
                                          children: [
                                            for (int i = 5; i >= 1; i--)
                                              Container(
                                                width: 70.0,
                                                child: Center(
                                                  child: Radio<int>(
                                                    value: i, // Options 1 to 5
                                                    groupValue:
                                                        _selectedOptions[index],
                                                    onChanged: (int? value) {
                                                      setState(() {
                                                        _selectedOptions[
                                                            index] = value;
                                                      });
                                                      _updateAnswer(index,
                                                          value); // Update Firestore in real-time
                                                    },
                                                  ),
                                                ),
                                              ),
                                          ],
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Container to ensure the text is aligned properly
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                          right: 20.0), // Space between text and buttons
                      child: Text(
                        '20 out of 25 questions',
                        style: TextStyle(
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey[200]!),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 16.0)),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.black
                                  .withOpacity(0.6)), // Semi-black text color
                        ),
                        child: Text('Previous'),
                      ),
                      SizedBox(width: 10.0),
                      ElevatedButton(
                        onPressed: () async {
                          await _submitAnswers();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Questionnaire34th()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 158, 39, 39)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 16.0)),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // Set font color to white
                        ),
                        child: Text('Next'),
                      ),
                    ],
                  ),
                ],
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
