import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:educast/Assessment/Rules/G10Intro.dart';
import 'package:educast/Assessment/assess4g10.dart';
import 'package:educast/Result/resultg10.dart';
import '../Home/Info/Abm.dart';
import '../Home/Info/GAS.dart';
import '../Home/Info/HUMSS.dart';
import '../Home/Info/STEM.dart';
import '../Home/homeg10.dart';

class SearchG10 extends StatefulWidget {
  const SearchG10({super.key});

  @override
  _SearchG10 createState() => _SearchG10();
}

class _SearchG10 extends State<SearchG10> {
  List<String> searchResults = [];
  List<String> visibleResults = [];
  List<Map<String, dynamic>> topCourses = [];
  bool showSearchResults = false;
  TextEditingController searchController = TextEditingController();
  String selectedFilter = 'All'; // Default value for the dropdown

  @override
  void initState() {
    super.initState();
    visibleResults.addAll(searchResults.take(2));
    _fetchTopCourses();
  }

  Future<void> _fetchTopCourses() async {
    try {
      final collectionRef =
          FirebaseFirestore.instance.collection('TopCoursesInBatStateU');

      final Map<String, List<String>> filterCourses = {
        'STEM': [
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
        ],
        'ABM': [
          'Bachelor of Science in Criminology',
        ],
        'HUMSS': [
          'Bachelor of Science in Criminology',
          'Bachelor of Science in Psychology',
        ],
        'GAS': [
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
        ],
      };

      // Retrieve the courses to be fetched based on selected filter
      final List<String> coursesToRetrieve = selectedFilter == 'All'
          ? [] // Empty list to get all fields
          : filterCourses[selectedFilter] ?? [];

      List<Map<String, dynamic>> courses = [];

      // Query the collection
      final querySnapshot = await collectionRef.get();

      // Loop through documents in the collection
      for (var docSnapshot in querySnapshot.docs) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        if (selectedFilter == 'All') {
          // For 'All' filter, iterate over all fields in the document
          data.forEach((fieldName, value) {
            String label;
            switch (fieldName) {
              case "Bachelor of Science in Information Technology":
                label = "BSIT";
                break;
              case "Bachelor of Automotive Engineering Technology":
                label = "BAET";
                break;
              case "Bachelor of Civil Engineering Technology":
                label = "BCivET";
                break;
              case "Bachelor of Computer Engineering Technology":
                label = "BCompET";
                break;
              case "Bachelor of Drafting Engineering Technology":
                label = "BDT";
                break;
              case "Bachelor of Electrical Engineering Technology":
                label = "BElecET";
                break;
              case "Bachelor of Electronics Engineering Technology":
                label = "BElectroET";
                break;
              case "Bachelor of Food Engineering Technology":
                label = "BFET";
                break;
              case "Bachelor of Mechanical Engineering Technology":
                label = "BMechET";
                break;
              case "Bachelor of Mechatronics Engineering Technology":
                label = "BMechtronET";
                break;
              case "Bachelor of Science in Criminology":
                label = "BSCrim";
                break;
              case "Bachelor of Science in Psychology":
                label = "BSPsych";
                break;
              default:
                label = "Other";
                break;
            }
            // Add the course to the list
            courses.add({'label': label, 'value': value});
          });
        } else {
          // For other filters, use the provided course list
          for (String fieldName in coursesToRetrieve) {
            final value = data[fieldName];
            if (value != null) {
              String label;
              switch (fieldName) {
                case "Bachelor of Science in Information Technology":
                  label = "BSIT";
                  break;
                case "Bachelor of Automotive Engineering Technology":
                  label = "BAET";
                  break;
                case "Bachelor of Civil Engineering Technology":
                  label = "BCivET";
                  break;
                case "Bachelor of Computer Engineering Technology":
                  label = "BCompET";
                  break;
                case "Bachelor of Drafting Engineering Technology":
                  label = "BDT";
                  break;
                case "Bachelor of Electrical Engineering Technology":
                  label = "BElecET";
                  break;
                case "Bachelor of Electronics Engineering Technology":
                  label = "BElectroET";
                  break;
                case "Bachelor of Food Engineering Technology":
                  label = "BFET";
                  break;
                case "Bachelor of Mechanical Engineering Technology":
                  label = "BMechET";
                  break;
                case "Bachelor of Mechatronics Engineering Technology":
                  label = "BMechtronET";
                  break;
                case "Bachelor of Science in Criminology":
                  label = "BSCrim";
                  break;
                case "Bachelor of Science in Psychology":
                  label = "BSPsych";
                  break;
                default:
                  label = "Other";
                  break;
              }
              courses.add({'label': label, 'value': value});
            }
          }
        }
      }

      // Sort the courses by value in descending order
      courses.sort((a, b) => b['value'].compareTo(a['value']));

      // Update the state with the fetched courses
      setState(() {
        topCourses = courses;
      });
    } catch (e) {
      print('Error fetching top courses: $e');
    }
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
      List<String> documentIds = ['abm', 'stem', 'humss', 'gas'];
      Set<String> uniqueResults = Set<String>();

