import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class DynamicDropdownWidget extends StatefulWidget {
  final Function(String strand, String selectedOption) onDropdownChanged;

  const DynamicDropdownWidget({Key? key, required this.onDropdownChanged}) : super(key: key);

  @override
  _DynamicDropdownWidgetState createState() => _DynamicDropdownWidgetState();
}

class _DynamicDropdownWidgetState extends State<DynamicDropdownWidget> {
  String? selectedOption;
  String userStrand = '';
  List<String> dropdownOptions = [];

  @override
  void initState() {
    super.initState();
    _fetchUserStrandAndOptions();
  }

  Future<void> _fetchUserStrandAndOptions() async {
    try {
      // Fetch the current user's UID
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Fetch the user's strand from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          userStrand = userDoc['strand'] ?? 'Unknown Strand';
          dropdownOptions = _getDropdownOptionsForStrand(userStrand);
          selectedOption = dropdownOptions.first;
          // Notify the parent widget with the initial values
          widget.onDropdownChanged(userStrand, selectedOption!);
        });
      }
    } catch (e) {
      print('Error fetching user strand: $e');
    }
  }

  // Return dropdown options based on the user's strand
  List<String> _getDropdownOptionsForStrand(String strand) {
    switch (strand) {
      case 'Science, Technology, Engineering, and Mathematics':
        return ['All', 'CAS', 'CET', 'CICS'];
      default:
        return ['All']; // Default case for other strands
    }
  }

  @override
  Widget build(BuildContext context) {
    return dropdownOptions.isEmpty
        ? Center(child: CircularProgressIndicator()) // Show loader while fetching data
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Spacer(), // Push the dropdown to the right
          DropdownButton<String>(
            value: selectedOption,
            items: dropdownOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedOption = newValue;
                // Notify parent widget about the selection change
                widget.onDropdownChanged(userStrand, selectedOption!);
              });
            },
          ),
        ],
      ),
    );
  }
}

class TopCoursesBarChart extends StatefulWidget {
  final String strand;
  final String selectedOption;

  const TopCoursesBarChart({
    Key? key,
    required this.strand,
    required this.selectedOption,
  }) : super(key: key);

  @override
  _TopCoursesBarChartState createState() => _TopCoursesBarChartState();
}

class _TopCoursesBarChartState extends State<TopCoursesBarChart> {
  List<Map<String, dynamic>> topCourses = [];

  Future<void> _fetchTopCourses() async {
    try {
      CollectionReference coursesCollection =
      FirebaseFirestore.instance.collection('TopCoursesInBatStateU');

      QuerySnapshot querySnapshot = await coursesCollection.get();

      // Extract fields from each document
      setState(() {
        topCourses = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Filter the data based on the fields relevant to the selected strand and option
          Map<String, dynamic> filteredCourses = {};
          data.forEach((key, value) {
            if (_isRelevantCourse(key)) {
              filteredCourses[key] = value;
            }
          });

          // Convert the filtered data into a list of course info
          return filteredCourses.entries.map((entry) {
            return {
              'label': entry.key,
              'value': entry.value ?? 0,
            };
          }).toList();
        }).expand((element) => element).toList(); // Flatten the list
      });
    } catch (e) {
      print('Error fetching top courses: $e');
    }
  }

  bool _isRelevantCourse(String courseName) {
    List<String> relevantCourses = [];

    if (widget.strand == 'Science, Technology, Engineering, and Mathematics') {
      switch (widget.selectedOption) {
        case 'All':
          relevantCourses = [
            'Bachelor of Automotive Engineering Technology',
            'Bachelor of Civil Engineering Technology',
            'Bachelor of Computer Engineering Technology',
            'Bachelor of Drafting Engineering Technology',
            'Bachelor of Electrical Engineering Technology',
            'Bachelor of Food Engineering Technology',
            'Bachelor of Mechanical Engineering Technology',
            'Bachelor of Mechatronics Engineering Technology',
            'Bachelor of Science in Criminology',
            'Bachelor of Science in Psychology',
            'Bachelor of Science in Information Technology'
          ];
          break;
        case 'CAS':
          relevantCourses = [
            'Bachelor of Science in Criminology',
            'Bachelor of Science in Psychology'
          ];
          break;
        case 'CET':
          relevantCourses = [
            'Bachelor of Automotive Engineering Technology',
            'Bachelor of Civil Engineering Technology',
            'Bachelor of Computer Engineering Technology',
            'Bachelor of Drafting Engineering Technology',
            'Bachelor of Electrical Engineering Technology',
            'Bachelor of Food Engineering Technology',
            'Bachelor of Mechanical Engineering Technology',
            'Bachelor of Mechatronics Engineering Technology'
          ];
          break;
        case 'CICS':
          relevantCourses = [
            'Bachelor of Science in Information Technology'
          ];
          break;
      }
    }

    return relevantCourses.contains(courseName);
  }


  @override
  void didUpdateWidget(TopCoursesBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.strand != widget.strand || oldWidget.selectedOption != widget.selectedOption) {
      _fetchTopCourses();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTopCourses(); // Fetch courses initially
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TopCoursesChart(topCourses: topCourses),
        ),
      ],
    );
  }
}
class TopCoursesChart extends StatelessWidget {
  final List<Map<String, dynamic>> topCourses;

