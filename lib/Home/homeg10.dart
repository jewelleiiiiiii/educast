import 'package:flutter/material.dart';

class homeg10 extends StatefulWidget {
  const homeg10({Key? key}) : super(key: key);

  @override
  _homeg10State createState() => _homeg10State();
}

class _homeg10State extends State<homeg10> {
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
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  minHeight: 99.0,
                  maxHeight: 99.0,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 158, 39, 39),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.zero,
                            topRight: Radius.zero,
                            bottomLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _toggleDrawer,
                              child: Image.asset(
                                '../lib/assets/menu.png',
                                width: 30.0,
                                height: 30.0,
                              ),
                            ),
                            const Text(
                              'HOME',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => userG10()),
                                // );
                              },
                              child: Image.asset(
                                '../lib/assets/profile.png',
                                width: 30.0,
                                height: 30.0,
                              ),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                        height: 280,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(36, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Statistical Strand Insights',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Expanded(
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
                                child: ListView(
                                  padding: const EdgeInsets.all(8.0),
                                  children: [
                                    StrandCard(
                                        strandName: 'HUMSS', progress: 0.5),
                                    StrandCard(
                                        strandName: 'STEM', progress: 0.2),
                                    StrandCard(
                                        strandName: 'ABM', progress: 0.3),
                                    StrandCard(
                                        strandName: 'ICT', progress: 0.6),
                                    StrandCard(
                                        strandName: 'TOURISM', progress: 0.4),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _isDrawerOpen
              ? GestureDetector(
            onTap: _closeDrawer,
            child: Container(
              color: Colors.black54,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.5,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [

                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.all(16.0),
                            children: [
                              ListTile(
                                title: Text('Settings'),
                                onTap: () {
                                  // Handle menu item tap
                                },
                              ),
                              ListTile(
                                title: Text('History'),
                                onTap: () {
                                  // Handle menu item tap
                                },
                              ),
                              ListTile(
                                title: Text('About'),
                                onTap: () {
                                  // Handle menu item tap
                                },
                              ),
                              ListTile(
                                title: Text('Feedback'),
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
          )
              : Container(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: .2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const homeg10()),
                // );
              },
              icon: Image.asset(
                '../lib/assets/home.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SearchScreen()),
                // );
              },
              icon: Image.asset(
                '../lib/assets/search.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MainG10()),
                // );
              },
              icon: Image.asset(
                '../lib/assets/main.png',
                width: 40.0,
                height: 40.0,
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => NotificationScreen()),
                // );
              },
              icon: Image.asset(
                '../lib/assets/notif.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MyProgressPage()),
                // );
              },
              icon: Image.asset(
                '../lib/assets/stats.png',
                width: 25.0,
                height: 25.0,
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
  double get maxExtent => maxHeight;

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
  final double progress;

  StrandCard({required this.strandName, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: const Color(0xFFD9D9D9),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: 80.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  strandName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  '../lib/assets/manual.png', // Replace with your image path
                  width: 24.0,
                  height: 24.0,
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 158, 39, 39),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class homeg12 extends StatefulWidget {
  const homeg12({Key? key}) : super(key: key);

  @override
  _homeg12 createState() => _homeg12();
}

class _homeg12 extends State<homeg12> {
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

  void _onItemTapped2(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate2(
                  minHeight2: 99.0, // Height of the combined AppBar and Container
                  maxHeight2: 99.0,
                  child2: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 158, 39, 39),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.zero,
                            topRight: Radius.zero,
                            bottomLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _toggleDrawer,
                              child: Image.asset(
                                '../lib/assets/menu.png', // Menu icon image path
                                width: 30.0,
                                height: 30.0,
                              ),
                            ),
                            const Text(
                              'HOME',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => userG12()),
                                // );
                              },
                              child: Image.asset(
                                '../lib/assets/profile.png', // Profile icon image path
                                width: 30.0,
                                height: 30.0,
                              ),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // New Container for Statistical Strand Insights with fixed height
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                        height: 280, // Fixed height for the container
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              36, 30, 30, 30), // 14% opacity of #1E1E1E
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Statistical Course Insights',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            // Scrollable Container for the Strand Cards
                            Expanded(
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
                                child: ListView(
                                  padding: const EdgeInsets.all(8.0),
                                  children: [
                                    StrandCard2(
                                      strandName2: 'Information Technology',
                                    ),
                                    StrandCard2(
                                      strandName2: 'Food Engineering Technology',
                                    ),
                                    StrandCard2(
                                      strandName2:
                                      'Computer Engineering Technology',
                                    ),
                                    StrandCard2(
                                      strandName2: 'Industrial Technology',
                                    ),
                                    StrandCard2(
                                      strandName2: 'Computer Science',
                                    ),
                                    StrandCard2(
                                      strandName2: 'Mechanical Engineering',
                                    ),
                                    StrandCard2(
                                      strandName2: 'Computer Engineering',
                                    ),
                                    StrandCard2(
                                      strandName2: 'Industrial Engineering',
                                    ),
                                    StrandCard2(
                                      strandName2: 'Civil Engineering',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _isDrawerOpen
              ? GestureDetector(
            onTap: _closeDrawer,
            child: Container(
              color: Colors.black54,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.5,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.all(16.0),
                            children: [
                              ListTile(
                                title: Text('Settings'),
                                onTap: () {
                                  // Handle menu item tap
                                },
                              ),
                              ListTile(
                                title: Text('History'),
                                onTap: () {
                                  // Handle menu item tap
                                },
                              ),
                              ListTile(
                                title: Text('About'),
                                onTap: () {
                                  // Handle menu item tap
                                },
                              ),
                              ListTile(
                                title: Text('Feedback'),
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
          )
              : SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey, // Border color
              width: .2, // Border width
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const homeg12()),
                // );
              },
              icon: Image.asset(
                '../lib/assets/home.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SearchScreen3()),
                // );
              },
              icon: Image.asset(
                '../lib/assets/search.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MainG12()),
                // );
              },
              icon: Image.asset(
                '../lib/assets/main.png',
                width: 40.0,
                height: 40.0,
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => NotificationScreen2()),
                // );
              },
              icon: Image.asset(
                '../lib/assets/notif.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MyProgressPage2()),
                // );
              },
              icon: Image.asset(
                '../lib/assets/stats.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate2 extends SliverPersistentHeaderDelegate {
  final double minHeight2;
  final double maxHeight2;
  final Widget child2;

  _SliverAppBarDelegate2({
    required this.minHeight2,
    required this.maxHeight2,
    required this.child2,
  });

  @override
  double get minExtent => minHeight2;

  @override
  double get maxExtent => maxHeight2;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child2);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate2 oldDelegate) {
    return maxHeight2 != oldDelegate.maxHeight2 ||
        minHeight2 != oldDelegate.minHeight2 ||
        child2 != oldDelegate.child2;
  }
}

class StrandCard2 extends StatelessWidget {
  final String strandName2;

  StrandCard2({
    required this.strandName2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: const Color(0xFFD9D9D9),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: 80.0,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.zero, // You can adjust thcanis if needed
                padding:
                const EdgeInsets.all(5.0), // You  adjust this if needed
                child: Image.asset(
                  '../lib/assets/manual.png', // Replace with your image path
                  width: 24.0,
                  height: 24.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Add horizontal padding if needed
                child: Text(
                  strandName2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class home4th extends StatefulWidget {
  const home4th({Key? key}) : super(key: key);

  @override
  _home4th createState() => _home4th();
}

class _home4th extends State<home4th> {
  bool _isDrawerOpen = false;

  void _openDrawer() {
    setState(() {
      _isDrawerOpen = true;
    });
  }

  void _closeDrawer() {
    setState(() {
      _isDrawerOpen = false;
    });
  }

  void _onItemTapped3(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Wrap with GestureDetector to handle taps
      onTap: () {
        if (_isDrawerOpen) {
          _closeDrawer();
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate3(
                minHeight3: 99.0, // Height of the combined AppBar and Container
                maxHeight3: 99.0,
                child3: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 158, 39, 39),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.zero,
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _openDrawer,
                            child: Image.asset(
                              '../lib/assets/menu.png', // Menu icon image path
                              width: 30.0,
                              height: 30.0,
                            ),
                          ),
                          const Text(
                            'HOME',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => user4th()),
                              // );
                            },
                            child: Image.asset(
                              '../lib/assets/profile.png', // Profile icon image path
                              width: 30.0,
                              height: 30.0,
                            ),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
                    ),
                  ],
                ),
              ),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.zero,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // New Container for Statistical Strand Insights with fixed height
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      height: 280, // Fixed height for the container
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            36, 30, 30, 30), // 14% opacity of #1E1E1E
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Statistical Job Insights',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          // Scrollable Container for the Strand Cards
                          Expanded(
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
                              child: ListView(
                                padding: const EdgeInsets.all(8.0),
                                children: [
                                  StrandCard3(
                                    strandName3:
                                    'Artifical Intelligent Specialist',
                                  ),
                                  StrandCard3(
                                    strandName3: 'Data Scientist',
                                  ),
                                  StrandCard3(
                                    strandName3: 'Software Engineering',
                                  ),
                                  StrandCard3(
                                    strandName3: 'Systems Security Manager',
                                  ),
                                  StrandCard3(
                                    strandName3: 'Developer',
                                  ),
                                  StrandCard3(
                                    strandName3: 'Business Analyst',
                                  ),
                                  StrandCard3(
                                    strandName3: 'IT Consultant',
                                  ),
                                  StrandCard3(
                                    strandName3: 'Financial Analyst',
                                  ),
                                  StrandCard3(
                                    strandName3: 'Project Manager',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey, // Border color
                width: .2, // Border width
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const home4th()),
                  // );
                },
                icon: Image.asset(
                  '../lib/assets/home.png',
                  width: 25.0,
                  height: 25.0,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SearchScreen2()),
                  // );
                },
                icon: Image.asset(
                  '../lib/assets/search.png',
                  width: 25.0,
                  height: 25.0,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Main4th()),
                  // );
                },
                icon: Image.asset(
                  '../lib/assets/main.png',
                  width: 40.0,
                  height: 40.0,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => NotificationScreen3()),
                  // );
                },
                icon: Image.asset(
                  '../lib/assets/notif.png',
                  width: 25.0,
                  height: 25.0,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MyProgressPage3()),
                  // );
                },
                icon: Image.asset(
                  '../lib/assets/stats.png',
                  width: 25.0,
                  height: 25.0,
                ),
              ),
            ],
          ),
        ),
        drawer: _isDrawerOpen
            ? GestureDetector(
          onTap: _closeDrawer,
          child: Container(
            color: Colors.black54,
            child: Align(
              alignment: Alignment.topCenter,
              child: FractionallySizedBox(
                heightFactor: 0.5,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(16.0),
                          children: [
                            ListTile(
                              title: Text('Settings'),
                              onTap: () {
                                // Handle menu item tap
                              },
                            ),
                            ListTile(
                              title: Text('History'),
                              onTap: () {
                                // Handle menu item tap
                              },
                            ),
                            ListTile(
                              title: Text('About'),
                              onTap: () {
                                // Handle menu item tap
                              },
                            ),
                            ListTile(
                              title: Text('Feedback'),
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
        )
            : null,
      ),
    );
  }
}



class _SliverAppBarDelegate3 extends SliverPersistentHeaderDelegate {
  final double minHeight3;
  final double maxHeight3;
  final Widget child3;

  _SliverAppBarDelegate3({
    required this.minHeight3,
    required this.maxHeight3,
    required this.child3,
  });

  @override
  double get minExtent => minHeight3;

  @override
  double get maxExtent => maxHeight3;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child3);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate3 oldDelegate) {
    return maxHeight3 != oldDelegate.maxHeight3 ||
        minHeight3 != oldDelegate.minHeight3 ||
        child3 != oldDelegate.child3;
  }
}

class StrandCard3 extends StatelessWidget {
  final String strandName3;

  StrandCard3({
    required this.strandName3,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: const Color(0xFFD9D9D9),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: 80.0,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.zero, // You can adjust thcanis if needed
                padding:
                const EdgeInsets.all(5.0), // You  adjust this if needed
                child: Image.asset(
                  '../lib/assets/manual.png', // Replace with your image path
                  width: 24.0,
                  height: 24.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Add horizontal padding if needed
                child: Text(
                  strandName3,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
