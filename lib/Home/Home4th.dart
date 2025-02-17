import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Assessment/assess34th.dart';
import 'package:educast/Home/Drawer/About.dart';
import 'package:educast/Home/Drawer/Feedback.dart';
import 'package:educast/Home/Drawer/History.dart';
import 'package:educast/Home/Drawer/Settings.dart';
import 'package:educast/Home/Info/SoftwareDev.dart';
import 'package:educast/Result/result4th.dart';
import 'package:educast/Search/search4th.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:educast/Assessment/Rules/4thIntro.dart';
import 'package:educast/Home/User/User4th.dart';
import 'package:educast/LoginSignUpPages/Login.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Notification/notification_page.dart';

class Home4th extends StatefulWidget {
  final String gradeLevel;
  const Home4th({
    super.key,
    required this.gradeLevel,
  });

  @override
  _Home4thState createState() => _Home4thState();
}

class _Home4thState extends State<Home4th> {
  int _currentSlideIndex = 0;
  bool _isDrawerOpen = false;
  String? firstName;
  String? userCourse;
  String relatedJobsText = "Related Jobs";
  List<String> jobs = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        firstName = userDoc['firstName'];
        userCourse = userDoc['course'];
        _updateContentBasedOnCourse(userCourse);
      });
    }
  }

  void _updateContentBasedOnCourse(String? course) {
    if (course == "Bachelor of Science in Information Technology") {
      setState(() {
        relatedJobsText = "BSIT-related Jobs";
        jobs = [
          "Software Developer",
          "Network Administrator",
          "Database Administrator",
          "IT Support Specialist",
          "Web Developer",
        ];
      });
    } else if (course == "Bachelor of Automotive Engineering Technology") {
      setState(() {
        relatedJobsText = "BAET-related Jobs";
        jobs = [
          "Automotive Engineer",
          "Automotive Design Engineer",
          "Product Development Engineer",
          "Manufacturing Engineer",
          "Vehicle Testing Engineer",
        ];
      });
    } else if (course == "Bachelor of Civil Engineering Technology") {
      setState(() {
        relatedJobsText = "BCivET-related Jobs";
        jobs = [
          "Civil Engineering Technologist",
          "Construction Manager",
          "Structural Designer",
          "Project Coordinator",
          "Site Inspector",
        ];
      });
    } else if (course == "Bachelor of Computer Engineering Technology") {
      setState(() {
        relatedJobsText = "BCompET-related Jobs";
        jobs = [
          "Computer Engineering Technologist",
          "Network Administrator",
          "Systems Analyst",
          "Embedded Systems Developer",
          "Software Developer",
        ];
      });
    } else if (course == "Bachelor of Drafting Engineering Technology") {
      setState(() {
        relatedJobsText = "BDT-related Jobs";
        jobs = [
          "Drafting Technician",
          "Mechanical Drafter",
          "Architectural Drafter",
          "CAD Operator",
          "Drafting Engineer",
        ];
      });
    } else if (course == "Bachelor of Electrical Engineering Technology") {
      setState(() {
        relatedJobsText = "BElecET-related Jobs";
        jobs = [
          "Electrical Engineering Technician",
          "Electrical Maintenance Technician",
          "Electrical CAD Drafter",
          "Electrical Project Coordinator",
          "Automation Technician",
        ];
      });
    } else if (course == "Bachelor of Electronics Engineering Technology") {
      setState(() {
        relatedJobsText = "BElectroET-related Jobs";
        jobs = [
          "Electronics Engineering Technician",
          "Electronics Test Technician",
          "PCB (Printed Circuit Board) Designer",
          "Electronics Maintenance Technician",
          "Broadcast Engineering Technician",
        ];
      });
    } else if (course == "Bachelor of Food Engineering Technology") {
      setState(() {
        relatedJobsText = "BFET-related Jobs";
        jobs = [
          "Food Process Engineer",
          "Quality Control",
          "Product Development Specialist",
          "Food Safety Officer",
          "Operations Supervisor in Food Manufacturing",
        ];
      });
    } else if (course == "Bachelor of Mechanical Engineering Technology") {
      setState(() {
        relatedJobsText = "BMechET-related Jobs";
        jobs = [
          "Mechanical Design Engineer",
          "Maintenance Engineer",
          "Manufacturing Engineer",
          "Automation Engineer",
          "Project Engineer",
        ];
      });
    } else if (course == "Bachelor of Mechatronics Engineering Technology") {
      setState(() {
        relatedJobsText = "BMechtronET-related Jobs";
        jobs = [
          "Automation Engineer",
          "Control Systems Engineer",
          "Robotics Engineer",
          "Mechatronics Specialist in Manufacturing",
          "Instrumentation Engineer",
        ];
      });
    } else if (course == "Bachelor of Science in Criminology") {
      setState(() {
        relatedJobsText = "BSCrim-related Jobs";
        jobs = [
          "Police Officer",
          "Crime Scene Investigator",
          "Forensic Specialist",
          "Criminal Investigator",
          "Security Officer",
        ];
      });
    } else if (course == "Bachelor of Science in Psychology") {
      setState(() {
        relatedJobsText = "BSPsych-related Jobs";
        jobs = [
          "Human Resources Officer",
          "Recruitment Specialist",
          "Guidance Counselor",
          "Training and Development Officer",
          "Behavioral Therapist",
        ];
      });
    } else {
      setState(() {
        relatedJobsText = "Related Jobs";
        jobs = []; // Clear jobs if course is not matched
      });
    }
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  void _closeDrawer() {
    setState(() {
      _isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final iconSize = screenWidth * 0.10;
    final paddingHorizontal = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: screenWidth * 0.03,
                  right: paddingHorizontal,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _toggleDrawer,
                      child: Image.asset(
                        'assets/menu2.png',
                        width: iconSize,
                        height: iconSize,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => User4th()),
                        );
                      },
                      child: Image.asset(
                        'assets/profile.png',
                        width: iconSize,
                        height: iconSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05,
                      0,
                      0,
                      screenHeight * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          firstName != null ? 'Hi, $firstName!' : 'Hi!',
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.19,
                    margin: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/1.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 150.0, left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Skill Exploration!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  'Discover your strengths and align with top career paths.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    final userResultDoc = FirebaseFirestore
                                        .instance
                                        .collection('userResult4th')
                                        .doc(user.uid);

                                    final docSnapshot =
                                        await userResultDoc.get();

                                    if (docSnapshot.exists) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AlreadyAnswered4th()),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FourthIntro()),
                                      );
                                    }
                                  } else {}
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 9.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                                child: const Text(
                                  'Take test now',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.05,
                  screenHeight * 0.05,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          relatedJobsText,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => const Programs()),
                              // );
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: List.generate(
                              // Ensure we only generate cards based on the length of jobs
                              jobs.length >= 2
                                  ? 2
                                  : jobs
                                      .length, // Limit to 2 or the actual number of jobs available
                              (index) {
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
                                          context, jobs[index]);
                                    },
                                    child: Container(
                                      height: 80,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient:
                                            gradients[index % gradients.length],
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            jobs[index],
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: null,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0), // Space between two columns
                        Expanded(
                          child: Column(
                            children: List.generate(
                              // Ensure we only generate cards based on the remaining jobs
                              jobs.length > 2
                                  ? 2
                                  : (jobs.length > 2
                                      ? jobs.length - 2
                                      : 0), // Limit to 2 or the remaining jobs
                              (index) {
                                List<Gradient> gradients = [
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
                                ];

                                // Calculate the actual index for the jobs list
                                int jobIndex = index + 2;

                                return jobIndex <
                                        jobs.length // Check if index is within range
                                    ? Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            navigateToCoursePage(
                                                context, jobs[index]);
                                          },
                                          child: Container(
                                            height: 80,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              gradient: gradients[
                                                  index % gradients.length],
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  jobs[jobIndex],
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: null,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(); // Return an empty box if no job is available
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05,
                      screenHeight * 0.01,
                      0,
                      0,
                    ),
                    child: Text(
                      'Explore BatStateU-TNEU',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  slider.CarouselSlider(
                    items: [
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/ISSTUD.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/IS.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/ISCHART.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ],
                    options: slider.CarouselOptions(
                      height: screenHeight * 0.3,
                      autoPlay: true,
                      enlargeCenterPage: false,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentSlideIndex = index;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 5.0),
                  SizedBox(
                    height: 20.0,
                    child: Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: _currentSlideIndex,
                        count: 3,
                        effect: CustomizableEffect(
                          activeDotDecoration: DotDecoration(
                            width: 30.0,
                            height: 7.0,
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          dotDecoration: DotDecoration(
                            width: 7.0,
                            height: 7.0,
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          spacing: 6.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
        if (_isDrawerOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDrawer,
              child: Container(
                color: Colors.black54,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.5, // Drawer covers half the screen width
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          DrawerHeader(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/logo.png', // Ensure this asset exists in your project
                                width: 150, // Adjust size as needed
                                height: 150,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.all(paddingHorizontal),
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.settings,
                                      color: Colors.black),
                                  title: const Text(
                                    'Settings',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SettingsPage()),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.history,
                                      color: Colors.black),
                                  title: const Text(
                                    'History',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HistoryPage4th()),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.info,
                                      color: Colors.black),
                                  title: const Text(
                                    'About',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AboutPage()),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.feedback,
                                      color: Colors.black),
                                  title: const Text(
                                    'Feedback',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FeedbackPage()),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.logout,
                                      color: Colors.black),
                                  title: const Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ]),
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
        child: BottomNavitation4th(iconSize: iconSize),
      ),
    );
  }

  void navigateToCoursePage(BuildContext context, String course) {
    switch (course) {
      case 'Software Developer':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Softwaredev()),
        );
        break;
      case 'Database Administrator':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Softwaredev()),
        );
        break;
      case 'Network Administrator':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Softwaredev()),
        );
        break;
      case 'IT Support Specialist':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Softwaredev()),
        );
        break;
      case 'Web Developer':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Softwaredev()),
        );
        break;
      case 'Web Developer':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Softwaredev()),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home4th(gradeLevel: "4th")),
        );
    }
  }
}

class BottomNavitation4th extends StatelessWidget {
  const BottomNavitation4th({
    super.key,
    required this.iconSize,
  });

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                      builder: (context) => const Home4th(gradeLevel: "4th")),
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
                  MaterialPageRoute(builder: (context) => Search4th()),
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
                      MaterialPageRoute(builder: (context) => FourthIntro()),
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
    );
  }
}
