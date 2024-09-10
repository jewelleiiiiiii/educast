import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Assessment/assess1g10.dart';
import 'package:myapp/Home/Info/Abm.dart';
import 'package:myapp/Home/Info/Gas.dart';
import 'package:myapp/Home/Info/Humss.dart';
import 'package:myapp/Home/Info/Stem.dart';
import 'package:myapp/Home/Info/automotive.dart';
import 'package:myapp/Home/UserG10/UserG10.dart';
import 'package:myapp/LoginSignUpPages/Login.dart';
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
  String? firstName; // Variable to store the first name

  @override
  void initState() {
    super.initState();
    _fetchUserStrand();
    _fetchUserFirstName(); // Fetch the first name on init
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

  // Function to fetch user's first name
  void _fetchUserFirstName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        firstName = userDoc['firstName']; // Assuming 'firstName' is the field in the 'users' collection
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
        'BAET',
        'BCET',
        'BSCrim',
        'BCET',
        'BDT',
        'BEET',
        'BEET',
        'BFET',
        'BSIT',
        'BMET',
        'BMET',
        'BSPsych',
      ];
    } else if (strand == 'Accountancy, Business, and Management') {
      courses = ['Criminology'];
    } else if (strand == 'Humanities and Social Sciences') {
      courses = ['Criminology', 'Psychology'];
    } else if (strand == 'General Academic Strand') {
      courses = [
        'BAET',
        'BCET',
        'BSCrim',
        'BCET',
        'BDT',
        'BEET',
        'BEET',
        'BFET',
        'BMET',
        'BMET',
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
    final double bottomNavHeight = MediaQuery.of(context).size.height * 0.10;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,  // Remove shadow
                  automaticallyImplyLeading: false, // Remove default back button
                  flexibleSpace: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top, // Add padding on top (status bar)
                      left: paddingHorizontal,
                      right: paddingHorizontal,
                    ), // Removed bottom padding
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

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Container for greeting text
                    Container(
                      padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 0, 0, screenHeight * 0.02),  // Adjust padding as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,  // Align text to the left
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

                    // Container with background image and button
                    Container(
                      height: screenHeight * 0.19,  // Adjusted height
                      margin: EdgeInsets.symmetric(horizontal: paddingHorizontal),  // Horizontal margin
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/1.png'),  // Background image
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(17),  // Rounded corners
                      ),
                      child: Stack(
                        children: [
                          // Add text on the right side in 2 rows
                          Align(
                            alignment: Alignment.centerRight,  // Align text to the right
                            child: Padding(
                              padding: const EdgeInsets.only(right: 150.0, left: 20),  // Adjust padding to position text on the right
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,  // Center vertically
                                crossAxisAlignment: CrossAxisAlignment.start,  // Align text to the right
                                children: const [
                                  Text(
                                    '15 MINUTES!',
                                    style: TextStyle(
                                      fontSize: 25,  // Larger font size for the first row
                                      fontWeight: FontWeight.bold,  // Bold text
                                      color: Colors.white,  // White color
                                    ),
                                  ),
                                  SizedBox(height: 7),  // Spacing between the rows
                                  Text(
                                    'Take the IQ Test to See Which Program Fits You Best.',
                                    style: TextStyle(
                                      fontSize: 15,  // Smaller font size for the second row
                                      fontWeight: FontWeight.normal,  // Normal (non-bold) text
                                      color: Colors.white,  // White color
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Align the button on the right side
                          Align(
                            alignment: Alignment.centerRight,  // Aligns the button to the right
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),  // Adjust padding for positioning
                              child: SizedBox(
                                width: 120,  // Adjusted width to reduce button size
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Add your action here for the button press
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,  // White background for the button
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 9.0),  // Minimized padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9),  // 9 radius for rounded corners
                                    ),
                                  ),
                                  child: const Text(
                                    'Take test now',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontFamily: 'Roboto',  // Set the font to Roboto
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
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row( // Use Row to align both texts horizontally
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and View All
                        children: [
                          Text(
                            relatedProgramsText,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0), // Add right padding here
                            child: GestureDetector(
                              onTap: () {
                                // Handle the tap here (e.g., navigate to another screen or show more content)
                                print('View All tapped');
                              },
                              child: Text(
                                "View All",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue, // Make the text blue to indicate it's clickable
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0), // Add minimal spacing between the Text and GridView
                      SizedBox(
                        height: 200.0, // Adjust the height of the GridView area
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Two columns
                            crossAxisSpacing: 8.0, // Space between columns
                            mainAxisSpacing: 8.0, // Space between rows
                            childAspectRatio: 2.5, // Adjust based on the reduced card height
                          ),
                          itemCount: courses.length > 4 ? 4 : courses.length, // Limit to the first 4 items
                          itemBuilder: (context, index) {
                            // Define different gradients for each card
                            List<Gradient> gradients = [
                              LinearGradient(
                                colors: [Colors.blueAccent, Colors.purpleAccent.shade100], // Bold blue to soft purple
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),

                              LinearGradient(
                                colors: [Colors.teal.shade300, Colors.cyan.shade100], // Calm teal to light cyan
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),

                              LinearGradient(
                                colors: [Colors.pink.shade600, Colors.orange.shade300], // Vibrant pink to warm orange
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),

                              LinearGradient(
                                colors: [Colors.indigo.shade500, Colors.blueGrey.shade200], // Deep indigo to soft blue-grey
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),



                            ];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0), // Rounded corners
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: gradients[index], // Apply different gradient based on index
                                  borderRadius: BorderRadius.circular(16.0), // Ensure the gradient applies to the rounded corners
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0), // Reduce padding for a shorter card
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        courses[index], // Course name
                                        style: TextStyle(
                                          fontSize: 14.0, // Adjust font size if needed
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black, // Adjust text color if needed for better contrast
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
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
              )




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
                      widthFactor: 0.5,
                      child: Container(
                        color: Colors.white,
                        child: ListView(
                          children: [
                            ListTile(
                              leading: Icon(Icons.info),
                              title: Text('About Us'),
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => AboutUs()),
                                // );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.search),
                              title: Text('Search'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SearchG10()),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.exit_to_app),
                              title: Text('Log Out'),
                              onTap: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                );
                              },
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
              offset: const Offset(0, -2), // Shadow above the bar
              blurRadius: 0, // Soft shadow
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none, // Allows the circle to go outside the bar
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
                      MaterialPageRoute(builder: (context) => const SearchG10()),
                    );
                  },
                  icon: Image.asset(
                    'assets/search.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                SizedBox(width: iconSize), // Space for the middle icon (to center the others)
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
            // Circle in the middle that overlaps the BottomNavigationBar
            Positioned(
              top: -iconSize * 0.75, // Adjust this value to position the circle higher or lower
              left: MediaQuery.of(context).size.width / 2 - iconSize, // Center the circle
              child: Container(
                width: iconSize * 2, // Double the iconSize for a larger circle
                height: iconSize * 2,
                decoration: BoxDecoration(
                  color: Color(0xFFF08080), // Color of the circle
                   // Color of the circle
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8), // Color of the border
                    width: 10, // Thickness of the border
                  ),

                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Questionnaire1G10()),
                    );
                  },
                  icon: Image.asset(
                    'assets/main.png',
                    width: iconSize * 1.3, // Adjust size of the icon inside the circle
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
}
