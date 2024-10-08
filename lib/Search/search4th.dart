import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Assessment/Rules/4thIntro.dart';
import 'package:educast/Assessment/assess34th.dart';
import 'package:educast/Home/Home4th.dart';
import 'package:educast/Home/Info/SoftwareDev.dart';
import 'package:educast/Result/result4th.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search4th extends StatefulWidget {
  const Search4th({super.key});

  @override
  _Search4thh createState() => _Search4thh();
}

class _Search4thh extends State<Search4th> {
  List<String> searchResults = [];
  List<String> visibleResults = [];
  bool showSearchResults = false;
  TextEditingController searchController = TextEditingController();
  String selectedCourse = '';
  String selectedOption = 'All';

  @override
  void initState() {
    super.initState();
    visibleResults.addAll(searchResults.take(2));
  }

  void toggleSeeMore() {
    setState(() {
      if (visibleResults.length < searchResults.length) {
        visibleResults.clear();
        visibleResults.addAll(searchResults);
      } else {
        visibleResults.clear();
        visibleResults.addAll(searchResults.take(2));
      }
    });
  }

  Future<void> performSearch() async {
    String query = searchController.text.trim().toLowerCase();
    setState(() {
      showSearchResults = query.isNotEmpty;
    });

    if (query.isEmpty) {
      setState(() {
        visibleResults.clear();
        visibleResults.addAll(searchResults.take(2));
      });
      return;
    }

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String currentUserId = user?.uid ?? ''; // Safely get the current user's ID

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      final Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      String userCourse = userData?['course'] ?? '';

      List<String> documentIds;
      if (userCourse == 'Bachelor of Science in Information Technology') {
        documentIds = [
          'Software Developer',
          'Network Administrator',
          'Database Administrator',
          'IT Support Specialist',
          'Web Developer',
        ];
      } else if (userCourse == 'Bachelor of Automotive Engineering Technology') {
        documentIds = [
          'Automotive Engineer',
          'Automotive Design Engineer',
          'Product Development Engineer',
          'Manufacturing Engineer',
          'Vehicle Testing Engineer',
        ];
      }
      else if (userCourse == 'Bachelor of Civil Engineering Technology') {
        documentIds = [
          'Civil Engineering Technologist',
          'Construction Manager',
          'Structural Designer',
          'Project Coordinator',
          'Site Inspector',
        ];
      } else if (userCourse == 'Bachelor of Computer Engineering Technology') {
        documentIds = [
          'Computer Engineering Technologist',
          'Network Administrator',
          'Systems Analyst',
          'Embedded Systems Developer',
          'Software Developer',
        ];
      } else if (userCourse == 'Bachelor of Drafting Engineering Technology') {
        documentIds = [
          'Drafting Technician',
          'Mechanical Drafter',
          'Architectural Drafter',
          'CAD Operator',
          'Drafting Engineer',
        ];
      }
      else if (userCourse == 'Bachelor of Electrical Engineering Technology') {
        documentIds = [
          'Electrical Engineering Technician',
          'Electrical Maintenance Technician',
          'Electrical CAD Drafter',
          'Electrical Project Coordinator',
          'Automation Technician',
        ];
      } else if (userCourse == 'Bachelor of Electronics Engineering Technology') {
        documentIds = [
          'Electronics Engineering Technician',
          'Electronics Test Technician',
          'PCB (Printed Circuit Board) Designer',
          'Electronics Maintenance Technician',
          'Broadcast Engineering Technician',
        ];
      }  else if (userCourse == 'Bachelor of Food Engineering Technology') {
        documentIds = [
          'Food Process Engineer',
          'Quality Control/Assurance Specialist',
          'Product Development Specialist',
          'Food Safety Officer',
          'Operations Supervisor in Food Manufacturing',
        ];
      }  else if (userCourse == 'Bachelor of Mechanical Engineering Technology') {
        documentIds = [
          'Mechanical Design Engineer',
          'Maintenance Engineer',
          'Manufacturing Engineer',
          'Automation Engineer',
          'Project Engineer',
        ];
      } else if (userCourse == 'Bachelor of Mechatronics Engineering Technology') {
        documentIds = [
          'Automation Engineer',
          'Control Systems Engineer',
          'Robotics Engineer',
          'Mechatronics Specialist in Manufacturing',
          'Instrumentation Engineer',
        ];
      } else if (userCourse == 'Bachelor of Science in Psychology') {
        documentIds = [
          'Human Resources Officer',
          'Recruitment Specialist',
          'Guidance Counselor',
          'Training and Development Officer',
          'Behavioral Therapist',
        ];
      } else if (userCourse == 'Bachelor of Science in Criminology') {
        documentIds = [
          'Police Officer',
          'Crime Scene Investigator',
          'Forensic Specialist',
          'Criminal Investigator',
          'Security Officer',
        ];
      } else {
        documentIds = [];
      }

      Set<String> uniqueResults = Set<String>();

      for (String docId in documentIds) {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('jobcontent')
            .doc(docId)
            .get();

        if (docSnapshot.exists) {
          if (docSnapshot.id.toLowerCase().contains(query)) {
            uniqueResults.add(docSnapshot.id);
          } else {
            final Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
            if (data != null) {
              data.forEach((key, value) {
                if (value.toString().toLowerCase().contains(query)) {
                  uniqueResults.add(docSnapshot.id);
                }
              });
            }
          }
        }
      }
      List<String> matchingDocs = uniqueResults.toList();
      if (matchingDocs.length > 4) {
        matchingDocs = matchingDocs.take(4).toList();
      }

      setState(() {
        searchResults = matchingDocs;
        visibleResults.clear();
        visibleResults.addAll(searchResults.take(2));
      });

      if (searchResults.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No results found'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error performing search: $e');
    }
  }

  void navigateToScreen(String title) {
    print('Navigating to screen with title: $title');

    Widget screen;
    String normalizedTitle = title.toUpperCase();

    switch (normalizedTitle) {
      case 'SOFTWARE DEVELOPER':
        screen = Softwaredev();  // Make sure this screen exists
        break;
      default:
        screen = const Home4th();  // Make sure this screen exists
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.transparent],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg7.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 195),
            child: SingleChildScrollView(
              child: Container(
                // Wrap Column in Container
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      160, // Adjust based on top padding
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onChanged: (value) {
                                performSearch();
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                    ),
                    if (showSearchResults) ...[
                      for (int i = 0; i < visibleResults.length; i++)
                        SearchResultTile(
                          text: visibleResults[i],
                          onTap: () {
                            navigateToScreen(visibleResults[i]); // No need for context as string
                          },
                        ),
                      if (searchResults.length > 3) ...[
                        const SizedBox(height: 10.0),
                        Center(
                          child: TextButton(
                            onPressed: toggleSeeMore,
                            child: Text(
                              visibleResults.length < searchResults.length
                                  ? 'See More'
                                  : 'See Less',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ],
                    ],
                    const SizedBox(height: 20.0),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'You may like',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: YouMayLikeTile(),
                    ),
                    const SizedBox(height: 30.0),
                    Center(
                      child: Text(
                        'Top Jobs under this program in',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'BatStateU-TNEU',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TopCoursesBarChart(
                        course: selectedCourse,
                        selectedOption: selectedOption,
                      ),
                    ),
                    const SizedBox(height: 50.0),
                  ],
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home4th()),
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
                      MaterialPageRoute(
                          builder: (context) => Search4th()),
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
                  onPressed: () {},
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
                      MaterialPageRoute(builder: (context) => Result4th()),
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
                          .collection('userResult4th')
                          .doc(user.uid);

                      final docSnapshot = await userResultDoc.get();

                      if (docSnapshot.exists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlreadyAnswered4th()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FourthIntro()),
                        );
                      }
                    }
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
        ),
      ),
    );
  }
}

class SearchResultTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SearchResultTile({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.search),
      title: Text(text),
      onTap: onTap,
    );
  }
}

class YouMayLikeTile extends StatelessWidget {
  const YouMayLikeTile({super.key});

  Future<List<String>> getTopTitles() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return []; // User is not authenticated

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!userDoc.exists) return [];

    final course = userDoc.data()?['course'] ?? '';

    final fields = <String>[
      'Software Developer',
      'Bachelor of Civil Engineering Technology',
      'Bachelor of Computer Engineering Technology',
      'Bachelor of Drafting Engineering Technology',
      'Bachelor of Electrical Engineering Technology',
      'Bachelor of Food Engineering Technology',
      'Bachelor of Mechanical Engineering Technology',
      'Bachelor of Mechatronics Engineering Technology',
      'Bachelor of Science in Criminology',
      'Bachelor of Science in Psychology',
      'Bachelor of Science in Information Technology',
    ];

    List<String> specificFields;
    switch (course) {
      case "Bachelor of Science in Information Technology":
        specificFields = ['Software Developer','Network Administrator', 'Database Administrator', 'IT Support Specialist','Web Developer',];
        break;
      case "Bachelor of Automotive Engineering Technology":
        specificFields = ['Automotive Engineer', 'Automotive Design Engineer', 'Product Development Engineer', 'Manufacturing Engineer', 'Vehicle Testing Engineer',];
        break;
      case "Bachelor of Civil Engineering Technology":
        specificFields = ['Civil Engineering Technologist', 'Construction Manager', 'Structural Designer', 'Project Coordinator', 'Site Inspector',];
        break;
      case "Bachelor of Computer Engineering Technology":
        specificFields = ['Computer Engineering Technologist','Network Administrator','Systems Analyst','Embedded Systems Developer','Software Developer',];
        break;
      case "Bachelor of Drafting Engineering Technology":
        specificFields = ['Drafting Technician', 'Mechanical Drafter', 'Architectural Drafter', 'CAD Operator', 'Drafting Engineer',];
        break;
      case "Bachelor of Electrical Engineering Technology":
        specificFields = ['Electrical Engineering Technician', 'Electrical Maintenance Technician', 'Electrical CAD Drafter', 'Electrical Project Coordinator', 'Automation Technician',];
        break;
      case "Bachelor of Electronics Engineering Technology":
        specificFields = ['Electronics Engineering Technician', 'Electronics Test Technician', 'PCB (Printed Circuit Board) Designer', 'Electronics Maintenance Technician', 'Broadcast Engineering Technician',];
        break;
      case "Bachelor of Food Engineering Technology":
        specificFields = ['Food Process Engineer', 'Quality Control/Assurance Specialist', 'Product Development Specialist', 'Food Safety Officer', 'Operations Supervisor in Food Manufacturing',];
        break;
      case "Bachelor of Mechanical Engineering Technology":
        specificFields = ['Mechanical Design Engineer', 'Maintenance Engineer', 'Manufacturing Engineer', 'Automation Engineer', 'Project Engineer',];
        break;
      case "Bachelor of Mechatronics Engineering Technology":
        specificFields = ['Automation Engineer', 'Control Systems Engineer', 'Robotics Engineer', 'Mechatronics Specialist in Manufacturing', 'Instrumentation Engineer',];
          break;
      case "Bachelor of Science in Psychology":
        specificFields = ['Human Resources Officer', 'Recruitment Specialist', 'Guidance Counselor', 'Training and Development Officer', 'Behavioral Therapist',];
        break;
      case "Bachelor of Science in Criminology":
        specificFields = ['Police Officer', 'Crime Scene Investigator', 'Forensic Specialist', 'Criminal Investigator', 'Security Officer',];
        break;
      default:
        return [];
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('TopJobsInBatStateU')
        .get();

    final courseMap = <String, num>{};
    for (final doc in querySnapshot.docs) {
      final courseData = doc.data();
      for (var field in specificFields) {
        final value =
            courseData[field] as num? ?? 0;
        if (courseMap.containsKey(field)) {
          courseMap[field] =
              (courseMap[field] ?? 0) + value;
        } else {
          courseMap[field] = value;
        }
      }
    }

    // Create a list of course names and their values
    final courseList = <Map<String, dynamic>>[];
    for (var field in specificFields) {
      final value = courseMap[field] ?? 0;
      courseList.add({'name': field, 'value': value});
    }

    courseList.sort((a, b) => b['value'].compareTo(a['value']));
    final topTitles =
    courseList.take(4).map((e) => e['name'] as String).toList();

    return topTitles;
  }

  void _navigateToPage(String title, BuildContext context) {
    Widget page;
    switch (title) {
      case 'Software Developer':
        page = Softwaredev();
        break;
      case 'Automotive Engineer':
      page = Home4th();
        break;
      default:
        page = Scaffold(
          body: Center(child: Text('No page available for $title')),
        );
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getTopTitles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            leading: const Icon(Icons.local_fire_department),
            title: Text('Loading...'),
          );
        }

        if (snapshot.hasError) {
          return ListTile(
            leading: const Icon(Icons.local_fire_department),
            title: Text('Error: ${snapshot.error}'),
          );
        }

        final topTitles = snapshot.data ?? [];

        // Limit to 4 titles, or show all if fewer than 4
        final displayTitles =
        topTitles.length > 4 ? topTitles.take(4).toList() : topTitles;

        return Column(
          children: displayTitles
              .map((title) => Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                    vertical: -10.0, horizontal: 10),
                // Adjust vertical padding as needed
                leading: const Icon(Icons.local_fire_department),
                title: Text(title),
                onTap: () {
                  _navigateToPage(title, context);
                },
              ), // Adjust spacing between ListTiles
            ],
          ))
              .toList(),
        );
      },
    );
  }
}


