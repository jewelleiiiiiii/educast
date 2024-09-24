import 'package:educast/Assessment/Rules/G10Intro.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:educast/Home/homeg10.dart';
import 'package:educast/Search/searchg10.dart';
import 'package:video_player/video_player.dart';
import '../Result/resultg10.dart';

class Questionnaire4G10 extends StatefulWidget {
  final Map<String, int>? previousAnswers;

  const Questionnaire4G10({Key? key, this.previousAnswers}) : super(key: key);

  @override
  _Questionnaire4G10 createState() => _Questionnaire4G10();
}

class _Questionnaire4G10 extends State<Questionnaire4G10> {
  List<String> _questions =
      List.generate(12, (index) => ''); // 12 questions now
  List<int?> _selectedOptions =
      List.generate(12, (index) => null); // 12 options now

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
              12,
              (index) => data[(index + 31).toString()] ?? 'No Question',
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
                _selectedOptions[i] = data[(i + 31).toString()];
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
          {(index + 31).toString(): value ?? -1},
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
        userAnswers[(i + 31).toString()] = _selectedOptions[i] ?? -1;
      }

      try {
        await FirebaseFirestore.instance
            .collection('userAnswerG10')
            .doc(uid)
            .set(userAnswers, SetOptions(merge: true));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SubmissionConfirmation()),
        );
      } catch (e) {
        print('Error submitting answers: $e');
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
                                  width: 300,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      for (String label in [
                                        'AGREE',
                                        'DISAGREE'
                                      ])
                                        Container(
                                          width: 150.0,
                                          child: Center(
                                            child: Text(
                                              label,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
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
                                            Container(
                                              width: 150.0,
                                              child: Center(
                                                child: Radio<int>(
                                                  value: 0, // AGREE
                                                  groupValue:
                                                      _selectedOptions[index],
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      _selectedOptions[index] =
                                                          value;
                                                    });
                                                    _updateAnswer(index, value);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 150.0,
                                              child: Center(
                                                child: Radio<int>(
                                                  value: 1, // DISAGREE
                                                  groupValue:
                                                      _selectedOptions[index],
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      _selectedOptions[index] =
                                                          value;
                                                    });
                                                    _updateAnswer(index, value);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
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
                  Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      '42 out of 42 questions',
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  Spacer(),
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
                  ElevatedButton(
                    onPressed: _submitAnswers,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 158, 39, 39)),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 20.0)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white), // Set font color to white
                    ),
                    child: Text('SUBMIT'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
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
}

class SubmissionConfirmation extends StatefulWidget {
  @override
  _SubmissionConfirmationState createState() => _SubmissionConfirmationState();
}

class _SubmissionConfirmationState extends State<SubmissionConfirmation> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/check.mp4')
      ..initialize().then((_) {
        setState(() {}); // Update the state when the video is initialized.
        _controller.play(); // Automatically play the video.
        _controller.setLooping(true); // Loop the video.
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed.
    super.dispose();
  }

  void _viewResults() async {
    // Get the current user's UID
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the user's answers from the userAnswerG10 collection
    DocumentSnapshot userAnswersSnapshot = await FirebaseFirestore.instance
        .collection('userAnswerG10')
        .doc(uid)
        .get();

    if (!userAnswersSnapshot.exists) {
      print('No answers found for the user');
      return;
    }

    // Initialize fields for Realistic, Investigative, etc.
    Map<String, int> results = {
      'Realistic': 0,
      'Investigative': 0,
      'Artistic': 0,
      'Social': 0,
      'Enterprising': 0,
      'Conventional': 0,
    };

    // Mapping of fields to the corresponding categories
    Map<int, String> fieldMapping = {
      1: 'Realistic',
      2: 'Investigative',
      3: 'Artistic',
      4: 'Social',
      5: 'Enterprising',
      6: 'Conventional',
      7: 'Realistic',
      8: 'Artistic',
      9: 'Conventional',
      10: 'Enterprising',
      11: 'Investigative',
      12: 'Social',
      13: 'Social',
      14: 'Realistic',
      15: 'Conventional',
      16: 'Enterprising',
      17: 'Artistic',
      18: 'Investigative',
      19: 'Enterprising',
      20: 'Social',
      21: 'Investigative',
      22: 'Realistic',
      23: 'Artistic',
      24: 'Conventional',
      25: 'Conventional',
      26: 'Investigative',
      27: 'Artistic',
      28: 'Social',
      29: 'Enterprising',
      30: 'Realistic',
      31: 'Artistic',
      32: 'Realistic',
      33: 'Investigative',
      34: 'Social',
      35: 'Conventional',
      36: 'Enterprising',
      37: 'Realistic',
      38: 'Conventional',
      39: 'Investigative',
      40: 'Social',
      41: 'Artistic',
      42: 'Enterprising',
    };

    // Evaluate the answers
    for (int i = 1; i <= 42; i++) {
      if (userAnswersSnapshot.get('$i') == 0) {
        // Updated to access field as "1", "2", etc.
        results[fieldMapping[i]!] = results[fieldMapping[i]!]! + 1;
      }
    }

    // Store the results in the userResultG10 collection
    await FirebaseFirestore.instance
        .collection('userResultG10')
        .doc(uid)
        .set(results);

    // Navigate to the results page or perform further actions
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ResultG10()), // Replace with your actual results page widget
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;
    final paddingHorizontal = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
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
                MaterialPageRoute(builder: (context) => const HomeG10()),
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_controller.value.isInitialized)
                      SizedBox(
                        height: 200.0, // Set the height to 200 pixels
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    else
                      CircularProgressIndicator(),
                    SizedBox(height: 20.0),
                    Text(
                      'Submitted successfully!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Please wait for the results.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: _viewResults,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 158, 39, 39),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'View Results',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
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
                      MaterialPageRoute(builder: (context) => const HomeG10()),
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
}


class AlreadyAnswered extends StatefulWidget {
  @override
  _AlreadyAnswered createState() => _AlreadyAnswered();
}

class _AlreadyAnswered extends State<AlreadyAnswered> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/check.mp4')
      ..initialize().then((_) {
        setState(() {}); // Update the state when the video is initialized.
        _controller.play(); // Automatically play the video.
        _controller.setLooping(true); // Loop the video.
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed.
    super.dispose();
  }

  void _viewResults() async {
    // Get the current user's UID
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the user's answers from the userAnswerG10 collection
    DocumentSnapshot userAnswersSnapshot = await FirebaseFirestore.instance
        .collection('userAnswerG10')
        .doc(uid)
        .get();

    if (!userAnswersSnapshot.exists) {
      print('No answers found for the user');
      return;
    }

    // Initialize fields for Realistic, Investigative, etc.
    Map<String, int> results = {
      'Realistic': 0,
      'Investigative': 0,
      'Artistic': 0,
      'Social': 0,
      'Enterprising': 0,
      'Conventional': 0,
    };

    // Mapping of fields to the corresponding categories
    Map<int, String> fieldMapping = {
      1: 'Realistic',
      2: 'Investigative',
      3: 'Artistic',
      4: 'Social',
      5: 'Enterprising',
      6: 'Conventional',
      7: 'Realistic',
      8: 'Artistic',
      9: 'Conventional',
      10: 'Enterprising',
      11: 'Investigative',
      12: 'Social',
      13: 'Social',
      14: 'Realistic',
      15: 'Conventional',
      16: 'Enterprising',
      17: 'Artistic',
      18: 'Investigative',
      19: 'Enterprising',
      20: 'Social',
      21: 'Investigative',
      22: 'Realistic',
      23: 'Artistic',
      24: 'Conventional',
      25: 'Conventional',
      26: 'Investigative',
      27: 'Artistic',
      28: 'Social',
      29: 'Enterprising',
      30: 'Realistic',
      31: 'Artistic',
      32: 'Realistic',
      33: 'Investigative',
      34: 'Social',
      35: 'Conventional',
      36: 'Enterprising',
      37: 'Realistic',
      38: 'Conventional',
      39: 'Investigative',
      40: 'Social',
      41: 'Artistic',
      42: 'Enterprising',
    };

    // Evaluate the answers
    for (int i = 1; i <= 42; i++) {
      if (userAnswersSnapshot.get('$i') == 0) {
        // Updated to access field as "1", "2", etc.
        results[fieldMapping[i]!] = results[fieldMapping[i]!]! + 1;
      }
    }

    // Store the results in the userResultG10 collection
    await FirebaseFirestore.instance
        .collection('userResultG10')
        .doc(uid)
        .set(results);

    // Navigate to the results page or perform further actions
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ResultG10()), // Replace with your actual results page widget
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;
    final paddingHorizontal = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
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
                MaterialPageRoute(builder: (context) => const HomeG10()),
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_controller.value.isInitialized)
                      SizedBox(
                        height: 200.0, // Set the height to 200 pixels
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    else
                      CircularProgressIndicator(),
                    SizedBox(height: 20.0),
                    Text(
                      'You have successfully completed the Interest Assessment.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: _viewResults,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 158, 39, 39),
                        padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'View Results',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
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
                      MaterialPageRoute(builder: (context) => const HomeG10()),
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
}
