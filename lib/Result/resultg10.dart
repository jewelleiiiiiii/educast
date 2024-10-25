import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educast/Assessment/assess1g10.dart';
import 'package:educast/Assessment/assess4g10.dart';
import 'package:educast/Search/searchg10.dart';
import '../Assessment/AssessmentHistory/AssessmentHistoryG10.dart';
import '../Home/homeg10.dart';
import '../Notification/notification_page.dart';

class ResultG10 extends StatefulWidget {
  @override
  _ResultG10State createState() => _ResultG10State();
}

class _ResultG10State extends State<ResultG10> {
  late Future<DocumentSnapshot> _userResult;

  @override
  void initState() {
    super.initState();
    _userResult = _getUserResult();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make the status bar transparent
      statusBarBrightness:
          Brightness.light, // Ensure the status bar text is readable (white)
    ));
    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
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
                      humssScore: 0,
                      abmScore: 0,
                      stemScore: 0,
                      gasScore: 0,
                      progressPercentage: 0,
                      likelyToChooseText: "Take the assessment",
                      likelyToChooseStrand:
                          "to know the suitable strand for you",
                      isBold: false,
                    );
                  } else {
                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    double humssScore = (data['Social'] as num).toDouble();
                    double abmScore =
                        ((data['Enterprising'] as num).toDouble() +
                                (data['Conventional'] as num).toDouble()) /
                            2;
                    double stemScore = ((data['Realistic'] as num).toDouble() +
                            (data['Investigative'] as num).toDouble()) /
                        2;
                    double gasScore = (data['Artistic'] as num).toDouble();

                    List<double> scores = [
                      humssScore,
                      abmScore,
                      stemScore,
                      gasScore
                    ];
                    List<String> strands = [
                      "Humanities, and Social Sciences",
                      "Accountancy, Business, and Management",
                      "Science, Technology, Engineering, and Mathematics",
                      "General Academic Strand"
                    ];

                    double maxScore = scores.reduce((a, b) => a > b ? a : b);
                    List<String> topStrands = [];

                    for (int i = 0; i < scores.length; i++) {
                      if (scores[i] == maxScore) {
                        topStrands.add(strands[i]);
                      }
                    }

                    String likelyToChooseText;
                    String likelyToChooseStrand;
                    bool isBold = true;

                    if (topStrands.length == 1) {
                      likelyToChooseText = "More likely to choose";
                      likelyToChooseStrand = topStrands[0];
                    } else if (topStrands.length == 2) {
                      likelyToChooseText = "You excelled in two strands!";
                      likelyToChooseStrand = "Check the details below.";
                      isBold = false;
                    } else if (topStrands.length == 3) {
                      likelyToChooseText = "You excelled in three strands!";
                      likelyToChooseStrand = "Check the details below.";
                      isBold = false;
                    } else {
                      likelyToChooseText = "You are a good fit in all strands!";
                      likelyToChooseStrand = "Check the details below.";
                      isBold = false;
                    }

                    return _buildResultPage(
                      context,
                      humssScore: humssScore,
                      abmScore: abmScore,
                      stemScore: stemScore,
                      gasScore: gasScore,
                      progressPercentage: 80,
                      likelyToChooseText: likelyToChooseText,
                      likelyToChooseStrand: likelyToChooseStrand,
                      isBold: isBold,
                    );
                  }
                },
              ),
            ),
          ],
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
                                const HomeG10(gradeLevel: "10")),
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
                        MaterialPageRoute(
                            builder: (context) => const SearchG10()),
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
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        final user = FirebaseAuth.instance.currentUser;

                        return NotificationPage(uuid: user!.uid);
                      }));
                    },
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
                                builder: (context) => SubmissionConfirmation()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const Questionnaire1G10()),
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
      ),
    );
  }

  Future<DocumentSnapshot> _getUserResult() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }
    return FirebaseFirestore.instance
        .collection('userResultG10')
        .doc(user.uid)
        .get();
  }

  Widget _buildResultPage(
    BuildContext context, {
    required double humssScore,
    required double abmScore,
    required double stemScore,
    required double gasScore,
    required String likelyToChooseText,
    required String likelyToChooseStrand,
    required bool isBold,
    required int progressPercentage,
  }) {
    List<Map<String, dynamic>> strands = [
      {"label": "HUMSS", "score": humssScore},
      {"label": "ABM", "score": abmScore},
      {"label": "STEM", "score": stemScore},
      {"label": "GAS", "score": gasScore},
    ];

    strands.sort((a, b) => b['score'].compareTo(a['score']));

    double totalMaxScore = humssScore + abmScore + stemScore + gasScore;
    double calculatedProgressPercentage = 0;

    // Set default progress to 0 if there is no data
    if (totalMaxScore > 0) {
      for (var strand in strands) {
        double score = strand['score'];
        double percentage = (score / totalMaxScore) * 100;
        print(
            '${strand['label']}: $score / $totalMaxScore = ${score / totalMaxScore}');
        print('Percent: ${percentage.toStringAsFixed(2)}%');
      }

      // Determine the top strands and calculate the progress
      List<double> scores = [humssScore, abmScore, stemScore, gasScore];
      double maxScore = scores.reduce((a, b) => a > b ? a : b);
      List<String> topStrands = [];

      for (int i = 0; i < scores.length; i++) {
        if (scores[i] == maxScore) {
          topStrands.add(strands[i]['label']);
        }
      }

      if (topStrands.isNotEmpty) {
        if (topStrands.length == 1) {
          calculatedProgressPercentage = maxScore / totalMaxScore * 100;
        } else if (topStrands.length == 2) {
          calculatedProgressPercentage =
              (scores[strands.indexWhere((s) => s['label'] == topStrands[0])] +
                      scores[strands
                          .indexWhere((s) => s['label'] == topStrands[1])]) /
                  (2 * totalMaxScore) *
                  100;
        } else if (topStrands.length == 3) {
          calculatedProgressPercentage =
              (scores[strands.indexWhere((s) => s['label'] == topStrands[0])] +
                      scores[strands
                          .indexWhere((s) => s['label'] == topStrands[1])] +
                      scores[strands
                          .indexWhere((s) => s['label'] == topStrands[2])]) /
                  (3 * totalMaxScore) *
                  100;
        } else {
          calculatedProgressPercentage =
              (scores[0] + scores[1] + scores[2] + scores[3]) /
                  (4 * totalMaxScore) *
                  100;
        }
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 110), // Ensures the scroll starts 110 pixels from the top
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Padding for the progress indicator to fine-tune its top space
                      Padding(
                        padding: const EdgeInsets.only(
                            top:
                                5), // Adjust to control the space above the progress indicator
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator(
                                value: calculatedProgressPercentage / 100,
                                strokeWidth: 10,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
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
                                  '${calculatedProgressPercentage.toStringAsFixed(2)}%',
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
                        likelyToChooseStrand,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              isBold ? FontWeight.bold : FontWeight.normal,
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
                                            AssessmentHistoryG10(),
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
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            for (var strand in strands)
                              AssessmentContainer(
                                label: strand['label'],
                                score: strand['score'],
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
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(2)}%',
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
