import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:educast/Assessment/Rules/G10Intro.dart';
import 'package:educast/Assessment/assess1g10.dart';
import 'package:educast/Assessment/assess4g10.dart';
import 'package:educast/Home/homeg10.dart';
import 'package:educast/Result/resultg10.dart';
import 'package:educast/Search/searchg10.dart';

class G10Rules extends StatefulWidget {
  const G10Rules({super.key});

  @override
  _G10Rules createState() => _G10Rules();
}

class _G10Rules extends State<G10Rules> with TickerProviderStateMixin {
  double _progressValue = 0.0;
  String animatedText = '';
  int _currentIndex = 0;
  late Timer _textTimer;
  final String _message =
      "This assessment will guide you \nin choosing your next path.";

  @override
  void initState() {
    super.initState();
    _startLoading();
    _startTextAnimation();
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progressValue += 0.01;
        if (_progressValue >= 1.0) {
          timer.cancel();
        }
      });
    });
  }

  void _startTextAnimation() {
    _textTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_currentIndex < _message.length) {
          animatedText += _message[_currentIndex];
          _currentIndex++;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _textTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
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
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg6.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Spartan image on the left side
          Positioned(
            left: 20.0,
            top: MediaQuery.of(context).size.height / 2 - 60,
            child: Image.asset(
              'assets/spartan.png',
              width: 100,
              height: 220,
            ),
          ),
          // Animated text container at the top
          Positioned(
            top: 180.0, // Adjust the top margin as necessary
            left: 20.0,
            right: 20.0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Text(
                animatedText,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            right: 30.0,
            bottom: 70.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const G10Rules2()),
                );
              },
              child: const Text(
                "Next",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic, // Makes the text italic
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(iconSize, context),
    );
  }

  Widget _buildBottomNavBar(double iconSize, BuildContext context) {
    return Container(
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
    );
  }
}

class G10Rules2 extends StatefulWidget {
  const G10Rules2({super.key});

  @override
  _G10Rules2 createState() => _G10Rules2();
}

class _G10Rules2 extends State<G10Rules2> with TickerProviderStateMixin {
  double _progressValue2 = 0.0;
  String animatedText2 = '';
  int _currentIndex2 = 0;
  late Timer _textTimer2;
  final String _message2 =
      "Before you begin answering the EduQUEST, \nyou must follow the  rules...";

  @override
  void initState() {
    super.initState();
    _startLoading();
    _startTextAnimation();
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progressValue2 += 0.01; // Increment the progress
        if (_progressValue2 >= 1.0) {
          timer.cancel(); // Stop the timer when loading is complete
        }
      });
    });
  }

  void _startTextAnimation() {
    _textTimer2 = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_currentIndex2 < _message2.length) {
          animatedText2 += _message2[_currentIndex2];
          _currentIndex2++;
        } else {
          timer
              .cancel(); // Stop the text animation when the full message is printed
        }
      });
    });
  }

  @override
  void dispose() {
    _textTimer2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
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
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg6.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Spartan image on the left side
          Positioned(
            left: 20.0,
            top: MediaQuery.of(context).size.height / 2 - 60,
            child: Image.asset(
              'assets/spartan.png',
              width: 100,
              height: 220,
            ),
          ),
          // Animated text container at the top
          Positioned(
            top: 180.0, // Adjust the top margin as necessary
            left: 20.0,
            right: 20.0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Text(
                animatedText2,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            right: 30.0,
            bottom: 70.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => G10Rules3()),
                );
              },
              child: const Text(
                "Next",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic, // Makes the text italic
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(iconSize, context),
    );
  }

  Widget _buildBottomNavBar(double iconSize, BuildContext context) {
    return Container(
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
    );
  }
}

class G10Rules3 extends StatefulWidget {
  const G10Rules3({super.key});

  @override
  _G10Rules3 createState() => _G10Rules3();
}

