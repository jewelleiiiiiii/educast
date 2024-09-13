import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Assessment/G10Intro.dart';
import 'package:myapp/Assessment/assess4g10.dart';
import 'package:myapp/Result/resultg10.dart';
import 'package:myapp/Search/filterg10.dart';
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
  bool showSearchResults = false;
  TextEditingController searchController = TextEditingController();

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true, // Extend body behind the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/bg7.png', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 90, 0, 0),
                  height: 150.0,
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 10, 16, 10),
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
                      ],
                    ),
                  ),
                ),
              ],
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
                      MaterialPageRoute(builder: (context) => const SearchG10()),
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
                          MaterialPageRoute(builder: (context) => SubmissionConfirmation()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => G10Intro()),
                        );
                      }
                    } else {
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

  const SearchResultTile({super.key,
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

  const YouMayLikeTile({super.key,
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
