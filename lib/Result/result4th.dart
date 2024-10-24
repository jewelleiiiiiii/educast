import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Assessment/AssessmentHistory/AssessmentHistory4th.dart';
import 'package:educast/Assessment/Rules/4thIntro.dart';
import 'package:educast/Assessment/assess34th.dart';
import 'package:educast/Home/Home4th.dart';
import 'package:educast/Search/search4th.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Result4th extends StatefulWidget {
  @override
  _Result4th createState() => _Result4th();
}

class _Result4th extends State<Result4th> {
  late Future<DocumentSnapshot> _userResult;
  late Future<String> _userCourse;


  @override
  void initState() {
    super.initState();
    _userResult = _getUserResult();
    _userCourse = _getUserCourse(); // Fetch the user's course
  }

  Future<String> _getUserCourse() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      // Cast the data to a Map<String, dynamic>
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      return data?['course'] ?? ''; // Adjust field name accordingly
    } else {
      throw Exception("User document does not exist.");
    }
  }


  Future<List<String>> _getJobsBasedOnCourse(String course) async {
    List<String> jobs = [];

    try {
      // Retrieve the document from Firestore
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('JobsperProgram')
          .doc(course)
          .get();

      // Check if the document exists
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        // Ensure data is not null and iterate through the fields (1-5)
        if (data != null) {
          for (int i = 1; i <= 5; i++) {
            String job = data['$i'] as String? ?? '';  // Safely cast and check for null
            jobs.add(job);
          }
        }
      }

      print("Jobs fetched for course $course: $jobs");
    } catch (e) {
      print("Error fetching jobs for course $course: $e");
    }

    // If jobs are empty, populate it with default job titles
    if (jobs.isEmpty) {
      jobs = ['Job Title 1', 'Job Title 2', 'Job Title 3', 'Job Title 4', 'Job Title 5'];
    }

    return jobs;
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make the status bar transparent
      statusBarBrightness: Brightness.light,
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
              future: _userResult,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Something went wrong"));
                }

                // User result document does not exist
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  // Fetch user's course first
                  return FutureBuilder<String>(
                    future: _userCourse,
                    builder: (context, courseSnapshot) {
                      if (courseSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (courseSnapshot.hasError) {
                        return Center(child: Text("Could not fetch course"));
                      }

                      String course = courseSnapshot.data ?? '';

                      // Fetch jobs based on course since user result does not exist
                      return FutureBuilder<List<String>>(
                        future: _getJobsBasedOnCourse(course),
                        builder: (context, jobSnapshot) {
                          if (jobSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (jobSnapshot.hasError) {
                            return Center(child: Text("Could not fetch jobs"));
                          }

                          List<String> jobs = jobSnapshot.data ?? [];

                          // Create a dummy score list for job scores
                          double firstjob = 0.0;
                          double secondjob = 0.0;
                          double thirdjob = 0.0;
                          double fourthjob = 0.0;
                          double fifthjob = 0.0;

                          double totalMaxScore = firstjob + secondjob + thirdjob + fourthjob + fifthjob;
                          double maxScore = 0; // No scores available
                          double progressPercentage = totalMaxScore > 0 ? (maxScore / totalMaxScore) * 100 : 0;

                          return _buildResultPage(
                            context,
                            firstjob: firstjob,
                            secondjob: secondjob,
                            thirdjob: thirdjob,
                            fourthjob: fourthjob,
                            fifthjob: fifthjob,
                            progressPercentage: progressPercentage.toInt(),
                            likelyToChooseText: "Take the assessment",
                            likelyToChooseJobs: "to know the suitable job for you",
                            isBold: false,
                            jobs: jobs,
                          );
                        },
                      );
                    },
                  );
                }

                var data = snapshot.data!.data() as Map<String, dynamic>;
                double firstjob = (data['1'] as num?)?.toDouble() ?? 0.0;
                double secondjob = (data['2'] as num?)?.toDouble() ?? 0.0;
                double thirdjob = (data['3'] as num?)?.toDouble() ?? 0.0;
                double fourthjob = (data['4'] as num?)?.toDouble() ?? 0.0;
                double fifthjob = (data['5'] as num?)?.toDouble() ?? 0.0;

                return FutureBuilder<String>(
                  future: _userCourse,
                  builder: (context, courseSnapshot) {
                    if (courseSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (courseSnapshot.hasError) {
                      return Center(child: Text("Could not fetch course"));
                    }

                    String course = courseSnapshot.data ?? '';

                    // Fetch jobs based on course
                    return FutureBuilder<List<String>>(
                      future: _getJobsBasedOnCourse(course),
                      builder: (context, jobSnapshot) {
                        if (jobSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (jobSnapshot.hasError) {
                          return Center(child: Text("Could not fetch jobs"));
                        }

                        List<String> jobs = jobSnapshot.data ?? [];

                        double totalMaxScore = firstjob + secondjob + thirdjob + fourthjob + fifthjob;
                        double maxScore = [firstjob, secondjob, thirdjob, fourthjob, fifthjob].reduce((a, b) => a > b ? a : b);
                        double progressPercentage = totalMaxScore > 0 ? (maxScore / totalMaxScore) * 100 : 0;

                        return _buildResultPage(
                          context,
                          firstjob: firstjob,
                          secondjob: secondjob,
                          thirdjob: thirdjob,
                          fourthjob: fourthjob,
                          fifthjob: fifthjob,
                          progressPercentage: progressPercentage.toInt(),
                          likelyToChooseText: "More likely to choose",
                          likelyToChooseJobs: jobs.isNotEmpty ? jobs.first : 'No job available',
                          isBold: true,
                          jobs: jobs,
                        );
                      },
                    );
                  },
                );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Search4th()),
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

    DocumentSnapshot userResultDoc = await FirebaseFirestore.instance
        .collection('userResult4th')
        .doc(user.uid)
        .get();

    return userResultDoc; // Return the document
  }

  Widget _buildResultPage(BuildContext context, {
    required double firstjob,
    required double secondjob,
    required double thirdjob,
    required double fourthjob,
    required double fifthjob,
    required String likelyToChooseText,
    required String likelyToChooseJobs,
    required bool isBold,
    required int progressPercentage,
    required List<String> jobs,
  }) {
    List<Map<String, dynamic>> jobResults = [
      {"label": jobs.length > 0 ? jobs[0] : 'No job available', "score": firstjob},
      {"label": jobs.length > 1 ? jobs[1] : 'No job available', "score": secondjob},
      {"label": jobs.length > 2 ? jobs[2] : 'No job available', "score": thirdjob},
      {"label": jobs.length > 3 ? jobs[3] : 'No job available', "score": fourthjob},
      {"label": jobs.length > 4 ? jobs[4] : 'No job available', "score": fifthjob},
    ];


    double totalMaxScore = firstjob + secondjob + thirdjob + fourthjob +
        fifthjob;
    jobResults.sort((a, b) => b['score'].compareTo(a['score']));
    // Calculate the maximum score and its frequency
    double maxScore = jobResults[0]['score']; // Top score
    List<Map<String, dynamic>> topJobs = jobResults.where((job) => job['score'] == maxScore).toList();
if (maxScore != 0.000){
    if (topJobs.length == 1) {
      likelyToChooseText = "More likely to choose";
      likelyToChooseJobs = topJobs[0]['label']; // Get the top job's label

    } else if (topJobs.length == 2) {
      likelyToChooseText = "You excelled in two jobs!";
      likelyToChooseJobs = "Check the details below.";
      isBold = false;
    } else if (topJobs.length == 3) {
      likelyToChooseText = "You excelled in three jobs!";
      likelyToChooseJobs = "Check the details below.";
      isBold = false;
    } else if (topJobs.length == 4) {
      likelyToChooseText = "You excelled in four jobs!";
      likelyToChooseJobs = "Check the details below.";
      isBold = false;
    } else if (topJobs.length == 5) {
      likelyToChooseText = "You are a good fit in all jobs!";
      likelyToChooseJobs = "Check the details below.";
      isBold = false;
    } else {
      likelyToChooseText = "Please take the assessment";
      likelyToChooseJobs = "to know the suitable job for you!";
      isBold = false;
    }}
else
  {
    likelyToChooseText = "Please take the assessment";
    likelyToChooseJobs = "to know the suitable job for you!";
    isBold = false;
  }

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
                      Text(likelyToChooseText, style: TextStyle(
                        fontSize: 15,
                      ),), SizedBox(height: 5),
                      topJobs.length == 1
                          ? Text(
                        likelyToChooseJobs,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Make the text bold if condition is met
                          fontSize: 20,
                        ),
                      )
                          : Text(likelyToChooseJobs), // Regular text if condition is not met
                      SizedBox(height: 15),
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
                          for (var job in jobResults) // Change here
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
