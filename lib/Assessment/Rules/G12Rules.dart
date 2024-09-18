import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/Assessment/Rules/G12Intro.dart';
import 'package:myapp/Assessment/assess4g10.dart';
import 'package:myapp/Home/homeg12.dart';
import 'package:myapp/Search/searchg12.dart';

class G12Rules extends StatefulWidget {
  const G12Rules({super.key});

  @override
  _G12Rules createState() => _G12Rules();
}

class _G12Rules extends State<G12Rules> with TickerProviderStateMixin {
  double _progressValue = 0.0;
  String animatedText = '';
  int _currentIndex = 0;
  late Timer _textTimer;
  final String _message = "This assessment will guide you \nin choosing your next path.";

  @override
  void initState() {
    super.initState();
    _startLoading();
    _startTextAnimation();
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progressValue += 0.01; // Increment the progress
        if (_progressValue >= 1.0) {
          timer.cancel(); // Stop the timer when loading is complete
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
          timer.cancel(); // Stop the text animation when the full message is printed
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
                  MaterialPageRoute(builder: (context) => const G12Rules2()),
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
                    MaterialPageRoute(builder: (context) => const SearchG12()),
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ResultG10()),
                  // );
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
                        .collection('userResultG12')
                        .doc(user.uid);

                    final docSnapshot = await userResultDoc.get();

                    if (docSnapshot.exists) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SubmissionConfirmation()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const G12Intro()),
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


class G12Rules2 extends StatefulWidget {
  const G12Rules2({super.key});

  @override
  _G12Rules2 createState() => _G12Rules2();
}

class _G12Rules2 extends State<G12Rules2> with TickerProviderStateMixin {
  double _progressValue2 = 0.0;
  String animatedText2 = '';
  int _currentIndex2 = 0;
  late Timer _textTimer2;
  final String _message2 = "Before you begin answering the EduQUEST, \nyou must follow the  rules...";

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
          timer.cancel(); // Stop the text animation when the full message is printed
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
                  MaterialPageRoute(builder: (context) => G12Rules3()),
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
                    MaterialPageRoute(builder: (context) => const SearchG12()),
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ResultG10()),
                  // );
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
                        .collection('userResultG12')
                        .doc(user.uid);

                    final docSnapshot = await userResultDoc.get();

                    if (docSnapshot.exists) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SubmissionConfirmation()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const G12Intro()),
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
class G12Rules3 extends StatefulWidget {
  const G12Rules3({super.key});

  @override
  _G12Rules3 createState() => _G12Rules3();
}

class _G12Rules3 extends State<G12Rules3> {
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
          // Centered 3D white container
          Center(
            child: Container(
              width: screenWidth * 0.80,
              height: 380,
              padding: const EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 100), // Adjust margin for overlap effect
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
                  _buildRuleText('1. ', 'One Attempt Only', 'You can take the test only once, so be prepared before starting.'),
                  SizedBox(height: 10),
                  _buildRuleText('2. ', 'Time-Limited', 'This is a speed test, so each question will have a strict time limit. Pay attention to the timer and answer as quickly and accurately as possible.'),
                  SizedBox(height: 10),
                  _buildRuleText('3. ', 'No Pausing', "Since it is a speed test, pauses aren't allowed."),
                  SizedBox(height: 10),
                  _buildRuleText('4. ', 'No Help Allowed', 'Complete the assessment independently, without external resources.'),
                  SizedBox(height: 10),
                  _buildRuleText('5. ', 'Result', 'Your results are final once submitted.'),
                ],
              ),
            ),
          ),
          Positioned(
            right: 60.0,
            bottom: 30.0,
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Questionnaire1G12()),
                // );
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
          ),Positioned(
            left: 20, // Adjust the left position as needed
            top: 63,  // Adjust the top position for overlap effect
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
                    MaterialPageRoute(builder: (context) => const SearchG12()),
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ResultG10()),
                  // );
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
                        .collection('userResultG12')
                        .doc(user.uid);

                    final docSnapshot = await userResultDoc.get();

                    if (docSnapshot.exists) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SubmissionConfirmation()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const G12Intro()),
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
