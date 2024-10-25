import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Assessment/Rules/G12Intro.dart';
import 'package:educast/Assessment/assess2g12.dart';
import 'package:educast/Home/homeg12.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    _userData = _fetchUserData(); // Initialize the future properly
  }

  final Map<String, int> maxScores = {
    'BAET': 255,
    'BCivET': 265,
    'BCompET': 295,
    'BDT': 215,
    'BElecET': 270,
    'BElectroET': 275,
    'BFET': 295,
    'BMechET': 265,
    'BMechtronET': 280,
    'BSCrim': 335,
    'BSIT': 300,
    'BSPsych': 295,
  };

  final Map<String, List<int>> programWeights = {
    'BAET': [5, 5, 2, 4, 2, 1, 4, 5, 5, 3, 2, 5, 2, 2, 4],
    'BCivET': [4, 5, 2, 5, 2, 1, 4, 5, 5, 4, 2, 5, 2, 2, 5],
    'BCompET': [4, 3, 3, 5, 3, 3, 4, 5, 5, 5, 3, 5, 3, 3, 5],
    'BDT': [3, 5, 2, 3, 1, 1, 5, 4, 4, 3, 2, 4, 1, 2, 3],
    'BElecET': [5, 4, 2, 5, 2, 2, 4, 5, 5, 4, 2, 5, 2, 2, 5],
    'BElectroET': [5, 4, 2, 5, 2, 2, 4, 5, 5, 5, 2, 5, 2, 2, 5],
    'BFET': [4, 4, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
    'BMechET': [5, 5, 2, 5, 2, 1, 4, 5, 5, 4, 2, 5, 2, 2, 4],
    'BMechtronET': [5, 4, 2, 5, 2, 2, 5, 5, 5, 4, 3, 5, 2, 2, 5],
    'BSIT': [3, 3, 4, 5, 4, 5, 4, 5, 5, 5, 5, 5, 4, 5, 5],
    'BSCrim': [2, 3, 5, 3, 5, 5, 4, 4, 3, 3, 5, 5, 5, 5, 3],
    'BSPsych': [1, 2, 5, 3, 5, 5, 3, 4, 3, 3, 5, 5, 5, 5, 5],
  };

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final iconSize = screenWidth * 0.10;
    final paddingHorizontal = screenWidth * 0.04;

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
                var strand = userData['strand'] ?? 'Unknown';
                var userResult = userData['userResult'];

                print(userData);
                print(strand);
                print(userResult);

                List<int> userScores = [
                  userResult['Mechanical Reasoning'] ?? 0,
                  userResult['Spatial Reasoning'] ?? 0,
                  userResult['Verbal Reasoning'] ?? 0,
                  userResult['Numerical Ability'] ?? 0,
                  userResult['Language Usage'] ?? 0,
                  userResult['Word Knowledge'] ?? 0,
                  userResult['Perceptual Speed and Accuracy'] ?? 0,
                  userResult['Analytical Ability'] ?? 0,
                  userResult['Basic Operations'] ?? 0,
                  userResult['Word Problems'] ?? 0,
                  userResult['Word Association'] ?? 0,
                  userResult['Logic'] ?? 0,
                  userResult['Grammar and Correct Usage'] ?? 0,
                  userResult['Vocabulary'] ?? 0,
                  userResult['Data Interpretation'] ?? 0
                ];

                final topProgramInfo = _calculateTopPrograms(userScores, strand);
                // Get the top program percentage
                double calculatedProgressPercentage = topProgramInfo['topProgram'] != ''
                    ? topProgramInfo['programPercentages'][topProgramInfo['topProgram']]
                    : 0;

                return _buildResultPage(
                  context,
                  assessmentLabels: assessmentLabels,
                  progressPercentage: calculatedProgressPercentage,
                  likelyToChooseText: topProgramInfo['likelyToChooseText'],
                  likelyToChoosePrograms: topProgramInfo['likelyToChoosePrograms'],
                  isBold: topProgramInfo['isBold'],
                  totalScores: topProgramInfo['totalScores'],
                  programPercentages: topProgramInfo['programPercentages'],
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
  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }

    // Fetch the user's strand from 'users' collection
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      // If the user document does not exist, set default messages
      // Return an empty result or handle as needed
      return {
        'strand': null,
        'userResult': null,
      };
    }

    // Fetch user result from 'userResultG12' collection
    DocumentSnapshot resultDoc = await FirebaseFirestore.instance
        .collection('userResultG12')
        .doc(user.uid)
        .get();

    // If resultDoc does not exist, set userResult to default scores
    var userResult = resultDoc.exists ? resultDoc.data() : {
      'Mechanical Reasoning': 0,
      'Spatial Reasoning': 0,
      'Verbal Reasoning': 0,
      'Numerical Ability': 0,
      'Language Usage': 0,
      'Word Knowledge': 0,
      'Perceptual Speed and Accuracy': 0,
      'Analytical Ability': 0,
      'Basic Operations': 0,
      'Word Problems': 0,
      'Word Association': 0,
      'Logic': 0,
      'Grammar and Correct Usage': 0,
      'Vocabulary': 0,
      'Data Interpretation': 0,
    };

    // Combine the fetched data
    final userStrand = userDoc['strand'];

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
      assessmentLabels = []; // Handle unknown strand case
    }

    return {
      'strand': userStrand,
      'userResult': userResult,
    };
  }
  Map<String, dynamic> _calculateTopPrograms(List<int> userScores, String userStrand) {
    Map<String, double> totalScores = {};
    double grandTotalScore = 0;

    // Default values for likelyToChooseText and likelyToChoosePrograms
    String likelyToChooseText = "Take the assessment to know the ";
    String likelyToChoosePrograms = "suitable programs available for you!";
    bool isBold = false;

    // Check if userScores is empty or all scores are zero
    if (userScores.isEmpty || userScores.every((score) => score == 0)) {
      return {
        'likelyToChooseText': likelyToChooseText,
        'likelyToChoosePrograms': likelyToChoosePrograms,
        'isBold': isBold,
        'totalScores': totalScores, // Correct type
        'programPercentages': <String, double>{}, // Correct type
        'topProgram': '',
      };
    }

    // Calculate total scores for each program
    programWeights.forEach((program, weights) {
      double totalScore = 0;
      for (int i = 0; i < userScores.length; i++) {
        totalScore += userScores[i] * weights[i];
      }
      totalScores[program] = totalScore;
      grandTotalScore += totalScore;
    });

    // Calculate program percentages
    Map<String, double> programPercentages = {};
    totalScores.forEach((program, score) {
      double maxScore = maxScores[program]!.toDouble(); // Use maxScores map
      double percentage = (score / maxScore) * 100; // Percentage calculation
      programPercentages[program] = percentage;
    });

    // Filter allowed programs based on user's strand
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
        allowedPrograms = []; // No allowed programs if strand is unknown
    }

    // Filter programPercentages to only include allowed programs
    Map<String, double> allowedProgramPercentages = Map.fromEntries(
        programPercentages.entries.where((entry) => allowedPrograms.contains(entry.key))
    );

    // Check if there are any allowed programs
    String topProgram = '';
    if (allowedProgramPercentages.isNotEmpty) {
      // Find the top program based on the highest percentage
      topProgram = allowedProgramPercentages.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    // Update likelyToChooseText and likelyToChoosePrograms based on conditions
    if (topProgram.isNotEmpty) {
      likelyToChooseText = "More likely to choose";
      likelyToChoosePrograms = topProgram;
      isBold = true;
    } else if (allowedProgramPercentages.length == 2) {
      likelyToChooseText = "You excelled in two programs!";
      likelyToChoosePrograms = "Check the details below.";
      isBold = false;
    } else if (allowedProgramPercentages.length == 3) {
      likelyToChooseText = "You excelled in three programs!";
      likelyToChoosePrograms = "Check the details below.";
      isBold = false;
    } else if (allowedProgramPercentages.isEmpty) {
      likelyToChooseText = "No suitable programs found based on your strand.";
      likelyToChoosePrograms = "Please check the details below.";
      isBold = false;
    } else {
      likelyToChooseText = "You are a good fit in all programs!";
      likelyToChoosePrograms = "Check the details below.";
      isBold = false;
    }

    print("User Scores: $userScores");
    print("User Strand: $userStrand");

    return {
      'likelyToChooseText': likelyToChooseText,
      'likelyToChoosePrograms': likelyToChoosePrograms,
      'isBold': isBold,
      'totalScores': totalScores as Map<String, double>, // Explicit cast
      'programPercentages': programPercentages, // Explicitly typed
      'topProgram': topProgram, // Include the top program in the return data
    };
  }





  Widget _buildResultPage(BuildContext context, {
    required List<String> assessmentLabels,
    required String likelyToChooseText,
    required String likelyToChoosePrograms,
    required bool isBold,
    required double progressPercentage,
    required Map<String, double> totalScores,  // Added parameter
    required Map<String, double> programPercentages,  // Added parameter
  }) {
    double totalMaxScore = 0;
    List<Widget> widgets = [];


    List<Map<String, dynamic>> programs = assessmentLabels.map((label) {
      return {
        "label": label,
        "score": totalScores[label] ?? 0.0,
        "percentage": programPercentages[label] ?? 0.0, // Ensure percentage is passed
      };
    }).toList();

    double maxScore = programs.isNotEmpty ? programs[0]['score'] : 0;
    double calculatedProgressPercentage = totalMaxScore > 0 ? (maxScore /
        totalMaxScore) * 100 : 0;

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
                                value: progressPercentage /100,
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
                                  '${progressPercentage
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
                        likelyToChoosePrograms,
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
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => AssessmentHistoryG12(),
                                    //   ),
                                    // );
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
                            for (var program in programs) ...{  // Use spread operator
                              AssessmentContainer(
                                label: program['label'],
                                score: program['score'],
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
  final double score;
  final double percentage;

  const AssessmentContainer({
    super.key,
    required this.label,
    required this.score,
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
            value: percentage / 100, // Use the percentage for progress indicator
            backgroundColor: Colors.grey.shade200,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
