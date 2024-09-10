import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Assessment/assess1g10.dart';
import 'package:myapp/Home/Info/Abm.dart';
import 'package:myapp/Home/Info/Gas.dart';
import 'package:myapp/Home/Info/Humss.dart';
import 'package:myapp/Home/Info/Stem.dart';
import 'package:myapp/Home/UserG10/UserG10.dart';
import 'package:myapp/LoginSignUpPages/Login.dart';
import 'package:myapp/Result/resultg10.dart';
import 'package:myapp/Search/searchg10.dart';

import '../Assessment/assess4g10.dart';

class HomeG10 extends StatefulWidget {
  const HomeG10({super.key,});

  @override
  _HomeG10State createState() => _HomeG10State();
}

class _HomeG10State extends State<HomeG10> {
  bool _isDrawerOpen = false;

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
                child:
                Container(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: paddingHorizontal),
                        padding: EdgeInsets.fromLTRB(
                            0, screenHeight * 0.02, 0.2, 0.2),
                        height: cardHeight,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(36, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                              child: const Text(
                                'STRANDS OVERVIEW',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),Expanded(
                              child: Container(
                                width: double.infinity,
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
                                  padding: EdgeInsets.all(screenWidth * 0.04), // Add padding here
                                  child: ListView(
                                    children: const [
                                      StrandCard(strandName: 'ABM'),
                                      StrandCard(strandName: 'GAS'),
                                      StrandCard(strandName: 'HUMSS'),
                                      StrandCard(strandName: 'STEM'),
                                    ],
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const LoginPage()),
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
                  MaterialPageRoute(builder: (context) => const HomeG10()),
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
              onPressed: () async {
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  final userResultRef = FirebaseFirestore.instance
                      .collection('userResultG10')
                      .doc(currentUser.uid);

                  final docSnapshot = await userResultRef.get();

                  if (docSnapshot.exists) {
                    // Navigate to SubmissionConfirmation if data exists
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubmissionConfirmation()),
                    );
                  } else {
                    // Navigate to Questionnaire1G10 if no data exists
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Questionnaire1G10()),
                    );
                  }
                }
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

class StrandCard extends StatelessWidget {
  final String strandName;

  const StrandCard({super.key, required this.strandName});

  @override
  Widget build(BuildContext context) {
    // Obtain screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = MediaQuery.of(context).size.width * 0.10;

    return InkWell(
      onTap: () {
        // Navigate to different pages based on strandName
        if (strandName == 'STEM') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AcademicStemScreen()),
          );
        } else if (strandName == 'HUMSS') {
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => const AcademicHumssScreen()),
           );
         } else if (strandName == 'ABM') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AcademicAbmScreen()),
          );
        }else if (strandName == 'GAS') {
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
                    strandName,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
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

