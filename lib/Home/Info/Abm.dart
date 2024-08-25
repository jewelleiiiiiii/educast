import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/Home/homeg10.dart';

class AcademicAbmScreen extends StatelessWidget {
  const AcademicAbmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the status bar color to match the header color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 158, 39, 39), // Red color for the status bar
      statusBarIconBrightness: Brightness.light, // White icons for better visibility on red background
    ));

    // Define sizes for bottom navigation bar and icons
    final double bottomNavHeight = MediaQuery.of(context).size.height * 0.10;
    final double iconSize = MediaQuery.of(context).size.width * 0.10;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Container
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 158, 39, 39), // Red color matching the status bar
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Accountancy, Business,',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'and Management (ABM)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20.0,
                    left: 16.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeG10()),
                        );
                      },
                      child: Image.asset(
                        'assets/back.png',
                        width: 30.0,
                        height: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color(0xFFFFC0CB).withOpacity(0.5), // Adjust border color and opacity
                            width: 1.5, // Adjust border width as needed
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                height: 150,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(0),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage('assets/stem1.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: const Text(
                                  'Things to know!',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/stem2.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          color: Colors.white,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 7.0),
                                        child: const Text(
                                          'See More',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                padding: const EdgeInsets.all(10), // Padding for the transparent container
                                decoration: BoxDecoration(
                                  color: Colors.transparent, // Transparent background for outer container
                                ),
                                child: Stack(
                                  children: [
                                    // Pink container as the second child
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.pink[50],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Expanded(
                                                child: Center(
                                                  child: Text(
                                                    'What is ABM all about?',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                            child: Text(
                                              'ABM is designed for students interested in the world of business, '
                                                  'finance, and management. It provides the foundational skills and '
                                                  'knowledge in accounting, economics, and entrepreneurship, equipping '
                                                  'students with the tools needed to succeed in corporate environments, '
                                                  'business ventures, and financial institutions.',
                                              style: TextStyle(
                                                fontSize: 14,
                                                height: 1.5, // Adjust height for better spacing
                                              ),
                                              textAlign: TextAlign.justify, // Set text alignment to justify
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Positioned(
                                      top: 0,
                                      left: 10,
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 158, 39, 39), // RGBA values

                                        ),
                                        child: const Text(
                                          '1',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
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
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: -40,
                      child: Transform.rotate(
                        angle: -0.785398, // -45 degrees in radians
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFC0CB), // Light pink shade
                          ),
                          child: const Center(
                            child: Text(
                              'ABM',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: bottomNavHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, -2), // Shadow above the bar
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
                // Add navigation logic
              },
              icon: Image.asset(
                'assets/search.png',
                width: iconSize,
                height: iconSize,
              ),
            ),
            IconButton(
              onPressed: () {
                // Add navigation logic
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
                // Add navigation logic
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
