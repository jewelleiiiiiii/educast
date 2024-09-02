import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/Home/homeg10.dart';
import 'package:myapp/Search/searchg10.dart';
import 'package:video_player/video_player.dart';


class Questionnaire4G10 extends StatefulWidget {
  final Map<String, int>? previousAnswers;

  const Questionnaire4G10({Key? key, this.previousAnswers}) : super(key: key);

  @override
  _Questionnaire4G10 createState() => _Questionnaire4G10();
}

class _Questionnaire4G10 extends State<Questionnaire4G10> {
  List<String> _questions = List.generate(12, (index) => ''); // 12 questions now
  List<int?> _selectedOptions = List.generate(12, (index) => null); // 12 options now

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
          { (index + 31).toString(): value ?? -1 },
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
                      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
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
                                      for (String label in ['AGREE', 'DISAGREE'])
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
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                                  groupValue: _selectedOptions[index],
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      _selectedOptions[index] = value;
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
                                                  groupValue: _selectedOptions[index],
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      _selectedOptions[index] = value;
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      '30 out of 42 questions',
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _submitAnswers,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 158, 39, 39)),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20.0)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set font color to white
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

  @override
  Widget build(BuildContext context) {
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
}