  const TopCoursesChart({Key? key, required this.topCourses}) : super(key: key);

  // Define the interval for Y-axis
  final double interval = 200.0;

  // Method to get the maximum Y value from the data
  double _getMaxYValue() {
    return topCourses.isNotEmpty
        ? topCourses.map((course) => course['value'].toDouble()).reduce((a, b) => a > b ? a : b)
        : 0.0;
  }

  // Method to round up to the nearest multiple of the interval
  double _roundUpToNearestInterval(double value, double interval) {
    if (value <= 0) return interval;
    return (value / interval).ceil() * interval;
  }

  // Method to get a short course name
  String _getShortCourseName(String longName) {
    Map<String, String> courseNameMap = {
      "Bachelor of Science in Information Technology": "BSIT",
      "Bachelor of Automotive Engineering Technology": "BAET",
      "Bachelor of Civil Engineering Technology": "BCET",
      "Bachelor of Computer Engineering Technology": "BCompET",
      "Bachelor of Drafting Engineering Technology": "BDT",
      "Bachelor of Electrical Engineering Technology": "BEET",
      "Bachelor of Electronics Engineering Technology": "BElET",
      "Bachelor of Food Engineering Technology": "BFET",
      "Bachelor of Mechanical Engineering Technology": "BMET",
      "Bachelor of Mechatronics Engineering Technology": "BMTET",
      "Bachelor of Science in Criminology": "BSCrim",
      "Bachelor of Science in Psychology": "BSPsych",
    };

    return courseNameMap[longName] ?? longName;
  }

  @override
  Widget build(BuildContext context) {
    // Sort courses by value in descending order
    List<Map<String, dynamic>> sortedCourses = List.from(topCourses)
      ..sort((a, b) => b['value'].compareTo(a['value']));

    // Get screen height
    double screenHeight = MediaQuery.of(context).size.height;

    // Define the minimum width for the chart
    double minWidth = 300.0; // Adjust this value as needed

    // Calculate dynamic width
    double dynamicWidth = sortedCourses.length * 100.0;

    // Get the maximum Y value for the chart and round up
    double maxYValue = _getMaxYValue();
    double roundedMaxY = _roundUpToNearestInterval(maxYValue, interval);

    return SizedBox(
      height: screenHeight / 2, // Half of the screen height
      child: sortedCourses.isEmpty
          ? Center(child: Text('No data available'))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
        child: SizedBox(
          width: dynamicWidth > minWidth ? dynamicWidth : minWidth, // Use max of dynamic and min width
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              maxY: roundedMaxY, // Set the max Y-axis value dynamically
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60, // Increase reserved space for Y-axis labels
                    interval: interval, // Set interval based on defined value
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
                    reservedSize: 60, // Same reserved space for right axis
                    interval: interval, // Same interval as left axis
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
                      if (index >= 0 && index < sortedCourses.length) {
                        String shortName = _getShortCourseName(sortedCourses[index]['label']);
                        return Text(shortName);
                      } else {
                        return const Text(''); // Return empty if out of bounds
                      }
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: sortedCourses
                  .asMap()
                  .map((index, course) {
                return MapEntry(
                  index,
                  BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: course['value'].toDouble(), // Use the actual value from the database
                        color: Color.fromARGB(255, 158, 39, 39),
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
    );
  }
}
