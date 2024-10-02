import 'package:educast/Assessment/Rules/G12Intro.dart';
import 'package:educast/Home/homeg12.dart';
import 'package:educast/Result/resultG12.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';

class SubmissionConfirmationG12 extends StatefulWidget {
  @override
  _SubmissionConfirmationG12 createState() => _SubmissionConfirmationG12();
}

class _SubmissionConfirmationG12 extends State<SubmissionConfirmationG12> {
  late VideoPlayerController _controller;



  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/alarm.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _viewResults() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure the user is logged in

    String uid = user.uid;
    DocumentSnapshot userAnswersSnapshot = await FirebaseFirestore.instance
        .collection('userAnswerG12')
        .doc(uid)
        .get();

    DocumentSnapshot correctAnswersSnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .doc('grade12Key') // Make sure this is the correct document ID
        .get();

    if (!userAnswersSnapshot.exists || !correctAnswersSnapshot.exists) {
      // Handle the case where the documents do not exist
      return;
    }

    // Safely casting to a Map
    Map<String, dynamic>? userAnswers = userAnswersSnapshot.data() as Map<String, dynamic>?;
    Map<String, dynamic>? correctAnswers = correctAnswersSnapshot.data() as Map<String, dynamic>?;

    if (userAnswers == null || correctAnswers == null) {
      // Handle the case where the data could not be retrieved
      return;
    }

    Map<String, int> results = {
      "Mechanical Reasoning": 0,
      "Spatial Reasoning": 0,
      "Verbal Reasoning": 0,
      "Numerical Ability": 0,
      "Language Usage": 0,
      "Word Knowledge": 0,
      "Perceptual Speed and Accuracy": 0,
      "Analytical Ability": 0,
      "Basic Operations": 0,
      "Word Problems": 0,
      "Word Association": 0,
      "Logic": 0,
      "Grammar and Correct Usage": 0,
      "Vocabulary": 0,
      "Data Interpretation": 0,
    };

    for (int i = 1; i <= 75; i++) {
      String key = i.toString();
      if (userAnswers.containsKey(key) && correctAnswers.containsKey(key)) {
        if (userAnswers[key] == correctAnswers[key]) {
          // Safely access and increment the results
          if (i <= 5) results["Mechanical Reasoning"] = (results["Mechanical Reasoning"] ?? 0) + 1;
          else if (i <= 10) results["Spatial Reasoning"] = (results["Spatial Reasoning"] ?? 0) + 1;
          else if (i <= 15) results["Verbal Reasoning"] = (results["Verbal Reasoning"] ?? 0) + 1;
          else if (i <= 20) results["Numerical Ability"] = (results["Numerical Ability"] ?? 0) + 1;
          else if (i <= 25) results["Language Usage"] = (results["Language Usage"] ?? 0) + 1;
          else if (i <= 30) results["Word Knowledge"] = (results["Word Knowledge"] ?? 0) + 1;
          else if (i <= 35) results["Perceptual Speed and Accuracy"] = (results["Perceptual Speed and Accuracy"] ?? 0) + 1;
          else if (i <= 40) results["Analytical Ability"] = (results["Analytical Ability"] ?? 0) + 1;
          else if (i <= 45) results["Basic Operations"] = (results["Basic Operations"] ?? 0) + 1;
          else if (i <= 50) results["Word Problems"] = (results["Word Problems"] ?? 0) + 1;
          else if (i <= 55) results["Word Association"] = (results["Word Association"] ?? 0) + 1;
          else if (i <= 60) results["Logic"] = (results["Logic"] ?? 0) + 1;
          else if (i <= 65) results["Grammar and Correct Usage"] = (results["Grammar and Correct Usage"] ?? 0) + 1;
          else if (i <= 70) results["Vocabulary"] = (results["Vocabulary"] ?? 0) + 1;
          else if (i <= 75) results["Data Interpretation"] = (results["Data Interpretation"] ?? 0) + 1;
        }
      }
    }

    // Store the results in the userResultG12 collection
    await FirebaseFirestore.instance.collection('userResultG12').doc(uid).set(results);

    // Optionally, navigate to a results screen or show a message
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultG12()), // Adjust as necessary
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
                MaterialPageRoute(builder: (context) => const HomeG12()),
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
                      'Time\'s up!',
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => SearchG12()),
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

class AlreadyAnsweredG12 extends StatefulWidget {
  @override
  _AlreadyAnsweredG12 createState() => _AlreadyAnsweredG12();
}

class _AlreadyAnsweredG12 extends State<AlreadyAnsweredG12> {
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

    DocumentSnapshot userAnswersSnapshot = await FirebaseFirestore.instance
        .collection('userAnswerG12')
        .doc(uid)
        .get();

    if (!userAnswersSnapshot.exists) {
      print('No answers found for the user');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ResultG12()), // Replace with your actual results page widget
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
                MaterialPageRoute(builder: (context) => const HomeG12()),
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => SearchG12()),
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
