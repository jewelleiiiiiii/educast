import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Home/Drawer/About.dart';
import 'package:educast/Home/Drawer/Feedback.dart';
import 'package:educast/Home/Drawer/History.dart';
import 'package:educast/Home/Drawer/Settings.dart';
import 'package:educast/Notification/notification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:educast/Assessment/Rules/G10Intro.dart';
import 'package:educast/Assessment/assess4g10.dart';
import 'package:educast/Home/Info/Abm.dart';
import 'package:educast/Home/Info/GAS.dart';
import 'package:educast/Home/Info/HUMSS.dart';
import 'package:educast/Home/Info/STEM.dart';
import 'package:educast/Home/User/UserG10.dart';
import 'package:educast/LoginSignUpPages/Login.dart';
import 'package:educast/Result/resultg10.dart';
import 'package:educast/Search/searchg10.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeG10 extends StatefulWidget {
  final String gradeLevel;
  const HomeG10({
    super.key,
    required this.gradeLevel,
  });

  @override
  _HomeG10 createState() => _HomeG10();
}

class _HomeG10 extends State<HomeG10> {
  int _currentSlideIndex = 0;
  bool _isDrawerOpen = false;
  String titlee = 'Strands';
  String? firstName;
  List<String> strands = ['ABM', 'GAS', 'HUMSS', 'STEM'];

  @override
  void initState() {
    super.initState();
    _fetchUserFirstName();
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
    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
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
                              MaterialPageRoute(
                                  builder: (context) => UserG10()),
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
                                padding: const EdgeInsets.only(
                                    right: 150.0, left: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'MATCH UP!',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 7),
                                    Text(
                                      'Discover the strand that fits your interests and talents.',
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
                                            .collection('userResultG10')
                                            .doc(user.uid);

                                        final docSnapshot =
                                            await userResultDoc.get();

                                        if (docSnapshot.exists) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AlreadyAnswered()),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    G10Intro()),
                                          );
                                        }
                                      } else {
                                        // Handle the case when the user is not logged in
                                        // You might want to show an error or redirect to a login page
                                      }
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
                              titlee,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.start,
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
                            itemCount: strands.length,
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

                              return GestureDetector(
                                onTap: () {
                                  switch (strands[index]) {
                                    case 'ABM':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AbmInfo()),
                                      );
                                      break;
                                    case 'STEM':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StemInfo()),
                                      );
                                      break;
                                    case 'HUMSS':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HumssInfo()),
                                      );
                                      break;
                                    case 'GAS':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GasInfo()),
                                      );
                                      break;
                                    default:
                                      break;
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: gradients[index],
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // Card content
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      strands[index],
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Like icon positioned at the top-right corner
                                        if (strands[index] == 'STEM')
                                          Positioned(
                                            top:
                                                5.0, // Adjust based on the padding or spacing you want
                                            left:
                                                8.0, // Adjust based on the padding or spacing you want
                                            child: Icon(
                                              Icons.bookmark,
                                              color: Colors.yellow,
                                              size: 30.0,
                                            ),
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
                                              builder: (context) =>
                                                  SettingsPage()),
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
                                                  HistoryPageG10()),
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
                                              builder: (context) =>
                                                  AboutPage()),
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
          child: BottomNavigationHome10(iconSize: iconSize),
        ),
      ),
    );
  }
}

class BottomNavigationHome10 extends StatelessWidget {
  const BottomNavigationHome10({
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
                      builder: (context) => const HomeG10(gradeLevel: "10")),
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
                  MaterialPageRoute(builder: (context) => SearchG10()),
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
                      .collection('userResultG10')
                      .doc(user.uid);

                  final docSnapshot = await userResultDoc.get();

                  if (docSnapshot.exists) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AlreadyAnswered()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => G10Intro()),
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
