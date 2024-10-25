import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Assessment/assess2g12.dart';
import 'package:educast/Result/resultG12.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:educast/Assessment/Rules/G12Intro.dart';
import 'package:educast/Home/homeg12.dart';
import '../Home/Info/Abm.dart';
import '../Home/Info/GAS.dart';
import '../Home/Info/HUMSS.dart';
import '../Home/Info/STEM.dart';
import '../Notification/notification_page.dart';

class SearchG12 extends StatefulWidget {
  const SearchG12({super.key});

  @override
  _SearchG12 createState() => _SearchG12();
}

class _SearchG12 extends State<SearchG12> {
  List<String> searchResults = [];
  List<String> visibleResults = [];
  bool showSearchResults = false;
  TextEditingController searchController = TextEditingController();
  String selectedStrand = '';
  String selectedOption = 'All';

  @override
  void initState() {
    super.initState();
    visibleResults.addAll(searchResults.take(2));
  }

  void removeSearchResult(int index) {
    setState(() {
      searchResults.removeAt(index);
      if (index < visibleResults.length) {
        visibleResults.removeAt(index);
      }
    });
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
      // Only search within specific documents
      List<String> documentIds = ['Bachelor of Science in Information Technology',
        'Bachelor of Automotive Engineering Technology',
        'Bachelor of Civil Engineering Technology',
        'Bachelor of Computer Engineering Technology',
        'Bachelor of Drafting Engineering Technology',
        'Bachelor of Electrical Engineering Technology',
        'Bachelor of Electronics Engineering Technology',
        'Bachelor of Food Engineering Technology',
        'Bachelor of Mechanical Engineering Technology',
        'Bachelor of Mechatronics Engineering Technology',
        'Bachelor of Science in Criminology',
        'Bachelor of Science in Psychology'];
      Set<String> uniqueResults = Set<String>();

      for (String docId in documentIds) {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('programcontent')
            .doc(docId)
            .get();

        if (docSnapshot.exists) {
          // Search in document ID
          if (docSnapshot.id.toLowerCase().contains(query)) {
            uniqueResults.add(docSnapshot.id);
          } else {
            // Search within document fields if data is not null
            final Map<String, dynamic>? data =
                docSnapshot.data() as Map<String, dynamic>?;
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

      // Convert Set to List and limit to 4 results
      List<String> matchingDocs = uniqueResults.toList();
      if (matchingDocs.length > 4) {
        matchingDocs = matchingDocs.take(4).toList();
      }

      setState(() {
        searchResults = matchingDocs;
        visibleResults.clear();
        visibleResults.addAll(searchResults.take(2));
      });

      // Show snackbar if no results found
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
      case 'STEM':
        screen = StemInfo();
        break;
      case 'ABM':
        screen = AbmInfo();
        break;
      case 'HUMSS':
        screen = HumssInfo();
        break;
      case 'GAS':
        screen = GasInfo();
        break;
      default:
        screen = const HomeG12(gradeLevel: "12");
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
            padding: const EdgeInsets.only(top: 170),
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
                            navigateToScreen(visibleResults[i]);
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
                        'Top Courses in BatStateU-TNEU',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                      child: DynamicDropdownWidget(
                        onDropdownChanged: (strand, option) {
                          setState(() {
                            selectedStrand = strand;
                            selectedOption = option;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TopCoursesBarChart(
                        strand: selectedStrand,
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
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomeG12(gradeLevel: "12")),
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
                          builder: (context) => const SearchG12()),
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
                      MaterialPageRoute(builder: (context) => ResultG12()),
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
                          .collection('userResultG12')
                          .doc(user.uid);

                      final docSnapshot = await userResultDoc.get();

                      if (docSnapshot.exists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlreadyAnsweredG12()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => G12Intro()),
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
    if (!userDoc.exists) return []; // User document doesn't exist

    final strand = userDoc.data()?['strand'] ?? '';

    // Define fields based on the strand
    final fields = <String>[
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
      'Bachelor of Science in Information Technology',
    ];

    List<String> specificFields;
    switch (strand) {
      case "Science, Technology, Engineering, and Mathematics":
        specificFields = fields;
        break;
      case "Accountancy, Business, and Management":
        specificFields = ['Bachelor of Science in Criminology'];
        break;
      case "Humanities and Social Sciences":
        specificFields = [
          'Bachelor of Science in Criminology',
          'Bachelor of Science in Psychology'
        ];
        break;
      case "General Academic Strand":
        specificFields = fields.sublist(
            0,
            fields.length -
                1); // Exclude 'Bachelor of Science in Information Technology'
        break;
      default:
        return [];
    }

    // Fetch all documents from the collection
    final querySnapshot = await FirebaseFirestore.instance
        .collection('TopCoursesInBatStateU')
        .get();

    // Create a map to aggregate the values
    final courseMap = <String, num>{};
    for (final doc in querySnapshot.docs) {
      final courseData = doc.data();
      for (var field in specificFields) {
        final value =
            courseData[field] as num? ?? 0; // Assuming value is numeric
        if (courseMap.containsKey(field)) {
          courseMap[field] =
              (courseMap[field] ?? 0) + value; // Aggregate values if necessary
        } else {
          courseMap[field] = value;
        }
      }
    }

    // Create a list of course names and their values
    final courseList = <Map<String, dynamic>>[];
    for (var field in specificFields) {
      final value = courseMap[field] ?? 0; // Default to 0 if not found
      courseList.add({'name': field, 'value': value});
    }

    // Sort by value and get the top 4
    courseList.sort((a, b) => b['value'].compareTo(a['value']));
    final topTitles =
        courseList.take(4).map((e) => e['name'] as String).toList();

    return topTitles;
  }

  void _navigateToPage(String title, BuildContext context) {
    Widget page;
    switch (title) {
      case 'Bachelor of Automotive Engineering Technology':
      case 'Bachelor of Civil Engineering Technology':
      case 'Bachelor of Computer Engineering Technology':
      case 'Bachelor of Drafting Engineering Technology':
      case 'Bachelor of Electrical Engineering Technology':
      case 'Bachelor of Food Engineering Technology':
      case 'Bachelor of Mechanical Engineering Technology':
      case 'Bachelor of Mechatronics Engineering Technology':
        page = StemInfo(); // Adjust as needed
        break;
      case 'Bachelor of Science in Criminology':
        page = AbmInfo();
        break;
      case 'Bachelor of Science in Psychology':
        page = HumssInfo();
        break;
      case 'Bachelor of Science in Information Technology':
        page = GasInfo();
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

class DynamicDropdownWidget extends StatefulWidget {
  final Function(String strand, String selectedOption) onDropdownChanged;

  const DynamicDropdownWidget({Key? key, required this.onDropdownChanged})
      : super(key: key);

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
      case 'Accountancy, Business, and Management':
        return ['All', 'CAS'];
      case 'Humanities and Social Sciences':
        return ['All', 'CAS'];
      case 'General Academic Strand':
        return ['All', 'CAS', 'CET'];
      default:
        return ['All']; // Default case for other strands
    }
  }

  @override
  Widget build(BuildContext context) {
    return dropdownOptions.isEmpty
        ? Center(
            child:
                CircularProgressIndicator()) // Show loader while fetching data
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedOption,
                    items: dropdownOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption = newValue;
                        widget.onDropdownChanged(userStrand, selectedOption!);
                      });
                    },
                  ),
                ),
              ],
            ));
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
        topCourses = querySnapshot.docs
            .map((doc) {
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
            })
            .expand((element) => element)
            .toList(); // Flatten the list
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
          relevantCourses = ['Bachelor of Science in Information Technology'];
          break;
      }
    } else if (widget.strand == 'Accountancy, Business, and Management') {
      switch (widget.selectedOption) {
        case 'All':
          relevantCourses = [
            'Bachelor of Science in Criminology',
          ];
          break;
        case 'CAS':
          relevantCourses = [
            'Bachelor of Science in Criminology',
          ];
          break;
      }
    } else if (widget.strand == 'Humanities and Social Sciences') {
      switch (widget.selectedOption) {
        case 'All':
          relevantCourses = [
            'Bachelor of Science in Criminology',
            'Bachelor of Science in Psychology',
          ];
          break;
        case 'CAS':
          relevantCourses = [
            'Bachelor of Science in Criminology',
            'Bachelor of Science in Psychology',
          ];
          break;
      }
    } else if (widget.strand == 'General Academic Strand') {
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
      }
    }

    return relevantCourses.contains(courseName);
  }

  @override
  void didUpdateWidget(TopCoursesBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.strand != widget.strand ||
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
    // Sort courses by value in descending order
    List<Map<String, dynamic>> sortedCourses = List.from(topCourses)
      ..sort((a, b) => b['value'].compareTo(a['value']));

    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width - 10;

    // Calculate dynamic width based on the number of courses
    double dynamicWidth = sortedCourses.length * 100.0;

    // Use the maximum of dynamic width and screen width
    double chartWidth = dynamicWidth > screenWidth ? dynamicWidth : screenWidth;

    // Get the maximum Y value for the chart and round up
    double maxYValue = _getMaxYValue();
    double roundedMaxY = _roundUpToNearestInterval(maxYValue, interval);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: chartWidth, // Set the width to the calculated chart width
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
                      String shortName =
                          _getShortCourseName(sortedCourses[index]['label']);
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
                          toY: course['value']
                              .toDouble(), // Use the actual value from the database
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
    );
  }
}
