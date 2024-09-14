import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/Home/homeg10.dart';

class StemInfo extends StatefulWidget {
  @override
  _StemInfo createState() => _StemInfo();
}

class _StemInfo extends State<StemInfo> {
  final List<String> lessons = List.generate(
      7, (index) => "Lesson ${(index + 1).toString().padLeft(2, '0')}");

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
      '6.1': '',
      '6.2': '',
      '6.3': '',
      '6.4': '',
      '6.5': '',
      '7': '',
      '8': '',
      '9': '',
      '10': '',
      '11': '',
    };
    try {
      final doc = await _firestore.collection('strandcontent').doc('stem').get();
      if (doc.exists) {
        lessonData['1'] = doc.data()?['1'] ?? 'No information available for Lesson 1';
        lessonData['2'] = doc.data()?['2'] ?? 'No information available for Lesson 2';
        lessonData['3'] = doc.data()?['3'] ?? 'No information available for Lesson 3';
        lessonData['3.1'] = doc.data()?['3.1'] ?? 'No information available for 3.1';
        lessonData['3.2'] = doc.data()?['3.2'] ?? 'No information available for 3.2';
        lessonData['3.3'] = doc.data()?['3.3'] ?? 'No information available for 3.3';
        lessonData['3.4'] = doc.data()?['3.4'] ?? 'No information available for 3.4';
        lessonData['4'] = doc.data()?['4'] ?? 'No information available for Lesson 4';
        lessonData['5.1'] = doc.data()?['5.1'] ?? 'No information available for 5.1';
        lessonData['5.2'] = doc.data()?['5.2'] ?? 'No information available for 5.2';
        lessonData['5.3'] = doc.data()?['5.3'] ?? 'No information available for 5.3';
        lessonData['5.4'] = doc.data()?['5.4'] ?? 'No information available for 5.4';
        lessonData['5.5'] = doc.data()?['5.5'] ?? 'No information available for 5.5';
        lessonData['5.6'] = doc.data()?['5.6'] ?? 'No information available for 5.6';
        lessonData['5.7'] = doc.data()?['5.7'] ?? 'No information available for 5.7';
        lessonData['5.8'] = doc.data()?['5.8'] ?? 'No information available for 5.8';
        lessonData['5.9'] = doc.data()?['5.9'] ?? 'No information available for 5.9';
        lessonData['5.10'] = doc.data()?['5.10'] ?? 'No information available for 5.10';
        lessonData['6.1'] = doc.data()?['6.1'] ?? 'No information available for 6.1';
        lessonData['6.2'] = doc.data()?['6.2'] ?? 'No information available for 6.2';
        lessonData['6.3'] = doc.data()?['6.3'] ?? 'No information available for 6.3';
        lessonData['6.4'] = doc.data()?['6.4'] ?? 'No information available for 6.4';
        lessonData['6.5'] = doc.data()?['6.5'] ?? 'No information available for 6.5';
        lessonData['7'] = doc.data()?['7'] ?? 'No information available for 7';
        lessonData['8'] = doc.data()?['8'] ?? 'No information available for 8';
        lessonData['9'] = doc.data()?['9'] ?? 'No information available for 9';
        lessonData['10'] = doc.data()?['10'] ?? 'No information available for 10';
        lessonData['11'] = doc.data()?['11'] ?? 'No information available for 11';

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/back.png', width: 24.0,
            height: 24.0,),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeG10()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg5.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
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
                  String lesson5_6 = snapshot.data!['5.6']!;
                  String lesson5_7 = snapshot.data!['5.7']!;
                  String lesson5_8 = snapshot.data!['5.8']!;
                  String lesson5_9 = snapshot.data!['5.9']!;
                  String lesson5_10 = snapshot.data!['5.10']!;
                  String lesson6_1 = snapshot.data!['6.1']!;
                  String lesson6_2 = snapshot.data!['6.2']!;
                  String lesson6_3 = snapshot.data!['6.3']!;
                  String lesson6_4 = snapshot.data!['6.4']!;
                  String lesson6_5 = snapshot.data!['6.5']!;
                  String lesson7 = snapshot.data!['7']!;
                  String lesson8 = snapshot.data!['8']!;
                  String lesson9 = snapshot.data!['9']!;
                  String lesson10 = snapshot.data!['10']!;
                  String lesson11 = snapshot.data!['11']!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lessonNum = (index + 1).toString().padLeft(2, '0');
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
                              ? const Text('Introduction to STEM')
                              : (index == 1
                              ? const Text('Why Choose STEM?')
                              : (index == 2
                              ? const Text('Career Opportunities in STEM')
                              : (index == 3
                              ? const Text('Skills Developed in STEM')
                              : (index == 4
                              ? const Text("STEM at BatStateU-IS")
                              : (index == 5
                              ? const Text("BatStateU-IS STEM Curriculum")
                              : (index == 6
                              ? const Text("BatStateU-IS STEM-Focused Facilities and Organizations")
                              : const Text(''))))))),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/abmm.png'), // Image for the first tile
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              lesson1Data,
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 30),
                                            const Center(
                                              child: Text(
                                                "What is STEM?",
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
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                if (index == 1)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/abmm.png'), // Image for the second tile
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              lesson3Data,
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 30),
                                            Padding(
                                              padding: EdgeInsets.only(left: 16),
                                              child: Text("• $lesson3_1", textAlign: TextAlign.justify, style: const TextStyle(fontSize: 16)),
                                            ),
                                            const SizedBox(height: 15),
                                            Padding(
                                              padding: EdgeInsets.only(left: 16),
                                              child: Text("• $lesson3_2", textAlign: TextAlign.justify, style: const TextStyle(fontSize: 16)),
                                            ),
                                            const SizedBox(height: 15),
                                            Padding(
                                              padding: EdgeInsets.only(left: 16),
                                              child: Text("• $lesson3_3", textAlign: TextAlign.justify, style: const TextStyle(fontSize: 16)),
                                            ),
                                            const SizedBox(height: 15),
                                            Padding(
                                              padding: EdgeInsets.only(left: 16),
                                              child: Text("• $lesson3_4", textAlign: TextAlign.justify, style: const TextStyle(fontSize: 16)),
                                            ),
                                            const SizedBox(height: 15),
                                            const SizedBox(height: 10),
                                            Text(
                                              lesson4Data,
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                if (index == 2)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Professions Under STEM:",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("• $career5_1", style: const TextStyle(fontSize: 16)),
                                                const SizedBox(height: 15),
                                                Text("• $career5_2", style: const TextStyle(fontSize: 16)),
                                                const SizedBox(height: 15),
                                                Text("• $career5_3", style: const TextStyle(fontSize: 16)),
                                                const SizedBox(height: 15),
                                                Text("• $career5_4", style: const TextStyle(fontSize: 16)),
                                                const SizedBox(height: 15),
                                                Text("• $career5_5", style: const TextStyle(fontSize: 16)),
                                              ],
                                            ),
                                            const SizedBox(height: 50),
                                            const Text(
                                              "Top Jobs for STEM Graduates:",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("• $lesson5_6", style: const TextStyle(fontSize: 16)),
                                                const SizedBox(height: 15),
                                                Text("• $lesson5_7", style: const TextStyle(fontSize: 16)),
                                                const SizedBox(height: 15),
                                                Text("• $lesson5_8", style: const TextStyle(fontSize: 16)),
                                                const SizedBox(height: 15),
                                                Text("• $lesson5_9", style: const TextStyle(fontSize: 16)),
                                                const SizedBox(height: 15),
                                                Text("• $lesson5_10", style: const TextStyle(fontSize: 16)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                if (index == 3)
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Center(
                                          child: Text(
                                            "Skills Developed in STEM",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          lesson6_1,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          lesson6_2,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          lesson6_3,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          lesson6_4,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          lesson6_5,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            if (index == 4)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset('assets/abmm.png'), // Image for the second tile
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Center(
                                          child: Text(
                                            "Why Choose STEM at BatStateU-IS?",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          lesson7,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                         const SizedBox(height: 30),
                                        Text(
                                          lesson8,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 30),
                                        const Center(
                                          child: Text(
                                            "BatStateU-IS Today: A Leader in STEM Education",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,

                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Text(
                                          lesson9,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 30),
                                        Text(
                                          lesson10,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            if (index == 5)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                        const SizedBox(height: 10),
                                        Text(
                                          lesson11,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                  const SizedBox(height: 30),
                                  Text(
                                    'Grade 11 - First Sem',
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 15),
                                  G11Table1(),

                                  const SizedBox(height: 30),
                                  Text(
                                    'Grade 11 - Second Sem',
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 15),
                                  G11Table2(),
                                  const SizedBox(height: 30),
                                  Text(
                                    'Grade 12 - First Sem',
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 15),
                                  G12Table1(),

                                  const SizedBox(height: 30),
                                  Text(
                                    'Grade 12 - Second Sem',
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 15),
                                  G12Table2(),
                                ],
                              ),
                            if (index == 6)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset('assets/abmm.png'), // Image for the second tile
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child:
                                          Text(
                                            'STEM-Related Facilities in BatStateU-IS',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        ISFacilitiesTable(),
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
    );
  }
}

class G11Table1 extends StatelessWidget {
  Future<Map<String, dynamic>> fetchCurriculumData() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('strandcontent').doc('ISStem11Curriculum');
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception("Document does not exist");
      }
    } catch (e) {
      print("Error fetching data: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchCurriculumData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Data Available'));
        } else {
          final data = snapshot.data!;
          print('Fetched Data: $data');  // Debug print statement

          final List<String> courseCodes = data.keys.toList();
          final List<String> courseTitles = [];
          final List<String> contactHours = [];

          for (String code in courseCodes) {
            final courseDetails = data[code];

            if (courseDetails is String) {
              final parts = courseDetails.split(',');

              if (parts.length > 1) {
                final title = parts.sublist(0, parts.length - 1).join(', ').trim();
                courseTitles.add(title);
                contactHours.add(parts.last.trim());
              } else {
                courseTitles.add(courseDetails.trim());
                contactHours.add('N/A');
              }
            } else {
              courseTitles.add('N/A');
              contactHours.add('N/A');
            }
          }
          // Calculate total contact hours
          double totalContactHours = 0;
          for (var hour in contactHours) {
            final hourValue = double.tryParse(hour);
            if (hourValue != null) {
              totalContactHours += hourValue;
            }
          }

          return Table(
            columnWidths: {
              0: FixedColumnWidth(100), // Width for Course Code column
              1: FlexColumnWidth(2),    // Width for Course Title column (wider)
              2: FixedColumnWidth(80),  // Width for Contact Hours column (smaller)
            },
            border: TableBorder.all(
              color: Colors.black,
              width: 2,
              style: BorderStyle.solid,
            ),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Course Code', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Course Title', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Contact Hours', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
              ...courseCodes.asMap().entries.map((entry) {
                final index = entry.key;
                final code = entry.value;
                return TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(code),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(courseTitles[index]),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(contactHours[index], textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                );
              }).toList(),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(totalContactHours.toStringAsFixed(0), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}

class G11Table2 extends StatelessWidget {
  Future<Map<String, dynamic>> fetchCurriculumData() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('strandcontent').doc('ISStem11Curriculum2');
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception("Document does not exist");
      }
    } catch (e) {
      print("Error fetching data: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchCurriculumData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Data Available'));
        } else {
          final data = snapshot.data!;
          print('Fetched Data: $data');  // Debug print statement

          final List<String> courseCodes = data.keys.toList();
          final List<String> courseTitles = [];
          final List<String> contactHours = [];

          for (String code in courseCodes) {
            final courseDetails = data[code];

            if (courseDetails is String) {
              final parts = courseDetails.split(',');

              if (parts.length > 1) {
                final title = parts.sublist(0, parts.length - 1).join(', ').trim();
                courseTitles.add(title);
                contactHours.add(parts.last.trim());
              } else {
                courseTitles.add(courseDetails.trim());
                contactHours.add('N/A');
              }
            } else {
              courseTitles.add('N/A');
              contactHours.add('N/A');
            }
          }

          // Calculate total contact hours
          double totalContactHours = 0;
          for (var hour in contactHours) {
            final hourValue = double.tryParse(hour);
            if (hourValue != null) {
              totalContactHours += hourValue;
            }
          }

          return Table(
            columnWidths: {
              0: FixedColumnWidth(100), // Width for Course Code column
              1: FlexColumnWidth(2),    // Width for Course Title column (wider)
              2: FixedColumnWidth(80),  // Width for Contact Hours column (smaller)
            },
            border: TableBorder.all(
              color: Colors.black,
              width: 2,
              style: BorderStyle.solid,
            ),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Course Code', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Course Title', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Contact Hours', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
              ...courseCodes.asMap().entries.map((entry) {
                final index = entry.key;
                final code = entry.value;
                return TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(code),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(courseTitles[index]),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(contactHours[index], textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                );
              }).toList(),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(totalContactHours.toStringAsFixed(0), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}

class G12Table1 extends StatelessWidget {
  Future<Map<String, dynamic>> fetchCurriculumData() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('strandcontent').doc('ISStem12Curriculum');
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception("Document does not exist");
      }
    } catch (e) {
      print("Error fetching data: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchCurriculumData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Data Available'));
        } else {
          final data = snapshot.data!;
          print('Fetched Data: $data');  // Debug print statement

          final List<String> courseCodes = data.keys.toList();
          final List<String> courseTitles = [];
          final List<String> contactHours = [];

          for (String code in courseCodes) {
            final courseDetails = data[code];

            if (courseDetails is String) {
              final parts = courseDetails.split(',');

              if (parts.length > 1) {
                final title = parts.sublist(0, parts.length - 1).join(', ').trim();
                courseTitles.add(title);
                contactHours.add(parts.last.trim());
              } else {
                courseTitles.add(courseDetails.trim());
                contactHours.add('N/A');
              }
            } else {
              courseTitles.add('N/A');
              contactHours.add('N/A');
            }
          }

          // Calculate total contact hours
          double totalContactHours = 0;
          for (var hour in contactHours) {
            final hourValue = double.tryParse(hour);
            if (hourValue != null) {
              totalContactHours += hourValue;
            }
          }

          return Table(
            columnWidths: {
              0: FixedColumnWidth(100), // Width for Course Code column
              1: FlexColumnWidth(2),    // Width for Course Title column (wider)
              2: FixedColumnWidth(80),  // Width for Contact Hours column (smaller)
            },
            border: TableBorder.all(
              color: Colors.black,
              width: 2,
              style: BorderStyle.solid,
            ),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Course Code', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Course Title', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Contact Hours', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
              ...courseCodes.asMap().entries.map((entry) {
                final index = entry.key;
                final code = entry.value;
                return TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(code),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(courseTitles[index]),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(contactHours[index], textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                );
              }).toList(),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(totalContactHours.toStringAsFixed(0), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}

class G12Table2 extends StatelessWidget {
  Future<Map<String, dynamic>> fetchCurriculumData() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('strandcontent').doc('ISStem12Curriculum2');
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception("Document does not exist");
      }
    } catch (e) {
      print("Error fetching data: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchCurriculumData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Data Available'));
        } else {
          final data = snapshot.data!;
          print('Fetched Data: $data');  // Debug print statement

          final List<String> courseCodes = data.keys.toList();
          final List<String> courseTitles = [];
          final List<String> contactHours = [];

          for (String code in courseCodes) {
            final courseDetails = data[code];

            if (courseDetails is String) {
              final parts = courseDetails.split(',');

              if (parts.length > 1) {
                final title = parts.sublist(0, parts.length - 1).join(', ').trim();
                courseTitles.add(title);
                contactHours.add(parts.last.trim());
              } else {
                courseTitles.add(courseDetails.trim());
                contactHours.add('N/A');
              }
            } else {
              courseTitles.add('N/A');
              contactHours.add('N/A');
            }
          }

          // Calculate total contact hours
          double totalContactHours = 0;
          for (var hour in contactHours) {
            final hourValue = double.tryParse(hour);
            if (hourValue != null) {
              totalContactHours += hourValue;
            }
          }

          return Table(
            columnWidths: {
              0: FixedColumnWidth(100), // Width for Course Code column
              1: FlexColumnWidth(2),    // Width for Course Title column (wider)
              2: FixedColumnWidth(80),  // Width for Contact Hours column (smaller)
            },
            border: TableBorder.all(
              color: Colors.black,
              width: 2,
              style: BorderStyle.solid,
            ),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Course Code', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Course Title', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Contact Hours', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
              ...courseCodes.asMap().entries.map((entry) {
                final index = entry.key;
                final code = entry.value;
                return TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(code),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(courseTitles[index]),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(contactHours[index], textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                );
              }).toList(),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(totalContactHours.toStringAsFixed(0), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}

class ISFacilitiesTable extends StatelessWidget {
  Future<Map<String, dynamic>> fetchFacilitiesData() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('strandcontent').doc('ISSTEMFacilities');
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception("Document does not exist");
      }
    } catch (e) {
      print("Error fetching data: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchFacilitiesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Data Available'));
        } else {
          final data = snapshot.data!;
          print('Fetched Data: $data');  // Debug print statement

          final List<String> codes = data.keys.toList();
          final List<String> levels = [];
          final List<String> facilities = [];

          for (String code in codes) {
            final details = data[code];

            if (details is String) {
              final parts = details.split(',');
              if (parts.length > 1) {
                final level = parts.first.trim();
                final remainingFacilities = parts.sublist(1).map((f) => f.trim()).join('\n\n');
                levels.add(level);
                facilities.add(remainingFacilities);
              } else {
                levels.add('N/A');
                facilities.add(details.trim());
              }
            } else {
              levels.add('N/A');
              facilities.add('N/A');
            }
          }

          return Table(
            columnWidths: {
              0: FixedColumnWidth(100), // Width for Code column
              1: FixedColumnWidth(120), // Width for Level/Floor column
              2: FlexColumnWidth(2),    // Width for Facilities column (wider)
            },
            border: TableBorder.all(
              color: Colors.black,
              width: 2,
              style: BorderStyle.solid,
            ),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Code', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Level/Floor', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Facilities', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
              ...codes.asMap().entries.map((entry) {
                final index = entry.key;
                final code = entry.value;
                return TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(code),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(levels[index]),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          facilities[index],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          );
        }
      },
    );
  }
}
