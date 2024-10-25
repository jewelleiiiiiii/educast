import 'package:educast/Home/homeg12.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Drafting extends StatefulWidget {
  @override
  _Drafting createState() => _Drafting();
}

class _Drafting extends State<Drafting> {
  final List<String> lessons = List.generate(
      4, (index) => "Lesson ${(index + 1).toString().padLeft(2, '0')}");

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>> _fetchLessonData() async {
    Map<String, String> lessonData = {
      '1': '',
      '2': '',
      '3': '',
      '3.1': '',
      '3.2': '',
      '3.3': '',
      '3.4': '',
      '4': '',
      '5.1': '',
      '5.2': '',
      '5.3': '',
      '5.4': '',
      '5.5': '',
      '5.6': '',
      '5.7': '',
      '5.8': '',
      '5.9': '',
      '5.10': '',
      '5.11': '',
      '6.1': '',
      '6.2': '',
      '6.3': '',
      '6.4': '',
      '6.5': '',
      '6.6': '',
    };
    try {
      final doc = await _firestore
          .collection('programcontent')
          .doc('Bachelor of Drafting Engineering Technology')
          .get();
      if (doc.exists) {
        lessonData['1'] =
            doc.data()?['1'] ?? 'No information available for Lesson 1';
        lessonData['2'] =
            doc.data()?['2'] ?? 'No information available for Lesson 2';
        lessonData['3'] =
            doc.data()?['3'] ?? 'No information available for Lesson 3';
        lessonData['3.1'] =
            doc.data()?['3.1'] ?? 'No information available for 3.1';
        lessonData['3.2'] =
            doc.data()?['3.2'] ?? 'No information available for 3.2';
        lessonData['3.3'] =
            doc.data()?['3.3'] ?? 'No information available for 3.3';
        lessonData['3.4'] =
            doc.data()?['3.4'] ?? 'No information available for 3.4';
        lessonData['4'] =
            doc.data()?['4'] ?? 'No information available for Lesson 4';
        lessonData['5.1'] =
            doc.data()?['5.1'] ?? 'No information available for 5.1';
        lessonData['5.2'] =
            doc.data()?['5.2'] ?? 'No information available for 5.2';
        lessonData['5.3'] =
            doc.data()?['5.3'] ?? 'No information available for 5.3';
        lessonData['5.4'] =
            doc.data()?['5.4'] ?? 'No information available for 5.4';
        lessonData['5.5'] =
            doc.data()?['5.5'] ?? 'No information available for 5.5';
        lessonData['5.6'] =
            doc.data()?['5.6'] ?? 'No information available for 5.6';
        lessonData['5.7'] =
            doc.data()?['5.7'] ?? 'No information available for 5.7';
        lessonData['5.8'] =
            doc.data()?['5.8'] ?? 'No information available for 5.8';
        lessonData['5.9'] =
            doc.data()?['5.9'] ?? 'No information available for 5.9';
        lessonData['5.10'] =
            doc.data()?['5.10'] ?? 'No information available for 5.10';
        lessonData['5.11'] =
            doc.data()?['5.11'] ?? 'No information available for 5.11';
        lessonData['6.1'] =
            doc.data()?['6.1'] ?? 'No information available for 6.1';
        lessonData['6.2'] =
            doc.data()?['6.2'] ?? 'No information available for 6.2';
        lessonData['6.3'] =
            doc.data()?['6.3'] ?? 'No information available for 6.3';
        lessonData['6.4'] =
            doc.data()?['6.4'] ?? 'No information available for 6.4';
        lessonData['6.5'] =
            doc.data()?['6.5'] ?? 'No information available for 6.5';
        lessonData['6.6'] =
            doc.data()?['6.6'] ?? 'No information available for 6.6';
      } else {
        lessonData.updateAll((key, value) => 'Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
      lessonData.updateAll((key, value) => 'Error fetching data');
    }
    return lessonData;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/back.png',
            width: 24.0,
            height: 24.0,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeG12(gradeLevel: "12")),
            );
          },
        ),
      ),
      body: Container(
        width: screenWidth, // Dynamically set width based on screen size
        height: screenHeight, // Dynamically set height based on screen size
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Drafting.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 250),
              child: FutureBuilder<Map<String, String>>(
                future: _fetchLessonData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    String lesson1Data = snapshot.data!['1']!;
                    String lesson2Data = snapshot.data!['2']!;
                    String lesson3Data = snapshot.data!['3']!;
                    String lesson3_1 = snapshot.data!['3.1']!;
                    String lesson3_2 = snapshot.data!['3.2']!;
                    String lesson3_3 = snapshot.data!['3.3']!;
                    String lesson3_4 = snapshot.data!['3.4']!;
                    String lesson4Data = snapshot.data!['4']!;
                    String career5_1 = snapshot.data!['5.1']!;
                    String career5_2 = snapshot.data!['5.2']!;
                    String career5_3 = snapshot.data!['5.3']!;
                    String career5_4 = snapshot.data!['5.4']!;
                    String career5_5 = snapshot.data!['5.5']!;
                    String career5_6 = snapshot.data!['5.6']!;
                    String lesson5_7 = snapshot.data!['5.7']!;
                    String lesson5_8 = snapshot.data!['5.8']!;
                    String lesson5_9 = snapshot.data!['5.9']!;
                    String lesson5_10 = snapshot.data!['5.10']!;
                    String lesson5_11 = snapshot.data!['5.11']!;
                    String lesson6_1 = snapshot.data!['6.1']!;
                    String lesson6_2 = snapshot.data!['6.2']!;
                    String lesson6_3 = snapshot.data!['6.3']!;
                    String lesson6_4 = snapshot.data!['6.4']!;
                    String lesson6_5 = snapshot.data!['6.5']!;
                    String lesson6_6 = snapshot.data!['6.6']!;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20),
                      itemCount: lessons.length,
                      itemBuilder: (context, index) {
                        final lessonNum =
                            (index + 1).toString().padLeft(2, '0');
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ExpansionTile(
                            leading: Text(
                              lessonNum,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: index == 0
                                ? const Text('Introduction to BDT')
                                : (index == 1
                                    ? const Text('Why Choose BDT?')
                                    : (index == 2
                                        ? const Text(
                                            'Career Opportunities in BDT')
                                        : (index == 3
                                            ? const Text(
                                                'Skills Developed in BDT')
                                            : const Text('')))),
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                            'assets/abmm.png'), // Image for the first tile
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                lesson1Data,
                                                textAlign: TextAlign.justify,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(height: 30),
                                              const Center(
                                                child: Text(
                                                  "What is BDT?",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                lesson2Data,
                                                textAlign: TextAlign.justify,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (index == 1)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                            'assets/abmm.png'), // Image for the second tile
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                lesson3Data,
                                                textAlign: TextAlign.justify,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(height: 30),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16),
                                                child: Text("○ $lesson3_1",
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: const TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              const SizedBox(height: 15),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16),
                                                child: Text("○ $lesson3_2",
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: const TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              const SizedBox(height: 15),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16),
                                                child: Text("○ $lesson3_3",
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: const TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              const SizedBox(height: 15),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16),
                                                child: Text(
                                                  "○ $lesson3_4",
                                                  textAlign: TextAlign.justify,
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              const SizedBox(height: 10),
                                              Text(
                                                lesson4Data,
                                                textAlign: TextAlign.justify,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (index == 2)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Professions Under BDT:",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "$career5_1",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    "$career5_2",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    "$career5_3",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    "$career5_4",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    "$career5_5",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 50),
                                              const Text(
                                                "Top Jobs for BDT Graduates:",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "$career5_6",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    "$lesson5_7",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    "$lesson5_8",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    "$lesson5_9",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    "$lesson5_10",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (index == 3)
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Center(
                                            child: Text(
                                              "Skills Developed in BDT",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            lesson6_1,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            lesson6_2,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            lesson6_3,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            lesson6_4,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            lesson6_5,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            lesson6_6,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