class _G10Rules3 extends State<G10Rules3> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
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
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg6.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: Container(
              width: screenWidth * 0.80,
              height: 380,
              padding: const EdgeInsets.all(20),
              margin:
                  EdgeInsets.only(top: 100), // Adjust margin for overlap effect
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRuleText('1. ', 'Read Carefully',
                      'Read each statement. If you agree with the statement, select the \'Agree\' button. Choose \'Disagree\' if otherwise. There are no wrong answers!'),
                  SizedBox(height: 10),
                  _buildRuleText('2. ', 'Result',
                      'Each statement corresponds to a category. The system will tally scores automatically.'),
                  SizedBox(height: 50),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CareerG10()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        backgroundColor: const Color.fromARGB(255, 159, 41,
                            33), // Customize the background color if needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Keeps the button as small as needed
                        children: const [
                          Text(
                            'View career pathways',
                            style: TextStyle(
                              color: Colors
                                  .white, // Customize text color if needed
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                              width:
                                  10), // Space between text and the arrow icon
                          Icon(
                            Icons
                                .arrow_forward, // Arrow icon pointing to the right
                            color:
                                Colors.white, // Customize icon color if needed
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 60.0,
            bottom: 30.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Questionnaire1G10()),
                );
              },
              child: const Text(
                "Start",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic, // Makes the text italic
                ),
              ),
            ),
          ),
          Positioned(
            left: 20, // Adjust the left position as needed
            top: 63, // Adjust the top position for overlap effect
            child: SizedBox(
              width: 130,
              height: 130,
              child: Image.asset('assets/ruleg10.png'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(iconSize, context),
    );
  }

  Widget _buildRuleText(String numberr, String title, String description) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: numberr,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: "$title – ",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: description,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(double iconSize, BuildContext context) {
    return Container(
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
    );
  }
}

class CareerG10 extends StatelessWidget {
  const CareerG10({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/back.png', // Path to the image
            width: 24, // Set the width
            height: 24, // Set the height
          ),
          onPressed: () {
            // Add back button functionality here
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Which Career Pathway is right for you?',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Divider(thickness: 1),
            SizedBox(height: 15.0),
            Center(
              child: Text(
                'Holland\'s Theory of Career Choice - RIASEC',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 15.0),
            RichText(
              text: TextSpan(
                children: const [
                  TextSpan(
                    text: 'R = Realistic (STEM) \n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text:
                        '- These people are often good at mechanical or athletic jobs. Good college majors for Realistic people are:\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   • Agriculture\n   • Health Assistant\n   • Computers\n   • Construction\n   • Mechanic/Machinist\n   • Engineering\n   • Food\n',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: const [
                  TextSpan(
                    text: 'I = Investigate (STEM)\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text:
                        '- These people like to watch, learn, analyze and solve problems. Good college majors for Investigative people are:\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   • Marine Biology\n   • Engineering\n   • Chemistry\n   • Zoology\n   • Medicine/Surgery\n   • Consumer Economics\n   • Psychology\n',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: const [
                  TextSpan(
                    text: 'A = Artistic (GAS)\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text:
                        '- These people like to work in unstructured situations where they can use their creativity. Good majors for Artistic people are:\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   • Communications\n   • Cosmetology\n   • Fine and Performing Arts\n   • Photography\n   • Radio and TV\n   • Interior Design\n   • Architecture\n',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: const [
                  TextSpan(
                    text: 'S = Social (HUMSS)\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text:
                        '- These people like to work with other people, rather than things. Good college majors for Social people are:\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   • Counseling\n   • Nursing\n   • Physical Theraphy\n   • Travel\n   • Advertising\n   • Public Relations\n   • Education',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: const [
                  TextSpan(
                    text: 'E = Enterprising (ABM)\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text:
                        '-These people like to work with others and enjoy persuading and and performing. Good college majors for Enterprising people are:\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   • Fashion Merchandising\n   • Real Estate\n   • Marketing/Sales\n   • Law\n   • Political Science\n   • International Trade\n',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: const [
                  TextSpan(
                    text: 'C = Convenional (ABM)\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text:
                        'These people are very detail oriented,organized and like to work with data. Good college majors for Conventional people are\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   • Accounting\n   • Court Reporting\n   • Insurance\n   • Administration\n   • Medical Records\n   • Banking\n   • Data Processing\n',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