      for (String docId in documentIds) {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('strandcontent')
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
        screen = const HomeG10();
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
    return WillPopScope(
      onWillPop: () async => false, // Disable back button
    child: Scaffold(
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
            padding: const EdgeInsets.only(
                top: 200), // Keep the top scroll cut at 150
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16.0, 0, 16, 10), // Adjust bottom padding for spacing
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
                  ),
                  // Rest of your widgets go here
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
                      TextButton(
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
                      const Icon(Icons.keyboard_arrow_down),
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
                  for (var title in ['STEM', 'ABM', 'HUMSS', 'GAS'])
                    YouMayLikeTile(
                      title: title,
                      onTap: () {
                        navigateToScreen(title);
                      },
                    ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Top Courses in BatStateU-TNEU',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: DropdownButton<String>(
                          dropdownColor: Colors.white,
                          value: selectedFilter,
                          isExpanded:
                              true, // Ensures the dropdown button takes the full width
                          items: <String>['All', 'STEM', 'ABM', 'GAS', 'HUMSS']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedFilter = newValue ?? 'All';
                              _fetchTopCourses(); // Fetch new data when filter changes
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: TopCoursesBarChart(topCourses: topCourses),
                  ),
                  const SizedBox(height: 30.0),
                  // Add the chart here
                ],
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
                      MaterialPageRoute(
                          builder: (context) => const SearchG10()),
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
                      MaterialPageRoute(builder: (context) => ResultG10()),
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
                          .collection('userResultG10')
                          .doc(user.uid);

                      final docSnapshot = await userResultDoc.get();

                      if (docSnapshot.exists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlreadyAnswered()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => G10Intro()),
                        );
                      }
                    } else {}
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
  final String title;
  final VoidCallback onTap;

  const YouMayLikeTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.local_fire_department),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class TopCoursesBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> topCourses;

  const TopCoursesBarChart({Key? key, required this.topCourses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen height
    double screenHeight = MediaQuery.of(context).size.height;

    // Define the minimum width for the chart
    double minWidth = 300.0; // Adjust this value as needed

    // Calculate dynamic width
    double dynamicWidth = topCourses.length * 100.0;

    return SizedBox(
      height: screenHeight / 2, // Half of the screen height
      child: topCourses.isEmpty
          ? Center(child: Text('No data available'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: SizedBox(
                width: dynamicWidth > minWidth
                    ? dynamicWidth
                    : minWidth, // Use max of dynamic and min width
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceEvenly,
                    maxY: 1000, // Set the max Y-axis value
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize:
                              60, // Increase reserved space for Y-axis labels
                          interval:
                              200, // Set interval to display 0, 200, 400, 600, 800
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
                              return const Text(
                                  ''); // Return empty if out of bounds
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
            ),
    );
  }
}
