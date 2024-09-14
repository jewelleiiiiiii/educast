import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class TopCoursesChart extends StatefulWidget {
  @override
  _TopCoursesChartState createState() => _TopCoursesChartState();
}

class _TopCoursesChartState extends State<TopCoursesChart> {
  List<Map<String, dynamic>> topCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchTopCourses();
  }

  // Fetch data from Firestore
  Future<void> _fetchTopCourses() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('TopCoursesInBatStateU')
          .get();

      List<Map<String, dynamic>> courses = [];
      snapshot.docs.forEach((doc) {
        doc.data().forEach((fieldName, value) {
          String label;
          if (fieldName == "Bachelor of Science in Information Technology") {
            label = "BSIT";
          } else if (fieldName == "Bachelor of Automotive Engineering Technology") {
            label = "BAET";
          } else if (fieldName == "Bachelor of Civil Engineering Technology") {
            label = "BCET";
          } else if (fieldName == "Bachelor of Computer Engineering Technology") {
            label = "BCompET";
          } else if (fieldName == "Bachelor of Drafting Engineering Technology") {
            label = "BDT";
          } else if (fieldName == "Bachelor of Electrical Engineering Technology") {
            label = "BEET";
          } else if (fieldName == "Bachelor of Electronics Engineering Technology") {
            label = "BElET";
          } else if (fieldName == "Bachelor of Food Engineering Technology") {
            label = "BFET";
          } else if (fieldName == "Bachelor of Mechanical Engineering Technology") {
            label = "BMET";
          } else if (fieldName == "Bachelor of Mechatronics Engineering Technology") {
            label = "BMTET";
          } else if (fieldName == "Bachelor of Science in Criminology") {
            label = "BSCrim";
          } else if (fieldName == "Bachelor of Science in Psychology") {
            label = "BSPsych";
          } else {
            label = "Other";
          }
          courses.add({'label': label, 'value': value});
        });
      });

      // Sort courses by value in descending order
      courses.sort((a, b) => b['value'].compareTo(a['value']));

      setState(() {
        topCourses = courses;
      });
    } catch (e) {
      print('Error fetching top courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Courses in BatStateU'),
      ),
      body: topCourses.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight / 2, // Half of the screen height
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: SizedBox(
                  width: topCourses.length * 100.0, // Set dynamic width based on the number of courses
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      maxY: 1000, // Set the max Y-axis value to 800
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60, // Increase reserved space for Y-axis labels
                            interval: 200, // Set interval to display 0, 200, 400, 600, 800
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60, // Same reserved size as the left
                            interval: 200, // Same interval for right Y-axis
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < topCourses.length) {
                                return Text(topCourses[index]['label']);
                              } else {
                                return const Text(''); // Return empty if out of bounds
                              }
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: topCourses
                          .asMap()
                          .map((index, course) {
                        return MapEntry(
                          index,
                          BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: course['value'].toDouble(),  // Use the actual value from the database
                                color: Colors.blue,
                                width: 20,
                              ),
                            ],
                          ),
                        );
                      })
                          .values
                          .toList(),
                    ),
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
