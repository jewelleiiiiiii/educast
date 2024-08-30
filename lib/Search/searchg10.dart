import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Search/filterg10.dart';
import '../Home/Info/Abm.dart';
import '../Home/Info/Gas.dart';
import '../Home/Info/Humss.dart';
import '../Home/Info/Stem.dart';
import '../Home/homeg10.dart';

class SearchG10 extends StatefulWidget {
  @override
  _SearchG10 createState() => _SearchG10();
}

class _SearchG10 extends State<SearchG10> {
  List<String> searchResults = [];
  List<String> visibleResults = [];
  bool showSearchResults = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize visibleResults with the first two items from searchResults
    visibleResults.addAll(searchResults.take(2));
  }

  void removeSearchResult(int index) {
    setState(() {
      searchResults.removeAt(index);
      // Remove from visibleResults as well, if necessary
      if (index < visibleResults.length) {
        visibleResults.removeAt(index);
      }
    });
  }

  void toggleSeeMore() {
    setState(() {
      // Toggle between showing visibleResults and all searchResults
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

    // Query Firestore to get matching documents
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('strandcontent')
          .get();

      Set<String> uniqueResults = Set<String>(); // Use a Set to track unique results

      for (var doc in snapshot.docs) {
        if (doc.id.toLowerCase().contains(query)) {
          uniqueResults.add(doc.id);
        } else {
          // Safely check if data is not null before calling forEach
          final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            data.forEach((key, value) {
              if (value.toString().toLowerCase().contains(query)) {
                uniqueResults.add(doc.id);
              }
            });
          }
        }
      }

      // Convert Set to List and limit the number of results
      List<String> matchingDocs = uniqueResults.toList();
      if (matchingDocs.length > 4) {
        matchingDocs = matchingDocs.take(4).toList();
      }

      setState(() {
        searchResults = matchingDocs;
        visibleResults.clear();
        visibleResults.addAll(searchResults.take(2));
      });
    } catch (e) {
      print('Error performing search: $e');
    }
  }

  void navigateToScreen(String title) {
    print('Navigating to screen with title: $title'); // Debug print

    Widget screen;

    // Normalize title case for matching
    String normalizedTitle = title.toUpperCase();

    switch (normalizedTitle) {
      case 'STEM':
        screen = AcademicStemScreen();
        break;
      case 'ABM':
        screen = AcademicAbmScreen();
        break;
      case 'HUMSS':
        screen = AcademicHumssScreen();
        break;
      case 'GAS':
        screen = AcademicGasScreen();
        break;
      default:
        screen = HomeG10(); // Default screen
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
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
              ),
              Positioned(
                top: 30.0,
                right: 16.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FilterG10()),
                    );
                  },
                  child: Image.asset(
                    'assets/filter.png', // Replace with your image path
                    width: 30.0,
                    height: 30.0,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 150.0,
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onChanged: (value) {
                                performSearch();
                              },
                            ),
                          ),
                          SizedBox(width: 10.0),
                          TextButton(
                            onPressed: performSearch,
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (showSearchResults) ...[
                            for (int i = 0; i < visibleResults.length; i++)
                              SearchResultTile(
                                text: visibleResults[i],
                                onTap: () {
                                  navigateToScreen(visibleResults[i]);
                                },

                              ),
                            if (searchResults.length > 3) ...[
                              SizedBox(height: 10.0),
                              TextButton(
                                onPressed: toggleSeeMore,
                                child: Text(
                                  visibleResults.length < searchResults.length
                                      ? 'See More'
                                      : 'See Less',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down),
                            ],
                          ],
                          SizedBox(height: 20.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          // List of titles for the "You may like" section
                          for (var title in ['STEM', 'ABM', 'HUMSS', 'GAS'])
                            YouMayLikeTile(
                              title: title,
                              onTap: () {
                                navigateToScreen(title);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.10,
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
        width: MediaQuery.of(context).size.width * 0.10,
        height: MediaQuery.of(context).size.width * 0.10,
      ),
    ),
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchG10()),
          );
        },
        icon: Image.asset(
          'assets/search.png',
          width: MediaQuery.of(context).size.width * 0.10,
          height: MediaQuery.of(context).size.width * 0.10,
        ),
      ),
      IconButton(
        onPressed: () {
          // Add navigation logic
        },
        icon: Image.asset(
          'assets/main.png',
          width: MediaQuery.of(context).size.width * 0.10,
          height: MediaQuery.of(context).size.width * 0.10,
        ),
      ),
      IconButton(
        onPressed: () {
          // Add navigation logic
        },
        icon: Image.asset(
          'assets/notif.png',
          width: MediaQuery.of(context).size.width * 0.10,
          height: MediaQuery.of(context).size.width * 0.10,
        ),
      ),
      IconButton(
        onPressed: () {
          // Add navigation logic
        },
        icon: Image.asset(
          'assets/stats.png',
          width: MediaQuery.of(context).size.width * 0.10,
          height: MediaQuery.of(context).size.width * 0.10,
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
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.timer),
      title: Text(text),
      onTap: onTap,
    );
  }
}


class YouMayLikeTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const YouMayLikeTile({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.local_fire_department),
      title: Text(title),
      onTap: onTap,
    );
  }
}

