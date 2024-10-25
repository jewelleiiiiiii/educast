import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Assessment/Rules/G12Intro.dart';
import 'package:educast/Assessment/assess2g12.dart';
import 'package:educast/Home/Drawer/Feedback.dart';
import 'package:educast/Home/Info/Criminology.dart';
import 'package:educast/Home/Info/GasPrograms.dart';
import 'package:educast/Home/Info/StemPrograms.dart';
import 'package:educast/Home/Info/automotive.dart';
import 'package:educast/Home/Info/civil.dart';
import 'package:educast/Home/Info/computer.dart';
import 'package:educast/Home/Info/drafting.dart';
import 'package:educast/Home/Info/electrical.dart';
import 'package:educast/Home/Info/electronics.dart';
import 'package:educast/Home/Info/food.dart';
import 'package:educast/Home/Info/mechanical.dart';
import 'package:educast/Home/Info/mechatronics.dart';
import 'package:educast/Home/Info/psychology.dart';
import 'package:educast/Result/resultG12.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:educast/Home/User/UserG12.dart';
import 'package:educast/LoginSignUpPages/Login.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:educast/Search/searchg12.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Notification/notification_page.dart';

class HomeG12 extends StatefulWidget {
  const HomeG12({
    super.key,
  });

  @override
  _HomeG12State createState() => _HomeG12State();
}

class _HomeG12State extends State<HomeG12> {
  int _currentSlideIndex = 0;
  bool _isDrawerOpen = false;
  String? userStrand;
  List<String> courses = [];
  String relatedProgramsText = '';
  String? firstName;

  @override
  void initState() {
    super.initState();
    _fetchUserStrand();
    _fetchUserFirstName();
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

  void _fetchUserFirstName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        firstName = userDoc['firstName'];
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

// Method to check if the "View All" text should be visible based on the user's strand.
  bool _shouldShowViewAll(String strand) {
    return strand == 'Science, Technology, Engineering, and Mathematics' ||
        strand == 'General Academic Strand';
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
                            MaterialPageRoute(builder: (context) => UserG12()),
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
                          screenWidth * 0.05, 0, 0, screenHeight * 0.02),
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
                      margin:
                          EdgeInsets.symmetric(horizontal: paddingHorizontal),
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
                                    '15 MINUTES!',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    'Take the IQ Test to See Which Program Fits You Best.',
                                    style: TextStyle(
                                      fontSize: 15,
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
                                          .collection('userResultG12')
                                          .doc(user.uid);

                                      final docSnapshot =
                                          await userResultDoc.get();

                                      if (docSnapshot.exists) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AlreadyAnsweredG12()),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => G12Intro()),
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
                  height: screenHeight * .35,
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
                            relatedProgramsText,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          if (_shouldShowViewAll(userStrand!))
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                onTap: () async {
                                  if (userStrand == "General Academic Strand") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GasPrograms()),
                                    );
                                  } else if (userStrand ==
                                      "Science, Technology, Engineering, and Mathematics") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StemPrograms()),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeG12()),
                                    );
                                  }
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
                      SizedBox(
                        height: 150.0,
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 2.5,
                          ),
                          itemCount: courses.length > 4 ? 4 : courses.length,
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
                            ];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: InkWell(
                                // Make the container clickable
                                onTap: () {
                                  // Add dynamic navigation logic here
                                  navigateToCoursePage(context, courses[index]);
                                },
                                borderRadius: BorderRadius.circular(16.0),
                                // Ripple effect follows the border radius
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
                          screenWidth * 0.05, screenHeight * 0.01, 0, 0),
                      child: Text(
                        'Explore BatStateU-IS',
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
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const NotificationPage();
                            }));
                          },
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
                    SizedBox(height: 50.0),
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
                                  'assets/logo.png',
                                  // Ensure this asset exists in your project
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
                                    onTap: () {},
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
                                      // Handle menu item tap
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
                                      // Handle menu item tap
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
                                            builder: (context) =>
                                                FeedbackPage()),
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
      case 'BElectoET':
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
      case 'BSCrim':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Criminology()),
        );
        break;
      case 'BSPsych':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Psychology()),
        );
        break;
      default:
        // Handle default case or navigate to a generic page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeG12()),
        );
    }
  }
}
