import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Assessment/AssessmentHistory/AssessmentHistory4th.dart';
import 'package:educast/Assessment/Rules/4thIntro.dart';
import 'package:educast/Assessment/assess34th.dart';
import 'package:educast/Home/Home4th.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Result4th extends StatefulWidget {
  @override
  _Result4th createState() => _Result4th();
}

class _Result4th extends State<Result4th> {
  late Future<DocumentSnapshot> _userResult;

  @override
  void initState() {
    super.initState();
    _userResult = _getUserResult();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final iconSize = screenWidth * 0.10;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make the status bar transparent
      statusBarBrightness:
      Brightness.light, // Ensure the status bar text is readable (white)
    ));

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bg8.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: FutureBuilder<DocumentSnapshot>(
              future: _getUserResult(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Something went wrong"));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return _buildResultPage(
                    context,
                    softwaredev: 0,
                    networkadmin: 0,
                    databaseadmin: 0,
                    ITSS: 0,
                    webdev: 0,
                    progressPercentage: 0,
                    likelyToChooseText: "Take the assessment",
                    likelyToChooseJobs: "to know the suitable job for you",
                    isBold: false,
                  );
                } else {
                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  double softwaredev = (data['1'] as num).toDouble();
                  double networkadmin = (data['2'] as num).toDouble();
                  double databaseadmin = (data['3'] as num).toDouble();
                  double ITSS = (data['4'] as num).toDouble();
                  double webdev = (data['5'] as num).toDouble();

                  List<double> scores = [
                    softwaredev,
                    networkadmin,
                    databaseadmin,
                    ITSS,
                    webdev
                  ];
                  List<String> jobs = [
                    "Software Developer",
                    "Network Administrator",
                    "Database Administrator",
                    "IT Support Specialist",
                    "Web Developer",
                  ];

                  double maxScore = scores.reduce((a, b) => a > b ? a : b);
                  List<String> topJobs = [];

                  for (int i = 0; i < scores.length; i++) {
                    if (scores[i] == maxScore) {
                      topJobs.add(jobs[i]);
                    }
                  }

                  String likelyToChooseText;
                  String likelyToChooseJobs;
                  bool isBold = true;

                  if (topJobs.length == 1) {
                    likelyToChooseText = "More likely to choose";
                    likelyToChooseJobs = topJobs[0];
                  } else if (topJobs.length == 2) {
                    likelyToChooseText = "You excelled in two jobs!";
                    likelyToChooseJobs = "Check the details below.";
                    isBold = false;
                  } else if (topJobs.length == 3) {
                    likelyToChooseText = "You excelled in three jobs!";
                    likelyToChooseJobs = "Check the details below.";
                    isBold = false;
                  } else {
                    likelyToChooseText = "You are a good fit in all jobs!";
                    likelyToChooseJobs = "Check the details below.";
                    isBold = false;
                  }

                  return _buildResultPage(
                    context,
                    softwaredev: softwaredev,
                    networkadmin: networkadmin,
                    databaseadmin: databaseadmin,
                    ITSS: ITSS,
                    webdev: webdev,
                    progressPercentage: 80,
                    likelyToChooseText: likelyToChooseText,
                    likelyToChooseJobs: likelyToChooseJobs,
                    isBold: isBold,
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.10,
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
                      MaterialPageRoute(builder: (context) => const Home4th()),
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
                    //   MaterialPageRoute(
                    //       builder: (context) => const SearchG10()),
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
              left: MediaQuery
                  .of(context)
                  .size
                  .width / 2 - iconSize,
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
                              builder: (context) => const FourthIntro()),
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

  Future<DocumentSnapshot> _getUserResult() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }
    return FirebaseFirestore.instance
        .collection('userResult4th')
        .doc(user.uid)
        .get();
  }

  Widget _buildResultPage(BuildContext context, {
    required double softwaredev,
    required double networkadmin,
    required double databaseadmin,
    required double ITSS,
    required double webdev,
    required String likelyToChooseText,
    required String likelyToChooseJobs,
    required bool isBold,
    required int progressPercentage,
  }) {
    double totalMaxScore = softwaredev + networkadmin + databaseadmin + ITSS +
        webdev;
    List<Map<String, dynamic>> jobs = [
      {"label": "Software Developer", "score": softwaredev},
      {"label": "Network Administrator", "score": networkadmin},
      {"label": "Database Administrator", "score": databaseadmin},
      {"label": "IT Support Specialist", "score": ITSS},
      {"label": "Web Developer", "score": webdev},
    ];

    jobs.sort((a, b) => b['score'].compareTo(a['score'])); // Sort by score

    // Calculate the maximum score and the percentage of the top job
    double maxScore = jobs[0]['score']; // Assuming the first job is the top job
    double calculatedProgressPercentage = totalMaxScore > 0 ? (maxScore /
        totalMaxScore) * 100 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 110),
            // Ensures the scroll starts 110 pixels from the top
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator(
                                value: calculatedProgressPercentage / 100,
                                strokeWidth: 10,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.red),
                                backgroundColor: Colors.red.shade100,
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 143, 29, 21),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${calculatedProgressPercentage
                                      .toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        likelyToChooseText,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        likelyToChooseJobs,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isBold ? FontWeight.bold : FontWeight
                              .normal,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 158, 39, 39),
                              Colors.pink.shade100,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 4,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Results',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AssessmentHistory4th(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'View details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            for (var job in jobs)
                              AssessmentContainer(
                                label: job['label'],
                                score: job['score'],
                                totalMaxScore: totalMaxScore,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

  class AssessmentContainer extends StatelessWidget {
  final String label;
  final double score;
  final double totalMaxScore;

  const AssessmentContainer({
    super.key,
    required this.label,
    required this.score,
    required this.totalMaxScore,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = totalMaxScore > 0 ? (score / totalMaxScore) * 100 : 0;

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(3)}%',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: totalMaxScore > 0 ? (score / totalMaxScore) : 0,
            backgroundColor: Colors.grey.shade200,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
