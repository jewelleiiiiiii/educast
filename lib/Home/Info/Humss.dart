import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/Home/homeg10.dart';
import 'package:myapp/Search/searchg10.dart';

class AcademicHumssScreen extends StatelessWidget {
  const AcademicHumssScreen({super.key});

  // Define a method to fetch content from Firestore
  Future<List<String>> fetchContent() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('strandcontent')
          .doc('humss')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return [
          data['1'] ?? 'Content not found',
          data['2'] ?? 'Content not found',
        ];
      } else {
        return ['Content not found', 'Content not found'];
      }
    } catch (e) {
      print('Error fetching content: $e');
      return ['Error fetching content', 'Error fetching content'];
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 158, 39, 39),
      statusBarIconBrightness: Brightness.light,
    ));

    // Define sizes for bottom navigation bar and icons
    final double iconSize = MediaQuery.of(context).size.width * 0.10;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<String>>(
          future: fetchContent(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available.'));
            } else {
              final contentList = snapshot.data!;

              return Column(
                children: [
                  // Header Container
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.12,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 158, 39, 39),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Humanities and',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Social Sciences (HUMSS)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10.0,
                          left: 16.0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeG10(),
                                ),
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
                          // Black Container
                          Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(10.0),
                            child: Stack(
                              children: [
                                // Transparent Container with Pink Border
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: const Color(0xFFFFC0CB).withOpacity(0.5),
                                      width: 1.5,
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
                                        // Dynamic content display
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: contentList.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                              padding: const EdgeInsets.all(10),
                                              decoration: const BoxDecoration(
                                                color: Colors.transparent,
                                              ),
                                              child: Stack(
                                                children: [
                                                  // Pink container should be the first child in the stack
                                                  Container(
                                                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.pink[50],
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        const Row(
                                                          children: [
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  'What is HUMSS all about?',
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
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                                          child: Text(
                                                            contentList[index],
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                              height: 1.5,
                                                            ),
                                                            textAlign: TextAlign.justify,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Positioned number container on top of the pink container
                                                  Positioned(
                                                    top: 0, // Adjust this value as needed
                                                    left: 10,
                                                    child: Container(
                                                      padding: const EdgeInsets.all(10.0),
                                                      decoration: const BoxDecoration(
                                                        color: Color.fromARGB(255, 158, 39, 39),
                                                      ),
                                                      // Center the text inside the container
                                                      alignment: Alignment.center, // Ensures text is centered
                                                      child: Text(
                                                        '${index + 1}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Ribbon on top of the black container and above the transparent one
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
                                    'HUMSS',
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
              );
            }
          },
        ),
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
