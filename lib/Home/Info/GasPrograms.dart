import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Assessment/Rules/G12Intro.dart';
import 'package:educast/Assessment/assess2g12.dart';
import 'package:educast/Home/Info/automotive.dart';
import 'package:educast/Home/Info/civil.dart';
import 'package:educast/Home/Info/computer.dart';
import 'package:educast/Home/Info/drafting.dart';
import 'package:educast/Home/Info/electrical.dart';
import 'package:educast/Home/Info/electronics.dart';
import 'package:educast/Home/Info/food.dart';
import 'package:educast/Home/Info/mechanical.dart';
import 'package:educast/Home/Info/mechatronics.dart';
import 'package:educast/Home/homeg12.dart';
import 'package:educast/Result/resultG12.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:educast/Search/searchg12.dart';

class GasPrograms extends StatefulWidget {
  const GasPrograms({
    super.key,
  });

  @override
  _GasPrograms createState() => _GasPrograms();
}

class _GasPrograms extends State<GasPrograms> {
  String? userStrand;
  List<String> courses = [];
  String relatedProgramsText = '';

  @override
  void initState() {
    super.initState();
    _fetchUserStrand();
  }

  void _fetchUserStrand() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userStrand = userDoc['strand'];
        _updateCoursesBasedOnStrand(userStrand!);
        _updateRelatedProgramsText(userStrand!);
      });
    }
  }

  void _updateRelatedProgramsText(String strand) {
    if (strand == 'Science, Technology, Engineering, and Mathematics') {
      relatedProgramsText = 'STEM-Related Programs';
    } else if (strand == 'Accountancy, Business, and Management') {
      relatedProgramsText = 'ABM-Related Programs';
    } else if (strand == 'Humanities and Social Sciences') {
      relatedProgramsText = 'HUMSS-Related Programs';
    } else if (strand == 'General Academic Strand') {
      relatedProgramsText = 'GAS-Related Programs';
    }
  }

  void _updateCoursesBasedOnStrand(String strand) {
    if (strand == 'Science, Technology, Engineering, and Mathematics') {
      courses = [
        'BAET',
        'BCivET',
        'BCompET',
        'BDT',
        'BElecET',
        'BElectroET',
        'BFET',
        'BMechET',
        'BMechtronET',
        'BSCrim',
        'BSIT',
        'BSPsych',
      ];
    } else if (strand == 'Accountancy, Business, and Management') {
      courses = ['BSCrim'];
    } else if (strand == 'Humanities and Social Sciences') {
      courses = ['BSCrim', 'BSPsych'];
    } else if (strand == 'General Academic Strand') {
      courses = [
        'BAET',
        'BCivET',
        'BCompET',
        'BDT',
        'BElecET',
        'BElectroET',
        'BFET',
        'BMechET',
        'BMechtronET',
        'BSCrim',
        'BSPsych',
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final iconSize = screenWidth * 0.10;
    final paddingHorizontal = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Image.asset(
                    'assets/back.png', // Path to your back.png
                    width: 24, // Adjust the size as needed
                    height: 24,
                  ),
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigates back to the previous page
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.05,
                    screenHeight * 0.02,
                    screenWidth * 0.05,
                    screenHeight * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        relatedProgramsText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 8.0),

                      // Adding horizontal line (Divider)
                      Divider(color: Colors.black, thickness: 1.0),

                      // Adding College of Engineering Technology text
                      SizedBox(height: 8.0),
                      Text(
                        'College of Engineering Technology',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      // First Courses Grid
                      Container(
                        height: 350.0,
                        color: Colors.transparent,
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 2.5,
                          ),
                          itemCount: userStrand == 'General Academic Strand'
                              ? 9
                              : courses.length > 4
                                  ? 4
                                  : courses.length,
                          itemBuilder: (context, index) {
                            List<Gradient> gradients = [
                              LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.purpleAccent.shade100
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              LinearGradient(
                                colors: [
                                  Colors.teal.shade300,
                                  Colors.cyan.shade100
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                              LinearGradient(
                                colors: [
                                  Colors.pink.shade600,
                                  Colors.orange.shade300
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              LinearGradient(
                                colors: [
                                  Colors.indigo.shade500,
                                  Colors.blueGrey.shade200
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              LinearGradient(
                                colors: [
                                  Colors.greenAccent.shade400,
                                  Colors.yellow.shade300,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              LinearGradient(
                                colors: [
                                  Colors.redAccent.shade200,
                                  Colors.deepOrange.shade300,
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                              LinearGradient(
                                colors: [
                                  Colors.lightBlueAccent.shade100,
                                  Colors.deepPurpleAccent.shade200,
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              LinearGradient(
                                colors: [
                                  Colors.lime.shade300,
                                  Colors.lightGreen.shade200,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              LinearGradient(
                                colors: [
                                  Colors.cyan.shade400,
                                  Colors.lightBlue.shade300,
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                              ),
                            ];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  navigateToCoursePage(context, courses[index]);
                                },
                                borderRadius: BorderRadius.circular(16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: gradients[index],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          courses[index],
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Adding College of Arts and Science text
                      SizedBox(height: 16.0),
                      Text(
                        'College of Arts and Science',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      // Second Courses Grid (Last 2 courses)
                      Container(
                        height: 80.0,
                        color: Colors.transparent,
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 2.5,
                          ),
                          itemCount: courses.length >= 2 ? 2 : 0,
                          itemBuilder: (context, index) {
                            int courseIndex = courses.length - 2 + index;
                            List<Gradient> gradients = [
                              LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.purpleAccent.shade100
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              LinearGradient(
                                colors: [
                                  Colors.teal.shade300,
                                  Colors.cyan.shade100
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                            ];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  navigateToCoursePage(
                                      context, courses[courseIndex]);
                                },
                                borderRadius: BorderRadius.circular(16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: gradients[index],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          courses[courseIndex],
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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

  void navigateToCoursePage(BuildContext context, String course) {
    switch (course) {
      case 'BAET':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Automotive()),
        );
        break;
      case 'BCivET':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Civil()),
        );
        break;
      case 'BCompET':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Computer()),
        );
        break;
      case 'BDT':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Drafting()),
        );
        break;
      case 'BElecET':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Electrical()),
        );
        break;
      case 'BElectroET':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Electronics()),
        );
        break;
      case 'BFET':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Food()),
        );
        break;
      case 'BMechET':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Mechanical()),
        );
        break;
      case 'BMechtronET':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Mechatronics()),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeG12(gradeLevel: "12")),
        );
    }
  }
}
