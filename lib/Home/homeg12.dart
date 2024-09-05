import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Assessment/assess1g10.dart';
import 'package:myapp/Home/Info/Abm.dart';
import 'package:myapp/Home/Info/Gas.dart';
import 'package:myapp/Home/Info/Humss.dart';
import 'package:myapp/Home/Info/Stem.dart';
import 'package:myapp/Home/UserG10/UserG10.dart';
import 'package:myapp/Result/resultg10.dart';
import 'package:myapp/Search/searchg10.dart';

class HomeG12 extends StatefulWidget {
  const HomeG12({super.key,});

  @override
  _HomeG12State createState() => _HomeG12State();
}

class _HomeG12State extends State<HomeG12> {
  bool _isDrawerOpen = false;
  String? userStrand;
  List<String> courses = [];
  String relatedProgramsText = 'GAS-RELATED PROGRAMS';

  @override
  void initState() {
    super.initState();
    _fetchUserStrand();
  }

  // Function to fetch user's strand
  void _fetchUserStrand() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userStrand = userDoc['strand'];
        _updateCoursesBasedOnStrand(userStrand!); // Update courses based on the strand
        _updateRelatedProgramsText(userStrand!);  // Update dynamic text based on the strand
      });
    }
  }

// Function to update the related programs text
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


  // Function to update the course list based on the user's strand
  void _updateCoursesBasedOnStrand(String strand) {
    if (strand == 'Science, Technology, Engineering, and Mathematics') {
      courses = [
        'Automotive Engineering Technology',
        'Civil Engineering Technology',
        'Criminology',
        'Computer Engineering Technology',
        'Drafting Engineering Technology',
        'Electrical Engineering Technology',
        'Electronics Engineering Technology',
        'Food Engineering Technology',
        'Information Technology',
        'Mechanical Engineering Technology',
        'Mechatronics Engineering Technology',
        'Psychology',
      ];
    } else if (strand == 'Accountancy, Business, and Management') {
      courses = ['Criminology'];
    } else if (strand == 'Humanities and Social Sciences') {
      courses = ['Criminology', 'Psychology'];
    } else if (strand == 'General Academic Strand') {
      courses = [
        'Automotive Engineering Technology',
        'Civil Engineering Technology',
        'Criminology',
        'Computer Engineering Technology',
        'Drafting Engineering Technology',
        'Electrical Engineering Technology',
        'Electronics Engineering Technology',
        'Food Engineering Technology',
        'Mechanical Engineering Technology',
        'Mechatronics Engineering Technology',
        'Psychology',
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

  @override
  Widget build(BuildContext context) {
    // Obtain screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Define responsive sizes based on screen dimensions
    final appBarHeight = screenHeight * 0.15;
    final appBarInnerHeight = screenHeight * 0.05;
    final iconSize = screenWidth * 0.10;
    final paddingHorizontal = screenWidth * 0.04;
    final paddingVertical = screenHeight * 0.01;
    final cardHeight = screenHeight * 0.68;
    // ignore: unused_local_variable
    final double bottomNavHeight = MediaQuery.of(context).size.height * 0.10;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  minHeight: appBarHeight,
                  maxHeight: appBarHeight,
                  child: Container(
                    width: double.infinity,
                    height: appBarInnerHeight,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 158, 39, 39),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: paddingHorizontal,vertical: paddingVertical),
                    child: Center(  // Center widget to vertically center the Row
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _toggleDrawer,
                            child: Image.asset(
                              'assets/menu.png',
                              width: iconSize,
                              height: iconSize,
                            ),
                          ),
                          const Text(
                            'HOME',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserG10()),
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
                ),
                pinned: true,
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: screenHeight * 0.05), // Add space between header and content
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                        padding: EdgeInsets.fromLTRB(0, screenHeight * 0.02, 0.2, 0.2),
                        height: cardHeight,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(36, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                              child: Text(
                                relatedProgramsText,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Remove Expanded and use SizedBox
                            SizedBox(
                              height: cardHeight * .85, // Define height for ListView
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 158, 39, 39),
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(screenWidth * 0.04),
                                  child: ListView.builder(
                                    itemCount: courses.length,
                                    itemBuilder: (context, index) {
                                      return Coursecard(CourseName: courses[index]);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),

            ],
          ),
          // Drawer Implementation
          // Drawer Implementation
          if (_isDrawerOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDrawer,
                child: Container(
                  color: Colors.black54,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.5,  // Drawer covers half the screen width
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
                                  'assets/logo.png',  // Ensure this asset exists in your project
                                  width: 150,  // Adjust size as needed
                                  height: 150,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.all(paddingHorizontal),
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.settings, color: Colors.black),
                                    title: const Text('Settings', style: TextStyle(
                                      fontSize: 18,
                                    ),),
                                    onTap: () {

                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.history, color: Colors.black),
                                    title: const Text('History', style: TextStyle(
                                      fontSize: 18,
                                    ),),
                                    onTap: () {
                                      // Handle menu item tap
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.info, color: Colors.black),
                                    title: const Text('About', style: TextStyle(
                                      fontSize: 18,
                                    ),),
                                    onTap: () {
                                      // Handle menu item tap
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.feedback, color: Colors.black),
                                    title: const Text('Feedback', style: TextStyle(
                                      fontSize: 18,
                                    ),),
                                    onTap: () {
                                      // Handle menu item tap
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.logout, color: Colors.black),
                                    title: const Text('Logout', style: TextStyle(
                                      fontSize: 18,
                                    ),),
                                    onTap: () {
                                      // Handle menu item tap
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
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, -2), // Shadow above the bar
              blurRadius: 6, // Soft shadow
            ),
          ],
        ),
        child: Row(
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
                  MaterialPageRoute(builder: (context) => const SearchG10()),
                );
              },
              icon: Image.asset(
                'assets/search.png',
                width: iconSize,
                height: iconSize,
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
                width: iconSize,
                height: iconSize,
              ),
            ),
            IconButton(
              onPressed: () {
                // Add navigation logic
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
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight > minHeight ? maxHeight : minHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
class Coursecard extends StatelessWidget {
  final String CourseName;

  const Coursecard({super.key, required this.CourseName});

  @override
  Widget build(BuildContext context) {
    // Obtain screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = MediaQuery.of(context).size.width * 0.10;

    // Split the course name into individual words
    List<String> words = CourseName.split(' ');
    String formattedCourseName = '';

    // Combine words into lines with a maximum of two words per line
    for (int i = 0; i < words.length; i++) {
      formattedCourseName += words[i];
      if ((i + 1) % 2 == 0 && i != words.length - 1) {
        formattedCourseName += '\n'; // Add new line after every two words
      } else if (i != words.length - 1) {
        formattedCourseName += ' ';  // Add space between words
      }
    }

    return InkWell(
      onTap: () {
        // Navigate to different pages based on CourseName
        if (CourseName == 'STEM') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AcademicStemScreen()),
          );
        } else if (CourseName == 'HUMSS') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AcademicHumssScreen()),
          );
        } else if (CourseName == 'ABM') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AcademicAbmScreen()),
          );
        } else if (CourseName == 'GAS') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AcademicGasScreen()),
          );
        }
        // Add other conditions for ABM, ICT, TOURISM...
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: const Color(0xFFF8F8F8),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: screenWidth * 0.04),
        child: Stack(
          children: [
            SizedBox(
              height: screenWidth * 0.20,  // Adjust the height here
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Center(
                  child: Text(
                    formattedCourseName,  // Use the formatted course name with new lines
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenWidth * 0.02,  // Adjust top padding
              right: screenWidth * 0.02,  // Adjust right padding
              child: Image.asset(
                'assets/manual.png', // Ensure this asset exists
                width: iconSize,
                height: iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
