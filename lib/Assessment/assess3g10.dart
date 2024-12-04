import 'package:educast/Assessment/Rules/G10Intro.dart';
import 'package:educast/Result/resultg10.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:educast/Assessment/assess4g10.dart';
import 'package:educast/Home/homeg10.dart';
import 'package:educast/Search/searchg10.dart';

class Questionnaire3G10 extends StatefulWidget {
  final Map<String, int>? previousAnswers;

  const Questionnaire3G10({Key? key, this.previousAnswers}) : super(key: key);

  @override
  _Questionnaire3G10 createState() => _Questionnaire3G10();
}

class _Questionnaire3G10 extends State<Questionnaire3G10> {
  List<String> _questions = List.generate(10, (index) => '');
  final List<int?> _selectedOptions = List.generate(10, (index) => null);

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _initializeAnswers();
  }

  Future<void> _fetchQuestions() async {
    try {
      final document = await FirebaseFirestore.instance
          .collection('questions')
          .doc('grade10')
          .get();
      if (document.exists) {
        final data = document.data();
        if (data != null) {
          setState(() {
            _questions = List.generate(
              10,
              (index) => data[(index + 21).toString()] ?? 'No Question',
            );
          });
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }

  void _initializeAnswers() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final document = await FirebaseFirestore.instance
            .collection('userAnswerG10')
            .doc(uid)
            .get();

        if (document.exists) {
          final data = document.data();
          if (data != null) {
            setState(() {
              for (int i = 0; i < _selectedOptions.length; i++) {
                _selectedOptions[i] = data[(i + 21).toString()];
              }
            });
          }
        } else {
          print('User document does not exist');
        }
      } catch (e) {
        print('Error initializing answers: $e');
      }
    }
  }

  Future<void> _updateAnswer(int index, int? value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance
            .collection('userAnswerG10')
            .doc(uid)
            .set(
          {(index + 21).toString(): value ?? -1},
          SetOptions(merge: true),
        );
        print('Answer updated successfully');
      } catch (e) {
        print('Error updating answer: $e');
      }
    }
  }

  Future<void> _submitAnswers() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      // Check if any question is unanswered (null values in the list)
      if (_selectedOptions.any((option) => option == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please answer all questions'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Exit the function if there are unanswered questions
      }

      final userAnswers = <String, int>{};
      for (int i = 0; i < _selectedOptions.length; i++) {
        userAnswers[(i + 21).toString()] = _selectedOptions[i]!;
      }

      try {
        await FirebaseFirestore.instance
            .collection('userAnswerG10')
            .doc(uid)
            .set(userAnswers, SetOptions(merge: true));

        print('Answers successfully submitted');

        // Navigate to the next page if all questions are answered
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Questionnaire4G10()), // Replace `NextPage` with your actual page
        );
      } catch (e) {
        print('Error submitting answers: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting answers. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
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
                  'Interest Assessment',
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
                                  width: (MediaQuery.of(context).size.width - 80),
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
                                        Center(
                                          child:
                                          Text(
                                            question,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        const SizedBox(height: 8.0),
                                        // Agree and Disagree columns with radio buttons below the text
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // Agree Column
                                            Column(
                                              children: [
                                                const Text("Agree", style: TextStyle(color: Colors.red)),Theme(
                                                  data: Theme.of(context).copyWith(
                                                    unselectedWidgetColor: Colors.red, // Set the unselected color to green
                                                  ),
                                                  child: Radio<int>(
                                                    value: 0, // AGREE
                                                    groupValue: _selectedOptions[index],
                                                    onChanged: (int? value) {
                                                      setState(() {
                                                        _selectedOptions[index] = value!;
                                                      });
                                                      _updateAnswer(index, value); // Update Firestore in real-time
                                                    },
                                                    activeColor: Colors.red, // Set the selected color to green
                                                  ),
                                                )

                                              ],
                                            ),
                                            const SizedBox(width: 140.0),
                                            Column(
                                              children: [
                                                const Text("Disagree", style: TextStyle(color: Colors.red)),
                                                Radio<int>(
                                                  value: 1, // DISAGREE
                                                  groupValue: _selectedOptions[index],
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      _selectedOptions[index] = value!;
                                                    });
                                                    _updateAnswer(index, value); // Update Firestore in real-time
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
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Row(
                children: [
                  // Container to ensure the text is aligned properly
                  Container(
                    margin: const EdgeInsets.only(
                        right: 3.0), // Space between text and buttons
                    child: Text(
                      '30 out of 42 \nquestions',
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey[200]!),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 20.0)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors
                          .black
                          .withOpacity(0.6)), // Semi-black text color
                    ),
                    child: Text('Previous'),
                  ),
                  SizedBox(width: 5.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _submitAnswers();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 158, 39, 39)),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 20.0)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white), // Set font color to white
                    ),
                    child: Text('Next'),
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
                          builder: (context) => const HomeG10(gradeLevel: "Grade 10")),
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
                      MaterialPageRoute(builder: (context) => const SearchG10()),
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
                  color: const Color(0xFFF08080),
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
                          MaterialPageRoute(
                              builder: (context) => const G10Intro()),
                        );
                      }
                    }
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