class TopCoursesBarChart extends StatefulWidget {
  final String course;
  final String selectedOption;

  const TopCoursesBarChart({
    Key? key,
    required this.course,
    required this.selectedOption,
  }) : super(key: key);

  @override
  _TopCoursesBarChartState createState() => _TopCoursesBarChartState();
}

class _TopCoursesBarChartState extends State<TopCoursesBarChart> {
  List<Map<String, dynamic>> topCourses = [];

  Future<void> _fetchTopCourses() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? ''; // Get the current user's UID
      if (uid.isEmpty) {
        print('User is not logged in');
        return;
      }

      // Reference to the 'users' collection
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        print('User document not found');
        return;
      }

      String? userCourse = userDoc.get('course'); // Ensure this matches your Firestore field name
      if (userCourse == null || userCourse.isEmpty) {
        print('User course not found');
        return;
      }

      DocumentSnapshot topJobsDoc =
      await FirebaseFirestore.instance.collection('TopJobsInBatStateU').doc(userCourse).get();

      if (topJobsDoc.exists) {
        Map<String, dynamic> data = topJobsDoc.data() as Map<String, dynamic>;
        print("Fetched Data for $userCourse: $data");

        setState(() {
          topCourses = data.entries.map((entry) {
            return {
              'label': entry.key, // Job role
              'value': entry.value ?? 0, // Ensure value is non-null (default to 0)
            };
          }).toList();
        });
      } else {
        print('No document found for the course: $userCourse');
      }
    } catch (e) {
      print('Error fetching top courses: $e');
    }
  }


  @override
  void didUpdateWidget(TopCoursesBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.course != widget.course ||
        oldWidget.selectedOption != widget.selectedOption) {
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
    return SizedBox(
      height: 300, // Fixed height for the chart
      child: TopCoursesChart(topCourses: topCourses),
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
        ? topCourses
        .map((course) => course['value'].toDouble())
        .reduce((a, b) => a > b ? a : b)
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
    List<Map<String, dynamic>> sortedCourses = List.from(topCourses)
      ..sort((a, b) => b['value'].compareTo(a['value']));

    double screenWidth = MediaQuery
        .of(context)
        .size
        .width - 10;

    double dynamicWidth = sortedCourses.length * 90.0;
    double chartWidth = dynamicWidth > screenWidth ? dynamicWidth : screenWidth;

    double maxYValue = _getMaxYValue();
    print("Max Y Value: $maxYValue");
    double roundedMaxY = _roundUpToNearestInterval(maxYValue, interval);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: chartWidth,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceEvenly,
            maxY: roundedMaxY,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 60,
                  interval: interval,
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
                  reservedSize: 60,
                  interval: interval,
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
                  reservedSize: 75,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < sortedCourses.length) {
                      String shortName = _getShortCourseName(
                          sortedCourses[index]['label']);
                      return RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          shortName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return const Text('');
                    }
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List<BarChartGroupData>.generate(
              sortedCourses.length,
                  (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: sortedCourses[index]['value'].toDouble(),
                      color: Color.fromARGB(255, 158, 39, 39),
                      width: 10,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}