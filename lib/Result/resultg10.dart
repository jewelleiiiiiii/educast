import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/Assessment/assess1g10.dart';
import 'package:myapp/Search/searchg10.dart';
import '../Assessment/AssessmentHistory/AssessmentHistoryG10.dart';
import '../Home/homeg10.dart';

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

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 158, 39, 39),
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      body: SafeArea(
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
                likelyToChooseStrand: "to know the suitable strand for you",
                isBold: false,
              );
            } else {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              double humssScore = (data['Social'] as num).toDouble();
              double abmScore = ((data['Enterprising'] as num).toDouble() + (data['Conventional'] as num).toDouble()) / 2;
              double stemScore = ((data['Realistic'] as num).toDouble() + (data['Investigative'] as num).toDouble()) / 2;
              double gasScore = (data['Artistic'] as num).toDouble();

              // Determine the highest score(s)
              List<double> scores = [humssScore, abmScore, stemScore, gasScore];
              List<String> strands = ["Humanities, and Social Sciences",
                "Accountancy, Business, and Management",
                "Science, Technology, Engineering, and Mathematics",
                "General Academic Strand"];
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
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Future<DocumentSnapshot> _getUserResult() async {
    User? user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('userResultG10')
        .doc(user!.uid)
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
    // Create a list of maps to store strand data
    List<Map<String, dynamic>> strands = [
      {"label": "HUMSS", "score": humssScore},
      {"label": "ABM", "score": abmScore},
      {"label": "STEM", "score": stemScore},
      {"label": "GAS", "score": gasScore},
    ];

    // Sort the strands by score in descending order
    strands.sort((a, b) => b['score'].compareTo(a['score']));

    // Calculate the total max score
    double totalMaxScore = humssScore + abmScore + stemScore + gasScore;
    print('Total Max Score: $totalMaxScore');

    // Print calculations and percentages for each strand
    for (var strand in strands) {
      double score = strand['score'];
      double percentage = totalMaxScore > 0 ? (score / totalMaxScore) * 100 : 0;
      print('${strand['label']}: $score / $totalMaxScore = ${score / totalMaxScore}');
      print('Percent: ${percentage.toStringAsFixed(2)}%');
    }

    // Calculate the score percentage based on the tied scenarios
    double calculatedProgressPercentage;

    List<double> scores = [humssScore, abmScore, stemScore, gasScore];
    double maxScore = scores.reduce((a, b) => a > b ? a : b);
    List<String> topStrands = [];

    for (int i = 0; i < scores.length; i++) {
      if (scores[i] == maxScore) {
        topStrands.add(strands[i]['label']);
      }
    }

    // Ensure that there are no out-of-bound errors
    if (topStrands.isNotEmpty) {
      if (topStrands.length == 1) {
        // Single highest strand
        calculatedProgressPercentage = maxScore / totalMaxScore * 100;
      } else if (topStrands.length == 2) {
        // Two strands tied
        calculatedProgressPercentage = (scores[strands.indexWhere((s) => s['label'] == topStrands[0])] +
            scores[strands.indexWhere((s) => s['label'] == topStrands[1])]) /
            (2 * totalMaxScore) * 100;
      } else if (topStrands.length == 3) {
        // Three strands tied
        calculatedProgressPercentage = (scores[strands.indexWhere((s) => s['label'] == topStrands[0])] +
            scores[strands.indexWhere((s) => s['label'] == topStrands[1])] +
            scores[strands.indexWhere((s) => s['label'] == topStrands[2])]) /
            (3 * totalMaxScore) * 100;
      } else {
        // All four strands tied
        calculatedProgressPercentage = (scores[0] + scores[1] + scores[2] + scores[3]) /
            (4 * totalMaxScore) * 100;
      }
    } else {
      calculatedProgressPercentage = 0; // Fallback value
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.12,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 158, 39, 39),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0),
            ),
          ),
          child: Stack(
            children: const [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'My Results',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 40),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: calculatedProgressPercentage / 100,
                            strokeWidth: 10,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
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
                              '${calculatedProgressPercentage.toStringAsFixed(2)}%', // Updated to 2 decimal points
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
                        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
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
                                      builder: (context) => AssessmentHistoryG10(), // Replace with the screen you want to navigate to
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
                          // Display the sorted strands with updated percentages
                          for (var strand in strands)
                            AssessmentContainer(
                              label: strand['label'],
                              score: strand['score'],
                              totalMaxScore: totalMaxScore,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
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
                MaterialPageRoute(builder: (context) => const Questionnaire1G10()),
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
    );
  }
}

class AssessmentContainer extends StatelessWidget {
  final String label;
  final double score;
  final double totalMaxScore;

  const AssessmentContainer({super.key,
    required this.label,
    required this.score,
    required this.totalMaxScore,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the percentage based on score and totalScore
    double percentage = totalMaxScore > 0 ? (score / totalMaxScore) * 100 : 0;

    return Container(
      margin: EdgeInsets.only(bottom: 20), // Increased bottom margin for spacing
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
                '${percentage.toStringAsFixed(2)}%', // Show percentage with two decimal points
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
            color: Colors.red, // Adjust as needed
          ),
        ],
      ),
    );
  }
}
