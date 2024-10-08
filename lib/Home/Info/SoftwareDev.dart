import 'package:educast/Home/homeg12.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Softwaredev extends StatefulWidget {
  @override
  _Softwaredev createState() => _Softwaredev();
}

class _Softwaredev extends State<Softwaredev> {
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
      '3.5': '',
      '4': '',
      '4.1': '',
      '4.2': '',
      '4.3': '',
      '4.4': '',
      '4.5': '',
      '5': '',
      '5.1': '',
      '5.2': '',
      '5.3': '',
      '5.4': '',
      '5.5': '',
    };
    try {
      final doc = await _firestore.collection('jobcontent').doc('Software Developer').get();
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
        lessonData['3.5'] =
            doc.data()?['3.5'] ?? 'No information available for 3.5';
        lessonData['4'] =
            doc.data()?['4'] ?? 'No information available for Lesson 4';
        lessonData['4.1'] =
            doc.data()?['4.1'] ?? 'No information available for 4.1';
        lessonData['4.2'] =
            doc.data()?['4.2'] ?? 'No information available for 4.2';
        lessonData['4.3'] =
            doc.data()?['4.3'] ?? 'No information available for 4.3';
        lessonData['4.4'] =
            doc.data()?['4.4'] ?? 'No information available for 4.4';
        lessonData['4.5'] =
            doc.data()?['4.5'] ?? 'No information available for 4.5';
        lessonData['5'] =
            doc.data()?['5'] ?? 'No information available for 5';
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
              MaterialPageRoute(builder: (context) => const HomeG12()),
            );
          },
        ),
      ),
      body:
      Container(
        width: screenWidth, // Dynamically set width based on screen size
        height: screenHeight, // Dynamically set height based on screen size
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/automotive.png'),
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
                    String lesson1 = snapshot.data!['1']!;
                    String lesson2 = snapshot.data!['2']!;
                    String lesson3 = snapshot.data!['3']!;
                    String lesson3_1 = snapshot.data!['3.1']!;
                    String lesson3_2 = snapshot.data!['3.2']!;
                    String lesson3_3 = snapshot.data!['3.3']!;
                    String lesson3_4 = snapshot.data!['3.4']!;
                    String lesson3_5 = snapshot.data!['3.5']!;
                    String lesson4 = snapshot.data!['4']!;
                    String lesson4_1 = snapshot.data!['4.1']!;
                    String lesson4_2 = snapshot.data!['4.2']!;
                    String lesson4_3 = snapshot.data!['4.3']!;
                    String lesson4_4 = snapshot.data!['4.4']!;
                    String lesson4_5 = snapshot.data!['4.5']!;
                    String lesson5 = snapshot.data!['5']!;
                    String lesson5_1 = snapshot.data!['5.1']!;
                    String lesson5_2 = snapshot.data!['5.2']!;
                    String lesson5_3 = snapshot.data!['5.3']!;
                    String lesson5_4 = snapshot.data!['5.4']!;
                    String lesson5_5 = snapshot.data!['5.5']!;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
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
                                ? const Text('Introduction to Software Developer job')
                                : (index == 1
                                ? const Text('Why Choose being a Software Developer?')
                                : (index == 2
                                ? const Text(
                                'Skills Required to be a Software Developer')
                                : (index == 3
                                ? const Text(
                                'Emerging Trends in Software Development')
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
                                                lesson1,
                                                textAlign: TextAlign.justify,
                                                style:
                                                const TextStyle(fontSize: 16),
                                              ),
                                              const SizedBox(height: 30),
                                              const Center(
                                                child: Text(
                                                  "What is Software Development?",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                lesson2,
                                                textAlign: TextAlign.justify,
                                                style:
                                                const TextStyle(fontSize: 16),
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
                                                lesson3,
                                                textAlign: TextAlign.justify,
                                                style:
                                                const TextStyle(fontSize: 16),
                                              ),
                                              const SizedBox(height: 30),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(left: 16),
                                                child: Text("○ $lesson3_1",
                                                    textAlign: TextAlign.justify,
                                                    style: const TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              const SizedBox(height: 15),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(left: 16),
                                                child: Text("○ $lesson3_2",
                                                    textAlign: TextAlign.justify,
                                                    style: const TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              const SizedBox(height: 15),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(left: 16),
                                                child: Text("○ $lesson3_3",
                                                    textAlign: TextAlign.justify,
                                                    style: const TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              const SizedBox(height: 15),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(left: 16),
                                                child: Text("○ $lesson3_4",
                                                  textAlign: TextAlign.justify,
                                                  style: const TextStyle(
                                                      fontSize: 16),),
                                              ),
                                              const SizedBox(height: 15),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(left: 16),
                                                child: Text("○ $lesson3_5",
                                                  textAlign: TextAlign.justify,
                                                  style: const TextStyle(
                                                      fontSize: 16),),
                                              ),
                                              const SizedBox(height: 15),
                                              const SizedBox(height: 10),

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
                                              const SizedBox(height: 10),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text("$lesson4",
                                                    style: const TextStyle(
                                                        fontSize: 16),textAlign: TextAlign.justify,),
                                                  const SizedBox(height: 15),
                                                  Text("$lesson4_1",
                                                    style: const TextStyle(
                                                        fontSize: 16),textAlign: TextAlign.justify,),
                                                  const SizedBox(height: 15),
                                                  Text("$lesson4_2",
                                                    style: const TextStyle(
                                                        fontSize: 16),textAlign: TextAlign.justify,),
                                                  const SizedBox(height: 15),
                                                  Text("$lesson4_3",
                                                    style: const TextStyle(
                                                        fontSize: 16),textAlign: TextAlign.justify,),
                                                  const SizedBox(height: 15),
                                                  Text("$lesson4_4",
                                                    style: const TextStyle(
                                                        fontSize: 16),textAlign: TextAlign.justify,),
                                                  const SizedBox(height: 15),
                                                  Text("$lesson4_5",
                                                    style: const TextStyle(
                                                        fontSize: 16),textAlign: TextAlign.justify,),
                                                  const SizedBox(height: 15),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (index == 3)
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

                                              const SizedBox(height: 10),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text("$lesson5",
                                                    style: const TextStyle(
                                                        fontSize: 16),textAlign: TextAlign.justify,),
                                                  const SizedBox(height: 15),
                                                  Text("$lesson5_1",
                                                    style: const TextStyle(
                                                        fontSize: 16),textAlign: TextAlign.justify,),
                                                  const SizedBox(height: 15),
                                                  Text("$lesson5_2",
                                                    style: const TextStyle(
                                                        fontSize: 16),textAlign: TextAlign.justify,),
                                                  const SizedBox(height: 15),
                                                  Text("$lesson5_3",
                                                    style: const TextStyle(
                                                        fontSize: 16), textAlign: TextAlign.justify,),
                                                  const SizedBox(height: 15),
                                                  Text("$lesson5_4",
                                                    style: const TextStyle(
                                                        fontSize: 16), textAlign: TextAlign.justify,),
                                                  const SizedBox(height: 15),
                                                  Text("$lesson5_5",
                                                    style: const TextStyle(
                                                        fontSize: 16),textAlign: TextAlign.justify,),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
