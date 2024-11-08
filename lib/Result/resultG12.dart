import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Assessment/AssessmentHistory/AssessmentHistoryG12.dart';
import 'package:educast/Assessment/Rules/G12Intro.dart';
import 'package:educast/Assessment/assess2g12.dart';
import 'package:educast/Home/homeg12.dart';
import 'package:educast/Search/searchg12.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Notification/notification_page.dart';

class ResultG12 extends StatefulWidget {
  @override
  _ResultG12 createState() => _ResultG12();
}

class _ResultG12 extends State<ResultG12> {
  Future<Map<String, dynamic>>? _userData;
  late List<String> assessmentLabels;

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/bg8.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Something went wrong"));
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text("No results found"));
                }

                var userData = snapshot.data!;
                var userStrand = userData['strand'] ?? 'Unknown';
                var userResult = userData['userResult'];

                // Calculate scores as described
                Map<String, double> calculatedScores = {};
                List<String> parameters = [
                  'Mechanical Reasoning', 'Spatial Reasoning', 'Verbal Reasoning',
                  'Numerical Ability', 'Language Usage', 'Word Knowledge',
                  'Perceptual Speed and Accuracy', 'Analytical Ability',
                  'Basic Operations', 'Word Problems', 'Word Association',
                  'Logic', 'Grammar and Correct Usage', 'Vocabulary',
                  'Data Interpretation'
                ];

                for (var parameter in parameters) {
                  double score = userResult[parameter] ?? 0.0;
                  double calculatedScore = (score / 5) * 100;
                  calculatedScores[parameter] = calculatedScore;
                }

                // Define allowed programs
                List<String> allowedPrograms;
                switch (userStrand) {
                  case "Science, Technology, Engineering, and Mathematics":
                    allowedPrograms = [
                      "BAET", "BCivET", "BCompET", "BDT", "BElecET", "BElectroET",
                      "BFET", "BMechET", "BMechtronET", "BSCrim", "BSIT", "BSPsych"
                    ];
                    break;
                  case "Accountancy, Business, and Management":
                    allowedPrograms = ["BSCrim"];
                    break;
                  case "Humanities and Social Sciences":
                    allowedPrograms = ["BSCrim", "BSPsych"];
                    break;
                  case "General Academic Strand":
                    allowedPrograms = [
                      "BAET", "BCivET", "BCompET", "BDT", "BElecET", "BElectroET",
                      "BFET", "BMechET", "BMechtronET", "BSCrim", "BSPsych"
                    ];
                    break;
                  default:
                    allowedPrograms = [];
                }

                // Calculate program percentages
                Map<String, double> programPercentages = {};
                Map<String, List<String>> programCriteria = {
                  'BAET': ['Mechanical Reasoning', 'Perceptual Speed and Accuracy', 'Spatial Reasoning', 'Numerical Ability'],
                  'BCivET': ['Analytical Ability', 'Spatial Reasoning', 'Data Interpretation', 'Grammar and Correct Usage'],
                  'BCompET': ['Logic', 'Basic Operations', 'Data Interpretation', 'Word Problems'],
                  'BDT': ['Analytical Ability', 'Spatial Reasoning', 'Vocabulary', 'Mechanical Reasoning'],
                  'BElecET': ['Logic', 'Numerical Ability', 'Perceptual Speed and Accuracy', 'Grammar and Correct Usage'],
                  'BElectroET': ['Basic Operations', 'Data Interpretation', 'Spatial Reasoning', 'Mechanical Reasoning'],
                  'BFET': ['Numerical Ability', 'Perceptual Speed and Accuracy', 'Word Knowledge', 'Grammar and Correct Usage'],
                  'BMechET': ['Analytical Ability', 'Mechanical Reasoning', 'Word Problems', 'Vocabulary'],
                  'BMechtronET': ['Logic', 'Mechanical Reasoning', 'Perceptual Speed and Accuracy', 'Verbal Reasoning'],
                  'BSIT': ['Analytical Ability', 'Logic', 'Data Interpretation', 'Word Association'],
                  'BSCrim': ['Analytical Ability', 'Logic', 'Perceptual Speed and Accuracy', 'Spatial Reasoning'],
                  'BSPsych': ['Verbal Reasoning', 'Vocabulary', 'Word Knowledge', 'Data Interpretation'],
                };

                for (var program in allowedPrograms) {
                  if (programCriteria.containsKey(program)) {
                    List<String> criteria = programCriteria[program]!;
                    double sum = criteria.fold(0.0, (total, param) => total + (calculatedScores[param] ?? 0.0));
                    double percentage = sum / criteria.length; // Average percentage
                    programPercentages[program] = percentage;
                  }
                }

                // Determine the top programs
                String likelyToChooseText;
                String likelyToChoosePrograms;
                bool isBold = true;
                double topPercentage = 0.0;

                if (calculatedScores.values.every((score) => score == 0.0)) {
                  likelyToChooseText = "Take the assessment to know";
                  likelyToChoosePrograms = "the suitable program for you";
                  isBold = false;
                } else {
                  var filteredProgramMatchCount = programPercentages.entries.where((entry) => allowedPrograms.contains(entry.key));

                  if (filteredProgramMatchCount.isNotEmpty) {
                    // Find the maximum percentage
                    double maxPercentage = filteredProgramMatchCount.map((entry) => entry.value).reduce((a, b) => a > b ? a : b);
                    topPercentage = maxPercentage;

                    // Find all programs that have the maximum percentage
                    var topPrograms = filteredProgramMatchCount
                        .where((entry) => entry.value == maxPercentage)
                        .map((entry) => entry.key)
                        .toList();

                    if (topPrograms.length > 1) {
                      likelyToChooseText = "You excelled in multiple programs!";
                      likelyToChoosePrograms = topPrograms.join(", ");
                    } else {
                      likelyToChooseText = "More likely to choose";
                      likelyToChoosePrograms = topPrograms.first;
                    }

                    isBold = true;
                  } else {
                    likelyToChooseText = "No suitable programs found based on your strand.";
                    likelyToChoosePrograms = "Please check the details below.";
                    isBold = false;
                  }
                }

                return _buildResultPage(
                  context,
                  assessmentLabels: assessmentLabels,
                  progressPercentage: topPercentage,
                  likelyToChooseText: likelyToChooseText,
                  likelyToChoosePrograms: likelyToChoosePrograms,
                  isBold: isBold,
                  programPercentages: programPercentages,
                );
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
                              const HomeG12(gradeLevel: "12")),
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

  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception("User document does not exist.");
    }

    DocumentSnapshot resultDoc = await FirebaseFirestore.instance
        .collection('userResultG12')
        .doc(user.uid)
        .get();

    final userStrand = userDoc['strand'];
    final userResult = resultDoc.exists ? resultDoc.data() : {
      'Mechanical Reasoning': 0.00,
      'Spatial Reasoning': 0.00,
      'Verbal Reasoning': 0.00,
      'Numerical Ability': 0.00,
      'Language Usage': 0.00,
      'Word Knowledge': 0.00,
      'Perceptual Speed and Accuracy': 0.00,
      'Analytical Ability': 0.00,
      'Basic Operations': 0.00,
      'Word Problems': 0.00,
      'Word Association': 0.00,
      'Logic': 0.00,
      'Grammar and Correct Usage': 0.00,
      'Vocabulary': 0.00,
      'Data Interpretation': 0.00
    };

    // Set assessmentLabels based on the strand
    if (userStrand == "Science, Technology, Engineering, and Mathematics") {
      assessmentLabels = [
        'BAET', 'BCivET', 'BCompET', 'BDT', 'BElecET', 'BElectroET',
        'BFET', 'BMechET', 'BMechtronET', 'BSCrim', 'BSIT', 'BSPsych'
      ];
    } else if (userStrand == "Accountancy, Business, and Management") {
      assessmentLabels = ['BSCrim'];
    } else if (userStrand == "Humanities and Social Sciences") {
      assessmentLabels = ['BSCrim', 'BSPsych'];
    } else if (userStrand == "General Academic Strand") {
      assessmentLabels = [
        'BAET', 'BCivET', 'BCompET', 'BDT', 'BElecET', 'BElectroET',
        'BFET', 'BMechET', 'BMechtronET', 'BSCrim', 'BSPsych'
      ];
    } else {
      assessmentLabels = [];
    }

    return {
      'strand': userStrand,
      'userResult': userResult,
    };
  }


  Widget _buildResultPage(
    BuildContext context, {
    required List<String> assessmentLabels,
    required String likelyToChooseText,
    required String likelyToChoosePrograms,
    required bool isBold,
    required double progressPercentage,
    required Map<String, double> programPercentages, // Added parameter
  }) {

    List<Widget> widgets = [];

    List<Map<String, dynamic>> programs = assessmentLabels.map((label) {
      return {
        "label": label,
        "percentage":
            programPercentages[label] ?? 0.0, // Ensure percentage is passed
      };
    }).toList();

    // Sort programs by percentage in descending order
    programs.sort((a, b) => b['percentage'].compareTo(a['percentage']));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 150),
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
                                value: progressPercentage / 100,
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
                                  '${progressPercentage.toStringAsFixed(2)}%',
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
                        likelyToChoosePrograms,
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
                                        builder: (context) => AssessmentHistoryG12(),
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
                            for (var program in programs) ...{
                              // Use spread operator
                              AssessmentContainer(
                                label: program['label'],

                                percentage: program['percentage'],
                              ),
                            },
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
  final double percentage;

  const AssessmentContainer({
    super.key,
    required this.label,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
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
            value:
                percentage / 100, // Use the percentage for progress indicator
            backgroundColor: Colors.grey.shade200,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
