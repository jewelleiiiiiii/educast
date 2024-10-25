import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Assessment/Rules/G12Intro.dart';
import 'package:educast/Assessment/assess2g12.dart';
import 'package:educast/Home/homeg12.dart';
import 'package:educast/Result/resultG12.dart';
import 'package:educast/Search/searchg12.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class QuestionG12 {
  final String questionTextG12;

  QuestionG12({
    required this.questionTextG12,
  });
}

class QuestionnaireG12 extends StatefulWidget {
  const QuestionnaireG12({Key? key}) : super(key: key);

  @override
  _QuestionnaireG12 createState() => _QuestionnaireG12();
}

class _QuestionnaireG12 extends State<QuestionnaireG12> {
  int _selectedIndex = 0; // Track the current question index
  int _totalQuestions = 75; // Default number of questions
  List<QuestionG12> _questions = []; // Store fetched questions
  List<List<String>> _options = []; // Store options for each question
  int _selectedOptionIndex = -1; // No option selected initially
  bool _isLoading = true; // Loading state for questions
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Timer? _timer; // Timer variable
  int _remainingTime = 4500; // 15 minutes = 900 seconds

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _fetchOptions();
    _retrieveStoredAnswer(); // Fetch the stored answer on initialization
    _startTimer(); // Start the timer when the page loads
  }

  Future<void> _fetchQuestions() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('questions')
          .doc('grade12')
          .get();

      if (snapshot.exists) {
        List<QuestionG12> fetchedQuestions = [];

        _totalQuestions = snapshot.data()?.keys.length ?? 75; // Dynamically set total questions

        for (int i = 1; i <= _totalQuestions; i++) {
          String fieldName = i.toString();
          String questionText = snapshot.get(fieldName) ?? '';
          fetchedQuestions.add(QuestionG12(questionTextG12: questionText));
        }

        setState(() {
          _questions = fetchedQuestions;
          _isLoading = false;
        });
      } else {
        print('No such document!');
        setState(() {
          _isLoading = false;  // Stop loading even if document is missing
        });
      }
    } catch (e) {
      print('Error fetching questions: $e');
      setState(() {
        _isLoading = false;  // Stop loading on error
      });
    }
  }

  Future<void> _fetchOptions() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('questions')
          .doc('grade12Options')
          .get();

      if (snapshot.exists) {
        List<List<String>> fetchedOptions = [];

        for (int i = 1; i <= _totalQuestions; i++) {
          String fieldName = i.toString();
          String optionString = snapshot.get(fieldName) ?? '';
          print('Options for question $fieldName: $optionString'); // Debug statement

          List<String> optionList = optionString.split(';').map((option) => option.trim()).toList();

          while (optionList.length < 4) {
            optionList.add(''); // Fill with empty strings if there are less than 4 options
          }

          if (optionList.length > 4) {
            optionList = optionList.sublist(0, 4);
          }

          List<String> formattedOptions = [
            'A) ${optionList[0]}',
            'B) ${optionList[1]}',
            'C) ${optionList[2]}',
            'D) ${optionList[3]}',
          ];

          fetchedOptions.add(formattedOptions);
        }

        setState(() {
          _options = fetchedOptions;
        });
      } else {
        print('No such document for options!');
      }
    } catch (e) {
      print('Error fetching options: $e');
    }
  }

  Future<void> _storeSelectedAnswer(int questionNumber, int selectedOptionValue) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final uid = user.uid;
        await FirebaseFirestore.instance
            .collection('userAnswerG12')
            .doc(uid)
            .set({
          '$questionNumber': selectedOptionValue,
        }, SetOptions(merge: true)); // Use merge to avoid overwriting other fields
      }
    } catch (e) {
      print('Error storing selected answer: $e');
    }
  }

  void _selectOption(int index) {
    setState(() {
      _selectedOptionIndex = index; // Update selected option index
    });

    // Determine the value to store based on the selected option
    int selectedOptionValue;
    switch (index) {
      case 0:
        selectedOptionValue = 1; // A)
        break;
      case 1:
        selectedOptionValue = 2; // B)
        break;
      case 2:
        selectedOptionValue = 3; // C)
        break;
      case 3:
        selectedOptionValue = 4; // D)
        break;
      default:
        selectedOptionValue = 0;
    }

    // Store the selected answer for the current question
    _storeSelectedAnswer(_selectedIndex + 1, selectedOptionValue); // Question numbers start at 1
  }

  Future<void> _retrieveStoredAnswer() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final uid = user.uid;
        final snapshot = await FirebaseFirestore.instance
            .collection('userAnswerG12')
            .doc(uid)
            .get();

        if (snapshot.exists) {
          int questionNumber = _selectedIndex + 1; // Current question number (1-based)
          if (snapshot.data()!.containsKey('$questionNumber')) {
            setState(() {
              _selectedOptionIndex = snapshot.get('$questionNumber') - 1; // Update index (0-based)
            });
          } else {
            setState(() {
              _selectedOptionIndex = -1; // Reset if no stored answer
            });
          }
        }
      }
    } catch (e) {
      print('Error retrieving stored answer: $e');
    }
  }

  void _nextQuestionG12() {
    if (_selectedOptionIndex == -1) {
      _storeSelectedAnswer(_selectedIndex + 1, 0); // Store 0 for unanswered question
    } else {
      _storeSelectedAnswer(_selectedIndex + 1, _selectedOptionIndex + 1); // Store selected answer
    }

    if (_selectedIndex < _totalQuestions - 1) {
      setState(() {
        _selectedIndex++;
      });
      _retrieveStoredAnswer(); // Retrieve stored answer for the next question
    }
  }


  void _previousQuestionG12() {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex--;
      });
      _retrieveStoredAnswer(); // Retrieve stored answer for the previous question
    }
  }

  void _submitQuestionnaireG12() {
    // Handle the submission logic here
    print('Questionnaire submitted');
    // You can navigate to another page or display a submission confirmation message
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubmissionConfirmationG12()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to start the timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _handleTimeUp(); // Call when time is up
        _timer?.cancel();
      }
    });
  }

  // Function to handle the logic when time runs out
  void _handleTimeUp() async {
    print('Time is up! Setting unanswered questions to 0.');

    // Loop through all questions and set unanswered ones to 0
    for (int i = 1; i <= _totalQuestions; i++) {
      await _checkAndSetDefaultAnswer(i);
    }

    // Navigate to HomeG12 page after processing
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeG12()),
    );
  }

  // Function to check and set default answer (0) if unanswered
  Future<void> _checkAndSetDefaultAnswer(int questionNumber) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final uid = user.uid;
        final snapshot = await FirebaseFirestore.instance
            .collection('userAnswerG12')
            .doc(uid)
            .get();

        // If the question is unanswered, set the answer to 0
        if (!snapshot.exists || !snapshot.data()!.containsKey('$questionNumber')) {
          await FirebaseFirestore.instance
              .collection('userAnswerG12')
              .doc(uid)
              .set({
            '$questionNumber': 0,
          }, SetOptions(merge: true)); // Set 0 for unanswered question
        }
      }
    } catch (e) {
      print('Error setting default answer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final iconSize = screenWidth * 0.10;
    final paddingHorizontal = screenWidth * 0.04;

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
          children: [
            // First Container with a timer
            Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 158, 39, 39),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Center(
                child: Text(
                  'IQ Assessment | Time Remaining: ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Expanded(
              // Scrollable content placed inside SingleChildScrollView
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isLoading
                                ? 'Loading...'
                                : 'Question #${_selectedIndex + 1} out of $_totalQuestions',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            _isLoading
                                ? 'Loading question...'
                                : _questions.isNotEmpty && _selectedIndex < _questions.length
                                ? _questions[_selectedIndex].questionTextG12
                                : 'No question available',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    // Display options if available
                    if (!_isLoading && _selectedIndex < _options.length)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 2.0,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _selectOption(index),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedOptionIndex == index
                                        ? const Color.fromARGB(255, 158, 39, 39)
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _options[_selectedIndex][index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: _selectedOptionIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    else
                      const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_selectedIndex > 0)
                            ElevatedButton(
                              onPressed: _previousQuestionG12,
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.grey[200]!),
                              ),
                              child: const Text(
                                'Previous',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          if (_selectedIndex < _totalQuestions - 1)
                            ElevatedButton(
                              onPressed: _nextQuestionG12,
                              child: const Text('Next'),
                            ),
                          if (_selectedIndex == _totalQuestions - 1)
                            ElevatedButton(
                              onPressed: _submitQuestionnaireG12,
                              child: const Text('Submit'),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                      MaterialPageRoute(builder: (context) => const HomeG12()),
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
}
